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
    final TruppForm trupp =
        ref.watch(einsatzProvider.select((e) => e.trupps[truppNumber]))
            as TruppForm;
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
              const Text('Funk: '),
              if (trupp.callName != null) ...[
                Text(trupp.callName!),
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
                      // Add to repository if the call number is new
                      if (!radioCallsList.any((r) => r.name == result)) {
                        try {
                          await ref
                              .read(radioCallRepositoryProvider)
                              .add(result);
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
                            .setCallName(truppNumber, result);
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
                  // deployment duration
                  if (trupp.theoreticalDuration == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Die Einsatzdauer muss ausgewählt werden',
                        ),
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
                label: Text(
                  trupp.theoreticalDuration != null
                      ? '${trupp.theoreticalDuration!.inMinutes} Min'
                      : 'Zeit wählen',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
