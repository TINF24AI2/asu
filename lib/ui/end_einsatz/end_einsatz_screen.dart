import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/einsatz/einsatz.dart';
import '../model/trupp/trupp.dart';
import '../model/history/history.dart';
import '../../services/pdf_export_service.dart';
import 'pdf_preview_screen.dart';

// screen that displays all completed trupps from the current operation and allows PDF export
class EndEinsatzScreen extends ConsumerWidget {
  const EndEinsatzScreen({super.key});

  // builds the screen with a list of ended trupps and PDF export functionality
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final einsatz = ref.watch(einsatzProvider);
    final endedTrupps = einsatz.trupps.entries
        .where((entry) => entry.value is TruppEnd)
        .map((entry) => MapEntry(entry.key, entry.value as TruppEnd))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Einsatz beendet')),
      body: endedTrupps.isEmpty
          ? const Center(child: Text('Keine beendeten Trupps'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: endedTrupps.length,
                    itemBuilder: (context, index) {
                      final entry = endedTrupps[index];
                      return _TruppEndCard(
                        number: entry.key,
                        trupp: entry.value,
                      );
                    },
                  ),
                ),
                _buildBottomButtons(context, ref, einsatz.trupps),
              ],
            ),
    );
  }

  // builds the bottom button section with PDF creation button
  Widget _buildBottomButtons(
    BuildContext context,
    WidgetRef ref,
    Map<int, Trupp> allTrupps,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateAndSharePdf(context, ref, allTrupps),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('PDF erstellen'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: const Color(0xFFE84230),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // generates the einsatz PDF and displays the preview screen
  Future<void> _generateAndSharePdf(
    BuildContext context,
    WidgetRef ref,
    Map<int, Trupp> trupps,
  ) async {
    try {
      // display loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // generate PDF for all trupps
      final pdfService = PdfExportService();
      final pdfData = await pdfService.generateEinsatzPdf(trupps);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // close loading dialog

      // show success dialog and navigate to preview
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('PDF erstellt'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfPreviewScreen(pdfData: pdfData),
                  ),
                );
              },
              child: const Text('Vorschau'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Erstellen der PDF: $e')),
      );
    }
  }
}

// widget displaying completed trupp details, history etc.
class _TruppEndCard extends StatelessWidget {
  final int number;
  final TruppEnd trupp;

  const _TruppEndCard({required this.number, required this.trupp});

  // builds the card with trupp details, collapsible history & heat exposure indicator
  @override
  Widget build(BuildContext context) {
    // check heat exposure status
    final hasHeatExposure = trupp.history.any((entry) {
      if (entry is StatusHistoryEntry) {
        final status = entry.status.toLowerCase();
        if (status.contains('hitzebeaufschlagt:')) {
          return status.trim().endsWith('ja');
        }
      }
      return false;
    });

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trupp ${trupp.number}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Chip(
                  label: Text(
                    hasHeatExposure
                        ? 'Hitzebeaufschlagt'
                        : 'Nicht hitzebeaufschlagt',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: hasHeatExposure
                      ? const Color(0xFFF5D5CC)
                      : Colors.green.shade100,
                  side: BorderSide.none,
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow(
              'Funkrufname',
              trupp.callName.isEmpty ? '-' : trupp.callName,
            ),
            _buildInfoRow(
              'Truppführer',
              trupp.leaderName.isEmpty ? '-' : trupp.leaderName,
            ),
            _buildInfoRow(
              'Truppmann',
              trupp.memberName.isEmpty ? '-' : trupp.memberName,
            ),
            _buildInfoRow(
              'Einsatzdauer',
              trupp.inAction == Duration.zero
                  ? '-'
                  : _formatDuration(trupp.inAction),
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              title: Text(
                'Historie (${trupp.history.length} Einträge)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(
                left: 10,
                top: 5,
                bottom: 5,
              ),
              children: _buildHistoryPreview(trupp.history),
            ),
          ],
        ),
      ),
    );
  }

  // builds a horizontal info row like "Truppführer: Anna Meier"
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // builds history entry widget
  List<Widget> _buildHistoryPreview(List<HistoryEntry> history) {
    return history.map((entry) {
      String text = '';
      IconData icon = Icons.history;

      if (entry is PressureHistoryEntry) {
        text =
            '${_formatTime(entry.date)} - Druck: ${entry.leaderPressure}/${entry.memberPressure} bar';
        icon = Icons.speed;
      } else if (entry is LocationHistoryEntry) {
        text = '${_formatTime(entry.date)} - ${entry.location}';
        icon = Icons.location_on;
      } else if (entry is StatusHistoryEntry) {
        text = '${_formatTime(entry.date)} - ${entry.status}';
        icon = Icons.info;
      }

      return Padding(
        padding: const EdgeInsets.only(left: 8, top: 2),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // formats a duration into MM:SS format string
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }

  // formats a DateTime into HH:MM format string (24h)
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
