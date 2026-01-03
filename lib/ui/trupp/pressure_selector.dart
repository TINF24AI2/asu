import 'package:flutter/material.dart';

class PressureSelector extends StatefulWidget {
  final int lowestPressure;
  final Function(int pressure)? onPressureSelected;
  final Widget? title;

  PressureSelector({
    super.key,
    required int lowestPressure,
    this.onPressureSelected,
    this.title,
  }) : lowestPressure = lowestPressure.clamp(100, 300);

  @override
  State<PressureSelector> createState() => _PressureSelectorState();
}

class _PressureSelectorState extends State<PressureSelector> {
  final TextEditingController _customPressureController =
      TextEditingController();

  @override
  void dispose() {
    _customPressureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(child: widget.title ?? const Text('Wähle den Druck aus')),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (
                int pressure = widget.lowestPressure + 20;
                pressure >= 10 && pressure >= widget.lowestPressure - 170;
                pressure -= 10
              )
                ElevatedButton(
                  onPressed: () {
                    widget.onPressureSelected?.call(pressure);
                  },
                  child: Text('$pressure bar'),
                ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 20.0)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _customPressureController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Eigenen Druck eingeben (bar)',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final customPressure = int.tryParse(
                    _customPressureController.text,
                  );
                  if (customPressure != null) {
                    widget.onPressureSelected?.call(customPressure);
                  }
                },
                child: const Text('Eintragen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PressureSelectionButton extends StatelessWidget {
  final int lowestPressure;
  final int? maxPressure;
  final int? pressure;
  final String? label;
  final Function(int pressure) onPressureSelected;

  const PressureSelectionButton({
    super.key,
    required this.lowestPressure,
    this.maxPressure,
    this.label,
    this.pressure,
    required this.onPressureSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => PressureSelector(
            lowestPressure: lowestPressure,
            title: Text('Druck für ${label != null ? "$label " : ''}auswählen'),
            onPressureSelected: (pressure) {
              onPressureSelected(pressure);
              Navigator.pop(context);
            },
          ),
        );
      },
      label: Text(pressure != null ? '$pressure bar' : 'Druck wählen'),
      icon: maxPressure != null
          ? Icon(
              (pressure ?? 400) >= maxPressure! * 0.9
                  ? Icons.speed
                  : Icons.warning,
              size: 18,
            )
          : null,
    );
  }
}
