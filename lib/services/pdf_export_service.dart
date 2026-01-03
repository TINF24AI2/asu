import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../ui/model/trupp/trupp.dart';
import '../ui/model/history/history.dart';

class PdfExportService {
  // generate PDF document
  Future<Uint8List> generateEinsatzPdf(Map<int, Trupp> trupps) async {
    final pdf = pw.Document();

    // convert all trupps to TruppEnd
    final endedTrupps = trupps.entries
        .map((entry) => MapEntry(entry.key, entry.value as TruppEnd))
        .toList();

    // calculate operation start and end time
    DateTime? einsatzStart;
    DateTime? einsatzEnd;

    for (final entry in endedTrupps) {
      final trupp = entry.value;
      if (trupp.history.isNotEmpty) {
        for (final historyEntry in trupp.history) {
          final date = historyEntry.map(
            pressure: (e) => e.date,
            status: (e) => e.date,
            location: (e) => e.date,
          );

          if (einsatzStart == null || date.isBefore(einsatzStart)) {
            einsatzStart = date;
          }
          if (einsatzEnd == null || date.isAfter(einsatzEnd)) {
            einsatzEnd = date;
          }
        }
      }
    }

    // build PDF page with header, summary & all trupp sections
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(einsatzStart, einsatzEnd),
          pw.SizedBox(height: 20),
          _buildSummary(endedTrupps.length),
          pw.SizedBox(height: 20),
          ...endedTrupps.map(
            (entry) => _buildTruppSection(entry.key, entry.value),
          ),
        ],
      ),
    );

    return await pdf.save();
  }

  // build PDF header with operation date and time
  pw.Widget _buildHeader(DateTime? einsatzStart, DateTime? einsatzEnd) {
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';

    String zeitStr = '';
    if (einsatzStart != null && einsatzEnd != null) {
      zeitStr =
          'Gesamte Einsatzzeit: ${_formatTime(einsatzStart)} - ${_formatTime(einsatzEnd)} Uhr';
    } else if (einsatzStart != null) {
      zeitStr = 'Start: ${_formatTime(einsatzStart)} Uhr';
    }

    return pw.Header(
      level: 0,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Atemschutzüberwachung',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Einsatzprotokoll',
            style: const pw.TextStyle(
              fontSize: 18,
              color: PdfColor.fromInt(0xFFE84230),
            ),
          ),
          pw.Text('Datum: $dateStr'),
          if (zeitStr.isNotEmpty) pw.Text(zeitStr),
        ],
      ),
    );
  }

  // build summary box with trupp count
  pw.Widget _buildSummary(int truppCount) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [pw.Text('Anzahl Trupps: $truppCount')],
      ),
    );
  }

  // build trupp section with info and history
  pw.Widget _buildTruppSection(int number, TruppEnd trupp) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Wrap(
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Trupp ${trupp.number}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Funkrufname: ${trupp.callName.isEmpty ? '-' : trupp.callName}',
                      ),
                      pw.Text(
                        'Truppführer: ${trupp.leaderName.isEmpty ? '-' : trupp.leaderName}',
                      ),
                      pw.Text(
                        'Truppmann: ${trupp.memberName.isEmpty ? '-' : trupp.memberName}',
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Einsatzdauer:'),
                      pw.Text(
                        trupp.inAction == Duration.zero
                            ? '-'
                            : _formatDuration(trupp.inAction),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Historie:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              ..._buildHistoryEntries(trupp.history),
              _buildHeatExposureStatus(trupp.history),
            ],
          ),
        ],
      ),
    );
  }

  // format history entries (pressure, location & status)
  List<pw.Widget> _buildHistoryEntries(List<HistoryEntry> history) {
    return history.map((entry) {
      String text = '';
      if (entry is PressureHistoryEntry) {
        text =
            '${_formatTime(entry.date)} - Druck: ${entry.leaderPressure} bar (TF), ${entry.memberPressure} bar (TM)';
      } else if (entry is LocationHistoryEntry) {
        text = '${_formatTime(entry.date)} - Standort: ${entry.location}';
      } else if (entry is StatusHistoryEntry) {
        text = '${_formatTime(entry.date)} - Status: ${entry.status}';
      }
      return pw.Padding(
        padding: const pw.EdgeInsets.only(left: 10, bottom: 3),
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
      );
    }).toList();
  }

  // build heat exposure status box
  pw.Widget _buildHeatExposureStatus(List<HistoryEntry> history) {
    // check if "Hitzebeaufschlagt: Ja" exists in status entries
    final hasHeatExposure = history.any((entry) {
      if (entry is! StatusHistoryEntry) return false;
      final status = entry.status.toLowerCase();
      return status.contains('hitzebeaufschlagt:') &&
          status.trim().endsWith('ja');
    });

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: hasHeatExposure
            ? const PdfColor.fromInt(0xFFF5D5CC)
            : PdfColors.green50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Text(
        hasHeatExposure ? 'Hitzebeaufschlagt' : 'Nicht hitzebeaufschlagt',
        style: pw.TextStyle(
          color: hasHeatExposure
              ? const PdfColor.fromInt(0xFFE84230)
              : PdfColors.green800,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  // format duration (MM:SS min)
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} min';
  }

  // format time (HH:MM) for history entries and header
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // share PDF via mail, WhatsApp (if installed) etc.
  Future<void> sharePdf(Uint8List pdfData) async {
    final fileName =
        'Einsatzprotokoll_${DateTime.now().toString().substring(0, 10)}.pdf';
    await Share.shareXFiles([
      XFile.fromData(pdfData, name: fileName, mimeType: 'application/pdf'),
    ], subject: 'Atemschutzüberwachung Einsatzprotokoll');
  }
}
