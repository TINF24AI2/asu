import 'package:asu/ui/core/qr_scanner.dart';
import 'package:flutter/material.dart';

/* reusable bottom sheet that shows horizontal choice chips with a free-text input field
  it returns a value 'T' when the user picks a candidate or confirms their typed input
  Type parameters:
    - 'C': candidate item type
    - 'T': return value type  */
Future<T?> showHorizontalChoiceSheet<C, T>(
  BuildContext context, {
  required String title,
  required List<C> candidates, // candidate items
  required String Function(C) labelBuilder, // label for choice chips
  required T Function(C) valueBuilder, // value for selected candidate
  required T? Function(String) normalizeTyped, // validates/converts typed input
  String textFieldLabel = '', // label for the text field
  TextInputType keyboardType = TextInputType.text,
  bool enableQrScan = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) {
      String? typed;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var c in candidates)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(labelBuilder(c)),
                              selected: false,
                              onSelected: (_) => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(valueBuilder(c)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(labelText: textFieldLabel),
                    keyboardType: keyboardType,
                    onChanged: (v) => typed = v,
                  ),

                  //Button for QR-Scanning
                  if (enableQrScan) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('QR-Code scannen'),
                    onPressed: () async {
                      final scannedName = await Navigator.of(context).push<String>(
                        MaterialPageRoute(builder: (_) => const QrScanner()),
                      );
                      if (scannedName == null) return;
                      
                      final norm = normalizeTyped(scannedName);

                      if (norm != null) {
                        Navigator.of(context, rootNavigator: true).pop(norm);
                      }
                    }
                   ),
                  ],

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                        child: const Text('Abbrechen'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (typed == null || typed!.trim().isEmpty) {
                            Navigator.of(context, rootNavigator: true).pop();
                            return;
                          }
                          final norm = normalizeTyped(typed!.trim());
                          if (norm == null) {
                            Navigator.of(context, rootNavigator: true).pop();
                            return;
                          }
                          Navigator.of(context, rootNavigator: true).pop(norm);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
