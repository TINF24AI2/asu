import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/einsatz/einsatz.dart';
import '../../model/trupp/trupp.dart';
import 'report.dart';
import '../../model/history/history.dart';

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
      onPressureSelected: (leaderPressure, memberPressure) {
        notifier.addHistoryEntryToTrupp(
          truppNumber,
          PressureHistoryEntry(
            date: DateTime.now(),
            leaderPressure: leaderPressure,
            memberPressure: memberPressure,
          ),
        );
        Navigator.of(context).pop();
      },
      onStatusSelected: (selectedStatus) {
        notifier.addHistoryEntryToTrupp(
          truppNumber,
          StatusHistoryEntry(date: DateTime.now(), status: selectedStatus),
        );
        Navigator.of(context).pop();
      },
      onLocationSelected: (selectedLocation) {
        notifier.addHistoryEntryToTrupp(
          truppNumber,
          LocationHistoryEntry(
            date: DateTime.now(),
            location: selectedLocation,
          ),
        );
        Navigator.of(context).pop();
      },
      lowestPressure: lowestPressure,
    );
  }
}
