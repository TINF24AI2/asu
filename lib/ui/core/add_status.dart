import 'package:flutter/material.dart';
import 'modal_choice_sheet.dart';

// normalize the typed status string
String? normalizeStatus(String input) {
  final s = input.trim();
  if (s.isEmpty) return null;
  return s;
}

/* Show a dialog to pick a status from the provided list or via text input
  -> 'statuses' contains the available statuses from Firestore
  -> Returns the selected/typed value or null */
Future<String?> showSelectStatusDialog(
  BuildContext context, {
  List<String>? statuses,
}) {
  // Use the provided list (typically from status stream provider)
  final list = statuses ?? [];

  // Use the shared bottom-sheet helper
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Status wählen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => normalizeStatus(s),
    textFieldLabel: 'Anderer Status:',
    keyboardType: TextInputType.text,
  );
}
