import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/core.dart';

// screen shown after einsatz completion with option to start a new einsatz
class EinsatzCompletedScreen extends ConsumerWidget {
  const EinsatzCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsuScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Einsatz abgeschlossen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.goNamed('operation'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                backgroundColor: const Color(0xFFE84230),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Neuen Einsatz beginnen',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
