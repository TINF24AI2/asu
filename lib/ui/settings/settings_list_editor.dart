import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Settings list editor that works with repository callbacks
class SettingsListEditor extends ConsumerWidget {
  final String title;
  final StreamProvider<List<dynamic>> streamProvider;
  final Future<void> Function(String name)? onAdd;
  final Future<void> Function(String id, String name)? onDelete;

  const SettingsListEditor({
    super.key,
    required this.title,
    required this.streamProvider,
    this.onAdd,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(streamProvider);

    return dataAsync.when(
      data: (items) {
        Future<void> addItem() async {
          final controller = TextEditingController();
          final result = await showDialog<String?>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Hinzufügen zu $title'),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name eingeben'),
                onSubmitted: (_) => Navigator.of(context).pop(controller.text),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          if (!context.mounted) return;

          final candidate = result?.trim();
          if (candidate == null || candidate.isEmpty) return;

          // Check for duplicates (case-insensitive)
          if (items.any((item) {
            final name = item.name as String;
            return name.toLowerCase() == candidate.toLowerCase();
          })) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Name ist bereits vorhanden')),
            );
            return;
          }

          // Call the repository add method
          if (onAdd != null) {
            try {
              await onAdd!(candidate);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fehler: $e')),
                );
              }
            }
          }
        }

        Future<void> removeItem(String id, String name) async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Löschen bestätigen'),
              content: Text('Soll "$name" wirklich gelöscht werden?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Löschen'),
                ),
              ],
            ),
          );

          if (!context.mounted) return;
          if (confirmed != true) return;

          // Call the repository delete method
          if (onDelete != null) {
            try {
              await onDelete!(id, name);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fehler: $e')),
                );
              }
            }
          }
        }

        // Re-sort entries for display
        final sortedItems = List.from(items)
          ..sort((a, b) => (a.name as String)
              .toLowerCase()
              .compareTo((b.name as String).toLowerCase()));

        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: sortedItems.isEmpty
                      ? Center(child: Text('Keine Einträge in $title'))
                      : ListView.builder(
                          itemCount: sortedItems.length,
                          itemBuilder: (context, i) {
                            final item = sortedItems[i];
                            return ListTile(
                              title: Text(item.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () =>
                                    removeItem(item.id, item.name),
                                tooltip: 'Löschen',
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Schließen'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: addItem,
                      icon: const Icon(Icons.add),
                      label: const Text('Hinzufügen'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => AlertDialog(
        title: Text(title),
        content: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => AlertDialog(
        title: Text(title),
        content: Text('Fehler: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }
}
