import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class ConfirmRedeemVouchersFailDialog extends StatefulWidget {
  final String? message;
  const ConfirmRedeemVouchersFailDialog({super.key, this.message});

  @override
  State<ConfirmRedeemVouchersFailDialog> createState() => _ConfirmRedeemVouchersFailDialogState();
}

class _ConfirmRedeemVouchersFailDialogState extends State<ConfirmRedeemVouchersFailDialog> {
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      focusNode: _keyboardListenerFocusNode,
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent) {
          return KeyEventResult.handled;
        }

        if (event.physicalKey == PhysicalKeyboardKey.f12) {
          context.pop(true);
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: AlertDialog(
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
            'Notification',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.fromLTRB(40, 20, 30, 10),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/3d-fail.png",
              width: 80,
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              width: 400,
              child: RichText(
                text: widget.message != null
                    ? TextSpan(
                        children: [
                          TextSpan(
                            text: widget.message,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(
                            text: "\n\nPlease reinput the vouchers and try again",
                          )
                        ],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      )
                    : const TextSpan(
                        children: [
                          TextSpan(
                            text: "Redeem was failed for one or more vouchers",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: "\n\nPlease reinput the vouchers and try again",
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

        // contentPadding: const EdgeInsets.symmetric(
        //     horizontal: 20, vertical: 5),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                onPressed: () {
                  context.pop(true);
                },
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "OK",
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
                ),
              )),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
}
