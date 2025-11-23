import 'package:asu/ui/auth/scaffold.dart';
import 'package:asu/ui/settings/initial_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostRegisterScreen extends StatelessWidget {
  const PostRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      body: Center(
        child: InitialSettingsForm(
          onSubmit: (pressure, duration) async {
            //TODO needs to change
            await Future.delayed(Duration(seconds: 5));
            if (!context.mounted) return;
            context.goNamed("operation");
          },
        ),
      ),
    );
  }
}
