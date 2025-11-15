import 'package:flutter/material.dart';

class Pressure extends StatelessWidget {
  final Function(int) onPressureSelected;
  final int lowestPressure;

  const Pressure({
    super.key,
    required this.onPressureSelected,
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
          Row(
            children: [
              Text(
                "Druck eintragen",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (
                int pressure = lowestPressure - 10;
                pressure >= 10;
                pressure -= 10
              )
                ElevatedButton(
                  onPressed: () {
                    onPressureSelected(pressure);
                    Navigator.pop(context);
                  },
                  child: Text("$pressure bar"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
