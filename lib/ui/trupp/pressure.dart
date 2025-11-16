import 'package:flutter/material.dart';

class Pressure extends StatelessWidget {
  final Function(int, String) onPressureSelected;
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showPressureSelection(context, "Truppführer");
                },
                child: const Text("Truppführer")
              ),
              ElevatedButton(onPressed: () {
                 _showPressureSelection(context, "Truppmann");
              }, 
              child: const Text("Truppmann"),
              )
            ]
          )
        ],
      ),
    );
  }

  // Function to show pressure selection
  void _showPressureSelection(BuildContext context, String role) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (int pressure = lowestPressure - 10;
                  pressure >= 10;
                  pressure -= 10)
                ElevatedButton(
                  onPressed: () {
                    onPressureSelected(pressure, role);
                    Navigator.pop(context);
                  },
                  child: Text("$pressure bar"),
                ),
            ],
          ),
        );
      },
    );   
  }
}
