import 'dart:async';
import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/initial_settings_repository.dart';
import '../settings/initial_settings.dart';
import '../history/history.dart';
import '../trupp/trupp.dart';

part 'einsatz.g.dart';
part 'einsatz.freezed.dart';

@Riverpod(keepAlive: true)
class EinsatzNotifier extends _$EinsatzNotifier {
  // private members for managing non-public state
  final Stream<void> _ticker = Stream.periodic(
    const Duration(seconds: 1),
  ).asBroadcastStream();
  final Map<int, StreamSubscription<void>> _truppSubscriptions = {};
  final Map<int, PressureTrend> _currentPressureTrends = {};
  final Map<int, TruppDates> _truppDates = {};
  final Map<int, Set<AlarmReason>> _acknowledgedAlarms = {};
  int _nextTruppNumber = 1;

  /// Builds the initial Einsatz state.
  ///
  /// overrides the build method of Riverpod Notifier
  @override
  Einsatz build() {
    return const Einsatz();
  }

  /// ends a trupp that is currently in [TruppAction] state
  Future<void> endTrupp(int number) async {
    assert(state.trupps.containsKey(number), 'Trupp $number does not exist');
    var trupp = state.trupps[number];
    assert(trupp is TruppAction, 'Trupp $number is not in action state');
    trupp = trupp as TruppAction;
    await _truppSubscriptions[number]?.cancel();
    _truppSubscriptions.remove(number);
    _currentPressureTrends.remove(number);
    _truppDates.remove(number);
    _acknowledgedAlarms.remove(number);
    final endedTrupp = Trupp.end(
      number: number,
      history: trupp.history,
      callName: trupp.callName,
      leaderName: trupp.leaderName,
      memberName: trupp.memberName,
      inAction: trupp.sinceStart,
    );
    state = state.copyWith(trupps: {...state.trupps, number: endedTrupp});
  }

  /// end a trupp that was never activated
  ///
  /// Because the trupp was never active it is [TruppForm]
  void endFormTrupp(int number) {
    assert(state.trupps.containsKey(number), 'Trupp $number does not exist');
    var trupp = state.trupps[number];
    assert(trupp is TruppForm, 'Trupp $number is not in form state');
    trupp = trupp as TruppForm;
    final endedTrupp = Trupp.end(
      number: number,
      history: [
        HistoryEntry.status(
          date: DateTime.now(),
          status: 'Trupp ohne aktiven Einsatz beendet',
        ),
      ],
      callName: trupp.callName ?? '',
      leaderName: trupp.leaderName ?? '',
      memberName: trupp.memberName ?? '',
      inAction: Duration.zero,
    );
    state = state.copyWith(trupps: {...state.trupps, number: endedTrupp});
  }

  /// activate a trupp that is currently in [TruppForm] state
  ///
  /// transfers it to [TruppAction] state and starts tracking
  void activateTrupp(int number) {
    assert(state.trupps.containsKey(number), 'Trupp $number does not exist');
    var trupp = state.trupps[number];
    assert(trupp is TruppForm, 'Trupp $number is not in form state');
    trupp = trupp as TruppForm;

    final lowestPressure = math.min(
      trupp.leaderPressure!,
      trupp.memberPressure!,
    );

    final checkDuration =
        trupp.theoreticalDuration > const Duration(minutes: 24)
        ? const Duration(minutes: 8)
        : const Duration(minutes: 6);

    _currentPressureTrends[number] = (m: 0, b: lowestPressure.toDouble());

    final activeTrupp = Trupp.action(
      number: number,
      callName: trupp.callName!,
      leaderName: trupp.leaderName!,
      memberName: trupp.memberName!,
      sinceStart: Duration.zero,
      theoreticalEnd: trupp.theoreticalDuration,
      nextCheck: Duration(milliseconds: checkDuration.inMilliseconds),
      checkInterval: checkDuration,
      lowestPressure: lowestPressure,
      lowestStartPressure: lowestPressure,
      maxPressure: trupp.maxPressure,
      potentialEnd: trupp.theoreticalDuration,
      history: [
        HistoryEntry.pressure(
          date: DateTime.now(),
          leaderPressure: trupp.leaderPressure!,
          memberPressure: trupp.memberPressure!,
        ),
        HistoryEntry.status(date: DateTime.now(), status: 'Geräte angelegt'),
      ],
    );

    _truppDates[number] = TruppDates(
      start: DateTime.now(),
      theoreticalEnd: DateTime.now().add(trupp.theoreticalDuration),
      potentialEnd: DateTime.now().add(trupp.theoreticalDuration),
      nextCheck: DateTime.now().add(checkDuration),
    );

    state = state.copyWith(trupps: {...state.trupps, number: activeTrupp});

    _truppSubscriptions[number] = _ticker.listen((_) {
      _onTruppTick(number);
    });
  }

