import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/firefighters_repository.dart';
import '../model/einsatz/einsatz.dart';
import '../model/trupp/trupp.dart';
import '../trupp/pressure_selector.dart';
import 'add_person.dart';

class PersonSelector extends ConsumerWidget {
  final int truppNumber;
  final int index;
  final Widget title;
  const PersonSelector({
    super.key,
    required this.truppNumber,
    required this.index,
    required this.title,
  });

  // open dialog and put the returned name into the selected slot
  Future<void> _addToSlot(BuildContext context, WidgetRef ref) async {
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

    // Avoid duplicates -> if the name already exists in the other slot, remove it from there
    final trupp = ref.read(
      einsatzProvider.select((e) => e.trupps[truppNumber]),
    )!;
    final otherMember = index == 0 ? trupp.memberName : trupp.leaderName;

    if (otherMember != null && otherMember == trimmed) {
      if (index == 0) {
        ref.read(einsatzProvider.notifier).setMemberName(truppNumber, null);
      } else {
        ref.read(einsatzProvider.notifier).setLeaderName(truppNumber, null);
      }
    }

    // Add to repository if the name is new
    if (!firefightersList.any((f) => f.name == trimmed)) {
      try {
        final repository = ref.read(firefightersRepositoryProvider);
        if (repository != null) {
          await repository.add(trimmed);
        }
      } catch (e) {
        if (context.mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text('Fehler beim Hinzufügen: $e')),
          );
        }
      }
    }
    if (context.mounted) {
      if (index == 0) {
        ref.read(einsatzProvider.notifier).setLeaderName(truppNumber, trimmed);
      } else {
        ref.read(einsatzProvider.notifier).setMemberName(truppNumber, trimmed);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch stream to keep it active and preload data
    ref.watch(firefightersStreamProvider);
    
    final trupp =
        ref.watch(einsatzProvider.select((e) => e.trupps[truppNumber]))
            as TruppForm;
    final String? name = index == 0 ? trupp.leaderName : trupp.memberName;
    final int? pressure = index == 0
        ? trupp.leaderPressure
        : trupp.memberPressure;
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              title,
              if (name != null) ...[
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    if (index == 0) {
                      ref
                          .read(einsatzProvider.notifier)
                          .setLeaderName(truppNumber, null);
                    } else {
                      ref
                          .read(einsatzProvider.notifier)
                          .setMemberName(truppNumber, null);
                    }
                  },
                ),
              ] else ...[
                TextButton(
                  onPressed: () => _addToSlot(context, ref),
                  child: const Text('Person hinzufügen'),
                ),
              ],
            ],
          ),
        ),
        PressureSelectionButton(
          lowestPressure: trupp.maxPressure,
          maxPressure: trupp.maxPressure,
          onPressureSelected: (int pressure) {
            if (index == 0) {
              ref
                  .read(einsatzProvider.notifier)
                  .setLeaderPressure(truppNumber, pressure);
            } else {
              ref
                  .read(einsatzProvider.notifier)
                  .setMemberPressure(truppNumber, pressure);
            }
          },
          label: index == 0 ? 'Truppführer' : 'Truppmann',
          pressure: pressure,
        ),
      ],
    );
  }
}
