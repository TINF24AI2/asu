import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'history.dart';

part 'trupp.g.dart';

@riverpod
class TruppNotifier extends _$TruppNotifier {
  (double, double) _currentPressureTrend = (0.0, 0.0);

  Iterable<(DateTime, int)> _pressureData(List<HistoryEntry> history) {
    return history.whereType<PressureHistoryEntry>().map(
      (e) => (
        e.date,
        e.leaderPressure <= e.memberPressure
            ? e.leaderPressure
            : e.memberPressure,
      ),
    );
  }

  (double, double) _interpolatePressure(Iterable<(DateTime, int)> data) {
    final n = data.length;
    final xBar =
        data
            .map((e) => e.$1.millisecondsSinceEpoch / 1000)
            .reduce((a, b) => a + b) /
        n;
    final yBar = data.map((e) => e.$2).reduce((a, b) => a + b) / n;

    final m =
        (data
            .map((e) {
              final x = e.$1.millisecondsSinceEpoch / 1000;
              final y = e.$2;
              return (x - xBar) * (y - yBar);
            })
            .reduce((a, b) => a + b)) /
        (data
            .map((e) {
              final x = e.$1.millisecondsSinceEpoch / 1000;
              return (x - xBar) * (x - xBar);
            })
            .reduce((a, b) => a + b));

    final b = yBar - m * xBar;
    return (m, b);
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
      if (state.potentialEnd != null && state.potentialEnd! > Duration.zero) {
        state.potentialEnd = state.potentialEnd! - oneSec;
      }

      state.nextCheck -= oneSec;

      if (state.theoreticalEnd > Duration.zero) {
        state.theoreticalEnd -= oneSec;
      }

      state.sinceStart += oneSec;

      state.lowestPressure =
          (_currentPressureTrend.$1 *
                      (DateTime.now().millisecondsSinceEpoch / 1000) +
                  _currentPressureTrend.$2)
              .round();

      state = state;
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
    state.history.add(entry);

    if (entry is PressureHistoryEntry) {
      final min = entry.leaderPressure <= entry.memberPressure
          ? entry.leaderPressure
          : entry.memberPressure;
      if (min < state.lowestPressure) {
        state.lowestPressure = min;
      }
      _currentPressureTrend = _interpolatePressure(
        _pressureData(state.history),
      );
    }
  }
}

class TruppViewModel {
  final int number;
  final String callName;
  final String leaderName;
  final String memberName;
  final List<HistoryEntry> history;
  Duration sinceStart;
  Duration? potentialEnd;
  Duration theoreticalEnd;
  Duration nextCheck;
  int lowestPressure;
  final int lowestStartPressure;
  final int maxPressure;
  final List<AlarmType> alarms = [];

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
  });
}

enum AlarmType { pressure, retreat, check }
