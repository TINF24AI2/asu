import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/router.dart';

class AsuApp extends ConsumerWidget {
  const AsuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Atemschutzüberwachung',
      theme: ThemeData(primarySwatch: Colors.red),
      routerConfig: router,
    );
  }
}
