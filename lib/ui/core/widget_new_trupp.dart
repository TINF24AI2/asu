import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/trupp/trupp.dart';
import '../model/einsatz/einsatz.dart';
import 'add_radio_call_number.dart';
import 'add_time.dart';
import '../../repositories/radio_call_repository.dart';
import 'person_selector.dart';

class WidgetNewTrupp extends ConsumerWidget {
  final int truppNumber;
  const WidgetNewTrupp({super.key, required this.truppNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch stream to keep it active and preload data
    ref.watch(radioCallsStreamProvider);

    // pressure input uses the shared 'Pressure' modal (same behaviour as in 'trupp.dart')
    final einsatz = ref.watch(einsatzProvider);
    final TruppForm trupp = einsatz.trupps[truppNumber] as TruppForm;
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(margin: const EdgeInsets.only(top: 20.0)),
          Text(
            'Trupp $truppNumber',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Leader slot (index 0)
          PersonSelector(
            truppNumber: truppNumber,
            index: 0,
            title: const Text('Truppführer: '),
          ),

          const SizedBox(height: 8),

          // Member slot (index 1)
          PersonSelector(
            truppNumber: truppNumber,
            index: 1,
            title: const Text('Truppmann: '),
          ),

          const SizedBox(height: 8),

          // radio call number row
          Row(
            children: [
              const Text('Funkrufnummer: '),
              if (trupp.callName != null) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    trupp.callName!,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref
                        .read(einsatzProvider.notifier)
                        .setCallName(truppNumber, null);
                  },
                ),
              ] else ...[
                TextButton(
                  onPressed: () async {
                    // Get current radio calls list from the stream
                    final radioCallsAsync = ref.read(radioCallsStreamProvider);
                    final radioCallsList = radioCallsAsync.asData?.value ?? [];
                    final candidates = radioCallsList
                        .map((r) => r.name)
                        .toList();

                    // Store messenger before async gap
                    final messenger = ScaffoldMessenger.of(context);

                    final result = await showSelectCallNumberSheet(
                      context,
                      callNumbers: candidates,
                    );

                    if (result != null) {
                      final trimmed = result.trim();
                      if (trimmed.isEmpty) return;
                      final normalized = trimmed.toLowerCase();

                      // check if call number is already used in any trupp
                      final callNumberUsed = ref
                          .read(einsatzProvider)
                          .trupps
                          .values
                          .any((t) {
                            String? callName;
                            if (t is TruppForm) {
                              callName = t.callName;
                            } else if (t is TruppAction) {
                              callName = t.callName;
                            } else if (t is TruppEnd) {
                              callName = t.callName;
                            }
                            return callName?.toLowerCase() == normalized;
                          });

                      if (callNumberUsed) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Diese Funkrufnummer ist bereits in einem Trupp vergeben',
                            ),
                          ),
                        );
                        return;
                      }

                      String? existingCallName;
                      for (final r in radioCallsList) {
                        if (r.name.toLowerCase() == normalized) {
                          existingCallName = r.name;
                          break;
                        }
                      }

                      if (existingCallName != null &&
                          existingCallName != trimmed) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Diese Funkrufnummer ist bereits vorhanden',
                            ),
                          ),
                        );
                        return;
                      }

                      // Add to repository if the call number is new
                      if (existingCallName == null) {
                        try {
                          final repository = ref.read(
                            radioCallRepositoryProvider,
                          );
                          await repository?.add(trimmed);
                        } catch (e) {
                          if (context.mounted) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Fehler beim Hinzufügen: $e'),
                              ),
                            );
                          }
                        }
                      }
                      if (context.mounted) {
                        ref
                            .read(einsatzProvider.notifier)
                            .setCallName(
                              truppNumber,
                              existingCallName ?? trimmed,
                            );
                      }
                    }
                  },
                  child: const Text('Rufname wählen'),
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
                              (e) => e.trupps[truppNumber],
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
                  ref.read(einsatzProvider.notifier).activateTrupp(truppNumber);
                },
                child: const Text('Start'),
              ),
              const SizedBox(width: 20),
              TextButton.icon(
                onPressed: () async {
                  final result = await showSelectDurationSheet(context);
                  if (result != null) {
                    ref
                        .read(einsatzProvider.notifier)
                        .setTheoreticalDuration(
                          truppNumber,
                          Duration(minutes: result),
                        );
                  }
                },
                icon: const Icon(Icons.timer),
                label: Text('${trupp.theoreticalDuration.inMinutes} Min'),
              ),
            ],
          ),
          // button to end trupp without activation
          if (_canEndWithoutActivation(einsatz)) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(einsatzProvider.notifier).endFormTrupp(truppNumber);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trupp ohne Start beendet')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                ),
                child: const Text('Verzicht auf Einsatzbeginn'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _canEndWithoutActivation(Einsatz einsatz) {
    // check if all trupps with lower numbers are ended
    for (int i = 1; i < truppNumber; i++) {
      final trupp = einsatz.trupps[i];
      if (trupp == null || trupp is! TruppEnd) {
        return false;
      }
    }
    return truppNumber > 1;
  }
}
