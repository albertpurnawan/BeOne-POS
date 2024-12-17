import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    Key? key,
    required this.imagePath,
    required this.sentence,
    this.height,
  }) : super(key: key);

  final String imagePath;
  final String sentence;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: const BoxDecoration(
        // border: Border.all(
        //     color: Color.fromRGBO(195, 53, 53, 1),
        //     width: 4.0),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        color: Colors.transparent,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (kIsWeb)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: ProjectColors.primary.withOpacity(.1), shape: BoxShape.circle),
                padding: const EdgeInsets.all(30),
                child: SvgPicture.asset(imagePath, height: 120),
              )
            else
              SvgPicture.asset(imagePath, height: height ?? 150),
            const SizedBox(height: kIsWeb ? 20 : 10),
            Text(sentence,
                textAlign: TextAlign.center, style: const TextStyle(height: 1.4, color: ProjectColors.lightBlack)),
            if (kIsWeb) const SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}
