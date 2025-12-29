import 'package:flutter/material.dart';

import '../../pubspec.g.dart';

class AuthScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? title;
  const AuthScaffold({super.key, this.body, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: Pubspec.name,
                applicationVersion: Pubspec.versionFull,
                applicationLegalese: '© 2025',
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      primary: true,
      body: body,
    );
  }
}
