import 'package:flutter/material.dart';
import 'modal_choice_sheet.dart';

/* dialog and selector for picking a duration in minutes
   Returns the selected minutes as integer or null. */
const List<int> defaultDurations = [
  5,
  10,
  15,
  20,
  25,
  30,
  35,
  40,
  45,
  50,
  55,
  60,
];

Future<int?> showSelectDurationDialog(BuildContext context) {
  String? typed;

  // Normalize typed input to an integer minute value.
  // Accepts only numeric input and bounds to 1..1440 (24 hours).
  int? normalize(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return null;
    final value = int.tryParse(digits);
    if (value == null) return null;
    if (value < 1 || value > 1440) return null;
    return value;
  }

  // pick from defaults or type a custom minute value
  return showDialog<int>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Dauer wählen (Minuten)'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var d in defaultDurations)
              ListTile(
                title: Text('$d min'),
                onTap: () => Navigator.of(context).pop(d),
              ),
            const Divider(),
            // Free-text entry for custom values.
            TextField(
              decoration: const InputDecoration(
                labelText: 'Eigene Dauer in Minuten',
                hintText: 'z.B. 32',
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => typed = v,
            ),
          ],
        ),
      ),
      actions: [
        // pressed OK -> validates typed input and return normalized minutes or null
        TextButton(
          onPressed: () {
            if (typed != null && typed!.trim().isNotEmpty) {
              final norm = normalize(typed!.trim());
              if (norm != null) {
                Navigator.of(context).pop(norm);
              } else {
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Text('OK'),
        ),
        // Cancel and return null
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
      ],
    ),
  );
}

/// bottom-sheet layout with horizontal choice chips and an input field
Future<int?> showSelectDurationSheet(BuildContext context) {
  return showHorizontalChoiceSheet<int, int>(
    context,
    title: 'Dauer auswählen',
    candidates: defaultDurations,
    labelBuilder: (d) => '$d min',
    valueBuilder: (d) => d,
    normalizeTyped: (s) {
      final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
      final value = int.tryParse(digits);
      if (value != null && value >= 1 && value <= 1440) return value;
      return null;
    },
    textFieldLabel: 'Dauer in Minuten:',
    keyboardType: TextInputType.number,
  );
}
