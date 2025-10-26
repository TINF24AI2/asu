import 'package:flutter/material.dart';

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
                hintText: 'e.g. 17',
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

/// Simple widget showing the selected duration
class TimeDurationSelector extends StatefulWidget {
  const TimeDurationSelector({super.key});

  @override
  State<TimeDurationSelector> createState() => _TimeDurationSelectorState();
}

class _TimeDurationSelectorState extends State<TimeDurationSelector> {
  int? selectedMinutes;

  Future<void> _pick() async {
    final result = await showSelectDurationDialog(context);
    if (result == null) return;
    setState(() => selectedMinutes = result);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Dauer: '),
        if (selectedMinutes != null) ...[
          Text('${selectedMinutes!} min'),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => selectedMinutes = null),
          ),
        ] else ...[
          TextButton(onPressed: _pick, child: const Text('Dauer wählen')),
        ],
      ],
    );
  }
}

/// Same UI as in add_radio_call_number.dart
Future<int?> showSelectDurationSheet(BuildContext context) async {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      int? localSelected;
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
                    'Dauer wählen',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: defaultDurations.map((d) {
                        final selected = localSelected == d;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text('$d min'),
                            selected: selected,
                            onSelected: (_) {
                              setState(() => localSelected = d);
                              // return immediately on chip tap
                              Navigator.of(context).pop(d);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Eigene Dauer in Minuten',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => typed = v,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Abbrechen'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (typed == null || typed!.trim().isEmpty) {
                            Navigator.of(context).pop();
                            return;
                          }
                          final digits = typed!.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );
                          final value = int.tryParse(digits);
                          if (value != null && value >= 1 && value <= 1440) {
                            Navigator.of(context).pop(value);
                          } else {
                            Navigator.of(context).pop();
                          }
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
