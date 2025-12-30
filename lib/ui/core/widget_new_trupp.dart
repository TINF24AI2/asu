import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/trupp/trupp.dart';
import '../model/einsatz/einsatz.dart';
import 'add_person.dart';
import 'add_radio_call_number.dart';
import 'add_time.dart';
import '../../repositories/firefighters_repository.dart';
import '../../repositories/radio_call_repository.dart';
import '../../repositories/initial_settings_repository.dart';
import '../trupp/pressure.dart';

// Functional implementation of widget_new_trupp using Firestore repositories

class WidgetNewTrupp extends ConsumerStatefulWidget {
  final int truppNumber;
  const WidgetNewTrupp({super.key, required this.truppNumber});

  @override
  ConsumerState<WidgetNewTrupp> createState() => _WidgetNewTruppState();
}

class _WidgetNewTruppState extends ConsumerState<WidgetNewTrupp> {
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
    final trupp = ref.read(
      einsatzProvider.select((e) => e.trupps[widget.truppNumber]),
    )!;
    final otherMember = index == 0 ? trupp.memberName : trupp.leaderName;

    if (otherMember != null && otherMember == trimmed) return;

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
      if (index == 0) {
        ref
            .read(einsatzProvider.notifier)
            .setLeaderName(widget.truppNumber, trimmed);
      } else {
        ref
            .read(einsatzProvider.notifier)
            .setMemberName(widget.truppNumber, trimmed);
      }
    }
  }

  // pressure input uses the shared 'Pressure' modal (same behaviour as in 'trupp.dart')
  @override
  Widget build(BuildContext context) {
    final TruppForm trupp =
        ref.watch(einsatzProvider.select((e) => e.trupps[widget.truppNumber]))
            as TruppForm;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: const EdgeInsets.only(top: 30)),
        Text(
          'Trupp ${widget.truppNumber}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        // Leader slot (index 0)
        Row(
          children: [
            const Text('Truppführer: '),
            if (trupp.leaderName != null) ...[
              Text(trupp.leaderName!),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref
                      .read(einsatzProvider.notifier)
                      .setLeaderName(widget.truppNumber, null);
                },
              ),
              if (trupp.leaderPressure != null) ...[
                const SizedBox(width: 6),
                Text('(${trupp.leaderPressure} bar)'),
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
            if (trupp.memberName != null) ...[
              Text(trupp.memberName!),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref
                      .read(einsatzProvider.notifier)
                      .setMemberName(widget.truppNumber, null);
                },
              ),
              if (trupp.memberPressure != null) ...[
                const SizedBox(width: 6),
                Text('(${trupp.memberPressure} bar)'),
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
            if (trupp.callName != null) ...[
              Text(trupp.callName!),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref
                      .read(einsatzProvider.notifier)
                      .setCallName(widget.truppNumber, null);
                },
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
                      ref
                          .read(einsatzProvider.notifier)
                          .setCallName(widget.truppNumber, result);
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
                final trupp =
                    ref.read(
                          einsatzProvider.select(
                            (e) => e.trupps[widget.truppNumber],
                          ),
                        )
                        as TruppForm;
                // validations before starting
                // trupp members
                if (trupp.leaderName == null || trupp.leaderName!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Der Truppführer muss ausgewählt werden'),
                    ),
                  );
                  return;
                }

                if (trupp.memberName == null || trupp.memberName!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Der Truppmann muss ausgewählt werden'),
                    ),
                  );
                  return;
                }
                // radio call number
                if (trupp.callName == null || trupp.callName!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Die Rufnummer muss ausgewählt werden'),
                    ),
                  );
                  return;
                }
                // pressure level
                if (trupp.leaderPressure == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Der Druck vom Truppführer fehlt'),
                    ),
                  );
                  return;
                }
                if (trupp.memberPressure == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Der Druck vom Truppmann fehlt'),
                    ),
                  );
                  return;
                }
                // deployment duration
                if (trupp.theoreticalDuration == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Die Einsatzdauer muss ausgewählt werden'),
                    ),
                  );
                  return;
                }

                ref
                    .read(einsatzProvider.notifier)
                    .activateTrupp(widget.truppNumber);
              },
              child: const Text('Start'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await showSelectDurationSheet(context);
                if (result != null) {
                  ref
                      .read(einsatzProvider.notifier)
                      .setTheoreticalDuration(
                        widget.truppNumber,
                        Duration(minutes: result),
                      );
                }
              },
              child: Text(
                trupp.theoreticalDuration != null
                    ? trupp.theoreticalDuration!.toString()
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
                    final initialSettings = ref
                        .watch(initialSettingsStreamProvider)
                        .value;
                    final trupp =
                        ref.watch(
                              einsatzProvider.select(
                                (e) => e.trupps[widget.truppNumber],
                              ),
                            )
                            as TruppForm;
                    return Pressure(
                      onPressureSelected: (selectedPressure, role) {
                        if (role == 'Truppführer') {
                          ref
                              .read(einsatzProvider.notifier)
                              .setLeaderPressure(
                                widget.truppNumber,
                                selectedPressure,
                              );
                        } else {
                          ref
                              .read(einsatzProvider.notifier)
                              .setMemberPressure(
                                widget.truppNumber,
                                selectedPressure,
                              );
                        }
                      },
                      lowestPressure:
                          // Why only from 270 bar upwards?
                          (trupp.leaderPressure ?? trupp.memberPressure) ??
                          ((initialSettings?.defaultPressure ?? 300) + 20),
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