  /// called every second for each active trupp
  void _onTruppTick(int number) {
    assert(state.trupps.containsKey(number), 'Trupp $number does not exist');
    assert(
      state.trupps[number] is TruppAction,
      'Trupp $number is not in action state',
    );
    final trupp = state.trupps[number]! as TruppAction;
    final now = DateTime.now();

    // update trupp durations
    var newPotentialEnd = trupp.potentialEnd;
    if (trupp.potentialEnd > Duration.zero) {
      newPotentialEnd = _truppDates[number]!.potentialEnd.difference(now);
    }

    final newNextCheck = _truppDates[number]!.nextCheck.difference(now);

    var newTheoreticalEnd = trupp.theoreticalEnd;
    if (trupp.theoreticalEnd > Duration.zero) {
      newTheoreticalEnd = _truppDates[number]!.theoreticalEnd.difference(now);
    }

    final newSinceStart = now.difference(_truppDates[number]!.start);

    // calculate new lowest pressure from trend line
    final newLowestPressure =
        (_currentPressureTrends[number]!.m *
                    (DateTime.now().millisecondsSinceEpoch / 1000) +
                _currentPressureTrends[number]!.b)
            .round();

    // update alarms from new conditions
    final newAlarms = state.alarms[number] ?? [];

    if (newNextCheck.isNegative) {
      if (!_alarmAlreadyExists(number, AlarmReason.checkPressure)) {
        newAlarms.add((
          type: AlarmType.sound,
          reason: AlarmReason.checkPressure,
        ));
      }
    } else {
      if (_alarmAlreadyExists(number, AlarmReason.checkPressure)) {
        newAlarms.removeWhere(
          (alarm) => alarm.reason == AlarmReason.checkPressure,
        );
      }
    }

    if (newLowestPressure < 60) {
      if (!_alarmAlreadyExists(number, AlarmReason.lowPressure) &&
          !_isAcknowledged(number, AlarmReason.lowPressure)) {
        newAlarms.add((type: AlarmType.sound, reason: AlarmReason.lowPressure));
      }
    } else {
      if (_alarmAlreadyExists(number, AlarmReason.lowPressure)) {
        newAlarms.removeWhere(
          (alarm) => alarm.reason == AlarmReason.lowPressure,
        );
      }
      _acknowledgedAlarms[number]?.remove(AlarmReason.lowPressure);
    }

    final newTrupp = trupp.copyWith(
      potentialEnd: newPotentialEnd,
      nextCheck: newNextCheck,
      theoreticalEnd: newTheoreticalEnd,
      sinceStart: newSinceStart,
      lowestPressure: newLowestPressure,
    );

    state = state.copyWith(
      trupps: {...state.trupps, number: newTrupp},
      alarms: {...state.alarms, number: newAlarms},
    );
  }

  bool _alarmAlreadyExists(int truppNumber, AlarmReason reason) {
    if (!state.alarms.containsKey(truppNumber)) {
      return false;
    }
    return state.alarms[truppNumber]!.any((alarm) => alarm.reason == reason);
  }

  bool _isAcknowledged(int truppNumber, AlarmReason reason) {
    return _acknowledgedAlarms[truppNumber]?.contains(reason) ?? false;
  }

