import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({Key? key, required this.child, this.color, this.label})
      : super(key: key);

  final Widget child;
  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (label == null) return child;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          color: color ?? const Color(0xFF555555),
        ),
        child: Text(label!),
      ),
      const SizedBox(height: 5),
      child
    ]);
  }
}
