import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // for ConsumerWidget
import 'package:go_router/go_router.dart';

import 'settings_list_editor.dart';
import '../../repositories/firefighters_repository.dart';
import '../../repositories/radio_call_repository.dart';
import '../../repositories/locations_repository.dart';
import '../../repositories/status_repository.dart';

enum SettingsKey {
  // stable keys for the editable lists
  truppMembers,
  callNumbers,
  locations,
  status,
}

/* settings page shows 4 editable lists backed by Firestore repositories
  -> changes are persisted to Firestore and seen app-wide */
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  // Helper to open the editor dialog for a specific setting type
  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    SettingsKey key,
    String title,
    StreamProvider<List<dynamic>> streamProvider,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => SettingsListEditor(
        title: title,
        streamProvider: streamProvider,
        onAdd: (name) async {
          try {
            switch (key) {
              case SettingsKey.truppMembers:
                final repo = ref.read(firefightersRepositoryProvider);
                if (repo != null) {
                  await repo.add(name);
                } else {
                  throw Exception('Repository nicht verfügbar');
                }
                break;
              case SettingsKey.callNumbers:
                final repo = ref.read(radioCallRepositoryProvider);
                if (repo != null) {
                  await repo.add(name);
                } else {
                  throw Exception('Repository nicht verfügbar');
                }
                break;
              case SettingsKey.locations:
                final repo = ref.read(locationsRepositoryProvider);
                if (repo != null) {
                  await repo.add(name);
                } else {
                  throw Exception('Repository nicht verfügbar');
                }
                break;
              case SettingsKey.status:
                final repo = ref.read(statusRepositoryProvider);
                if (repo != null) {
                  await repo.add(name);
                } else {
                  throw Exception('Repository nicht verfügbar');
                }
                break;
            }
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('"$name" hinzugefügt')));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fehler beim Hinzufügen: $e')),
              );
            }
          }
        },
        onDelete: (id, name) async {
          try {
            switch (key) {
              case SettingsKey.truppMembers:
                final repo = ref.read(firefightersRepositoryProvider);
                if (repo != null) {
                  await repo.delete(id);
                } else {
                  throw Exception('Repository nicht verfügbar');
                }
                break;
              case SettingsKey.callNumbers:
                final repo = ref.read(radioCallRepositoryProvider);
                if (repo != null) {
                  await repo.delete(id);
                } else {
                  throw Exception('Repository nicht verfügbar');
                }
                break;
              case SettingsKey.locations:
                final repo = ref.read(locationsRepositoryProvider);
                if (repo != null) {
                  await repo.delete(id);
                } else {
                  throw Exception('Repository nicht verfügbar');
                }
                break;
              case SettingsKey.status:
                final repo = ref.read(statusRepositoryProvider);
                if (repo != null) {
                  await repo.delete(id);
                } else {
                  throw Exception('Repository nicht verfügbar');
                }
                break;
            }
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('"$name" gelöscht')));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fehler beim Löschen: $e')),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all the stream providers
    final firefightersAsync = ref.watch(firefightersStreamProvider);
    final radioCallsAsync = ref.watch(radioCallsStreamProvider);
    final locationsAsync = ref.watch(locationsStreamProvider);
    final statusAsync = ref.watch(statusStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed('operation');
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Firefighters (Truppmitglieder)
          firefightersAsync.when(
            data: (firefighters) {
              return ListTile(
                title: const Text('Truppmitglieder'),
                subtitle: Text('${firefighters.length} Einträge'),
                onTap: () => _openEditor(
                  context,
                  ref,
                  SettingsKey.truppMembers,
                  'Truppmitglieder',
                  firefightersStreamProvider,
                ),
                trailing: const Icon(Icons.chevron_right),
              );
            },
            loading: () => const ListTile(
              title: Text('Truppmitglieder'),
              subtitle: Text('Lädt...'),
              trailing: CircularProgressIndicator(),
            ),
            error: (err, stack) => ListTile(
              title: const Text('Truppmitglieder'),
              subtitle: Text('Fehler: $err'),
              trailing: const Icon(Icons.error),
            ),
          ),
          const Divider(),

          // Radio call numbers (Funkrufnummern)
          radioCallsAsync.when(
            data: (radioCalls) {
              return ListTile(
                title: const Text('Funkrufnummer'),
                subtitle: Text('${radioCalls.length} Einträge'),
                onTap: () => _openEditor(
                  context,
                  ref,
                  SettingsKey.callNumbers,
                  'Funkrufnummer',
                  radioCallsStreamProvider,
                ),
                trailing: const Icon(Icons.chevron_right),
              );
            },
            loading: () => const ListTile(
              title: Text('Funkrufnummer'),
              subtitle: Text('Lädt...'),
              trailing: CircularProgressIndicator(),
            ),
            error: (err, stack) => ListTile(
              title: const Text('Funkrufnummer'),
              subtitle: Text('Fehler: $err'),
              trailing: const Icon(Icons.error),
            ),
          ),
          const Divider(),

          // Locations (Standort)
          locationsAsync.when(
            data: (locations) {
              return ListTile(
                title: const Text('Standort'),
                subtitle: Text('${locations.length} Einträge'),
                onTap: () => _openEditor(
                  context,
                  ref,
                  SettingsKey.locations,
                  'Standort',
                  locationsStreamProvider,
                ),
                trailing: const Icon(Icons.chevron_right),
              );
            },
            loading: () => const ListTile(
              title: Text('Standort'),
              subtitle: Text('Lädt...'),
              trailing: CircularProgressIndicator(),
            ),
            error: (err, stack) => ListTile(
              title: const Text('Standort'),
              subtitle: Text('Fehler: $err'),
              trailing: const Icon(Icons.error),
            ),
          ),
          const Divider(),

          // Status (Status)
          statusAsync.when(
            data: (status) {
              return ListTile(
                title: const Text('Status'),
                subtitle: Text('${status.length} Einträge'),
                onTap: () => _openEditor(
                  context,
                  ref,
                  SettingsKey.status,
                  'Status',
                  statusStreamProvider,
                ),
                trailing: const Icon(Icons.chevron_right),
              );
            },
            loading: () => const ListTile(
              title: Text('Status'),
              subtitle: Text('Lädt...'),
              trailing: CircularProgressIndicator(),
            ),
            error: (err, stack) => ListTile(
              title: const Text('Status'),
              subtitle: Text('Fehler: $err'),
              trailing: const Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }
}
