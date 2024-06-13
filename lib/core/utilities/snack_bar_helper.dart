import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class SnackBarHelper {
  static void presentErrorSnackBar(BuildContext? context, String message) {
    if (context == null) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

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

  static void presentFailSnackBar(BuildContext? context, String message) {
    if (context == null) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

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

  static void presentSuccessSnackBar(BuildContext? context, String message) {
    if (context == null) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.done_outline_outlined,
            color: ProjectColors.green,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(message,
              style: const TextStyle(
                  color: ProjectColors.green, fontWeight: FontWeight.w700)),
        ],
      ),
      showCloseIcon: true,
      closeIconColor: ProjectColors.green,
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
          side: const BorderSide(color: ProjectColors.green, width: 1),
          borderRadius: BorderRadius.circular(5)),
    ));
  }
}
