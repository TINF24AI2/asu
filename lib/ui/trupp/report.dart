import 'package:flutter/material.dart';

import 'location.dart';
import 'pressure.dart';
import 'status.dart';

class Report extends StatelessWidget {
  final Function(int leaderPressure, int memberPressure) onPressureSelected;
  final Function(String) onStatusSelected;
  final Function(String) onLocationSelected;
  final int lowestPressure;

  const Report({
    super.key,
    required this.onLocationSelected,
    required this.onPressureSelected,
    required this.onStatusSelected,
    required this.lowestPressure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Meldung eintragen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Button to enter pressure
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Pressure(
                        onPressureSelected: (leaderPressure, memberPressure) {
                          onPressureSelected(leaderPressure, memberPressure);
                          Navigator.of(context).pop();
                        },
                        lowestPressure: lowestPressure,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.speed, size: 18),
                label: const Text(
                  'Druck eintragen',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Button to enter status
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Status(onStatusSelected: onStatusSelected);
                    },
                  );
                },
                icon: const Icon(Icons.info, size: 18),
                label: const Text(
                  'Status eintragen',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Button to enter location
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Location(onLocationSelected: onLocationSelected);
                    },
                  );
                },
                icon: const Icon(Icons.location_pin, size: 18),
                label: const Text(
                  'Standort eintragen',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
