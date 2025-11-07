import 'package:flutter/material.dart';
import '../../data/shared_lists.dart';
import 'add_person.dart';
import 'add_radio_call_number.dart';
import 'add_time.dart';

// minimal functional implementation of widget_new_troop

class WidgetNewTroop extends StatefulWidget {
  const WidgetNewTroop({super.key});

  @override
  State<WidgetNewTroop> createState() => _WidgetNewTroopState();
}

class _WidgetNewTroopState extends State<WidgetNewTroop> {
  // two-slot storage -> index 0 = leader, index 1 = other member
  final List<String?> members = [null, null];
  int? _selectedMinutes;
  String? _selectedCallNumber;
  // open dialog and put the returned name into the selected slot
  Future<void> _addToSlot(int index) async {
    final result = await showAddPersonDialog(context);
    if (result == null) return;
    final trimmed = result.trim();
    if (trimmed.isEmpty) return;

    // Avoid duplicates -> if the name already exists in the other slot, ignore it
    final otherIndex = index == 0 ? 1 : 0;
    if (members[otherIndex] != null && members[otherIndex] == trimmed) return;

    // persist to shared lists so settings reflect the new names immediately
    SharedLists.addToTroopMembers(trimmed);
    setState(() {
      members[index] = trimmed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trupp 1'), // ToDo: make dynamic later
        // Leader slot (index 0)
        Row(
          children: [
            const Text('Truppführer: '),
            if (members[0] != null) ...[
              Text(members[0]!),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => setState(() => members[0] = null),
              ),
            ] else ...[
              TextButton(
                onPressed: () => _addToSlot(0),
                child: const Text('Person hinzufügen'),
              ),
            ],
          ],
        ),

        // Member slot (index 1)
        Row(
          children: [
            const Text('Truppmitglied: '),
            if (members[1] != null) ...[
              Text(members[1]!),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => setState(() => members[1] = null),
              ),
            ] else ...[
              TextButton(
                onPressed: () => _addToSlot(1),
                child: const Text('Person hinzufügen'),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        // radio call number row
        Row(
          children: [
            const Text('Rufnummer: '),
            if (_selectedCallNumber != null) ...[
              Text(_selectedCallNumber!),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => setState(() => _selectedCallNumber = null),
              ),
            ] else ...[
              TextButton(
                onPressed: () async {
                  final result = await showSelectCallNumberSheet(context);
                  if (result != null) {
                    // persist selected/typed call number to shared lists
                    SharedLists.addToCallNumbers(result);
                    setState(() => _selectedCallNumber = result);
                  }
                },
                child: const Text('Nummer wählen'),
              ),
            ],
          ],
        ),

        const SizedBox(height: 12),

        // action row -> start and duration selector
        Row(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Start')),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await showSelectDurationSheet(context);
                if (result != null) setState(() => _selectedMinutes = result);
              },
              child: Text(
                _selectedMinutes != null
                    ? '${_selectedMinutes!} Minuten'
                    : 'Zeit wählen',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
