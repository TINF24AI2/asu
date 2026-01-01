import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import '../model/einsatz/einsatz.dart';

// screen for previewing and sharing the generated einsatz PDF with download functionality
class PdfPreviewScreen extends ConsumerWidget {
  final Uint8List pdfData;

  const PdfPreviewScreen({super.key, required this.pdfData});

  // shows confirmation dialog and resets einsatz state if user confirms the closing
  Future<void> _onWillPop(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF schließen'),
        content: const Text(
          'Die PDF ist nach dem Schließen ohne Download nicht mehr verfügbar. Möchten Sie fortfahren?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE84230),
              foregroundColor: Colors.white,
            ),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );

    if (result == true) {
      if (context.mounted) {
        ref.read(einsatzProvider.notifier).reset();
        // navigate back to completion
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        context.go('/einsatz-completed');
      }
    }
  }

  // saves PDF to device downloads folder
  Future<void> _downloadPdf(BuildContext context) async {
    try {
      Directory? directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }

      if (directory != null) {
        final fileName =
            'Einsatzprotokoll_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(pdfData);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PDF im Downloadbereich gespeichert'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler beim Speichern: $e')));
      }
    }
  }

  // shares PDF via system share dialog
  Future<void> _sharePdf() async {
    final fileName =
        'Einsatzprotokoll_${DateTime.now().toString().substring(0, 10)}.pdf';
    await Share.shareXFiles([
      XFile.fromData(pdfData, name: fileName, mimeType: 'application/pdf'),
    ], subject: 'Atemschutzüberwachung Einsatzprotokoll');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _onWillPop(context, ref);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PDF Vorschau'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _onWillPop(context, ref),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadPdf(context),
              tooltip: 'Speichern',
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _sharePdf,
              tooltip: 'Teilen',
            ),
          ],
        ),
        body: PdfPreview(
          build: (format) => Future.value(pdfData),
          useActions: false, // to hide default actions
        ),
      ),
    );
  }
}
