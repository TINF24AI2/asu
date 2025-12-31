import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/initial_settings_repository.dart';
import '../../ui/model/settings/initial_settings.dart';

class InitialSettingsForm extends ConsumerStatefulWidget {
  final Future<void> Function(int pressure, Duration duration)? onSubmit;
  const InitialSettingsForm({super.key, this.onSubmit});

  @override
  ConsumerState<InitialSettingsForm> createState() =>
      _InitialSettingsFormState();
}

class _InitialSettingsFormState extends ConsumerState<InitialSettingsForm> {
  int _defaultPressure = InitialSettingsModel.kStandardMaxPressure;
  Duration _theoreticalDuration =
      const Duration(minutes: InitialSettingsModel.kStandardTheoreticalDurationMinutes);
  bool _loading = false;
  bool _initialized = false;

  // Load initial settings from repository once when dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _loadInitialSettings();
      _initialized = true;
    }
  }

  // load initial settings from repository
  Future<void> _loadInitialSettings() async {
    try {
      final repository = ref.read(initialSettingsRepositoryProvider);
      if (repository == null) {
        return;
      }
      final settings = await repository.get();
      if (settings != null && mounted) {
        setState(() {
          _defaultPressure = settings.defaultPressure;
          _theoreticalDuration = Duration(
            minutes: settings.theoreticalDurationMinutes,
          );
        });
      }
    } catch (e) {
      // use default values if loading fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Standardeinstellungen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Padding(padding: EdgeInsets.only(top: 15.0)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Flaschendruck:',
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
              'Rechnerische Einsatzzeit:',
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
          onPressed: _loading
              ? null
              : () async {
                  if (widget.onSubmit == null) return;

                  setState(() {
                    _loading = true;
                  });
                  await widget.onSubmit!(
                    _defaultPressure,
                    _theoreticalDuration,
                  );
                  if (!mounted) return;
                  setState(() {
                    _loading = false;
                  });
                },
          child: const Text('Weiter'),
        ),
        if (_loading) ...[
          const Padding(padding: EdgeInsets.only(top: 15.0)),
          const CircularProgressIndicator(),
        ],
      ],
    );
  }
}
