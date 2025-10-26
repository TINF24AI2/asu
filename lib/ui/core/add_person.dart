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

/* shows a dialog that lets the user pick a name from the list or enter a custom name 
   -> returns the chosen/entered name or null */
Future<String?> showAddPersonDialog(BuildContext context) {
  String? typed;

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Person hinzufügen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // candidate list
          for (var c in defaultCandidates)
            ListTile(title: Text(c), onTap: () => Navigator.of(context).pop(c)),
          // free text input
          TextField(onChanged: (v) => typed = v),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (typed != null && typed!.trim().isNotEmpty) {
              Navigator.of(context).pop(typed!.trim()); // return entered name
            } else {
              Navigator.of(context).pop(); //return null if input is empty
            }
          },
          child: const Text('OK'),
        ),
        // when you cancel it return null
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
      ],
    ),
  );
}
