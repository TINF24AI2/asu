import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/trupp/trupp.dart';

class Trupp extends ConsumerWidget {
  final TruppNotifierProvider truppProvider;

  const Trupp({super.key, required this.truppProvider});

  void handleStatus() {
    // TODO: Add logic for status
  }

  void handleMeldungen() {
    // TODO: Add logic for "Meldungen"
  }

  void handleEinsatzBeenden() {
    // TODO: Add logic for "Einsatz beenden"
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final truppfuehrer = ref.watch(truppProvider.select((t) => t.leaderName));
    final truppmann = ref.watch(truppProvider.select((t) => t.memberName));
    final funkrufname = ref.watch(truppProvider.select((t) => t.callName));
    final truppnumer = ref.watch(truppProvider.select((t) => t.number));

    final elapsedTime = ref
        .watch(truppProvider.select((t) => t.sinceStart))
        .inSeconds;
    final remainingTime = ref
        .watch(truppProvider.select((t) => t.theoreticalEnd))
        .inSeconds;
    final nextQueryTime = ref
        .watch(truppProvider.select((t) => t.nextCheck))
        .inSeconds;

    final pressure = ref.watch(truppProvider.select((t) => t.lowestPressure));
    final maxPressure = ref.watch(truppProvider.select((t) => t.maxPressure));

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                // Example heading
                "Trupp $truppnumer",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black,
                        child: Text(
                          "${truppfuehrer[0]}.${truppfuehrer.split(' ').last[0]}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                        child: Text(
                          "${truppmann[0]}.${truppmann.split(' ').last[0]}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      funkrufname,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          PressureReading(pressure: pressure, maxPressure: maxPressure),
          const SizedBox(height: 20),
          OperationInfo(
            elapsedTime: elapsedTime,
            remainingTime: remainingTime,
            nextQueryTime: nextQueryTime,
          ),
          const SizedBox(height: 20),
          OperationButtons(
            onStatusPressed: handleStatus,
            onMeldungenPressed: handleMeldungen,
            onEinsatzBeendenPressed: handleEinsatzBeenden,
          ),
        ],
      ),
    );
  }
}

// ----------------------
// Pressure
// ----------------------
class PressureReading extends StatelessWidget {
  final int pressure;
  final int maxPressure;

  const PressureReading({
    super.key,
    required this.pressure,
    required this.maxPressure,
  });

  @override
  Widget build(BuildContext context) {
    double pressurePercentage = pressure / maxPressure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Niedrigster Druck:", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: pressurePercentage.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[300],
          color: pressurePercentage > (2.0 / 3.0)
              ? Colors.green
              : (pressurePercentage > (1.0 / 3.0) ? Colors.yellow : Colors.red),
        ),
        const SizedBox(height: 8),
        Text(
          "$pressure bar / $maxPressure bar",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

// ----------------------
// Operation Informations
// ----------------------
class OperationInfo extends StatelessWidget {
  final int elapsedTime;
  final int remainingTime;
  final int nextQueryTime;

  const OperationInfo({
    super.key,
    required this.elapsedTime,
    required this.remainingTime,
    required this.nextQueryTime,
  });

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Einsatzdauer: ${formatTime(elapsedTime)}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          "Einsatzende in: ${formatTime(remainingTime)}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            "Nächste Abfrage in: ${formatTime(nextQueryTime)}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// ----------------------
// Operation Buttons
// ----------------------
class OperationButtons extends StatelessWidget {
  final VoidCallback onStatusPressed;
  final VoidCallback onMeldungenPressed;
  final VoidCallback onEinsatzBeendenPressed;

  const OperationButtons({
    super.key,
    required this.onStatusPressed,
    required this.onMeldungenPressed,
    required this.onEinsatzBeendenPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: onStatusPressed,
              child: const Text("Status:"),
            ),
            const SizedBox(width: 8),
            const Text("Placeholder"),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: onMeldungenPressed,
              child: const Text("Meldungen"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onEinsatzBeendenPressed,
              child: const Text("Einsatz beenden"),
            ),
          ],
        ),
      ],
    );
  }
}
