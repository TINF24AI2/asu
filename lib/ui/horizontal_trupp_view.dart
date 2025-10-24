import 'package:flutter/material.dart';

// Horizontal, paged view for "Trupp" pages with a final "New Trupp" tile.
class HorizontalTruppView extends StatefulWidget {
  // Pages to display. The final slot is the "New Trupp" tile.
  final List<Widget> truppPages;

  // Called when the user taps the final "New Trupp" tile.
  // Parent can add a new page and rebuild (e.g. via setState).
  final VoidCallback? onCreateNew;
  const HorizontalTruppView({
    super.key,
    required this.truppPages,
    this.onCreateNew,
  });

  @override
  State<HorizontalTruppView> createState() => _HorizontalTruppViewState();
}

class _HorizontalTruppViewState extends State<HorizontalTruppView> {
  late final PageController _pageController;

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
    // total items = pages + final "New Trupp" tile
    final totalItems = widget.truppPages.length + 1;
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
                    _buildPageItem(context, index, itemHeight),
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds a single page item in the horizontal scroll view.
  // Outsourced in order to keep the Widget build method cleaner, for further design changes.
  Widget _buildPageItem(BuildContext context, int index, double itemHeight) {
    final isNewTile = index == widget.truppPages.length;
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
          child: InkWell(
            onTap: isNewTile
                ? () {
                    // TODO: Open the form to create a new Trupp here.
                    widget.onCreateNew?.call();
                  }
                : null,
            child: SizedBox.expand(
              child: isNewTile
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, size: 48, color: Colors.black54),
                          SizedBox(height: 8),
                          Text('Neuer Trupp', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    )
                  : widget.truppPages[index],
            ),
          ),
        ),
      ),
    );
  }
}