  /// Adds a new Trupp in [TruppForm] state.
  ///
  /// Loads default values from [InitialSettingsRepository] if available.
  /// Uses fallback defaults (300 bar, 30 min) if settings unavailable.
  /// Reason: App should remain functional even if user skipped post-registration setup or Firestore connection fails.
  Future<void> addTrupp() async {
    final repository = ref.read(initialSettingsRepositoryProvider);
    InitialSettingsModel? settings;

    if (repository != null) {
      try {
        settings = await repository.get();
      } catch (_) {
        // Ignore fetch errors and fall back to defaults.
      }
    }

    state = state.copyWith(
      trupps: {
        ...state.trupps,
        _nextTruppNumber: Trupp.form(
          number: _nextTruppNumber,
          maxPressure:
              settings?.defaultPressure ??
              InitialSettingsModel.kStandardMaxPressure,
          theoreticalDuration: Duration(
            minutes:
                settings?.theoreticalDurationMinutes ??
                InitialSettingsModel.kStandardTheoreticalDurationMinutes,
          ),
        ),
      },
    );
    _nextTruppNumber++;
  }

  /// Adds a new [HistoryEntry] to the specified trupp.
  ///
  /// If the entry is a [PressureHistoryEntry], updates pressure trend and potential end time.
  /// The trupp must be in [TruppAction] state.
  void addHistoryEntryToTrupp(int truppNumber, HistoryEntry entry) {
    assert(
      state.trupps.containsKey(truppNumber),
      'Trupp $truppNumber does not exist',
    );
    final trupp = state.trupps[truppNumber]!;
    if (trupp is! TruppAction) {
      throw StateError('Trupp $truppNumber is not in action state');
    }

    var newLowestPressure = trupp.lowestPressure;

    if (entry is PressureHistoryEntry) {
      final min = math.min(entry.leaderPressure, entry.memberPressure);
      newLowestPressure = min;
      // Update pressure trend
      final lastPressures = trupp.history
          .whereType<PressureHistoryEntry>()
          .toList();
      double m;
      double lastDate;
      final currentDate = entry.date.millisecondsSinceEpoch / 1000;

      do {
        final lastPressure = lastPressures.removeAt(0);
        final lastMin = math.min(
          lastPressure.leaderPressure,
          lastPressure.memberPressure,
        );
        lastDate = lastPressure.date.millisecondsSinceEpoch / 1000;

        m = (min - lastMin) / (currentDate - lastDate);
      } while (m > 0 && lastPressures.isNotEmpty);
      final b = min - m * currentDate;

      _truppDates[truppNumber] = _truppDates[truppNumber]!.copyWith(
        potentialEnd: m != 0
            ? DateTime.fromMillisecondsSinceEpoch(((b / -m) * 1000).round())
            : _truppDates[truppNumber]!.theoreticalEnd,
        nextCheck: DateTime.now().add(trupp.checkInterval),
      );

      _currentPressureTrends[truppNumber] = (m: m, b: b);
      entry = entry.copyWith(date: DateTime.now());
    }

    final newHistory = [entry, ...trupp.history];
    final newTrupp = trupp.copyWith(
      history: newHistory,
      lowestPressure: newLowestPressure,
    );
    state = state.copyWith(trupps: {...state.trupps, truppNumber: newTrupp});
  }

  /// acknowledges a sounding ([AlarmType.sound]) alarm for a trupp making it [AlarmType.visual]
  void ackSoundingAlarm(int truppNumber, AlarmReason alarm) {
    if (!state.alarms.containsKey(truppNumber)) {
      return;
    }
    final newAlarms = state.alarms[truppNumber]!
        .where((a) => a.reason != alarm)
        .toList();
    newAlarms.add((type: AlarmType.visual, reason: alarm));
    state = state.copyWith(alarms: {...state.alarms, truppNumber: newAlarms});
  }

