import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../firebase/firebase_auth_provider.dart';
import '../auth/auth.dart';
import '../core/qr_scanner.dart';
import '../einsatz/einsatz_screen.dart';
import '../end_einsatz/end_einsatz_screen.dart';
import '../end_einsatz/pdf_preview_screen.dart';
import '../settings/settings.dart';
import '../end_einsatz/einsatz_completed_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final rootKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/',
    redirect: (context, state) {
      final authenticated =
          ref.read(firebaseAuthServiceProvider).currentUser != null;
      if (['/login', '/register'].contains(state.matchedLocation)) {
        if (authenticated) {
          return '/';
        }
        return null;
      } else {
        if (!authenticated) {
          return '/login';
        }
        return null;
      }
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/post_register',
        name: 'post_register',
        builder: (context, state) => const PostRegisterScreen(),
      ),
      GoRoute(
        path: '/qr-scanner',
        name: 'qr_scanner',
        builder: (context, state) {
          return const QrScanner();
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const EinsatzScreen(),
        name: 'operation',
        routes: [
          GoRoute(
            path: 'einsatz-completed',
            name: 'einsatz_completed',
            builder: (context, state) => const EinsatzCompletedScreen(),
          ),
          GoRoute(
            path: 'end-einsatz',
            name: 'end_einsatz',
            builder: (context, state) {
              return const EndEinsatzScreen();
            },
            routes: [
              GoRoute(
                path: 'pdf-preview',
                name: 'pdf_preview',
                builder: (context, state) {
                  final pdfdata = state.uri.queryParameters['pdfdata'];
                  assert(pdfdata != null, 'pdfdata parameter is required');
                  return PdfPreviewScreen(pdfData: base64Url.decode(pdfdata!));
                },
              ),
            ],
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsPage(),
            name: 'settings',
          ),
        ],
      ),
    ],
  );
}
