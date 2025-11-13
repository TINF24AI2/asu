import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // for ConsumerWidget
import 'settings_list_editor.dart';

// ToDo: placeholder data which needs to be replaced with the DB/repository
// I've kept it here for easy testing and example data for the DB/repository
List<String> devTruppMembers = [
  'Anna Müller',
  'Bernd Schmidt',
  'Clara Fischer',
];

List<String> devCallNumbers = [
  'Florian München 40/1',
  'Florian Berlin-Tegel 11/2',
  'Florian Köln 30/1',
];

List<String> devLocations = ['1. OG', 'Erdgeschoss'];

List<String> devStatus = ['Im Einsatz', 'Am Erkunden'];

enum SettingsKey {
  // stable keys for the editable lists
  truppMembers,
  callNumbers,
  locations,
  status,
}

/* settings page shows 4 editable lists backed by placeholder lists
  -> changes are seen app-wide e.g. in 'WidgetNewTrupp' */
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  // helper to open the stateless editor dialog and apply edits to the
  // top-level dev lists (placeholders until DB/repo is wired)
  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    SettingsKey key,
    String title,
    List<String> initial,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => SettingsListEditor(
        title: title,
        initialItems: initial,
        onChanged: (newList) {
          /* temporarily write edits to the dev placeholders; replace with
          provider/notifier writes once the SettingsRepository is wired */
          final Map<SettingsKey, void Function(List<String>)> _setters = {
            SettingsKey.truppMembers: (items) =>
                devTruppMembers = List<String>.from(items),
            SettingsKey.callNumbers: (items) =>
                devCallNumbers = List<String>.from(items),
            SettingsKey.locations: (items) =>
                devLocations = List<String>.from(items),
            SettingsKey.status: (items) => devStatus = List<String>.from(items),
          };

          _setters[key]?.call(newList);
          /* force rebuild of this widget's element so the stateless page 
             -> reflects the updated top-level lists immediately */
          try {
            (context as Element).markNeedsBuild();
          } catch (_) {}

          // show feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title: ${newList.length} Einträge')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Truppmitglieder'),
            // show current count from the dev placeholder list
            subtitle: Text('${devTruppMembers.length} Einträge'),
            onTap: () => _openEditor(
              context,
              ref,
              SettingsKey.truppMembers,
              'Truppmitglieder',
              devTruppMembers,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),

          ListTile(
            title: const Text('Funkrufnummer'),
            subtitle: Text('${devCallNumbers.length} Einträge'),
            onTap: () => _openEditor(
              context,
              ref,
              SettingsKey.callNumbers,
              'Funkrufnummer',
              devCallNumbers,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),

          ListTile(
            title: const Text('Standort'),
            subtitle: Text('${devLocations.length} Einträge'),
            onTap: () => _openEditor(
              context,
              ref,
              SettingsKey.locations,
              'Standort',
              devLocations,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),

          ListTile(
            title: const Text('Status'),
            subtitle: Text('${devStatus.length} Einträge'),
            onTap: () => _openEditor(
              context,
              ref,
              SettingsKey.status,
              'Status',
              devStatus,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
