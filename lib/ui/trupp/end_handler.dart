import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'end.dart';
import '../model/trupp/history.dart';
import '../model/trupp/trupp.dart';

class EndHandler extends ConsumerWidget {
  final TruppNotifierProvider truppProvider;
  final Duration operationTime;

  const EndHandler({
    super.key,
    required this.truppProvider,
    required this.operationTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int? leaderPressure;
    int? memberPressure;
    String? selectedType;
    bool isHeatExposed = false;

    void onPressureSelected(int pressure, String role) {
      if (role == "Truppführer") {
        leaderPressure = pressure;
      } else if (role == "Truppmann") {
        memberPressure = pressure;
      }
    }

    void onTypeSelected(String type) {
      selectedType = type;
    }

    void onHeatExposedSelected(bool value) {
      isHeatExposed = value;
    }

    void onSubmitPressed() {
      if (leaderPressure != null && memberPressure != null) {
        ref
            .read(truppProvider.notifier)
            .addHistoryEntry(
              PressureHistoryEntry(
                date: DateTime.now(),
                leaderPressure: leaderPressure!,
                memberPressure: memberPressure!,
              ),
            );
      }

      if (selectedType != null) {
        ref
            .read(truppProvider.notifier)
            .addHistoryEntry(
              StatusHistoryEntry(date: DateTime.now(), status: selectedType!),
            );
      }

      ref
          .read(truppProvider.notifier)
          .addHistoryEntry(
            StatusHistoryEntry(
              date: DateTime.now(),
              status: "Hitzebeaufschlagt: ${isHeatExposed ? "Ja" : "Nein"}",
            ),
          );

      ref
          .read(truppProvider.notifier)
          .addHistoryEntry(
            StatusHistoryEntry(date: DateTime.now(), status: "Einsatz beendet"),
          );

      Navigator.pop(context);
    }

    return End(
      operationTime: operationTime,
      lowestPressure: ref.read(truppProvider.select((t) => t.lowestPressure)),
      onPressureSelected: onPressureSelected,
      onTypeSelected: onTypeSelected,
      onHeatExposedSelected: onHeatExposedSelected,
      isHeatExposed: isHeatExposed,
      onSubmitPressed: onSubmitPressed,
    );

    // TODO: End operation for this troup
  }
}
