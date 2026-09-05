import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/nest_theme.dart';

class NestNavItem {
  const NestNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;

  /// The index-tab colour that marks this destination.
  final Color accent;
}

/// Bottom navigation drawn as index tabs on the edge of a page.
///
/// The selected destination lifts out of the sheet and shows its coloured tab
/// edge, so the bar behaves like the divider tabs of a notebook instead of a
/// row of icons. The capture button in the middle is offset-printed against a
/// highlighter block — the same mark used elsewhere in the app.
class NestNavBar extends StatelessWidget {
  const NestNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.onCapture,
    this.captureLabel = 'New note',
  });

  /// Exactly four destinations; the capture button sits between items 1 and 2.
  final List<NestNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCapture;
  final String captureLabel;

  static const double _barHeight = 68;
  static const double _tabRise = 12;

  @override
  Widget build(BuildContext context) {
    assert(items.length == 4, 'NestNavBar expects four destinations');
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: _barHeight + _tabRise + bottomInset,
      child: Stack(
        children: [
          // The page edge.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _barHeight + bottomInset,
            child: Container(
              decoration: BoxDecoration(
                color: NestColor.card,
                border: const Border(
                  top: BorderSide(color: NestColor.rule, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: NestColor.o(NestColor.ink, 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset,
            top: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _tab(0)),
                Expanded(child: _tab(1)),
                const SizedBox(width: 86),
                Expanded(child: _tab(2)),
                Expanded(child: _tab(3)),
              ],
            ),
          ),
          // Capture button, printed slightly off-register.
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 0, bottom: bottomInset),
              child: _captureButton(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(int index) {
    final item = items[index];
    final selected = index == currentIndex;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!selected) HapticFeedback.selectionClick();
          onTap(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          height: selected ? _barHeight + _tabRise : _barHeight - 4,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? NestColor.card : Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            // The shadow is always present and only its colour changes.
            // easeOutBack overshoots past both ends of the range, so a shadow
            // that appears and disappears would be interpolated to a negative
            // blur radius, which Flutter rejects.
            boxShadow: [
              BoxShadow(
                color: NestColor.o(
                  NestColor.ink,
                  selected ? 0.10 : 0.0,
                ),
                blurRadius: 14,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The coloured edge of the tab.
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                margin: const EdgeInsets.only(bottom: 10),
                height: 4,
                width: selected ? 30 : 0,
                decoration: BoxDecoration(
                  color: item.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  selected ? item.activeIcon : item.icon,
                  key: ValueKey(selected),
                  size: 22,
                  color: selected ? NestColor.pen : NestColor.inkFaint,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: NestFont.mono,
                  fontSize: 10.5,
                  letterSpacing: 0.4,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? NestColor.ink : NestColor.inkFaint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _captureButton(BuildContext context) {
    return Semantics(
      button: true,
      label: captureLabel,
      child: SizedBox(
        width: 74,
        height: 70,
        child: Stack(
          children: [
            // Highlighter block, offset like a misregistered print.
            Positioned(
              left: 12,
              top: 10,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: NestColor.highlight,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              left: 4,
              top: 2,
              child: Material(
                color: NestColor.pen,
                borderRadius: BorderRadius.circular(20),
                elevation: 6,
                shadowColor: NestColor.o(NestColor.penDeep, 0.4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onCapture();
                  },
                  child: const SizedBox(
                    width: 58,
                    height: 58,
                    child: Icon(Icons.edit_rounded,
                        color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
