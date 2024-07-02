import 'package:flutter/material.dart';

class CustomerInfoTooltip extends StatelessWidget {
  final GlobalKey key;
  final Widget child;
  final String tooltip;

  const CustomerInfoTooltip({
    required this.key,
    required this.child,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: () {
        final box = key.currentContext!.findRenderObject() as RenderBox;
        final overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

        showMenu(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromPoints(
              box.localToGlobal(Offset.zero, ancestor: overlay),
              box.localToGlobal(box.size.bottomRight(Offset.zero),
                  ancestor: overlay),
            ),
            Offset.zero & overlay.size,
          ),
          items: [
            PopupMenuItem(
              child: Text(tooltip),
              enabled: false,
            ),
          ],
        );
      },
      child: child,
    );
  }
}
