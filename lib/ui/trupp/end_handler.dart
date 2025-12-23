import 'package:asu/ui/model/einsatz/einsatz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asu/ui/trupp/end.dart';
import 'package:asu/ui/model/history/history.dart';
import 'package:asu/ui/model/trupp/trupp.dart';

class EndHandler extends ConsumerWidget {
  final int truppNumber;
  final Duration operationTime;

  const EndHandler({
    super.key,
    required this.truppNumber,
    required this.operationTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int? leaderPressure;
    int? memberPressure;
    String? selectedType;
    bool isHeatExposed = false;

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
        notifier.addHistoryEntryToTrupp(
          truppNumber,
          PressureHistoryEntry(
            date: DateTime.now(),
            leaderPressure: leaderPressure!,
            memberPressure: memberPressure!,
          ),
        );
      }

      if (selectedType != null) {
        notifier.addHistoryEntryToTrupp(
          truppNumber,
          StatusHistoryEntry(date: DateTime.now(), status: selectedType!),
        );
      }

      notifier.addHistoryEntryToTrupp(
        truppNumber,
        StatusHistoryEntry(
          date: DateTime.now(),
          status: "Hitzebeaufschlagt: ${isHeatExposed ? "Ja" : "Nein"}",
        ),
      );

      notifier.addHistoryEntryToTrupp(
        truppNumber,
        StatusHistoryEntry(date: DateTime.now(), status: "Einsatz beendet"),
      );

      notifier.endTrupp(truppNumber);

      Navigator.pop(context);
    }

    return End(
      operationTime: operationTime,
      lowestPressure: lowestPressure,
      onPressureSelected: onPressureSelected,
      onTypeSelected: onTypeSelected,
      onHeatExposedSelected: onHeatExposedSelected,
      isHeatExposed: isHeatExposed,
      onSubmitPressed: onSubmitPressed,
    );

  }
}
