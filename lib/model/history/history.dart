import 'package:freezed_annotation/freezed_annotation.dart';

part 'history.freezed.dart';

@freezed
sealed class HistoryEntry with _$HistoryEntry {
  const factory HistoryEntry.pressure({
    required DateTime date,
    required int leaderPressure,
    required int memberPressure,
  }) = PressureHistoryEntry;
  const factory HistoryEntry.status({
    required DateTime date,
    required String status,
  }) = StatusHistoryEntry;
  const factory HistoryEntry.location({
    required DateTime date,
    required String location,
  }) = LocationHistoryEntry;
}
