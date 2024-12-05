import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_manual_rounding.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class RoundingUpDialog extends StatefulWidget {
  const RoundingUpDialog({super.key});

  @override
  State<RoundingUpDialog> createState() => _RoundingUpDialogState();
}

class _RoundingUpDialogState extends State<RoundingUpDialog> {
  final TextEditingController _textEditorAmountRoundUpController = TextEditingController();
  final FocusNode _amountRoundUpFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final FocusScopeNode _focusScopeWarningNode = FocusScopeNode();

  double initialGrandTotal = 0;

  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showKeyboard = true;

  @override
  void initState() {
    super.initState();
    final ReceiptEntity receiptEntity = context.read<ReceiptCubit>().state;
    initialGrandTotal = ((receiptEntity.grandTotal - receiptEntity.rounding)).roundToDouble();

    _textEditorAmountRoundUpController.text = Helpers.parseMoney(receiptEntity.rounding.round());
  }

  @override
  void dispose() {
    _textEditorAmountRoundUpController.dispose();
    _amountRoundUpFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    _focusScopeWarningNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  double getSimulatedGrandTotal() {
    try {
      final double simulatedGrandTotal =
          (initialGrandTotal + Helpers.revertMoneyToDecimalFormatDouble(_textEditorAmountRoundUpController.text))
              .roundToDouble();

      return simulatedGrandTotal;
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
      context.pop();
      return 0;
    }
  }

  Future<void> onSubmit(BuildContext childContext) async {
    try {
      if (_textEditorAmountRoundUpController.text == "-") {
        _amountRoundUpFocusNode.unfocus();
        throw "Invalid discount amount";
      }
      double input = Helpers.revertMoneyToDecimalFormat(_textEditorAmountRoundUpController.text);
      final ReceiptCubit cubit = context.read<ReceiptCubit>();
      final ReceiptEntity state = cubit.state;

      if (state.grandTotal < 0 && input != 0) {
        _amountRoundUpFocusNode.unfocus();
        throw "Rounding up is inapplicable on negative grand total";
      }
      await cubit.applyManualRounding(RoundingMode.up, input);
      context.pop(true);
    } catch (e) {
      if (childContext.mounted) {
        SnackBarHelper.presentErrorSnackBar(childContext, e.toString());
      }
      Future.delayed(const Duration(seconds: 3), () {
        _amountRoundUpFocusNode.requestFocus();
      });
    }
  }

  void _resetRoundingUp(BuildContext childContext) {
    try {
      setState(() {
        _amountRoundUpFocusNode.unfocus();
        _textEditorAmountRoundUpController.text = "0";
      });
      SnackBarHelper.presentSuccessSnackBar(childContext, "Reset rounding success", null);
      Future.delayed(const Duration(seconds: 3), () {
        _amountRoundUpFocusNode.requestFocus();
      });
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(childContext, e.toString());
      Future.delayed(const Duration(seconds: 3), () {
        _amountRoundUpFocusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Builder(builder: (childContext) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: FocusScope(
          autofocus: true,
          skipTraversal: true,
          node: _focusScopeWarningNode,
          onKeyEvent: (node, event) {
            if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;
            if (event.physicalKey == PhysicalKeyboardKey.f12) {
              onSubmit(childContext);
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
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Round Up ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(360)),
                    ),
                    child: IconButton(
                      focusColor: const Color.fromARGB(255, 110, 0, 0),
                      focusNode: _keyboardFocusNode,
                      icon: Icon(
                        _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _showKeyboard = !_showKeyboard;
                        });
                      },
                      tooltip: 'Toggle Keyboard',
                    ),
                  ),
                ],
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              color: Colors.white,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      focusNode: _amountRoundUpFocusNode,
                      controller: _textEditorAmountRoundUpController,
                      onFieldSubmitted: (value) async => await onSubmit(childContext),
                      onChanged: (value) => setState(() {}),
                      autofocus: true,
                      inputFormatters: [MoneyInputFormatter()],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                      keyboardType: TextInputType.none,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Enter Rounding Amount",
                          hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.arrow_upward_outlined,
                            size: 24,
                          ),
                          suffix: SizedBox(
                            width: 24,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(color: ProjectColors.background, borderRadius: BorderRadius.circular(5)),
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const TableCell(
                                child: Text(
                                  "Grand Total (No Rounding)",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              TableCell(
                                child: Text(
                                  Helpers.parseMoney(initialGrandTotal),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const TableCell(
                                child: Text(
                                  "Rounding",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              TableCell(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _textEditorAmountRoundUpController.text == "" ||
                                                _textEditorAmountRoundUpController.text == "0" ||
                                                _textEditorAmountRoundUpController.text == "-"
                                            ? "0"
                                            : _textEditorAmountRoundUpController.text,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ExcludeFocus(
                                        child: InkWell(
                                            onTap: () => _resetRoundingUp(childContext),
                                            child: const Icon(
                                              Icons.delete_outline_rounded,
                                              color: ProjectColors.swatch,
                                              size: 16,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const TableRow(children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ]),
                          TableRow(
                            children: [
                              const TableCell(
                                child: Text(
                                  "Grand Total",
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                ),
                              ),
                              TableCell(
                                child: Text(
                                  Helpers.parseMoney(getSimulatedGrandTotal()),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  (_showKeyboard)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: KeyboardWidget(
                            controller: _textEditorAmountRoundUpController,
                            isNumericMode: true,
                            customLayoutKeys: false,
                            onKeyPress: (key) async {
                              String text = _textEditorAmountRoundUpController.text;
                              TextSelection currentSelection = _textEditorAmountRoundUpController.selection;
                              int cursorPosition = currentSelection.start;

                              if (key.keyType == VirtualKeyboardKeyType.String) {
                                String inputText = key.text ?? '';
                                text = text.replaceRange(
                                    (text == '0') ? cursorPosition - 1 : cursorPosition, cursorPosition, inputText);
                                cursorPosition += inputText.length;
                              } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                                switch (key.action) {
                                  case VirtualKeyboardKeyAction.Backspace:
                                    if (text.isNotEmpty) {
                                      text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
                                      cursorPosition -= 1;
                                    }
                                    break;
                                  default:
                                    break;
                                }
                              }
                              _textEditorAmountRoundUpController.text = text;
                              _textEditorAmountRoundUpController.selection =
                                  TextSelection.collapsed(offset: cursorPosition);

                              setState(() {});
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                      child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: ProjectColors.primary))),
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                        overlayColor:
                            MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
                    onPressed: () {
                      Navigator.of(context).pop(false);
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
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: ProjectColors.primary),
                        )),
                        backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                    onPressed: () async => await onSubmit(childContext),
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Save",
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
            actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
        ),
      );
    }));
  }
}
