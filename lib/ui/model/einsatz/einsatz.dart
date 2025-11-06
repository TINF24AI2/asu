import 'package:asu/ui/model/trupp/trupp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'einsatz.g.dart';

@riverpod
class EinsatzNotifier extends _$EinsatzNotifier {
  @override
  TruppList build() {
    return TruppList([]);
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
    final updatedTrupps = [...(state).trupps, (number, newTrupp)];
    updatedTrupps.sort((a, b) => a.$1.compareTo(b.$1));
    state = TruppList(updatedTrupps);
  }
}

class TruppList {
  final List<(int, TruppNotifierProvider)> _trupps;
  List<(int, TruppNotifierProvider)> get trupps => _trupps;
  TruppList(this._trupps);
}
