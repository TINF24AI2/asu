import 'package:flutter/material.dart';

class Location extends StatelessWidget {
  final Function(String) onLocationSelected;

  const Location({super.key, required this.onLocationSelected});

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Standort eintragen",
                style: const TextStyle(
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
                  onLocationSelected("UG");
                  Navigator.pop(context);
                }, 
                child: const Text("UG")
              ),
              ElevatedButton(
                onPressed: () {
                  onLocationSelected("EG");
                  Navigator.pop(context);
                }, 
                child: const Text("EG")
              ),
              ElevatedButton(
                onPressed: () {
                  onLocationSelected("1. OG");
                  Navigator.pop(context);
                }, 
                child: const Text("1. OG")
              ),
            ],
          )
        ],
      ),
    );
  }
}