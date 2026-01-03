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
    final normalized = trimmed.toLowerCase();

    final existingName = firefightersList
        .map((f) => f.name)
        .firstWhere(
          (name) => name.toLowerCase() == normalized,
          orElse: () => '',
        );

    if (existingName.isNotEmpty && existingName != trimmed) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Dieser Name ist bereits vorhanden'),
        ),
      );
      return;
    }

    // blocks reusing a name in any trupp
    final nameUsed = ref.read(einsatzProvider).trupps.values.any((t) {
      String? leader;
      String? member;
      if (t is TruppForm) {
        leader = t.leaderName;
        member = t.memberName;
      } else if (t is TruppAction) {
        leader = t.leaderName;
        member = t.memberName;
      } else if (t is TruppEnd) {
        leader = t.leaderName;
        member = t.memberName;
      }
      return leader?.toLowerCase() == normalized ||
          member?.toLowerCase() == normalized;
    });

    if (nameUsed) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Dieser Name ist bereits in einem Trupp vergeben'),
        ),
      );
      return;
    }

    // Add to repository if the name is new
    if (existingName.isEmpty) {
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
      final selectedName = existingName.isEmpty ? trimmed : existingName;
      if (index == 0) {
        ref
            .read(einsatzProvider.notifier)
            .setLeaderName(truppNumber, selectedName);
      } else {
        ref
            .read(einsatzProvider.notifier)
            .setMemberName(truppNumber, selectedName);
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
