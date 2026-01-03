import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
        context.go('/einsatz-completed');
      }
    }
  }

  // saves PDF directly to Downloads via MediaStore
  Future<void> _downloadPdf(BuildContext context) async {
    try {
      // permission handling -> only for Android 6-9
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidDetails = await deviceInfo.androidInfo;

        // Android < 10 (API < 29) -> needs WRITE_EXTERNAL_STORAGE permission
        // Android >= 10 (API >= 29) permission is automatically granted via MediaStore
        if (androidDetails.version.sdkInt < 29) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Speicherberechtigung erforderlich'),
                ),
              );
            }
            return;
          }
        }
      }

      // create temporary file which is required by MediaStore API
      final fileName =
          'Einsatzprotokoll_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(pdfData);

      // initialize MediaStore and set app folder
      await MediaStore.ensureInitialized();
      MediaStore.appFolder = 'ASU';

      // save PDF to Downloads folder
      final mediaStore = MediaStore();
      await mediaStore.saveFile(
        tempFilePath: tempFile.absolute.path,
        dirType: DirType.download,
        dirName: DirName.download,
      );

      // show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF gespeichert im Downloadbereich: $fileName'),
          ),
        );
      }

      // clean up temp file
      try {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (_) {}
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
