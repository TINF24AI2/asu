import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/trupp/trupp.dart';
import 'trupp/end_handler.dart';
import 'trupp/report_handler.dart';
import 'model/einsatz/einsatz.dart';
import 'model/history/history.dart';

class Trupp extends ConsumerWidget {
  final int truppNumber;
  const Trupp({super.key, required this.truppNumber});

  String getInitials(String name, {String fallback = '?'}) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return fallback;
    if (parts.length == 1) return '${parts.first[0]}.';
    return '${parts.first[0]}.${parts.last[0]}';
  }

  // Used to display latest location and status on screen
  String getLatestLocation(List<HistoryEntry> history) {
    final locationEntry =
        history.firstWhere(
              (entry) => entry is LocationHistoryEntry,
              orElse: () => LocationHistoryEntry(
                date: DateTime.now(),
                location: 'Unbekannt',
              ),
            )
            as LocationHistoryEntry;
    return locationEntry.location;
  }

  String getLatestStatus(List<HistoryEntry> history) {
    final statusEntry =
        history.firstWhere(
              (entry) => entry is StatusHistoryEntry,
              orElse: () =>
                  StatusHistoryEntry(date: DateTime.now(), status: 'Unbekannt'),
            )
            as StatusHistoryEntry;
    return statusEntry.status;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trupp = ref.watch(
      einsatzProvider.select((e) => e.trupps[truppNumber]),
    );

    if (trupp == null) {
      return ListTile(
        title: Text('Trupp $truppNumber'),
        subtitle: const Text('Noch nicht angelegt'),
      );
    }

    return trupp.map(
      form: (t) => ListTile(
        title: Text('Trupp ${t.number} (in Vorbereitung)'),
        subtitle: const Text('Noch nicht gestartet'),
      ),
      end: (t) => ListTile(
        title: Text('Trupp ${t.number} (beendet)'),
        subtitle: Text(
          '${t.leaderName} / ${t.memberName} · ${t.callName}\n'
          'Dauer: ${t.inAction.inMinutes}:${(t.inAction.inSeconds % 60).toString().padLeft(2, '0')}',
        ),
      ),
      action: (t) {
        final history = t.history;
        final latestLocation = getLatestLocation(history);
        final latestStatus = getLatestStatus(history);

        final elapsedTime = t.sinceStart.inSeconds;
        final remainingTime = t.theoreticalEnd.inSeconds;
        final nextQueryTime = t.nextCheck.inSeconds;

        final pressure = t.lowestPressure;
        final maxPressure = t.maxPressure;

        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Trupp ${t.number}',
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
                              getInitials(t.leaderName),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey,
                            child: Text(
                              getInitials(t.memberName),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
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
                          t.callName,
                          style: const TextStyle(
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
                onMeldungenPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) =>
                        ReportHandler(truppNumber: truppNumber),
                  );
                },
                onEinsatzBeendenPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => EndHandler(
                      truppNumber: truppNumber,
                      operationTime: Duration(seconds: elapsedTime),
                    ),
                  );
                },
                latestLocation: latestLocation,
                latestStatus: latestStatus,
              ),
              const SizedBox(height: 10),
              const Text(
                'Historie',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length > 5 ? 5 : history.length,
                  itemBuilder: (context, index) {
                    final entry = history.toList()[index];
                    if (entry is StatusHistoryEntry) {
                      return ListTile(
                        title: Text('Status: ${entry.status}'),
                        subtitle: Text('Datum: ${entry.date}'),
                      );
                    } else if (entry is PressureHistoryEntry) {
                      return ListTile(
                        title: Text(
                          'Druck: ${entry.leaderPressure}/${entry.memberPressure}',
                        ),
                        subtitle: Text('Datum: ${entry.date}'),
                      );
                    } else if (entry is LocationHistoryEntry) {
                      return ListTile(
                        title: Text('Standort: ${entry.location}'),
                        subtitle: Text('Datum: ${entry.date}'),
                      );
                    } else {
                      return ListTile(
                        title: const Text('Unbekannter Eintrag'),
                        subtitle: Text('Datum: ${entry.date}'),
                      );
                    }
                  },
                ),
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
                onMeldungenPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) =>
                        ReportHandler(truppNumber: truppNumber),
                  );
                },
                onEinsatzBeendenPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => EndHandler(
                      truppNumber: truppNumber,
                      operationTime: Duration(seconds: elapsedTime),
                    ),
                  );
                },
                latestLocation: latestLocation,
                latestStatus: latestStatus,
              ),

              const SizedBox(height: 10),

              const Text(
                'Historie',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length > 5 ? 5 : history.length,
                  itemBuilder: (context, index) {
                    final entry = history.reversed.toList()[index];
                    if (entry is StatusHistoryEntry) {
                      return ListTile(
                        title: Text('Status: ${entry.status}'),
                        subtitle: Text('Datum: ${entry.date}'),
                      );
                    } else if (entry is PressureHistoryEntry) {
                      return ListTile(
                        title: Text(
                          'Druck: ${entry.leaderPressure}/${entry.memberPressure}',
                        ),
                        subtitle: Text('Datum: ${entry.date}'),
                      );
                    } else if (entry is LocationHistoryEntry) {
                      return ListTile(
                        title: Text('Standort: ${entry.location}'),
                        subtitle: Text('Datum: ${entry.date}'),
                      );
                    } else {
                      return ListTile(
                        title: const Text('Unbekannter Eintrag'),
                        subtitle: Text('Datum: ${entry.date}'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
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
    final double pressurePercentage = pressure / maxPressure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Niedrigster Druck:', style: TextStyle(fontSize: 16)),
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
          '$pressure bar / $maxPressure bar',
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
          'Einsatzdauer: ${formatTime(elapsedTime)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Einsatzende in: ${formatTime(remainingTime)}',
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
            'Nächste Abfrage in: ${formatTime(nextQueryTime)}',
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
  final VoidCallback onMeldungenPressed;
  final VoidCallback onEinsatzBeendenPressed;
  final String latestLocation;
  final String latestStatus;

  const OperationButtons({
    super.key,
    required this.onMeldungenPressed,
    required this.onEinsatzBeendenPressed,
    required this.latestLocation,
    required this.latestStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            Row(
              children: [
                const Icon(Icons.location_pin),
                Text(' $latestLocation'),
              ],
            ),
            const SizedBox(height: 5),
            Row(children: [const Icon(Icons.info), Text(' $latestStatus')]),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton(
              onPressed: onMeldungenPressed,
              child: const Text('Meldungen'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onEinsatzBeendenPressed,
              child: const Text('Einsatz beenden'),
            ),
          ],
        ),
      ],
    );
  }
}
