import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/features/sales/presentation/widgets/auth_input_discount_dialog.dart';

class SelectAuthDialog extends StatefulWidget {
  final double discountValue;
  const SelectAuthDialog({Key? key, required this.discountValue})
      : super(key: key);

  @override
  State<SelectAuthDialog> createState() => _SelectAuthDialogState();
}

class _SelectAuthDialogState extends State<SelectAuthDialog> {
  String? radioValue;
  String? selectedEmployee;
  final FocusNode _authFocusNode = FocusNode();

  @override
  void dispose() {
    _authFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: FocusNode(
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          if (event.runtimeType == KeyUpEvent) {
            return KeyEventResult.handled;
          }

          if (event.character != null &&
              RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(event.character!) &&
              !_authFocusNode.hasPrimaryFocus) {
            _authFocusNode.unfocus();
            _authFocusNode.requestFocus();
            return KeyEventResult.handled;
          } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown &&
              _authFocusNode.hasPrimaryFocus) {
            _authFocusNode.nextFocus();
            return KeyEventResult.handled;
          } else if (event.physicalKey == PhysicalKeyboardKey.f12) {
            _authFocusNode.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();

            selectedEmployee = radioValue;
            Navigator.of(context).pop(selectedEmployee);
            return KeyEventResult.handled;
          } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
            Navigator.of(context).pop();
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        },
      ),
      child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Container(
          decoration: const BoxDecoration(
            color: ProjectColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: const Text(
            'Authorization Method',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: Theme(
          data: ThemeData(
            splashColor: const Color.fromARGB(40, 169, 0, 0),
            highlightColor: const Color.fromARGB(40, 169, 0, 0),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            fontFamily: 'Roboto',
            useMaterial3: true,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  RadioListTile<String>(
                    activeColor: ProjectColors.primary,
                    hoverColor: ProjectColors.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: 'OTP',
                    groupValue: radioValue,
                    title: const Text('OTP'),
                    onChanged: (val) => setState(() => radioValue = val),
                  ),
                  RadioListTile<String>(
                    activeColor: ProjectColors.primary,
                    hoverColor: ProjectColors.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: 'Admin',
                    groupValue: radioValue,
                    title: const Text('Admin'),
                    onChanged: (val) => setState(() => radioValue = val),
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
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black.withOpacity(.2))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Cancel",
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
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white.withOpacity(.2))),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AuthInputDiscountDialog(
                              discountValue: widget.discountValue));
                      // Navigator.pop(context);
                    },
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Select",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: "  (F12)",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    )),
              )
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
}
