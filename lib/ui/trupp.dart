import 'package:asu/ui/model/trupp/history.dart';
import 'package:asu/ui/trupp/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/trupp/trupp.dart';

class Trupp extends ConsumerWidget {
  final TruppNotifierProvider truppProvider;

  const Trupp({super.key, required this.truppProvider});

  //void handleStatus() {
  // unnecessary, because status is not a button
  //}

  void handleMeldungen(BuildContext context, WidgetRef ref) {
    final lowestPressure = ref.watch(
      truppProvider.select((t) => t.lowestPressure),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Report(
          onPressureSelected: (selectedPressure) {
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
                  StatusHistoryEntry(
                    date: DateTime.now(),
                    status: selectedStatus,
                  ),
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
      },
    );
  }

  void handleEinsatzBeenden() {
    // TODO: Add logic for "Einsatz beenden"
  }

  // Those functions can be writte somewhere else in future
  String getLatestLocation(List<HistoryEntry> history) {
    final locationEntry =
        history.lastWhere(
              (entry) => entry is LocationHistoryEntry,
              orElse: () => LocationHistoryEntry(
                date: DateTime.now(),
                location: "Unbekannt",
              ),
            )
            as LocationHistoryEntry;
    return locationEntry.location;
  }

  String getLatestStatus(List<HistoryEntry> history) {
    final statusEntry =
        history.lastWhere(
              (entry) => entry is StatusHistoryEntry,
              orElse: () =>
                  StatusHistoryEntry(date: DateTime.now(), status: "Unbekannt"),
            )
            as StatusHistoryEntry;
    return statusEntry.status;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final truppfuehrer = ref.watch(truppProvider.select((t) => t.leaderName));
    final truppmann = ref.watch(truppProvider.select((t) => t.memberName));
    final funkrufname = ref.watch(truppProvider.select((t) => t.callName));
    final truppnumer = ref.watch(truppProvider.select((t) => t.number));
    final history = ref.watch(truppProvider.select((t) => t.history));

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

    final latestLocation = getLatestLocation(history);
    final latestStatus = getLatestStatus(history);

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Trupp $truppnumer",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                  const SizedBox(height: 8),
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
            //  onStatusPressed: handleStatus,
            onMeldungenPressed: () => handleMeldungen(context, ref),
            onEinsatzBeendenPressed: handleEinsatzBeenden,
            latestLocation: latestLocation,
            latestStatus: latestStatus,
          ),

          const SizedBox(height: 10),

          const Text(
            "Historie",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: history.length > 5 ? 5 : history.length,
              itemBuilder: (context, index) {
                final entry = history.reversed.toList()[index];
                if (entry is StatusHistoryEntry) {
                  return ListTile(
                    title: Text("Status: ${entry.status}"),
                    subtitle: Text("Datum: ${entry.date}"),
                  );
                } else if (entry is PressureHistoryEntry) {
                  return ListTile(
                    title: Text(
                      "Druck: ${entry.leaderPressure}/${entry.memberPressure}",
                    ),
                    subtitle: Text("Datum: ${entry.date}"),
                  );
                } else if (entry is LocationHistoryEntry) {
                  return ListTile(
                    title: Text("Standort: ${entry.location}"),
                    subtitle: Text("Datum: ${entry.date}"),
                  );
                } else {
                  return ListTile(
                    title: Text("Unbekannter Eintrag"),
                    subtitle: Text("Datum: ${entry.date}"),
                  );
                }
              },
            ),
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
  //  final VoidCallback onStatusPressed;
  final VoidCallback onMeldungenPressed;
  final VoidCallback onEinsatzBeendenPressed;
  final String latestLocation;
  final String latestStatus;

  const OperationButtons({
    super.key,
    //    required this.onStatusPressed,
    required this.onMeldungenPressed,
    required this.onEinsatzBeendenPressed,
    required this.latestLocation,
    required this.latestStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            //            ElevatedButton(
            //              onPressed: onStatusPressed,
            //              child: const Text("Status:"),
            //            ),
            const Text(
              "Status",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            Row(children: [Icon(Icons.location_pin), Text(" $latestLocation")]),
            SizedBox(height: 5),
            Row(children: [Icon(Icons.info), Text(" $latestStatus")]),
          ],
        ),
        const SizedBox(height: 10),
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
