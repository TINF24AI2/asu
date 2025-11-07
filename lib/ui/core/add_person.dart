import 'package:flutter/material.dart';
import '../../data/shared_lists.dart';
import 'modal_choice_sheet.dart';

/* show a dialog that lets the user pick a name or enter a custom name
  -> Uses 'SharedLists.troopMembers' as of now and returns the selected/entered name or null */
Future<String?> showAddPersonDialog(
  BuildContext context, {
  List<String>? candidates,
}) {
  // use the SharedLists as the source and allow override through 'candidates'
  final list = candidates ?? SharedLists.troopMembers;

  // Use the shared bottom-sheet helper. If callers pass an empty list the
  // sheet will show only the text field (useful for the Settings flow).
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Person hinzufügen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => s.trim().isEmpty ? null : s.trim(),
    textFieldLabel: 'Anderer Name:',
  );
}
