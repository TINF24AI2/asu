import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'report.dart';
import '../model/trupp/history.dart';
import '../model/trupp/trupp.dart';

class ReportHandler extends ConsumerWidget {
  final TruppNotifierProvider truppProvider;

  const ReportHandler({super.key, required this.truppProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowestPressure = ref.read(
      truppProvider.select((t) => t.lowestPressure),
    );

    return Report(
      onPressureSelected: (selectedPressure, role) {
        ref
            .read(truppProvider.notifier)
            .addHistoryEntry(
              PressureHistoryEntry(
                date: DateTime.now(),
                leaderPressure: selectedPressure,
                memberPressure: selectedPressure,
              ),
            );
      },
      onStatusSelected: (selectedStatus) {
        ref
            .read(truppProvider.notifier)
            .addHistoryEntry(
              StatusHistoryEntry(date: DateTime.now(), status: selectedStatus),
            );
      },
      onLocationSelected: (selectedLocation) {
        ref
            .read(truppProvider.notifier)
            .addHistoryEntry(
              LocationHistoryEntry(
                date: DateTime.now(),
                location: selectedLocation,
              ),
            );
      },
      lowestPressure: lowestPressure,
    );
  }
}
