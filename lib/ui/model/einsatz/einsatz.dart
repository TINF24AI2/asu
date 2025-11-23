import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../history/history.dart';
import '../trupp/trupp.dart';

part 'einsatz.g.dart';
part 'einsatz.freezed.dart';

@Riverpod(keepAlive: true)
class EinsatzNotifier extends _$EinsatzNotifier {
  @override
  Einsatz build() {
    return Einsatz();
  }

  void endTrupp(int number) {
    //TODO new state handling
  }

  void activateTrupp(int number) {
    //TODO new state handling
  }

  void addTrupp(int number) {
    //TODO new state handling
  }

  void addHistoryEntryToTrupp(int truppNumber, HistoryEntry entry) {
    //TODO new state handling
  }

  void ackSoundingAlarm(int truppNumber, AlarmReason alarm) {
    //TODO new state handling
  }

  void setLeaderName(int truppNumber, String? name) {
    //TODO new state handling
  }
  void setMemberName(int truppNumber, String? name) {
    //TODO new state handling
  }
  void setCallName(int truppNumber, String? name) {
    //TODO new state handling
  }
  void setLeaderPressure(int truppNumber, int? pressure) {
    //TODO new state handling
  }
  void setMemberPressure(int truppNumber, int? pressure) {
    //TODO new state handling
  }
  void setTheoreticalDuration(int truppNumber, Duration? duration) {
    //TODO new state handling
  }
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
