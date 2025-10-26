import 'package:flutter/material.dart';

// temporary static list of default call numbers
const List<String> defaultCallNumbers = [
  '11-1234',
  '11-568',
  '12-3001',
  '13-042',
  '14-9000',
];

/* Normalize a raw input into the format 'NN-NNNN' and 
  -> returns null if the input isn't 5-6 digits */
String? normalizeCallNumber(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length < 5 || digits.length > 6) return null;
  return '${digits.substring(0, 2)}-${digits.substring(2)}';
}

/* Shows a dialog that offers a list of default call numbers and a free-text input 
  -> returns the selected/entered call number or null. */
Future<String?> showSelectCallNumberDialog(BuildContext context) async {
  String? typed;

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Rufnummer wählen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // candidate list
            for (var c in defaultCallNumbers)
              ListTile(
                title: Text(c),
                onTap: () => Navigator.of(context).pop(c),
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
        // when you cancel it returns null
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
      ],
    ),
  );
}

// small selector widget showing chosen call number and a clear action.
// Should probably be outsourced because it's also used in add_time.dart
class RadioCallNumberSelector extends StatefulWidget {
  const RadioCallNumberSelector({super.key});

  @override
  State<RadioCallNumberSelector> createState() =>
      _RadioCallNumberSelectorState();
}

class _RadioCallNumberSelectorState extends State<RadioCallNumberSelector> {
  String? selected;

  Future<void> _select() async {
    final result = await showSelectCallNumberDialog(context);
    if (result == null) return;
    setState(() => selected = result);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Rufnummer: '),
        if (selected != null) ...[
          Text(selected!),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => selected = null),
          ),
        ] else ...[
          TextButton(onPressed: _select, child: const Text('Nummer wählen')),
        ],
      ],
    );
  }
}

/// Bottom-sheet layout with horizontal choice chips and an input field
Future<String?> showSelectCallNumberSheet(BuildContext context) async {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      String? typed;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rufnummer wählen',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var c in defaultCallNumbers)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(c),
                              selected: false,
                              onSelected: (_) => Navigator.of(context).pop(c),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Eigene Rufnummer (z.B. 11123 oder 12-4734)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => typed = v,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (typed == null || typed!.trim().isEmpty) {
                            Navigator.of(context).pop();
                            return;
                          }
                          final norm = normalizeCallNumber(typed!.trim());
                          if (norm == null) {
                            Navigator.of(context).pop();
                            return;
                          }
                          Navigator.of(context).pop(norm);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
