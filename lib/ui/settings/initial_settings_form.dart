import 'package:flutter/material.dart';

class InitialSettingsForm extends StatefulWidget {
  final Future<void> Function(int pressure, Duration duration)? onSubmit;
  const InitialSettingsForm({super.key, this.onSubmit});

  @override
  State<InitialSettingsForm> createState() => _InitialSettingsFormState();
}

class _InitialSettingsFormState extends State<InitialSettingsForm> {
  int _defaultPressure = 300;
  Duration _theoreticalDuration = Duration(minutes: 30);
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Standardeinstellungen",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Padding(padding: EdgeInsets.only(top: 15.0)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Flaschendruck:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Padding(padding: EdgeInsets.only(left: 10.0)),
            SegmentedButton(
              segments: const <ButtonSegment<int>>[
                ButtonSegment<int>(value: 200, label: Text('200 bar')),
                ButtonSegment<int>(value: 300, label: Text('300 bar')),
              ],
              selected: {_defaultPressure},
              direction: Axis.horizontal,
              emptySelectionAllowed: false,
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _defaultPressure = newSelection.first;
                });
              },
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 15.0)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Rechnerische Einsatzzeit:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Padding(padding: EdgeInsets.only(left: 10.0)),
            SegmentedButton(
              segments: const <ButtonSegment<Duration>>[
                ButtonSegment<Duration>(
                  value: Duration(minutes: 20),
                  label: Text('20 min'),
                ),
                ButtonSegment<Duration>(
                  value: Duration(minutes: 30),
                  label: Text('30 min'),
                ),
              ],
              selected: {_theoreticalDuration},
              direction: Axis.horizontal,
              onSelectionChanged: (Set<Duration> newSelection) {
                setState(() {
                  _theoreticalDuration = newSelection.first;
                });
              },
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 15.0)),
        ElevatedButton(
          onPressed: () async {
            if (widget.onSubmit == null) return;

            setState(() {
              _loading = true;
            });
            await widget.onSubmit!(_defaultPressure, _theoreticalDuration);
            if (!mounted) return;
            setState(() {
              _loading = false;
            });
          },
          child: const Text("Weiter"),
        ),
        if (_loading) ...[
          const Padding(padding: EdgeInsets.only(top: 15.0)),
          const CircularProgressIndicator(),
        ],
      ],
    );
  }
}
