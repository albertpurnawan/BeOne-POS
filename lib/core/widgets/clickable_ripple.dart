import 'package:flutter/material.dart';

class ClickableRipple extends StatelessWidget {
  const ClickableRipple(
      {Key? key,
      this.shape,
      required this.child,
      this.onTap,
      this.brightness,
      this.onLongPress})
      : super(key: key);

  final BoxShape? shape;
  final Widget child;
  final Brightness? brightness;
  final void Function()? onTap, onLongPress;

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark || brightness == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: shape == BoxShape.circle
            ? BorderRadius.circular(100)
            : BorderRadius.circular(5),
        highlightColor: isDark
            ? Colors.black.withOpacity(.1)
            : Colors.white.withOpacity(.2),
        splashColor: isDark
            ? Colors.black.withOpacity(.05)
            : Colors.white.withOpacity(.2),
        child: child,
      ),
    );
  }
}
