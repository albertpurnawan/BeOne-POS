import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScrollWidget extends StatelessWidget {
  const ScrollWidget({Key? key, this.controller, required this.child, this.padding}) : super(key: key);

  final ScrollController? controller;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final localController = controller ?? ScrollController();

      return Scrollbar(
          thickness: 8,
          radius: const Radius.circular(100),
          controller: localController,
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
              controller: localController, padding: padding, physics: const BouncingScrollPhysics(), child: child));
    }

    return SingleChildScrollView(
        controller: controller, padding: padding, physics: const BouncingScrollPhysics(), child: child);
  }
}
