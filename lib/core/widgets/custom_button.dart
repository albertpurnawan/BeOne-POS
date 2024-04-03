import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    this.splashColor,
    this.highlightColor,
    required this.child,
    this.borderRadius,
    this.padding,
    this.style = CustomButtonStyle.fill,
    this.onTap,
    this.color,
  }) : super(key: key);

  final Color? splashColor, highlightColor, color;
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final CustomButtonStyle style;
  final void Function()? onTap;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  bool pressedIn = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ProjectColors.primary;
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(5);
    final scaleAnimation =
        Tween<double>(begin: 1, end: .97).animate(_animationController);
    final enabled = widget.onTap != null;

    return Opacity(
      opacity: enabled ? 1 : .6,
      child: Transform.scale(
        scale: scaleAnimation.value,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              color:
                  widget.style != CustomButtonStyle.fill ? Colors.white : color,
              border: widget.style == CustomButtonStyle.bordered
                  ? Border.all(color: color, width: 2)
                  : null),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: widget.splashColor ??
                  (widget.style == CustomButtonStyle.fill
                      ? Colors.white.withOpacity(.2)
                      : color.withOpacity(.2)),
              highlightColor: widget.highlightColor ??
                  (widget.style == CustomButtonStyle.fill
                      ? Colors.white.withOpacity(.1)
                      : color.withOpacity(.1)),
              onTap: enabled
                  ? () {
                      widget.onTap!();
                      _animationController.reverse();
                    }
                  : null,
              onTapDown: enabled ? (_) => _animationController.forward() : null,
              onTapCancel:
                  enabled ? () => _animationController.reverse() : null,
              borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: widget.padding ??
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Center(
                    child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.style != CustomButtonStyle.fill
                                ? color
                                : Colors.white),
                        child: widget.child)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum CustomButtonStyle { fill, bordered, white }
