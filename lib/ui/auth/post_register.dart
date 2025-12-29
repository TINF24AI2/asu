import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'scaffold.dart';
import '../settings/initial_settings_form.dart';
import '../../repositories/initial_settings_repository.dart';

class PostRegisterScreen extends ConsumerWidget {
  const PostRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(initialSettingsRepositoryProvider);

    return AuthScaffold(
      body: Center(
        child: InitialSettingsForm(
          onSubmit: (pressure, duration) async {
            // Save the initial settings to Firestore
            await repository.save(
              defaultPressure: pressure,
              theoreticalDurationMinutes: duration.inMinutes,
            );

            if (!context.mounted) return;
            context.goNamed("operation");
          },
        ),
      ),
    );
  }
}
