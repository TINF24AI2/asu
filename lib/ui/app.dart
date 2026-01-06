import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/router.dart';
import '../audioplayers/sound_service.dart';
import '../model/einsatz/einsatz.dart';

class AsuApp extends ConsumerWidget {
  const AsuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    ref.listen(
      einsatzProvider.select((e) {
        int count = 0;
        for (final alarmList in e.alarms.values) {
          count += alarmList.where((a) => a.type == AlarmType.sound).length;
        }
        return count;
      }),
      (previous, current) async {
        final soundService = SoundService();
        if (current > 0 && (previous == null || previous == 0)) {
          await soundService.playAlarmSound();
        } else if (current == 0 && previous != null && previous > 0) {
          await soundService.stopAlarmSound();
        }
      }
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Atemschutzüberwachung')),
              body: Center(
                child: Text(
                  'Bitte das Gerät in den Querformatmodus drehen.',
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          );
        }
        return MaterialApp.router(
          title: 'Atemschutzüberwachung',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFE84230),
            ),
          ),
          routerConfig: router,
        );
      },
    );
  }
}
