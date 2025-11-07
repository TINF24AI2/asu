import 'package:flutter/material.dart';
import '../../data/shared_lists.dart';
import 'settings_list_editor.dart';

/* settings page shows 4 editable lists backed by 'SharedLists' as source
  -> changes are seen app-wide e.g. in 'WidgetNewTroop' */
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // open the list editor and persist edits to 'SharedLists' according to [title]
  void _openEditor(BuildContext context, String title, List<String> initial) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsListEditor(
          title: title,
          initialItems: initial,
          onChanged: (newList) {
            // persist edits to SharedLists so changes are visible app-wide
            switch (title) {
              case 'Truppmitglieder':
                SharedLists.setTroopMembers(newList);
                break;
              case 'Funkrufnummer':
                SharedLists.setCallNumbers(newList);
                break;
              case 'Standort':
                SharedLists.setLocations(newList);
                break;
              case 'Status':
                SharedLists.setStatus(newList);
                break;
            }
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
                'Funkrufnummer',
                SharedLists.callNumbers,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),

            ListTile(
              title: const Text('Standort'),
              subtitle: Text('${SharedLists.locations.length} Einträge'),
              onTap: () =>
                  _openEditor(context, 'Standort', SharedLists.locations),
              trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),

            ListTile(
              title: const Text('Status'),
              subtitle: Text('${SharedLists.status.length} Einträge'),
              onTap: () => _openEditor(context, 'Status', SharedLists.status),
              trailing: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
