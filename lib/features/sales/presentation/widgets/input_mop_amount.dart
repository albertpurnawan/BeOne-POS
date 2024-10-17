// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';

class InputMopAmountDialog extends StatefulWidget {
  const InputMopAmountDialog({
    Key? key,
    required this.mopSelectionEntity,
    this.max = double.infinity,
  }) : super(key: key);

  final MopSelectionEntity mopSelectionEntity;
  final double max;

  @override
  State<InputMopAmountDialog> createState() => _InputMopAmountDialogState();
}

class _InputMopAmountDialogState extends State<InputMopAmountDialog> {
  TextEditingController _textEditingControllerOpenPrice = TextEditingController();
  bool isErr = false;
  String errMsg = "Invalid";

  late final _focusNodeOpenPrice = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.f12) {
        final double mopAmount = Helpers.revertMoneyToDecimalFormat(_textEditingControllerOpenPrice.text);
        if (mopAmount > widget.max) {
          setState(() {
            isErr = true;
          });

          return KeyEventResult.handled;
        }
        context.pop(mopAmount);
        return KeyEventResult.handled;
      } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    },
  );

  @override
  initState() {
    super.initState();
    if (widget.max != double.infinity) {
      final String initialAmount = Helpers.parseMoney(widget.max);
      _textEditingControllerOpenPrice = TextEditingController.fromValue(TextEditingValue(
          text: initialAmount, selection: TextSelection(baseOffset: 0, extentOffset: initialAmount.length)));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingControllerOpenPrice.dispose();
    _focusNodeOpenPrice.dispose();
    super.dispose();
  }

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
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'Input Amount',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                decoration: BoxDecoration(
                  color: ProjectColors.primary,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 5,
                      color: Color.fromRGBO(0, 0, 0, 0.222),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const Icon(Icons.inventory_2_outlined, color: Colors.white),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Text(
                      widget.mopSelectionEntity.mopAlias,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                  focusNode: _focusNodeOpenPrice,
                  controller: _textEditingControllerOpenPrice,
                  autofocus: true,
                  inputFormatters: [NegativeMoneyInputFormatter()],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                  onChanged: (value) {
                    final double mopAmount = Helpers.revertMoneyToDecimalFormat(value);
                    if (mopAmount == double.infinity) return;
                    if (mopAmount > widget.max) {
                      setState(() {
                        isErr = true;
                      });
                    } else if (isErr) {
                      setState(() {
                        isErr = false;
                      });
                    }
                  },
                  onEditingComplete: () {
                    final double mopAmount = Helpers.revertMoneyToDecimalFormat(_textEditingControllerOpenPrice.text);
                    if (mopAmount == double.infinity) return;
                    if (mopAmount > widget.max) return;
                    context.pop(mopAmount);
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintText: "Enter Amount",
                      hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                      border: const OutlineInputBorder(),
                      suffix: Container(
                        alignment: Alignment.centerRight,
                        width: 100,
                        child: Text(
                          isErr ? errMsg : "",
                          style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              color: ProjectColors.swatch),
                        ),
                      ),
                      prefixIcon: Container(
                        width: 100,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: const Icon(
                          Icons.payments_outlined,
                          size: 24,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),

      // contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 20, vertical: 5),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  // Future.delayed(const Duration(milliseconds: 200),
                  //     () => _newReceiptItemCodeFocusNode.requestFocus());
                });
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
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
              onPressed: () {
                if (isErr) return;
                final double mopAmount = Helpers.revertMoneyToDecimalFormat(_textEditingControllerOpenPrice.text);
                context.pop(mopAmount);
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
