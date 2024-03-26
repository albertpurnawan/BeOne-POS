import 'package:flutter/material.dart';
import 'package:pos_fe/core/widgets/field_label.dart';

class CustomRowInput extends StatelessWidget {
  final String leftText;
  final String rightText;

  const CustomRowInput({
    Key? key,
    required this.leftText,
    required this.rightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FieldLabel(
      color: theme.colorScheme.primary,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red), // Add border here
            borderRadius:
                BorderRadius.circular(4), // Optional: Add border radius
          ),
          child: Row(
            children: [
              Text(
                leftText,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: TextField(
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: rightText,
                      hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 5),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
