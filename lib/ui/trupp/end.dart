import 'package:flutter/material.dart';

import 'pressure_selector.dart';

class End extends StatelessWidget {
  final Function() onSubmitPressed;
  final Function(bool) onHeatExposedSelected;
  final Function(int) onLeaderPressureSelected;
  final Function(int) onMemberPressureSelected;
  final Duration operationTime;
  final int lowestPressure;
  final int? maxPressure;
  final int? leaderPressure;
  final int? memberPressure;
  final bool isHeatExposed;
  final String? errorMessage;

  const End({
    super.key,
    required this.operationTime,
    required this.lowestPressure,
    required this.onSubmitPressed,
    required this.onHeatExposedSelected,
    required this.onLeaderPressureSelected,
    required this.onMemberPressureSelected,
    this.maxPressure,
    this.leaderPressure,
    this.memberPressure,
    required this.isHeatExposed,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Einsatzende',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              const Icon(Icons.timer),
              Text(
                " Einsatzzeit: ${operationTime.inMinutes}:${(operationTime.inSeconds % 60).toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // final pressure selection for leader and member
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Enddruck Truppführer:',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              PressureSelectionButton(
                lowestPressure: lowestPressure,
                maxPressure: maxPressure,
                label: 'Truppführer',
                pressure: leaderPressure,
                onPressureSelected: onLeaderPressureSelected,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Enddruck Truppmann:',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              PressureSelectionButton(
                lowestPressure: lowestPressure,
                maxPressure: maxPressure,
                label: 'Truppmann',
                pressure: memberPressure,
                onPressureSelected: onMemberPressureSelected,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 'Hitzebeaufschlagt' switch
          Row(
            children: [
              const Icon(Icons.local_fire_department),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Hitzebeaufschlagt',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(
                isHeatExposed ? 'Ja' : 'Nein',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: isHeatExposed,
                onChanged: onHeatExposedSelected,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // error message
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(
                  color: Color(0xFFE84230),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: onSubmitPressed,
              child: const Text('Speichern'),
            ),
          ),
        ],
      ),
    );
  }
}
