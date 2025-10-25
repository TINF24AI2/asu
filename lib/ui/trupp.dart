import 'dart:async';
import 'package:flutter/material.dart';

class Trupp extends StatelessWidget {
  const Trupp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                // Example heading
                "Trupp 1",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black,
                        child: Text(
                          // TODO: Set first letter of Sur- and Lastname
                          "A.B",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                        child: Text(
                          // TODO: Set first letter of Sur- and Lastname
                          "D.G",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Abstand zwischen Kreisen und Funkrufname
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text(
                      // TODO: Set "Funkrufname"
                      "Funkrufname",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const PressureReading(),
          const SizedBox(height: 20),
          const OperationInfo(),
          const SizedBox(height: 20),
          const OperationButtons(),
        ],
      ),
    );
  }
}

// ----------------------
// Pressure
// ----------------------
class PressureReading extends StatefulWidget {
  const PressureReading({super.key});

  @override
  PressureReadingState createState() => PressureReadingState();
}

class PressureReadingState extends State<PressureReading> {
  // Example value for pressure
  final int maxPressure = 300;
  // TODO: Set to start pressure
  int pressure = 200;

  void updatePressure(int newPressure) {
    setState(() {
      pressure = newPressure;
    });
  }

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
class OperationInfo extends StatefulWidget {
  const OperationInfo({super.key});

  @override
  OperationInfoState createState() => OperationInfoState();
}

class OperationInfoState extends State<OperationInfo> {
  int elapsedTime = 0;
  int remainingTime = 400; //Only example value TODO: Initialize to actual time
  int nextQueryTime = 60 * 8;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      int newElapsedTime = elapsedTime + 1;
      int newRemainingTime = remainingTime > 0 ? remainingTime - 1 : 0;
      int newNextQueryTime = nextQueryTime - 1;
      if (newNextQueryTime <= 0) {
        newNextQueryTime = 60 * 8; //Only example TODO: When user did query, than reset timer
      }
      if (newElapsedTime != elapsedTime ||
          newRemainingTime != remainingTime ||
          newNextQueryTime != nextQueryTime) {
        setState(() {
          elapsedTime = newElapsedTime;
          remainingTime = newRemainingTime;
          nextQueryTime = newNextQueryTime;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }
}

// ----------------------
// Operation Buttons
// ----------------------
class OperationButtons extends StatelessWidget {
  const OperationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic for status
              },
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
              onPressed: () {
                // TODO: Add logic for "Meldungen"
              },
              child: const Text("Meldungen"),
            ),
            const SizedBox(width: 8), 
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic for "Einsatz beenden"
              },
              child: const Text("Einsatz beenden"),
            ),
          ],
        ),
      ],
    );
  }
}