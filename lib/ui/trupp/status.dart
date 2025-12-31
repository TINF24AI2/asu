import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  final Function(String) onStatusSelected;

  const Status({super.key, required this.onStatusSelected});

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
                'Status eintragen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Only for testing
          // TODO: Connect to settings
          Wrap(
            spacing: 8.0,
            children: [
              ElevatedButton(
                onPressed: () {
                  onStatusSelected('am Einsatzort');
                  Navigator.pop(context);
                },
                child: const Text('am Einsatzort'),
              ),
              ElevatedButton(
                onPressed: () {
                  onStatusSelected('Erkundung');
                  Navigator.pop(context);
                },
                child: const Text('Erkundung'),
              ),
              ElevatedButton(
                onPressed: () {
                  onStatusSelected('Menschenrettung');
                  Navigator.pop(context);
                },
                child: const Text('Menschenrettung'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
