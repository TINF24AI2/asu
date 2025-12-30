import 'dart:async';
import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../repositories/initial_settings_repository.dart';
import '../history/history.dart';
import '../trupp/trupp.dart';

part 'einsatz.g.dart';
part 'einsatz.freezed.dart';

@Riverpod(keepAlive: true)
class EinsatzNotifier extends _$EinsatzNotifier {
  static const _oneSec = Duration(seconds: 1);
  final Stream<void> _ticker = Stream.periodic(_oneSec).asBroadcastStream();
  final Map<int, StreamSubscription<void>> _truppSubscriptions = {};
  final Map<int, PressureTrend> _currentPressureTrends = {};

  @override
  Einsatz build() {
    return const Einsatz();
  }

  Future<void> endTrupp(int number) async {
    assert(state.trupps.containsKey(number), 'Trupp $number does not exist');
    var trupp = state.trupps[number];
    assert(trupp is TruppAction, 'Trupp $number is not in action state');
    trupp = trupp as TruppAction;
    await _truppSubscriptions[number]?.cancel();
    _truppSubscriptions.remove(number);
    _currentPressureTrends.remove(number);
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
        trupp.theoreticalDuration! > const Duration(minutes: 24)
        ? const Duration(minutes: 8)
        : const Duration(minutes: 6);
    _currentPressureTrends[number] = (m: 0, b: lowestPressure.toDouble());
    final activeTrupp = Trupp.action(
      number: number,
      callName: trupp.callName!,
      leaderName: trupp.leaderName!,
      memberName: trupp.memberName!,
      sinceStart: Duration.zero,
      theoreticalEnd: trupp.theoreticalDuration!,
      nextCheck: Duration(milliseconds: checkDuration.inMilliseconds),
      checkInterval: checkDuration,
      lowestPressure: lowestPressure,
      lowestStartPressure: lowestPressure,
      maxPressure: trupp.maxPressure!,
      potentialEnd: trupp.theoreticalDuration!,
      history: [
        HistoryEntry.pressure(
          date: DateTime.now(),
          leaderPressure: trupp.leaderPressure!,
          memberPressure: trupp.memberPressure!,
        ),
        HistoryEntry.status(date: DateTime.now(), status: 'Geräte angelegt'),
      ],
    );
    state = state.copyWith(trupps: {...state.trupps, number: activeTrupp});
    _truppSubscriptions[number] = _ticker.listen((_) {
      _onTruppTick(number);
    });
  }

