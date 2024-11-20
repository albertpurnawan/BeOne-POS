import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/field_label.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class InputLineDiscountDialog extends StatefulWidget {
  final ReceiptItemEntity receiptItemEntity;
  final double min;
  final double max;
  final double lineDiscount;

  const InputLineDiscountDialog(
      {super.key,
      required this.receiptItemEntity,
      this.min = double.negativeInfinity,
      this.max = double.infinity,
      required this.lineDiscount});

  @override
  State<InputLineDiscountDialog> createState() =>
      _InputLineDiscountDialogState();
}

class _InputLineDiscountDialogState extends State<InputLineDiscountDialog> {
  final FocusNode _inputReturnedQtyFocusNode = FocusNode();

  final TextEditingController _inputReturnedQtyEditingController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputReturnedQtyEditingController.text =
        Helpers.parseMoney(widget.lineDiscount);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      skipTraversal: true,
      canRequestFocus: false,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent) {
          return KeyEventResult.handled;
        }

        if (event.physicalKey == PhysicalKeyboardKey.escape) {
          Navigator.of(context).pop();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
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
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Row(
            children: [
              const Text(
                'Line Discount',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const Spacer(),
              ExcludeFocus(
                  child: InkWell(
                onTap: () => _saveLineDiscount(amount: 0),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                ),
              ))
            ],
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            width: 400,
            // constraints: BoxConstraints(
            //   maxHeight: MediaQuery.of(context).size.height * 0.6,
            // ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            FieldLabel(
                              label: "Amount",
                              child: TextField(
                                onSubmitted: (_) => _saveLineDiscount(),
                                onChanged: (value) => setState(() {}),
                                autofocus: true,
                                inputFormatters: [
                                  NegativeMoneyInputFormatter()
                                ],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 66, 66, 66)),
                                controller: _inputReturnedQtyEditingController,
                                focusNode: _inputReturnedQtyFocusNode,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(),

                                  // suffixIcon: Container(
                                  //   padding: const EdgeInsets.all(10),
                                  //   width: 80,
                                  //   height: 50,
                                  //   child: OutlinedButton(
                                  //     focusNode: FocusNode(skipTraversal: true),
                                  //     style: OutlinedButton.styleFrom(
                                  //       backgroundColor: ProjectColors.primary,
                                  //       padding: const EdgeInsets.all(5),
                                  //       foregroundColor: Colors.white,
                                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  //     ),
                                  //     onPressed: () async {},
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: [
                                  //         RichText(
                                  //           textAlign: TextAlign.center,
                                  //           text: const TextSpan(
                                  //             children: [
                                  //               TextSpan(
                                  //                 text: "Check",
                                  //                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                  //               ),
                                  //             ],
                                  //             style: TextStyle(height: 1, fontSize: 10),
                                  //           ),
                                  //           overflow: TextOverflow.clip,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: ProjectColors.background,
                        borderRadius: BorderRadius.circular(5)),
                    child: Table(
                      // defaultColumnWidth: IntrinsicColumnWidth(),
                      columnWidths: const {
                        0: FixedColumnWidth(150),
                        1: FlexColumnWidth()
                      },
                      children: [
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Barcode",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                widget.receiptItemEntity.itemEntity.barcode,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Name",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                widget.receiptItemEntity.itemEntity.itemName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Quantity",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                Helpers.cleanDecimal(
                                    widget.receiptItemEntity.quantity, 3),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Initial Total Amt (Tax Inc.)",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                Helpers.parseMoney(widget
                                    .receiptItemEntity.totalAmount
                                    .round()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Line Disc.",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                _inputReturnedQtyEditingController.text == ""
                                    ? "0"
                                    : _inputReturnedQtyEditingController.text,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            TableCell(
                                child: SizedBox(
                              height: 10,
                            )),
                            TableCell(
                                child: SizedBox(
                              height: 10,
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Total Amt. (Tax Inc.)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                Helpers.parseMoney((widget
                                            .receiptItemEntity.totalAmount -
                                        Helpers.revertMoneyToDecimalFormatDouble(
                                            _inputReturnedQtyEditingController
                                                .text))
                                    .round()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
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
        ),
        actionsPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        actions: [
          Row(
            children: [
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor:
                        WidgetStateColor.resolveWith((states) => Colors.white),
                    overlayColor: WidgetStateColor.resolveWith(
                        (states) => ProjectColors.primary.withOpacity(.2))),
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
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ProjectColors.primary),
                    )),
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => ProjectColors.primary),
                    overlayColor: WidgetStateColor.resolveWith(
                        (states) => Colors.white.withOpacity(.2))),
                onPressed: () => _saveLineDiscount(),
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Save",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "  (Enter)",
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
      ),
    );
  }

  void _saveLineDiscount({double? amount}) {
    try {
      final double lineDiscountAmount = amount ??
          Helpers.revertMoneyToDecimalFormatDouble(
              _inputReturnedQtyEditingController.text);
      if (lineDiscountAmount < widget.min || lineDiscountAmount > widget.max)
        throw "Invalid amount";
      context.pop(lineDiscountAmount);
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }
}
