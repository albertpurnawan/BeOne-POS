import 'package:flutter/material.dart';

class BeOneLogo extends StatelessWidget {
  const BeOneLogo({
    Key? key,
    required this.size,
    this.color,
  }) : super(key: key);

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/ruby_pos.png", color: color, width: size);
  }
}
