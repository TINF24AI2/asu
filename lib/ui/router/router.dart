import 'package:asu/ui/core/core.dart';
import 'package:asu/ui/horizontal_trupp_view.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  // Assume we have an authState provider that notifies about authentication changes
  // and we are already logged in
  // TODO change this as soon as firebase is integrated

  final einsatzKey = GlobalKey();

  return GoRouter(
    initialLocation: '/operation',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final name = state.topRoute?.name;
          return AsuScaffold(body: child, topRouteName: name);
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
            builder: (context, state) => const Placeholder(),
            name: 'settings',
          ),
        ],
      ),
    ],
  );
}
