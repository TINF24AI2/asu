import 'package:flutter/material.dart';
import 'modal_choice_sheet.dart';

// normalize the typed location string
String? normalizeLocation(String input) {
  final s = input.trim();
  if (s.isEmpty) return null;
  return s;
}

/* Show a dialog to pick a location from the provided list or via text input
  -> 'locations' contains the available locations from Firestore
  -> Returns the selected/typed value or null */
Future<String?> showSelectLocationDialog(
  BuildContext context, {
  List<String>? locations,
}) {
  // Use the provided list (typically from locations stream provider)
  final list = locations ?? [];

  // Use the shared bottom-sheet helper
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Standort wählen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => normalizeLocation(s),
    textFieldLabel: 'Anderer Standort:',
    keyboardType: TextInputType.text,
  );
}
