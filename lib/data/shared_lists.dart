import 'package:flutter/foundation.dart';

class SharedLists {
  SharedLists._();

  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  /* Internal backing lists, each of which is mutable and kept private 
    -> callers can't accidentally mutate the shared data */
  static final List<String> _troopMembers = [
    'Anna Müller',
    'Bernd Schmidt',
    'Maurice Meier',
    'Clara Fischer',
  ];

  static final List<String> _callNumbers = [
    'Florian München 40/1',
    'Florian Berlin-Tegel 11/2',
    'Florian Köln 30/1',
    'Florian Hamburg 92/1',
    'Florian Nürnberg 21/3',
  ];

  static final List<String> _locations = [
    '1. OG',
    '2. OG',
    '3. OG',
    'Erdgeschoss',
  ];

  static final List<String> _status = [
    'Am Brandlöschen',
    'Am Erkunden',
    'Im Einsatz',
  ];

  // Public read-only views which are always sorted
  static List<String> get troopMembers => _sorted(_troopMembers);
  static List<String> get callNumbers => _sorted(_callNumbers);
  static List<String> get locations => _sorted(_locations);
  static List<String> get status => _sorted(_status);

  /* replace the entire content of a list. The editor screen uses these when
    -> the user confirms a new list and it replaces the old values */
  static void setTroopMembers(List<String> items) =>
      _replace(_troopMembers, items);
  static void setCallNumbers(List<String> items) =>
      _replace(_callNumbers, items);
  static void setLocations(List<String> items) => _replace(_locations, items);
  static void setStatus(List<String> items) => _replace(_status, items);

  // public helpers -> simple API to add/remove/replace items and notify the UI of it
  static void addToTroopMembers(String s) => _addUnique(_troopMembers, s);
  static void removeFromTroopMembers(String s) => _remove(_troopMembers, s);

  static void addToCallNumbers(String s) => _addUnique(_callNumbers, s);
  static void removeFromCallNumbers(String s) => _remove(_callNumbers, s);

  static void addToLocations(String s) => _addUnique(_locations, s);
  static void removeFromLocations(String s) => _remove(_locations, s);

  static void addToStatus(String s) => _addUnique(_status, s);
  static void removeFromStatus(String s) => _remove(_status, s);

  /* internal helpers
     -> replace destination list with trimmed, non-empty items from src and sort them 
        then bump the notifiers */

  static void _replace(List<String> dest, List<String> src) {
    dest
      ..clear()
      ..addAll(src.map((e) => e.trim()).where((e) => e.isNotEmpty));
    dest.sort(_ci);
    notifier.value++;
  }

  // add an item if it doesn't exist (case-insensitive), trim whitespace, sort and notify listeners
  static void _addUnique(List<String> list, String s) {
    final t = s.trim();
    if (t.isEmpty) return; // ignore empty input
    if (list.any((e) => e.toLowerCase() == t.toLowerCase())) return;
    list.add(t);
    list.sort(_ci);
    notifier.value++;
  }

  // remove all matches case-insensitively and notify
  static void _remove(List<String> list, String s) {
    list.removeWhere((e) => e.toLowerCase() == s.trim().toLowerCase());
    notifier.value++;
  }

  // case-insensitive compare helper used for sorting
  static int _ci(String a, String b) =>
      a.toLowerCase().compareTo(b.toLowerCase());

  // return a sorted, unmodifiable copy for safe public exposure to prevent external mutation
  static List<String> _sorted(List<String> src) {
    final copy = List<String>.from(src);
    copy.sort(_ci);
    return List.unmodifiable(copy);
  }
}
