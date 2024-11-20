import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';

class QuantityReceiveDPDialog extends StatefulWidget {
  const QuantityReceiveDPDialog({super.key, required this.quantity});
  final double quantity;

  @override
  State<QuantityReceiveDPDialog> createState() =>
      _QuantityReceiveDPDialogState();
}

class _QuantityReceiveDPDialogState extends State<QuantityReceiveDPDialog> {
  final _textEditingControllerQuantity = TextEditingController();
  bool isZero = false;

  late final _focusNodeQuantity = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.f12) {
        if (_textEditingControllerQuantity.text == '0') {
          setState(() {
            isZero = true;
          });
          return KeyEventResult.handled;
        }
        setState(() {
          isZero = false;
        });
        context.pop(_textEditingControllerQuantity.text);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
  );

  @override
  initState() {
    super.initState();
    _textEditingControllerQuantity.text =
        Helpers.cleanDecimal(widget.quantity, 1);
  }

  @override
  void dispose() {
    _textEditingControllerQuantity.dispose();
    super.dispose();
  }

  // void _check

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'Input Quantity',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 30, 40, 5),
              child: TextFormField(
                focusNode: _focusNodeQuantity,
                controller: _textEditingControllerQuantity,
                autofocus: true,
                inputFormatters: [MoneyInputFormatter()],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
                onEditingComplete: () {
                  if (_textEditingControllerQuantity.text == '0') {
                    setState(() {
                      isZero = true;
                    });
                    return;
                  }
                  setState(() {
                    isZero = false;
                  });
                  context.pop(_textEditingControllerQuantity.text);
                },
                onChanged: (value) {
                  setState(() {
                    isZero = false;
                  });
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Enter Quantity",
                  hintStyle:
                      TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.numbers,
                    size: 24,
                  ),
                  suffixIcon: SizedBox(width: 24),
                ),
              ),
            ),
            (isZero)
                ? const Text(
                    "Quantity can't be zero",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                      color: ProjectColors.swatch,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: WidgetStateColor.resolveWith(
                      (states) => ProjectColors.primary),
                  overlayColor: WidgetStateColor.resolveWith(
                      (states) => Colors.white.withOpacity(.2))),
              onPressed: () {
                if (_textEditingControllerQuantity.text == '0') {
                  setState(() {
                    isZero = true;
                  });
                  return;
                }
                setState(() {
                  isZero = false;
                });
                log("adwfwfwwf - ${_textEditingControllerQuantity.text}");
                context.pop(_textEditingControllerQuantity.text);
              },
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Set",
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
    );
  }
}
