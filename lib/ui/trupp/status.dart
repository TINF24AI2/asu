import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/status_repository.dart';
import '../core/add_status.dart';

class Status extends ConsumerWidget {
  final Function(String) onStatusSelected;

  const Status({super.key, required this.onStatusSelected});

  Future<void> _handleAddStatus(
    BuildContext context,
    WidgetRef ref,
    List<String> existingStatuses,
  ) async {
    // Store messenger before async gap
    final messenger = ScaffoldMessenger.of(context);

    final selected = await showSelectStatusDialog(
      context,
      statuses: existingStatuses,
    );

    if (selected == null || !context.mounted) return;

    final trimmed = selected.trim();
    if (trimmed.isEmpty) return;
    final normalized = trimmed.toLowerCase();

    // Check if status already exists (case-insensitive)
    String? existingStatus;
    for (final status in existingStatuses) {
      if (status.toLowerCase() == normalized) {
        existingStatus = status;
        break;
      }
    }

    // If it exists with different casing, show informational message
    // (but continue and use the existing one)
    if (existingStatus != null && existingStatus != trimmed) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Dieser Status ist bereits vorhanden: "$existingStatus"',
          ),
        ),
      );
      // Don't return - we'll use the existing one below
    }

    // Add to repository if the status is new
    if (existingStatus == null) {
      final repo = ref.read(statusRepositoryProvider);
      if (repo != null) {
        try {
          await repo.add(trimmed);
        } catch (e) {
          if (context.mounted) {
            messenger.showSnackBar(
              SnackBar(content: Text('Fehler beim Hinzufügen: $e')),
            );
            return;
          }
        }
      }
    }

    // Call the callback with the selected status
    if (context.mounted) {
      onStatusSelected(existingStatus ?? trimmed);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(statusStreamProvider);
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Status eintragen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Display statuses from settings
          statusAsync.when(
            data: (statuses) {
              final statusNames = statuses.map((s) => s.name).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (statusNames.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Keine Status verfügbar.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8.0,
                      children: statusNames.map((statusName) {
                        return ElevatedButton(
                          onPressed: () {
                            onStatusSelected(statusName);
                            Navigator.pop(context);
                          },
                          child: Text(statusName),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _handleAddStatus(
                      context,
                      ref,
                      statusNames,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Status hinzufügen/auswählen'),
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text(
              'Fehler beim Laden des Status: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
