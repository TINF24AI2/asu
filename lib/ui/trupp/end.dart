import 'package:asu/ui/trupp/pressure.dart';
import 'package:flutter/material.dart';

class End extends StatelessWidget {
  final Function(int, String) onPressureSelected;
  final Function(String) onTypeSelected;
  final Function() onSubmitPressed;
  final Function(bool) onHeatExposedSelected;
  final Duration operationTime;
  final int lowestPressure;
  final bool isHeatExposed;

  End({
    super.key,
    required this.operationTime,
    required this.lowestPressure,
    required this.onPressureSelected,
    required this.onSubmitPressed,
    required this.onTypeSelected,
    required this.onHeatExposedSelected,
    required this.isHeatExposed,
  }) {
    // only one type for now
    onTypeSelected("Brandeinsatz");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Einsatz-Ende",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              Icon(Icons.timer),
              Text(
                " Einsatz-Zeit: ${operationTime.inMinutes}:${(operationTime.inSeconds % 60).toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 18),
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
                        onPressureSelected: (selectedPressure, role) {
                          onPressureSelected(selectedPressure, role);
                        },
                        lowestPressure: lowestPressure,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.speed, size: 18),
                label: const Text(
                  "Druck eintragen",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Button to enter type of operation
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton.icon(
                onPressed: () {
                  // uncomment when we need more than 'Brandeinsatz'
                  // onTypeSelected
                },
                icon: const Icon(Icons.bookmark_rounded, size: 18),
                label: const Text(
                  "Art des Einsatzes - Brandeinsatz",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Button to enter 'Hitzebeaufschlagt'
          // Here look that user see wheter yes or no is activated
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Dialog anzeigen
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Hitzebeaufschlagt?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              onHeatExposedSelected(true);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ja"),
                          ),
                          TextButton(
                            onPressed: () {
                              onHeatExposedSelected(false);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Nein"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.local_fire_department, size: 18),
                label: Text(
                  "Hitzebeaufschlagt",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: onSubmitPressed,
              child: const Text("Speichern"),
            ),
          ),
        ],
      ),
    );
  }
}
