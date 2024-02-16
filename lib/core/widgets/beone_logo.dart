import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return SvgPicture.asset("assets/logo/maroon.svg",
        color: color, width: size);
  }
}
