import 'package:flutter/material.dart';
import 'modal_choice_sheet.dart';

// normalize the typed call number string
String? normalizeCallNumber(String input) {
  final s = input.trim();
  if (s.isEmpty) return null;
  return s;
}

/* Show a dialog to pick a call number from the provided list or via text input
  -> 'callNumbers' contains the available radio call numbers from Firestore
  -> Returns the selected/typed value or null */
Future<String?> showSelectCallNumberDialog(
  BuildContext context, {
  List<String>? callNumbers,
}) {
  // Use the provided list (typically from radio calls stream provider)
  final list = callNumbers ?? [];

  // Use the shared bottom-sheet helper; callers may pass an empty list to
  // show only the text input (useful for Settings).
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Funkrufnummer wählen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => normalizeCallNumber(s),
    textFieldLabel: 'Eigene Funkrufnummer (z.B. 111234 oder 23-573)',
    keyboardType: TextInputType.text,
  );
}

// bottom-sheet layout with horizontal choice chips and an input field
Future<String?> showSelectCallNumberSheet(
  BuildContext context, {
  List<String>? callNumbers,
}) {
  final list = callNumbers ?? [];
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Funkrufnummer auswählen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => normalizeCallNumber(s),
    textFieldLabel: 'Andere Funkrufnummer:',
    keyboardType: TextInputType.text,
  );
}
