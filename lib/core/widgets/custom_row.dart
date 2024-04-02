import 'package:flutter/material.dart';
import 'package:pos_fe/core/widgets/field_label.dart';

class CustomRow extends StatelessWidget {
  final String leftText;
  final String? rightText;

  const CustomRow({
    Key? key,
    required this.leftText,
    this.rightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FieldLabel(
      color: theme.colorScheme.primary,
      child: Row(
        children: [
          Text(
            leftText,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const Spacer(),
          Text(
            rightText!,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
