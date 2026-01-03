import 'package:flutter/material.dart';

import '../core/about_dialog.dart';

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
              showAsuAbout(context: context);
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
