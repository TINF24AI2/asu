import 'package:asu/pubspec.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AsuScaffold extends StatelessWidget {
  final String? topRouteName;
  final Widget body;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AsuScaffold({super.key, this.topRouteName, required this.body});

  void _closeDrawer() {
    if (_scaffoldKey.currentState != null &&
        _scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.closeDrawer();
    }
  }

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
      key: _scaffoldKey,
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
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              context.goNamed('operation');
              _closeDrawer();
              break;
            case 1:
              context.goNamed('protocols');
              _closeDrawer();
              break;
            case 2:
              context.goNamed('settings');
              _closeDrawer();
              break;
            default:
          }
        },
        children: [
          NavigationDrawerDestination(
            icon: Icon(Icons.local_fire_department),
            label: const Text("Einsatz"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.description),
            label: const Text("Protokolle"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings),
            label: const Text("Einstellungen"),
          ),
        ],
      ),
      primary: true,
      body: body,
    );
  }
}
