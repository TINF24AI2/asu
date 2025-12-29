import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../trupp/trupp.dart';

part 'einsatz.g.dart';

@riverpod
class EinsatzNotifier extends _$EinsatzNotifier {
  @override
  TruppList build() {
    return TruppList({});
  }

  void addTrupp(
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
    final newTrupp = truppProvider.call(
      number,
      callName,
      leaderName,
      memberName,
      start,
      leaderPressure,
      memberPressure,
      maxPressure,
      theoreticalDuration,
    );
    final map = state.trupps;
    map[number] = newTrupp;
    state = TruppList(map);
  }
}

class TruppList {
  final Map<int, TruppNotifierProvider> _trupps;
  Map<int, TruppNotifierProvider> get trupps => _trupps;
  TruppList(this._trupps);
}
