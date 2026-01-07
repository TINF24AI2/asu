import 'package:flutter/material.dart';
import 'modal_choice_sheet.dart';

// Show a bottom-sheet dialog that lets the user pick a name or enter a custom name
// Uses the firefighters from Firestore via the repository

Future<String?> showAddPersonDialog(
  BuildContext context, {
  List<String>? candidates,
  bool enableQrScan = true,
}) {
  // Use the provided candidates list (for displaying available firefighters)
  // Candidates are typically passed from a stream provider watching firefighters
  final list = candidates ?? [];

  // Use the shared bottom-sheet helper
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Person hinzufügen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => s.trim().isEmpty ? null : s.trim(),
    textFieldLabel: 'Anderer Name:',
    enableQrScan: enableQrScan,
    validate: (s) {
      final name = RegExp(r'^[A-Za-zÄÖÜäöüß\- ]+$');
      if (!name.hasMatch(s)) return 'Ungültiger Name';
      return null;
    }
  );
}
