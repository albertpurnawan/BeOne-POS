import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class DuitkuExpiredDialog extends StatefulWidget {
  const DuitkuExpiredDialog({super.key});

  @override
  State<DuitkuExpiredDialog> createState() => _DuitkuExpiredDialogState();
}

class _DuitkuExpiredDialogState extends State<DuitkuExpiredDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
        child: const Text(
          'Duitku Payment',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Virtual Account HAS EXPIRED",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ProjectColors.mediumBlack,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ProjectColors.green,
                    borderRadius: BorderRadius.circular(36.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                    child: Text(
                      "Please Choose Other Payment Method",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Choose Other Method",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: "  (Esc)",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ],
                    style: TextStyle(color: ProjectColors.primary),
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            )),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
