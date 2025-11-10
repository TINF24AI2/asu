import 'package:flutter/material.dart';

/* Reusable editor for a named list of strings
  -> shows the provided 'initialItems' in an alphabetic order and allows adding items
      through a dialog which is duplicate-safe
  -> requires confirmation for deletions
  -> 'onChanged' is called with an immutable snapshot after every change */
class SettingsListEditor extends StatefulWidget {
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
  State<SettingsListEditor> createState() => _SettingsListEditorState();
}

class _SettingsListEditorState extends State<SettingsListEditor> {
  late List<String> items;

  @override
  void initState() {
    super.initState();
    // create a local, trimmed, non-empty, modifiable copy of the initial items
    items = List<String>.from(
      widget.initialItems.map((e) => e.trim()).where((e) => e.isNotEmpty),
    );
    // ensures alphabetic and case-insensitive order
    items.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  void _notify() {
    // notify external listener with an immutable snapshot
    widget.onChanged?.call(List<String>.unmodifiable(items));
    // rebuild UI to reflect the change (only if still mounted)
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _addItem() async {
    final controller = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hinzufügen zu ${widget.title}'),
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
        );
      },
    );

    /* if the widget was removed while the dialog was open -> bail out to avoid
     using the BuildContext or calling setState across an async gap. */
    if (!mounted) return;

    // Validate input
    final candidate = result?.trim();
    if (candidate == null || candidate.isEmpty) return;
    // prevent case-insensitive duplicates
    if (items.any((e) => e.toLowerCase() == candidate.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name ist bereits vorhanden')),
      );
      return;
    }
    // add and sort the list
    items.add(candidate);
    items.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    _notify();
  }

  Future<void> _removeItem(int index) async {
    final name = items[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        // confirm deletion
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
    // Avoid using context or setState after an async gap if the widget was disposed while the dialog was shown.
    if (!mounted) return;

    if (confirmed == true) {
      // remove the item and notify listeners
      final removed = items.removeAt(index);
      _notify();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('"$removed" gelöscht')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: items.isEmpty
          // empty state
          ? Center(child: Text('Keine Einträge in ${widget.title}'))
          // list of items with delete buttons
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final name = items[i];
                return ListTile(
                  title: Text(name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _removeItem(i),
                    tooltip: 'Löschen',
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
