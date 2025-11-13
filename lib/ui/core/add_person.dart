import 'package:flutter/material.dart';
import '../settings/settings.dart'
    show devTruppMembers; // mutable dev placeholder
import 'modal_choice_sheet.dart';

// show a bottom-sheet dialog that lets the user pick a name or enter a custom name

Future<String?> showAddPersonDialog(
  BuildContext context, {
  List<String>? candidates,
}) {
  // use the provided candidates or fall back to the dev placeholder list
  // ToDo: replace this with a repository or DB call later
  final list = candidates ?? devTruppMembers;

  // use the shared bottom-sheet helper
  return showHorizontalChoiceSheet<String, String>(
    context,
    title: 'Person hinzufügen',
    candidates: list,
    labelBuilder: (c) => c,
    valueBuilder: (c) => c,
    normalizeTyped: (s) => s.trim().isEmpty ? null : s.trim(),
    textFieldLabel: 'Anderer Name:',
  );
}
