import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class PermissionHandler {
  static Future<void> requestStoragePermissions(BuildContext context) async {
    final manageStatus = await Permission.manageExternalStorage.status;
    log("Permission request status: ${manageStatus.toString()}");

    if (manageStatus.isGranted) {
      log("Permission Granted");
    } else {
      log("Permission Denied");
      if (context.mounted) {
        _showPermissionDeniedDialog(context);
      }
    }
  }

  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          title: Container(
            decoration: const BoxDecoration(
              color: ProjectColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
            ),
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            child: const Text(
              "Permission Required",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          contentPadding: const EdgeInsets.fromLTRB(40, 20, 30, 10),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/caution.png",
                width: 80,
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 400,
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "This app needs file access permission to manage its database.",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: "\n\nPlease proceed to settings page",
                      )
                    ],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  overflow: TextOverflow.clip,
                ),
              )
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(color: ProjectColors.primary))),
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
                      onPressed: () {
                        context.pop(false);
                      },
                      child: const Center(
                          child: Text(
                        "Cancel",
                        style: TextStyle(color: ProjectColors.primary),
                      )),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                      overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                  onPressed: () async {
                    context.pop();
                    await Permission.manageExternalStorage.request();
                  },
                  child: const Center(
                      child: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  )),
                )),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        );
      },
    );
  }
}
