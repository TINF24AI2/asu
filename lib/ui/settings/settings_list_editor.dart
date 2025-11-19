import 'package:flutter/material.dart';

/* stateless settings list editor
  the widget itself is stateless and exposes an 'onChanged' callback and the
  transient editing state lives inside the dialog (StatefulBuilder) */
class SettingsListEditor extends StatelessWidget {
  final String title;
  final List<String> initialItems;
  final ValueChanged<List<String>>? onChanged;

  const SettingsListEditor({
    super.key,
    required this.title,
    this.initialItems = const [],
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // the stateful editing happens inside the dialog using StatefulBuilder
    return AlertDialog(
      title: Text(title),
      content: Builder(
        builder: (context) {
          // create a local mutable copy for the dialog
          final items = List<String>.from(
            initialItems.map((e) => e.trim()).where((e) => e.isNotEmpty),
          )..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

          return StatefulBuilder(
            builder: (context, setState) {
              Future<void> addItem() async {
                final controller = TextEditingController();
                final result = await showDialog<String?>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Hinzufügen zu $title'),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Name eingeben',
                      ),
                      onSubmitted: (_) =>
                          Navigator.of(context).pop(controller.text),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Abbrechen'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(controller.text),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                // guard against using the BuildContext after the dialog was dismissed
                if (!context.mounted) return;

                final candidate = result?.trim();
                if (candidate == null || candidate.isEmpty) return;
                if (items.any(
                  (e) => e.toLowerCase() == candidate.toLowerCase(),
                )) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name ist bereits vorhanden')),
                  );
                  return;
                }
                setState(() {
                  items.add(candidate);
                  items.sort(
                    (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
                  );
                });
                onChanged?.call(List<String>.unmodifiable(items));
              }

              Future<void> removeItem(int index) async {
                final name = items[index];
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
                // ensure the dialog's BuildContext is still valid before calling setState
                if (!context.mounted) return;
                if (confirmed == true) {
                  // remove inside setState for clarity, then notify and show feedback
                  setState(() {
                    items.removeAt(index);
                  });
                  onChanged?.call(List<String>.unmodifiable(items));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('"$name" gelöscht')));
                }
              }

              return SizedBox(
                width: double.maxFinite,
                // limit height so dialog remains usable
                height: 300,
                child: Column(
                  children: [
                    Expanded(
                      child: items.isEmpty
                          ? Center(child: Text('Keine Einträge in $title'))
                          : ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, i) {
                                final name = items[i];
                                return ListTile(
                                  title: Text(name),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => removeItem(i),
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
              );
            },
          );
        },
      ),
    );
  }
}
