import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audioplayers/sound_service.dart';
import '../../model/einsatz/einsatz.dart';

class AlarmView extends ConsumerWidget {
  final int truppNumber;
  final List<Alarm> alarms;
  final VoidCallback onClose;

  const AlarmView({
    super.key,
    required this.truppNumber,
    required this.alarms,
    required this.onClose,
  });

  String _getAlarmText(AlarmReason reason) {
    switch (reason) {
      case AlarmReason.checkPressure:
        return 'DRUCK ABFRAGEN!';
      case AlarmReason.lowPressure:
        return 'NIEDRIGER DRUCK!';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (alarms.isEmpty) return const SizedBox.shrink();

    final soundService = SoundService();

    final hasSoundingAlarm = alarms.any((a) => a.type == AlarmType.sound);
    if (hasSoundingAlarm) {
      soundService.playAlarmSound();
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            ...alarms.map(
              (alarm) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Trupp $truppNumber - ${_getAlarmText(alarm.reason)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await soundService.stopAlarmSound();
                for (var alarm in alarms) {
                  ref
                      .read(einsatzProvider.notifier)
                      .ackVisualAlarm(truppNumber, alarm.reason);
                }
                onClose();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check),
              label: const Text('Bestätigen'),
            ),
          ],
        ),
      ),
    );
  }
}