  void _onTruppTick(int number) {
    final trupp = state.trupps[number]! as TruppAction;
    var newPotentialEnd = trupp.potentialEnd;
    if (trupp.potentialEnd > Duration.zero) {
      newPotentialEnd = trupp.potentialEnd - _oneSec;
    }

    final newNextCheck = trupp.nextCheck - _oneSec;
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

    var newTheoreticalEnd = trupp.theoreticalEnd;
    if (trupp.theoreticalEnd > Duration.zero) {
      newTheoreticalEnd = trupp.theoreticalEnd - _oneSec;
    }

    final newSinceStart = trupp.sinceStart + _oneSec;

    final newLowestPressure =
        (_currentPressureTrends[number]!.m *
                    (DateTime.now().millisecondsSinceEpoch / 1000) +
                _currentPressureTrends[number]!.b)
            .round();

    if (newLowestPressure < 60) {
      if (!_alarmAlreadyExists(number, AlarmReason.lowPressure)) {
        newAlarms.add((type: AlarmType.sound, reason: AlarmReason.lowPressure));
      }
    } else {
      if (_alarmAlreadyExists(number, AlarmReason.lowPressure)) {
        newAlarms.removeWhere(
          (alarm) => alarm.reason == AlarmReason.lowPressure,
        );
      }
    }

    // TODO retreat alarm check

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

  Future<void> addTrupp(int number) async {
    assert(!state.trupps.containsKey(number), 'Trupp $number already exists');

    final settings = await ref.read(initialSettingsRepositoryProvider).get();

    state = state.copyWith(
      trupps: {
        ...state.trupps,
        number: Trupp.form(
          number: number,
          maxPressure: settings?.defaultPressure,
          theoreticalDuration: settings != null
              ? Duration(minutes: settings.theoreticalDurationMinutes)
              : null,
        ),
      },
    );
  }

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
    var pressureUpdated = false;
    var possibleEndSec = 0;

    if (entry is PressureHistoryEntry) {
      pressureUpdated = true;
      final min = math.min(entry.leaderPressure, entry.memberPressure);
      newLowestPressure = min;
      // Update pressure trend
      final lastPressure = trupp.history
          .whereType<PressureHistoryEntry>()
          .firstOrNull;
      assert(lastPressure != null, 'No previous pressure entry found');
      final lastMin = math.min(
        lastPressure!.leaderPressure,
        lastPressure.memberPressure,
      );
      final lastDate = lastPressure.date.millisecondsSinceEpoch / 1000;
      final currentDate = entry.date.millisecondsSinceEpoch / 1000;

      final m = (min - lastMin) / (currentDate - lastDate);
      final b = min - m * currentDate;

      possibleEndSec = ((b / -m) - currentDate).round();

      _currentPressureTrends[truppNumber] = (m: m, b: b);
      entry = entry.copyWith(date: DateTime.now());
    }

    final newHistory = [entry, ...trupp.history];
    final newTrupp = trupp.copyWith(
      history: newHistory,
      lowestPressure: newLowestPressure,
      nextCheck: pressureUpdated
          ? Duration(milliseconds: trupp.checkInterval.inMilliseconds)
          : trupp.nextCheck,
      potentialEnd: pressureUpdated
          ? Duration(seconds: (possibleEndSec).clamp(0, 86400))
          : trupp.potentialEnd,
    );
    state = state.copyWith(trupps: {...state.trupps, truppNumber: newTrupp});
  }

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

  void _updateFormTrupp(
    int truppNumber,
    TruppForm Function(TruppForm trupp) update,
  ) {
    assert(
      state.trupps.containsKey(truppNumber),
      'Trupp $truppNumber does not exist',
    );
    if (state.trupps[truppNumber] is! TruppForm) {
      throw StateError('Trupp $truppNumber is not in form state');
    }
    final trupp = state.trupps[truppNumber] as TruppForm;
    final newTrupp = update(trupp);
    state = state.copyWith(trupps: {...state.trupps, truppNumber: newTrupp});
  }

  void setLeaderName(int truppNumber, String? name) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(leaderName: name),
  );

  void setMemberName(int truppNumber, String? name) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(memberName: name),
  );

  void setCallName(int truppNumber, String? name) =>
      _updateFormTrupp(truppNumber, (trupp) => trupp.copyWith(callName: name));

  void setLeaderPressure(int truppNumber, int? pressure) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(leaderPressure: pressure),
  );

  void setMemberPressure(int truppNumber, int? pressure) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(memberPressure: pressure),
  );

  void setTheoreticalDuration(int truppNumber, Duration? duration) =>
      _updateFormTrupp(
        truppNumber,
        (trupp) => trupp.copyWith(theoreticalDuration: duration),
      );

  void setMaxPressure(int truppNumber, int? pressure) => _updateFormTrupp(
    truppNumber,
    (trupp) => trupp.copyWith(maxPressure: pressure),
  );
}

enum AlarmReason { checkPressure, lowPressure, retreat }

enum AlarmType { sound, visual }

typedef Alarm = ({AlarmType type, AlarmReason reason});

@freezed
abstract class Einsatz with _$Einsatz {
  const factory Einsatz({
    @Default({}) Map<int, Trupp> trupps,
    @Default({}) Map<int, List<Alarm>> alarms,
  }) = _Einsatz;
}

// A linear trend line represented by y = m*x + b
typedef PressureTrend = ({double m, double b});
