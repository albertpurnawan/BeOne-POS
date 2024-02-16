import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class ClickableText extends StatelessWidget {
  const ClickableText(
    this.data, {
    Key? key,
    this.textStyle,
    this.onTap,
  }) : super(key: key);

  final String data;
  final void Function()? onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(data,
              style: textStyle ??
                  const TextStyle(
                      color: ProjectColors.swatch,
                      fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
