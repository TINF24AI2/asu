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
    const String title = 'Atemschutzüberwachung';

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          IconButton( 
            onPressed: () {
              context.goNamed('settings');
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: Pubspec.name,
                applicationVersion: Pubspec.versionFull,
                applicationLegalese: '© 2024',
                children: [const Text(Pubspec.description)],
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
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      primary: true,
      body: body,
    );
  }
}
