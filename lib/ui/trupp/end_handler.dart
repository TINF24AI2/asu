import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/einsatz/einsatz.dart';
import '../model/history/history.dart';
import '../model/trupp/trupp.dart';
import 'end.dart';

// handler for collecting final trupp data before the ending operation
class EndHandler extends ConsumerStatefulWidget {
  final int truppNumber;
  final Duration operationTime;

  const EndHandler({
    super.key,
    required this.truppNumber,
    required this.operationTime,
  });

  @override
  ConsumerState<EndHandler> createState() => _EndHandlerState();
}

class _EndHandlerState extends ConsumerState<EndHandler> {
  int? leaderPressure;
  int? memberPressure;
  String? selectedType;
  bool isHeatExposed = false;

  @override
  Widget build(BuildContext context) {
    final trupp = ref.watch(
      einsatzProvider.select((e) => e.trupps[widget.truppNumber]),
    );

    if (trupp == null) {
      return const Center(child: Text('Trupp existiert nicht.'));
    }
    if (trupp is! TruppAction) {
      return Center(child: Text('Trupp ${trupp.number + 1} ist nicht aktiv.'));
    }

    final truppNumber = widget.truppNumber;
    final operationTime = widget.operationTime;
    final lowestPressure = trupp.lowestPressure;
    final notifier = ref.read(einsatzProvider.notifier);

    void onPressureSelected(int leaderPressure, int memberPressure) {
      setState(() {
        this.leaderPressure = leaderPressure;
        this.memberPressure = memberPressure;
      });
    }

    void onTypeSelected(String type) {
      setState(() => selectedType = type);
    }

    void onHeatExposedSelected(bool value) {
      setState(() => isHeatExposed = value);
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
          status: 'Hitzebeaufschlagt: ${isHeatExposed ? 'Ja' : 'Nein'}',
        ),
      );

      notifier.addHistoryEntryToTrupp(
        truppNumber,
        StatusHistoryEntry(date: DateTime.now(), status: 'Einsatz beendet'),
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
