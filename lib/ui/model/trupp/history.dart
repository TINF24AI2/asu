abstract class HistoryEntry {
  final DateTime _date;
  DateTime get date => _date;

  const HistoryEntry({required DateTime date}) : _date = date;
}

class PressureHistoryEntry extends HistoryEntry {
  final int _leaderPressure;
  final int _memberPressure;

  int get leaderPressure => _leaderPressure;
  int get memberPressure => _memberPressure;

  const PressureHistoryEntry({
    required super.date,
    required int leaderPressure,
    required int memberPressure,
  }) : _leaderPressure = leaderPressure,
       _memberPressure = memberPressure;
}

class StatusHistoryEntry extends HistoryEntry {
  final String _status;

  String get status => _status;

  const StatusHistoryEntry({required super.date, required String status})
    : _status = status;
}

class LocationHistoryEntry extends HistoryEntry {
  final String _location;

  String get location => _location;

  const LocationHistoryEntry({required super.date, required String location})
    : _location = location;
}
