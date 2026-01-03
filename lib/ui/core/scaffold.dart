import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../firebase/firebase_auth_provider.dart';
import 'about_dialog.dart';

class AsuScaffold extends ConsumerWidget {
  final Widget? title;
  final Widget body;
  final bool showSettings;

  const AsuScaffold({
    super.key,
    this.title,
    required this.body,
    this.showSettings = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          if (showSettings)
            IconButton(
              onPressed: () {
                context.goNamed('settings');
              },
              icon: const Icon(Icons.settings),
            ),
          IconButton(
            onPressed: () {
              showAsuAbout(context: context);
            },
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(firebaseAuthServiceProvider).signOut();
              if (!context.mounted) return;
              context.goNamed('login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: body,
    );
  }
}
