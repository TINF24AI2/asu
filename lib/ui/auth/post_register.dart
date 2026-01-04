import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'scaffold.dart';
import '../settings/initial_settings_form.dart';
import '../../repositories/initial_settings_repository.dart';
import '../../firebase/firebase_auth_provider.dart';
import '../../firebase/firestore_provider.dart';

class PostRegisterScreen extends ConsumerWidget {
  const PostRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthScaffold(
      body: Center(
        child: InitialSettingsForm(
          onSubmit: (pressure, duration) async {
            // Get userId directly from currentUser - more reliable than waiting for provider
            final authService = ref.read(firebaseAuthServiceProvider);
            final userId = authService.currentUser?.uid;

            if (userId == null) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fehler: Authentifizierung fehlgeschlagen'),
                ),
              );
              return;
            }

            try {
              // Create repository with current userId
              final firestoreService = ref.read(firestoreServiceProvider);
              final repository = InitialSettingsRepository(
                firestoreService,
                userId: userId,
              );

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
