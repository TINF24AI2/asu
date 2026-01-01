import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/widget_new_trupp.dart';
import 'model/einsatz/einsatz.dart';
import 'model/trupp/trupp.dart' as model;
import 'trupp.dart';
import 'end_einsatz/end_einsatz_screen.dart';

// Horizontal, paged view for "Trupp" pages with a final "New Trupp" tile.
class HorizontalTruppView extends ConsumerStatefulWidget {
  const HorizontalTruppView({super.key});

  @override
  ConsumerState<HorizontalTruppView> createState() =>
      _HorizontalTruppViewState();
}

class _HorizontalTruppViewState extends ConsumerState<HorizontalTruppView> {
  late final PageController _pageController;
  int _nextTruppNumber = 1;

  void _onCreateNew() {
    ref.read(einsatzProvider.notifier).addTrupp(_nextTruppNumber);
    _nextTruppNumber++;
    // scroll to new trupp automatically for better UX
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_pageController.hasClients) {
        final updated = ref.read(einsatzProvider);
        final newPage = (updated.trupps.length - 1).clamp(
          0,
          updated.trupps.length,
        );
        _pageController.animateToPage(
          newPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  List<Widget> _assembleWidgetsToList(Map<int, model.Trupp> trupps) {
    final List<Widget> pages = [];
    trupps.forEach((number, trupp) {
      if (trupp is model.TruppForm) {
        pages.add(WidgetNewTrupp(truppNumber: number));
      }
      if (trupp is model.TruppAction) {
        pages.add(Trupp(truppNumber: number));
      }
      if (trupp is model.TruppEnd) {
        pages.add(_TruppEndWidget(trupp: trupp));
      }
    });
    return pages;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1 / 3,
      // Alternative: start with page 0 so first trupp is visible without empty left slot
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trupps = ref.watch(einsatzProvider).trupps;
    final items = _assembleWidgetsToList(trupps);
    // total items = pages + final "New Trupp" tile
    final totalItems = items.length + 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemHeight = constraints.maxHeight;
        return SizedBox(
          height: itemHeight,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: totalItems,
                physics: const PageScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                padEnds: false,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    _buildPageItem(context, index, itemHeight, items),
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds a single page item in the horizontal scroll view.
  // Outsourced in order to keep the Widget build method cleaner, for further design changes.
  Widget _buildPageItem(
    BuildContext context,
    int index,
    double itemHeight,
    List<Widget> items,
  ) {
    final Widget child;
    if (index == items.length) {
      child = InkWell(
        onTap: _onCreateNew,
        child: const SizedBox.expand(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 48, color: Colors.black54),
                SizedBox(height: 8),
                Text('Neuer Trupp', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      );
    } else {
      child = SizedBox.expand(child: items[index]);
    }
    return Container(
      height: itemHeight,
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}

// widget displays completed trupp with operation duration and final end button
class _TruppEndWidget extends ConsumerWidget {
  final model.TruppEnd trupp;

  const _TruppEndWidget({required this.trupp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final einsatz = ref.watch(einsatzProvider);
    final allEnded = einsatz.trupps.values.every((t) => t is model.TruppEnd);
    // check if this is the last trupp
    final isLastTrupp = einsatz.trupps.keys.isEmpty
        ? false
        : trupp.number == einsatz.trupps.keys.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 64, color: Colors.green.shade400),
          const SizedBox(height: 16),
          Text(
            'Trupp ${trupp.number}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Einsatz beendet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Text(
            'Einsatzdauer: ${_formatDuration(trupp.inAction)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          if (allEnded && isLastTrupp)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EndEinsatzScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.assignment_turned_in),
              label: const Text('Einsatz vollständig beenden'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                backgroundColor: const Color(0xFFE84230),
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  // formats a duration into MM:SS format
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }
}
