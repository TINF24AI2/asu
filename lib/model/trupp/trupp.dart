import 'package:freezed_annotation/freezed_annotation.dart';

import '../history/history.dart';

part 'trupp.freezed.dart';

@freezed
sealed class Trupp with _$Trupp {
  const factory Trupp.action({
    required int number,
    required String callName,
    required String leaderName,
    required String memberName,
    @Default([]) List<HistoryEntry> history,
    required Duration sinceStart,
    required Duration potentialEnd,
    required Duration theoreticalEnd,
    required Duration nextCheck,
    required Duration checkInterval,
    required int lowestPressure,
    required int lowestStartPressure,
    required int maxPressure,
  }) = TruppAction;
  const factory Trupp.form({
    required int number,
    String? callName,
    String? leaderName,
    String? memberName,
    int? leaderPressure,
    int? memberPressure,
    @Default(Duration(minutes: 30)) Duration theoreticalDuration,
    @Default(300) int maxPressure,
  }) = TruppForm;
  const factory Trupp.end({
    required int number,
    required String callName,
    required String leaderName,
    required String memberName,
    required List<HistoryEntry> history,
    required Duration inAction,
  }) = TruppEnd;
}

@freezed
sealed class TruppDates with _$TruppDates {
  const factory TruppDates({
    required DateTime start,
    required DateTime theoreticalEnd,
    required DateTime potentialEnd,
    required DateTime nextCheck,
  }) = _TruppDates;
}
