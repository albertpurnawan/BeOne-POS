// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/image_assets.dart';

class ConfirmationDialog extends StatefulWidget {
  final ConfirmationDialogTitle title;
  final ImageAssets imageAsset;

  final String primaryMsg;
  final String? secondaryMsg;
  final bool isProceedOnly;

  const ConfirmationDialog({
    Key? key,
    this.title = ConfirmationDialogTitle.confirmation,
    this.imageAsset = ImageAssets.caution,
    required this.primaryMsg,
    this.secondaryMsg,
    this.isProceedOnly = false,
  }) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
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
        if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;

        if (event.physicalKey == PhysicalKeyboardKey.f12) {
          context.pop(true);
          return KeyEventResult.handled;
        } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
          context.pop(false);
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
          child: Text(
            widget.title.string,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.fromLTRB(40, 20, 30, 10),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.imageAsset.path,
              width: 80,
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              width: 400,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.primaryMsg,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (widget.secondaryMsg != null)
                      TextSpan(
                        text: "\n\n${widget.secondaryMsg}",
                      )
                  ],
                  style: const TextStyle(
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
              if (!widget.isProceedOnly)
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
              if (!widget.isProceedOnly)
                const SizedBox(
                  width: 10,
                ),
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
                          text: "Proceed",
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

enum ConfirmationDialogTitle {
  caution,
  confirmation,
}

extension ConfirmationDialogTitleExt on ConfirmationDialogTitle {
  String get string {
    switch (this) {
      case ConfirmationDialogTitle.caution:
        return "Caution";
      case ConfirmationDialogTitle.confirmation:
      default:
        return "Confirmation";
    }
  }
}
