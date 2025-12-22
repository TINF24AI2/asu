import 'package:asu/ui/model/einsatz/einsatz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asu/repositories/firefighters_repository.dart';
import 'package:asu/repositories/radio_call_repository.dart';
import 'package:asu/repositories/initial_settings_repository.dart';
import 'add_person.dart';
import 'add_radio_call_number.dart';
import 'add_time.dart';
import 'package:asu/ui/trupp/pressure.dart';

// Functional implementation of widget_new_trupp using Firestore repositories

class WidgetNewTrupp extends ConsumerStatefulWidget {
  final int truppNumber;
  const WidgetNewTrupp({super.key, required this.truppNumber});

  @override
  ConsumerState<WidgetNewTrupp> createState() => _WidgetNewTruppState();
}

class _WidgetNewTruppState extends ConsumerState<WidgetNewTrupp> {
  final List<String?> members = [null, null];
  int? _selectedMinutes;
  String? _selectedCallNumber;
  int? _leaderPressure;
  int? _memberPressure;
  // fallback values - overridden by settings if available
  int _defaultPressure = 300;
  int _theoreticalDurationMinutes = 30;

  // load initial settings from repository
  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    try {
      final repository = ref.read(initialSettingsRepositoryProvider);
      final settings = await repository.get();
      if (settings != null && mounted) {
        setState(() {
          _defaultPressure = settings.defaultPressure;
          _theoreticalDurationMinutes = settings.theoreticalDurationMinutes;
        });
      }
    } catch (e) {
      // use default values if loading fails
    }
  }

  // open dialog and put the returned name into the selected slot
  Future<void> _addToSlot(int index) async {
    // Get current firefighters list from the stream
    final firefightersAsync = ref.read(firefightersStreamProvider);
    final firefightersList = firefightersAsync.asData?.value ?? [];
    final candidates = firefightersList.map((f) => f.name).toList();

    // Store messenger before any async operations
    final messenger = ScaffoldMessenger.of(context);

    final result = await showAddPersonDialog(context, candidates: candidates);
    if (result == null) return;
    final trimmed = result.trim();
    if (trimmed.isEmpty) return;

    // Avoid duplicates -> if the name already exists in the other slot, ignore it
    final otherIndex = index == 0 ? 1 : 0;
    if (members[otherIndex] != null && members[otherIndex] == trimmed) return;

    // Add to repository if the name is new
    if (!firefightersList.any((f) => f.name == trimmed)) {
      try {
        await ref.read(firefightersRepositoryProvider).add(trimmed);
      } catch (e) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text('Fehler beim Hinzufügen: $e')),
          );
        }
      }
    }
    if (mounted) {
      setState(() {
        members[index] = trimmed;
      });
    }
  }

  // pressure input uses the shared 'Pressure' modal (same behaviour as in 'trupp.dart')
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: const EdgeInsets.only(top: 30)),
        Text(
          "Trupp ${widget.truppNumber}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
              if (_leaderPressure != null) ...[
                const SizedBox(width: 6),
                Text('($_leaderPressure bar)'),
              ],
              const SizedBox(width: 8),
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
            const Text('Truppmann: '),
            if (members[1] != null) ...[
              Text(members[1]!),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => setState(() => members[1] = null),
              ),
              if (_memberPressure != null) ...[
                const SizedBox(width: 6),
                Text('($_memberPressure bar)'),
              ],
              const SizedBox(width: 8),
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
                  // Get current radio calls list from the stream
                  final radioCallsAsync = ref.read(radioCallsStreamProvider);
                  final radioCallsList = radioCallsAsync.asData?.value ?? [];
                  final candidates = radioCallsList.map((r) => r.name).toList();

                  // Store messenger before async gap
                  final messenger = ScaffoldMessenger.of(context);

                  final result = await showSelectCallNumberSheet(
                    context,
                    callNumbers: candidates,
                  );

                  if (result != null) {
                    // Add to repository if the call number is new
                    if (!radioCallsList.any((r) => r.name == result)) {
                      try {
                        await ref.read(radioCallRepositoryProvider).add(result);
                      } catch (e) {
                        if (mounted) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text('Fehler beim Hinzufügen: $e'),
                            ),
                          );
                        }
                      }
                    }
                    if (mounted) {
                      setState(() => _selectedCallNumber = result);
                    }
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
            ElevatedButton(
              onPressed: () {
                ref
                    .read(einsatzProvider.notifier)
                    .addTrupp(
                      widget.truppNumber,
                      _selectedCallNumber ?? "",
                      members[0] ?? "",
                      members[1] ?? "",
                      DateTime.now(),
                      _leaderPressure ?? (_defaultPressure - 20),
                      _memberPressure ?? (_defaultPressure - 30),
                      _defaultPressure,
                      Duration(
                        minutes:
                            _selectedMinutes ?? _theoreticalDurationMinutes,
                      ),
                    );
              },
              child: const Text('Start'),
            ),
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
            // button for pressure input
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Pressure(
                      onPressureSelected: (selectedPressure, role) {
                        setState(() {
                          if (role == 'Truppführer') {
                            _leaderPressure = selectedPressure;
                          } else {
                            _memberPressure = selectedPressure;
                          }
                        });
                      },
                      lowestPressure:
                          (_leaderPressure ?? _memberPressure) ??
                          (_defaultPressure - 20), // fallback from settings
                    );
                  },
                );
              },
              child: const Text('Druck eintragen'),
            ),
          ],
        ),
      ],
    );
  }
}
