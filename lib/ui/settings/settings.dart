import 'package:flutter/material.dart';
import '../../data/shared_lists.dart';
import 'settings_list_editor.dart';

enum SettingsKey {
  // stable keys for the editable lists
  troopMembers,
  callNumbers,
  locations,
  status,
}

/* settings page shows 4 editable lists backed by 'SharedLists' as source
  -> changes are seen app-wide e.g. in 'WidgetNewTroop' */
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // open the list editor and persist edits to 'SharedLists' using a stable key
  void _openEditor(
    BuildContext context,
    SettingsKey key,
    String title,
    List<String> initial,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsListEditor(
          title: title,
          initialItems: initial,
          onChanged: (newList) {
            // Persist edits using a stable enum key -> decouples UI strings from logic
            const setterMap = {
              SettingsKey.troopMembers: SharedLists.setTroopMembers,
              SettingsKey.callNumbers: SharedLists.setCallNumbers,
              SettingsKey.locations: SharedLists.setLocations,
              SettingsKey.status: SharedLists.setStatus,
            };
            setterMap[key]?.call(newList);
            // amount of entries feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title: ${newList.length} Einträge')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ValueListenableBuilder<int>(
        valueListenable: SharedLists.notifier,
        builder: (context, _, _) => ListView(
          children: [
            ListTile(
              title: const Text('Truppmitglieder'),
              subtitle: Text('${SharedLists.troopMembers.length} Einträge'),
              onTap: () => _openEditor(
                context,
                SettingsKey.troopMembers,
                'Truppmitglieder',
                SharedLists.troopMembers,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),

            ListTile(
              title: const Text('Funkrufnummer'),
              subtitle: Text('${SharedLists.callNumbers.length} Einträge'),
              onTap: () => _openEditor(
                context,
                SettingsKey.callNumbers,
                'Funkrufnummer',
                SharedLists.callNumbers,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),

            ListTile(
              title: const Text('Standort'),
              subtitle: Text('${SharedLists.locations.length} Einträge'),
              onTap: () => _openEditor(
                context,
                SettingsKey.locations,
                'Standort',
                SharedLists.locations,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),

            ListTile(
              title: const Text('Status'),
              subtitle: Text('${SharedLists.status.length} Einträge'),
              onTap: () => _openEditor(
                context,
                SettingsKey.status,
                'Status',
                SharedLists.status,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
