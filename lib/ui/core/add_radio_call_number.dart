import 'package:flutter/material.dart';
import '../settings/settings.dart'
    show devCallNumbers; // mutable dev placeholder
import 'modal_choice_sheet.dart';

// normalize the typed call number string
String? normalizeCallNumber(String input) {
  final s = input.trim();
  if (s.isEmpty) return null;
  return s;
}

/* show a dialog to pick a call number from the shared list or per text input
  -> 'callNumbers' can override the source and returns the selected/typed value or null */
Future<String?> showSelectCallNumberDialog(
  BuildContext context, {
  List<String>? callNumbers,
}) {
  // use the provided override or fall back to dev placeholder values.
  // ToDo: wire this to the repository / DB later.
  final list = callNumbers ?? devCallNumbers;

  // Use the shared bottom-sheet helper; callers may pass an empty list to
  // show only the text input (useful for Settings).
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Rufnummer wählen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => normalizeCallNumber(s),
    textFieldLabel: 'Eigene Rufnummer (z.B. 111234 oder 23-573)',
    keyboardType: TextInputType.text,
  );
}

// bottom-sheet layout with horizontal choice chips and an input field
Future<String?> showSelectCallNumberSheet(
  BuildContext context, {
  List<String>? callNumbers,
}) {
  final list = callNumbers ?? devCallNumbers;
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Rufnummer auswählen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => normalizeCallNumber(s),
    textFieldLabel: 'Andere Rufnummer:',
    keyboardType: TextInputType.text,
  );
}