  /// resets the entire Einsatz state to initial
  void reset() {
    // cancel all trupp subscriptions
    for (final subscription in _truppSubscriptions.values) {
      subscription.cancel();
    }
    _truppSubscriptions.clear();
    _currentPressureTrends.clear();
    _truppDates.clear();
    _acknowledgedAlarms.clear();
    _nextTruppNumber = 1;
    state = const Einsatz();
  }

  /// acknowledges a visual ([AlarmType.visual]) alarm for a trupp removing it entirely
  ///
  /// cannot be used for [AlarmReason.checkPressure] because those alarms
  /// self-reset on next check and are displayed until pressure is checked.
  void ackVisualAlarm(int truppNumber, AlarmReason alarm) {
    assert(alarm != AlarmReason.checkPressure);
    if (!state.alarms.containsKey(truppNumber)) {
      return;
    }

    if (!_acknowledgedAlarms.containsKey(truppNumber)) {
      _acknowledgedAlarms[truppNumber] = {};
    }

    _acknowledgedAlarms[truppNumber]!.add(alarm);

    final newAlarms = state.alarms[truppNumber]!
        .where((a) => a.reason != alarm)
        .toList();
    state = state.copyWith(alarms: {...state.alarms, truppNumber: newAlarms});
  }

  /// helper to update a trupp in form state
  void _updateFormTrupp(
    int truppNumber,
    TruppForm Function(TruppForm trupp) update,
  ) {
    assert(state.trupps.containsKey(truppNumber));
    if (state.trupps[truppNumber] is! TruppForm) {
      throw StateError('Trupp $truppNumber is not in form state');
    }

    final trupp = state.trupps[truppNumber] as TruppForm;
    final newTrupp = update(trupp);
    state = state.copyWith(trupps: {...state.trupps, truppNumber: newTrupp});
  }

  /// sets the leader name of the trupp in form state
  ///
  /// The corresponding [Trupp] needs to be in [TruppForm] state.
  void setLeaderName(int truppNumber, String? name) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(leaderName: name),
  );

  /// sets the member name of the trupp in form state
  ///
  /// The corresponding [Trupp] needs to be in [TruppForm] state.
  void setMemberName(int truppNumber, String? name) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(memberName: name),
  );

  /// sets the call name of the trupp in form state
  ///
  /// The corresponding [Trupp] needs to be in [TruppForm] state.
  void setCallName(int truppNumber, String? name) =>
      _updateFormTrupp(truppNumber, (trupp) => trupp.copyWith(callName: name));

  /// sets the leader pressure of the trupp in form state
  ///
  /// The corresponding [Trupp] needs to be in [TruppForm] state.
  void setLeaderPressure(int truppNumber, int? pressure) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(leaderPressure: pressure),
  );

  /// sets the member pressure of the trupp in form state
  ///
  /// The corresponding [Trupp] needs to be in [TruppForm] state.
  void setMemberPressure(int truppNumber, int? pressure) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(memberPressure: pressure),
  );

  /// sets the theoretical duration of the trupp in form state
  ///
  /// The corresponding [Trupp] needs to be in [TruppForm] state.
  void setTheoreticalDuration(int truppNumber, Duration duration) =>
      _updateFormTrupp(
        truppNumber,
        (trupp) => trupp.copyWith(theoreticalDuration: duration),
      );

  /// sets the max pressure of the trupp in form state
  ///
  /// The corresponding [Trupp] needs to be in [TruppForm] state.
  void setMaxPressure(int truppNumber, int pressure) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(maxPressure: pressure),
  );
}

/// reasons for an alarm, possibly more in the future
enum AlarmReason { checkPressure, lowPressure }

enum AlarmType { sound, visual }

typedef Alarm = ({AlarmType type, AlarmReason reason});

@freezed
abstract class Einsatz with _$Einsatz {
  const factory Einsatz({
    @Default({}) Map<int, Trupp> trupps,
    @Default({}) Map<int, List<Alarm>> alarms,
  }) = _Einsatz;
}

/// A linear trend line represented by y = m*x + b
typedef PressureTrend = ({double m, double b});
