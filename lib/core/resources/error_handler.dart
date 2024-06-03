import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class ErrorHandler {
  static void presentErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: ProjectColors.primary,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(message,
              style: const TextStyle(
                  color: ProjectColors.primary, fontWeight: FontWeight.w700)),
        ],
      ),
      showCloseIcon: true,
      closeIconColor: ProjectColors.primary,
      backgroundColor: ProjectColors.background,
      elevation: 1,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).size.height - 100,
      ),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: ProjectColors.primary, width: 1),
          borderRadius: BorderRadius.circular(5)),
    ));
  }
}
