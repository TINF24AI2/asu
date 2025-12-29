import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pubspec.g.dart';

class AsuScaffold extends StatelessWidget {
  final String? topRouteName;
  final Widget body;
  final Future<void> Function()? signOut;

  const AsuScaffold({
    super.key,
    this.topRouteName,
    required this.body,
    this.signOut,
  });

  @override
  Widget build(BuildContext context) {
    String title = 'Atemschutzüberwachung';
    int selectedIndex = -1;
    switch (topRouteName) {
      case 'operation':
        title = 'Einsatz - Atemschutzüberwachung';
        selectedIndex = 0;
        break;
      case 'protocols':
        title = 'Protokolle - Atemschutzüberwachung';
        selectedIndex = 1;
        break;
      case 'settings':
        title = 'Einstellungen - Atemschutzüberwachung';
        selectedIndex = 2;
        break;
      default:
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: Pubspec.name,
                applicationVersion: Pubspec.versionFull,
                applicationLegalese: '© 2024',
                children: [Text(Pubspec.description)],
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: () async {
              if (signOut != null) {
                await signOut!();
                if (!context.mounted) return;
                context.goNamed('login');
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              context.goNamed('operation');
              break;
            case 1:
              context.goNamed('protocols');
              break;
            case 2:
              context.goNamed('settings');
              break;
            default:
          }
        },
        children: [
          NavigationDrawerDestination(
            icon: const Icon(Icons.local_fire_department),
            label: const Text("Einsatz"),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.description),
            label: const Text("Protokolle"),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.settings),
            label: const Text("Einstellungen"),
          ),
        ],
      ),
      primary: true,
      body: body,
    );
  }
}
