import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/locations_repository.dart';
import '../core/add_location.dart';

class Location extends ConsumerWidget {
  final Function(String) onLocationSelected;

  const Location({super.key, required this.onLocationSelected});

  Future<void> _handleAddLocation(
    BuildContext context,
    WidgetRef ref,
    List<String> existingLocations,
  ) async {
    // Store messenger before async gap
    final messenger = ScaffoldMessenger.of(context);

    final selected = await showSelectLocationDialog(
      context,
      locations: existingLocations,
    );

    if (selected == null || !context.mounted) return;

    final trimmed = selected.trim();
    if (trimmed.isEmpty) return;
    final normalized = trimmed.toLowerCase();

    // Check if location already exists (case-insensitive)
    String? existingLocation;
    for (final location in existingLocations) {
      if (location.toLowerCase() == normalized) {
        existingLocation = location;
        break;
      }
    }

    // If it exists with different casing, show informational message
    // (but continue and use the existing one)
    if (existingLocation != null && existingLocation != trimmed) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Dieser Standort ist bereits vorhanden: "$existingLocation"',
          ),
        ),
      );
      // Don't return - we'll use the existing one below
    }

    // Add to repository if the location is new
    if (existingLocation == null) {
      final repo = ref.read(locationsRepositoryProvider);
      if (repo != null) {
        try {
          await repo.add(trimmed);
        } catch (e) {
          if (context.mounted) {
            messenger.showSnackBar(
              SnackBar(content: Text('Fehler beim Hinzufügen: $e')),
            );
            return;
          }
        }
      }
    }

    // Call the callback with the selected location
    if (context.mounted) {
      onLocationSelected(existingLocation ?? trimmed);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(locationsStreamProvider);
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Standort eintragen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Display locations from settings
          locationsAsync.when(
            data: (locations) {
              final locationNames =
                  locations.map((l) => l.name).toList();
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (locationNames.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Keine Standorte verfügbar.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8.0,
                      children: locationNames.map((locationName) {
                        return ElevatedButton(
                          onPressed: () {
                            onLocationSelected(locationName);
                            Navigator.pop(context);
                          },
                          child: Text(locationName),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _handleAddLocation(
                      context,
                      ref,
                      locationNames,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Standort hinzufügen/auswählen'),
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text(
              'Fehler beim Laden der Standorte: $error',
              style: const TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}