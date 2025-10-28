import 'package:flutter/material.dart';

// temporary static list  because the data backend is not yet implemented
const List<String> defaultCandidates = [
  'Person1',
  'Person2',
  'Person3',
  'Person4',
  'Person5',
  'Person6',
];

// maximum members within a troop
const int defaultMaxMembers = 2;

/* shows a dialog that lets the user pick a name from the list or enter a custom name.
   'candidates' is the function parameter and can be provided to override the default list
  -> returns the chosen/entered name or null. */
Future<String?> showAddPersonDialog(
  BuildContext context, {
  List<String>? candidates,
}) {
  final list = candidates ?? defaultCandidates;
  String? typed;

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Person hinzufügen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // candidate list which uses the data bank or falls back to the default hardcoded list
          // right now it just uses the default list because there is no data backend yet
          for (var c in list)
            ListTile(title: Text(c), onTap: () => Navigator.of(context).pop(c)),
          // free text input
          TextField(
            onChanged: (v) => typed = v,
            decoration: const InputDecoration(labelText: 'Anderer Name:'),
          ),
        ],
      ),
      actions: [
        // when you cancel it return null
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () {
            if (typed != null && typed!.trim().isNotEmpty) {
              Navigator.of(context).pop(typed!.trim()); // return entered name
            } else {
              Navigator.of(context).pop(); //return null if input is empty
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
