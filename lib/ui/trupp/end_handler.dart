import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/einsatz/einsatz.dart';
import '../../model/history/history.dart';
import '../../model/trupp/trupp.dart';
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
  bool isHeatExposed = false; //default
  String? errorMessage;

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
    final maxPressure = trupp.maxPressure;
    final notifier = ref.read(einsatzProvider.notifier);

    void onHeatExposedSelected(bool value) {
      setState(() => isHeatExposed = value);
    }

    // handler for submit button
    void onSubmitPressed() {
      if (leaderPressure == null || memberPressure == null) {
        setState(() {
          errorMessage = 'Eine Druckangabe fehlt';
        });
        return;
      }

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

    // render End widget
    return End(
      operationTime: operationTime,
      lowestPressure: lowestPressure,
      maxPressure: maxPressure,
      leaderPressure: leaderPressure,
      memberPressure: memberPressure,
      onLeaderPressureSelected: (p) {
        setState(() {
          leaderPressure = p;
          errorMessage = null;
        });
      },
      onMemberPressureSelected: (p) {
        setState(() {
          memberPressure = p;
          errorMessage = null;
        });
      },
      onHeatExposedSelected: onHeatExposedSelected,
      isHeatExposed: isHeatExposed,
      onSubmitPressed: onSubmitPressed,
      errorMessage: errorMessage,
    );
  }
}
