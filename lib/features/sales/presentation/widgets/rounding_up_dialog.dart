import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_manual_rounding.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';

class RoundingUpDialog extends StatefulWidget {
  const RoundingUpDialog({super.key});

  @override
  State<RoundingUpDialog> createState() => _RoundingUpDialogState();
}

class _RoundingUpDialogState extends State<RoundingUpDialog> {
  final TextEditingController _textEditorAmountRoundUpController = TextEditingController();
  final FocusNode _amountRoundUpFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  double initialGrandTotal = 0;

  @override
  void initState() {
    super.initState();
    final ReceiptEntity receiptEntity = context.read<ReceiptCubit>().state;

    initialGrandTotal = receiptEntity.grandTotal +
        (receiptEntity.discHeaderManual ?? 0) +
        receiptEntity.receiptItems.fold(
            0.0,
            (previousValue, e1) =>
                previousValue +
                (((100 + e1.itemEntity.taxRate) / 100) *
                    e1.promos
                        .where((e2) => e2.promoType == 998)
                        .fold(0.0, (previousValue, e3) => previousValue + (e3.discAmount ?? 0))));
    _textEditorAmountRoundUpController.text = Helpers.parseMoney(receiptEntity.rounding);
  }

  @override
  void dispose() {
    _textEditorAmountRoundUpController.dispose();
    _amountRoundUpFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  double getSimulatedGrandTotal() {
    try {
      final double simulatedGrandTotal =
          initialGrandTotal + Helpers.revertMoneyToDecimalFormatDouble(_textEditorAmountRoundUpController.text);

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
      await cubit.applyRounding(RoundingMode.up, input);
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
          node: _focusScopeNode,
          onKeyEvent: (node, event) {
            if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;
            if (event.physicalKey == PhysicalKeyboardKey.f12) {
              onSubmit(childContext);
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
              context.pop();
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
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: const Row(
                children: [
                  Text(
                    'Round Up ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ],
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.4,
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
                      inputFormatters: [NegativeMoneyInputFormatter()],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
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
                                  "Initial Grand Total",
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
                                  "Rounding Amount",
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
                      Navigator.of(context).pop();
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
            actionsPadding: const EdgeInsets.all(10),
          ),
        ),
      );
    }));
  }
}
