import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../firebase/firebase_auth_provider.dart';
import '../auth/auth.dart';
import '../core/core.dart';
import '../horizontal_trupp_view.dart';
import '../settings/settings.dart';

part 'router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final einsatzKey = GlobalKey();

  return GoRouter(
    initialLocation: '/operation',
    redirect: (context, state) {
      final authenticated =
          ref.read(firebaseAuthServiceProvider).currentUser != null;
      if (['/login', '/register'].contains(state.matchedLocation)) {
        if (authenticated) {
          return '/operation';
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
        path: "/login",
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: "/register",
        name: 'register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: "/post_register",
        name: 'post_register',
        builder: (context, state) => PostRegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final name = state.topRoute?.name;
          return AsuScaffold(
            body: child,
            topRouteName: name,
            signOut: () async {
              await ref.read(firebaseAuthServiceProvider).signOut();
            },
          );
        },
        routes: [
          GoRoute(
            path: '/operation',
            builder: (context, state) => HorizontalTruppView(key: einsatzKey),
            name: 'operation',
          ),
          GoRoute(
            path: '/protocols',
            builder: (context, state) => const Placeholder(),
            name: 'protocols',
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
            name: 'settings',
          ),
        ],
      ),
    ],
  );
}
