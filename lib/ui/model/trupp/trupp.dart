import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'history.dart';

part 'trupp.freezed.dart';
part 'trupp.g.dart';

// A simple representation of a linear function y = mx + b
typedef LinearFunction = ({double m, double b});
typedef PressureRecord = ({DateTime date, int pressure});

@Riverpod(keepAlive: true)
class TruppNotifier extends _$TruppNotifier {
  LinearFunction _currentPressureTrend = (m: 0.0, b: 0.0);

  // Return relevant pressure data from PressureHistory.
  // Only the lower pressure is used as it is the deciding factor.
  Iterable<PressureRecord> _pressureData(List<HistoryEntry> history) {
    return history.whereType<PressureHistoryEntry>().map(
      (e) => (
        date: e.date,
        pressure: e.leaderPressure <= e.memberPressure
            ? e.leaderPressure
            : e.memberPressure,
      ),
    );
  }

  // Interpolate a linear function (regression line) based on the last two of the given data points.
  LinearFunction _interpolatePressure(Iterable<PressureRecord> data) {
    data = data.toList().reversed.take(2);
    final n = data.length;
    final xBar =
        data
            .map((e) => e.date.millisecondsSinceEpoch / 1000)
            .reduce((a, b) => a + b) /
        n;
    final yBar = data.map((e) => e.pressure).reduce((a, b) => a + b) / n;

    final m = n == 1
        ? 0.0
        : (data
                  .map((e) {
                    final x = e.date.millisecondsSinceEpoch / 1000;
                    final y = e.pressure;
                    return (x - xBar) * (y - yBar);
                  })
                  .reduce((a, b) => a + b)) /
              (data
                  .map((e) {
                    final x = e.date.millisecondsSinceEpoch / 1000;
                    return (x - xBar) * (x - xBar);
                  })
                  .reduce((a, b) => a + b));

    final b = yBar - m * xBar;
    return (m: m, b: b);
  }

  @override
  TruppViewModel build(
    int number,
    String callName,
    String leaderName,
    String memberName,
    DateTime start,
    int leaderPressure,
    int memberPressure,
    int maxPressure,
    Duration theoreticalDuration,
  ) {
    final oneSec = Duration(seconds: 1);
    final seconds = Stream.periodic(oneSec, (x) => x);
    final secondsSubscription = seconds.listen((_) {
      var newPotentialEnd = state.potentialEnd;
      if (state.potentialEnd != null && state.potentialEnd! > Duration.zero) {
        newPotentialEnd = state.potentialEnd! - oneSec;
      }

      final newNextCheck = state.nextCheck - oneSec;

      var newTheoreticalEnd = state.theoreticalEnd;
      if (state.theoreticalEnd > Duration.zero) {
        newTheoreticalEnd = state.theoreticalEnd - oneSec;
      }

      final newSinceStart = state.sinceStart + oneSec;

      final newLowestPressure =
          (_currentPressureTrend.m *
                      (DateTime.now().millisecondsSinceEpoch / 1000) +
                  _currentPressureTrend.b)
              .round();

      state = state.copyWith(
        potentialEnd: newPotentialEnd,
        nextCheck: newNextCheck,
        theoreticalEnd: newTheoreticalEnd,
        sinceStart: newSinceStart,
        lowestPressure: newLowestPressure,
      );
    });
    ref.onDispose(() => secondsSubscription.cancel());

    final lowestPressure = leaderPressure < memberPressure
        ? leaderPressure
        : memberPressure;

    _currentPressureTrend = _interpolatePressure(
      _pressureData([
        PressureHistoryEntry(
          date: start,
          leaderPressure: leaderPressure,
          memberPressure: memberPressure,
        ),
      ]),
    );

    final checkDuration = theoreticalDuration == Duration(minutes: 30)
        ? Duration(minutes: 8)
        : Duration(minutes: 6);

    final sinceStart = DateTime.now().difference(start);

    return TruppViewModel(
      callName: callName,
      leaderName: leaderName,
      memberName: memberName,
      number: number,
      sinceStart: sinceStart,
      maxPressure: maxPressure,
      lowestPressure: lowestPressure,
      lowestStartPressure: lowestPressure,
      theoreticalEnd: theoreticalDuration,
      nextCheck: checkDuration,
      potentialEnd: theoreticalDuration,
      history: [
        StatusHistoryEntry(date: start, status: "Geräte angelegt"),
        PressureHistoryEntry(
          date: start,
          leaderPressure: leaderPressure,
          memberPressure: memberPressure,
        ),
      ],
    );
  }

  void addHistoryEntry(HistoryEntry entry) {
    var newState = state.copyWith();
    newState.history.add(entry);

    if (entry is PressureHistoryEntry) {
      final min = entry.leaderPressure <= entry.memberPressure
          ? entry.leaderPressure
          : entry.memberPressure;
      if (min < state.lowestPressure) {
        newState = newState.copyWith(lowestPressure: min);
      }
      _currentPressureTrend = _interpolatePressure(
        _pressureData(state.history),
      );
    }
    state = newState;
  }
}

@freezed
class TruppViewModel with _$TruppViewModel {
  @override
  final int number;
  @override
  final String callName;
  @override
  final String leaderName;
  @override
  final String memberName;
  @override
  final List<HistoryEntry> history;
  @override
  final Duration sinceStart;
  @override
  final Duration? potentialEnd;
  @override
  final Duration theoreticalEnd;
  @override
  final Duration nextCheck;
  @override
  final int lowestPressure;
  @override
  final int lowestStartPressure;
  @override
  final int maxPressure;
  @override
  final List<AlarmType> alarms;

  TruppViewModel({
    required this.callName,
    required this.leaderName,
    required this.memberName,
    this.history = const [],
    required this.number,
    required this.sinceStart,
    this.potentialEnd,
    required this.theoreticalEnd,
    required this.nextCheck,
    required this.lowestPressure,
    required this.lowestStartPressure,
    required this.maxPressure,
    this.alarms = const [],
  });
}

enum AlarmType { pressure, retreat, check }
