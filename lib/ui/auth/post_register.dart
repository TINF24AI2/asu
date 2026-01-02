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
    return AuthScaffold(
      body: Center(
        child: InitialSettingsForm(
          onSubmit: (pressure, duration) async {
            // Ensure repository is available before saving
            final repository = ref.read(initialSettingsRepositoryProvider);
            if (repository == null) {
              // Should not happen since user just registered, but guard anyway
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fehler: Authentifizierung fehlgeschlagen'),
                ),
              );
              return;
            }
            try {
              await repository.save(
                defaultPressure: pressure,
                theoreticalDurationMinutes: duration.inMinutes,
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fehler beim Speichern der Einstellungen: $e'),
                ),
              );
              return;
            }
            if (!context.mounted) return;
            context.goNamed('operation');
          },
        ),
      ),
    );
  }
}
