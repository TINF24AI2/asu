import 'package:flutter/material.dart';
import 'modal_choice_sheet.dart';

// temporary static list of default call numbers because the data backend is not yet implemented
const List<String> defaultCallNumbers = [
  'Florian München 40/1',
  'Florian Berlin-Tegel 11/2',
  'Florian Köln 30/1',
  'Florian Hamburg 92/1',
  'Florian Nürnberg 21/3',
];

// Return the typed call-number string
String? normalizeCallNumber(String input) {
  final s = input.trim();
  if (s.isEmpty) return null;
  return s;
}

/* pick a default call number or type any value
  'callNumbers' is the function parameter and can be provided to override the default list
  -> will show the call numbers from a data bank which still needs to be implemented */
Future<String?> showSelectCallNumberDialog(
  BuildContext context, {
  List<String>? callNumbers,
}) {
  final list = callNumbers ?? defaultCallNumbers;
  String? typed;

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Rufnummer wählen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // candidate list -> uses provided callNumbers or defaults
            for (var c in list)
              ListTile(
                title: Text(c),
                onTap: () => Navigator.of(context, rootNavigator: true).pop(c),
              ),
            const Divider(),
            // free text input
            TextField(
              decoration: const InputDecoration(
                labelText: 'Eigene Rufnummer (z.B. 111234 oder 23-573)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => typed = v,
            ),
          ],
        ),
      ),
      actions: [
        // gives back the entered call number if valid otherwise null
        TextButton(
          onPressed: () {
            if (typed != null && typed!.trim().isNotEmpty) {
              final norm = normalizeCallNumber(typed!.trim());
              if (norm != null) {
                Navigator.of(context, rootNavigator: true).pop(norm);
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: const Text('OK'),
        ),
        // when you cancel it returns null
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Abbrechen'),
        ),
      ],
    ),
  );
}

// bottom-sheet layout with horizontal choice chips and an input field
Future<String?> showSelectCallNumberSheet(
  BuildContext context, {
  List<String>? callNumbers,
}) {
  final list = callNumbers ?? defaultCallNumbers;
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Rufnummer auswählen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => normalizeCallNumber(s),
    textFieldLabel: 'Andere Rufnummer:',
    keyboardType: TextInputType.number,
  );
}
