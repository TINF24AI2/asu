import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/widget_new_trupp.dart';
import 'model/einsatz/einsatz.dart';
import 'model/trupp/trupp.dart' as model;
import 'trupp.dart';

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
        //TODO remove placeholder and add End widget
        pages.add(const Placeholder());
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
