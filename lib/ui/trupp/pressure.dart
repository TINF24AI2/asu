import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pressure_selector.dart';

class Pressure extends ConsumerStatefulWidget {
  final Function(int leaderPressure, int memberPressure) onPressureSelected;
  final int lowestPressure;

  const Pressure({
    super.key,
    required this.onPressureSelected,
    required this.lowestPressure,
  });

  @override
  ConsumerState<Pressure> createState() => _PressureState();
}

class _PressureState extends ConsumerState<Pressure> {
  int? _leaderPressure;
  int? _memberPressure;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Druck eintragen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              const Text('Truppführer: '),
              const Padding(padding: EdgeInsets.only(right: 10.0)),
              PressureSelectionButton(
                lowestPressure: widget.lowestPressure,
                pressure: _leaderPressure,
                onPressureSelected: (int pressure) {
                  setState(() {
                    _leaderPressure = pressure;
                  });
                },
                label: 'Truppführer',
              ),
            ],
          ),
          Row(
            children: [
              const Text('Truppmann: '),
              const Padding(padding: EdgeInsets.only(right: 10.0)),
              PressureSelectionButton(
                lowestPressure: widget.lowestPressure,
                pressure: _memberPressure,
                onPressureSelected: (int pressure) {
                  setState(() {
                    _memberPressure = pressure;
                  });
                },
                label: 'Truppmann',
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],

          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_leaderPressure == null) {
                  setState(() {
                    _error = 'Bitte den Druck für den Truppführer auswählen.';
                  });
                  return;
                }
                if (_memberPressure == null) {
                  setState(() {
                    _error = 'Bitte den Druck für den Truppmann auswählen.';
                  });
                  return;
                }
                widget.onPressureSelected(_leaderPressure!, _memberPressure!);
              },
              child: const Text('Druck speichern'),
            ),
          ),
        ],
      ),
    );
  }
}
