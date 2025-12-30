import 'package:asu/ui/model/einsatz/einsatz.dart';
import 'package:asu/ui/model/trupp/trupp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asu/ui/trupp/report.dart';
import 'package:asu/ui/model/history/history.dart';

class ReportHandler extends ConsumerWidget {
  final int truppNumber;

  const ReportHandler({super.key, required this.truppNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trupp = ref.watch(
      einsatzProvider.select((e) => e.trupps[truppNumber]),
    );

    if (trupp == null) {
      return const Center(child: Text('Trupp existiert nicht.'));
    }
    if (trupp is! TruppAction) {
      return Center(child: Text('Trupp ${trupp.number + 1} ist nicht aktiv.'));
    }

    final lowestPressure = trupp.lowestPressure;
    final notifier = ref.read(einsatzProvider.notifier);

    return Report(
      onPressureSelected: (selectedPressure, role) {
        notifier.addHistoryEntryToTrupp(
          truppNumber,
          PressureHistoryEntry(
            date: DateTime.now(),
            leaderPressure: selectedPressure,
            memberPressure: selectedPressure,
          ),
        );
      },
      onStatusSelected: (selectedStatus) {
        notifier.addHistoryEntryToTrupp(
          truppNumber,
          StatusHistoryEntry(date: DateTime.now(), status: selectedStatus),
        );
      },
      onLocationSelected: (selectedLocation) {
        notifier.addHistoryEntryToTrupp(
          truppNumber,
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
