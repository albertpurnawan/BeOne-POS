import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/auth_input_discount_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DiscountAndRoundingDialog extends StatefulWidget {
  final String docnum;
  const DiscountAndRoundingDialog({super.key, required this.docnum});

  @override
  State<DiscountAndRoundingDialog> createState() => _DiscountAndRoundingDialogState();
}

class _DiscountAndRoundingDialogState extends State<DiscountAndRoundingDialog> {
  final TextEditingController _textEditorDiscountController = TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  int count = 0;
  final ScrollController _scrollController = ScrollController();

  bool isHeaderDiscount = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      count = prefs.getInt("countDiscount") ?? 0;
    });
  }

  @override
  void dispose() {
    _textEditorDiscountController.dispose();
    _discountFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  Future<void> onSubmit() async {
    try {
      if (_textEditorDiscountController.text == "-" || _textEditorDiscountController.text == "") {
        context.pop();
        throw "Invalid discount amount";
      }
      double input = Helpers.revertMoneyToDecimalFormat(_textEditorDiscountController.text);
      final ReceiptEntity state = context.read<ReceiptCubit>().state;
      if (state.grandTotal < 0) {
        context.pop();
        throw "Discount & Rounding is inapplicable on negative grand total";
      }
      if ((input > state.grandTotal + (state.discHeaderManual ?? 0))) {
        context.pop();
        throw "Invalid discount amount";
      }

      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "POS Parameter not found";
      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>().call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) throw "Store master not found";

      if (input < (storeMasterEntity.minDiscount ?? 0) || input > (storeMasterEntity.maxDiscount ?? 0)) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AuthInputDiscountDialog(
                  discountValue: input,
                  docnum: widget.docnum,
                ));
      } else {
        await context.read<ReceiptCubit>().updateTotalAmountFromDiscount(input, context);
        // if (context.read<ReceiptCubit>().state.downPayments != null &&
        //     context.read<ReceiptCubit>().state.downPayments!.isNotEmpty) {
        //   await context.read<ReceiptCubit>().processReceiptBeforeCheckout(context);
        // }
        context.pop(input);
      }
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Focus(
            autofocus: true,
            skipTraversal: true,
            onKeyEvent: (node, event) {
              if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;
              if (event.physicalKey == PhysicalKeyboardKey.f12) {
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
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: Row(
                  children: [
                    const Text(
                      'Discount & Rounding',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const Spacer(),
                    ToggleSwitch(
                      minHeight: 30,
                      // minWidth: 80.0,
                      cornerRadius: 5,
                      animate: true,
                      animationDuration: 400,
                      curve: Curves.easeInOut,
                      activeBgColors: const [
                        [ProjectColors.green],
                        [ProjectColors.green]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: const Color.fromARGB(255, 211, 211, 211),
                      inactiveFgColor: ProjectColors.lightBlack,
                      initialLabelIndex: isHeaderDiscount ? 0 : 1,
                      totalSwitches: 2,
                      labels: const ['Header', 'Line'],
                      customTextStyles: const [
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700)
                      ],
                      radiusStyle: true,
                      onToggle: (index) {
                        if (index == 0) {
                          setState(() {
                            isHeaderDiscount = true;
                          });
                        }
                        if (index == 1) {
                          setState(() {
                            isHeaderDiscount = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: isHeaderDiscount ? discountHeaderWidget(context) : [Row()],
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
                      onPressed: isHeaderDiscount
                          ? () async {
                              // FocusScope.of(context).unfocus();
                              // final receiptItems = context.read<ReceiptCubit>().state.receiptItems;
                              // if (receiptItems.any((item) => item.itemEntity.itemCode != "99") &&
                              //     receiptItems.any((item) => item.itemEntity.itemCode != "08700000002")) {
                              //   SnackBarHelper.presentErrorSnackBar(
                              //       childContext, "Down payment has to be excluded from other transactions");
                              //   return;
                              // }
                              // if (salesSelected == "Not Set*") {
                              //   SnackBarHelper.presentErrorSnackBar(childContext, "Please select the salesperson");
                              //   return;
                              // }
                              // if (receiveZero || _amountController.text == "") {
                              //   SnackBarHelper.presentErrorSnackBar(
                              //       childContext, "Please input the Down Payment amount");
                              //   return;
                              // }
                              // if (_remarksController.text.isEmpty) {
                              //   SnackBarHelper.presentErrorSnackBar(childContext, "Please fill in the remarks");
                              //   return;
                              // }
                              // if (await _checkDrawDownPayment()) {
                              //   if (childContext.mounted) {
                              //     SnackBarHelper.presentErrorSnackBar(childContext,
                              //         "Receiving and drawing down a payment cannot be processed in a single transaction");
                              //   }
                              //   return;
                              // }
                              // if (context.mounted) {
                              //   context.pop();
                              // }
                              // await _addOrUpdateReceiveDownPayment();
                              // // log("is it here? - $stateInvoice");
                            }
                          : () async {
                              // FocusScope.of(context).unfocus();
                              // if (await _checkReceiveDownPayment()) {
                              //   if (childContext.mounted) {
                              //     SnackBarHelper.presentErrorSnackBar(childContext,
                              //         "Receiving and drawing down payment cannot be processed in a single transaction");
                              //   }
                              //   return;
                              // }

                              // await _resetDrawDownPayment();

                              // if (childContext.mounted) {
                              //   await _addOrUpdateDrawDownPayment(childContext);
                              // }
                            },
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
      }),
    );
  }

  List<Widget> discountHeaderWidget(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          focusNode: _discountFocusNode,
          controller: _textEditorDiscountController,
          onFieldSubmitted: (value) async => await onSubmit(),
          onChanged: (value) => setState(() {}),
          autofocus: true,
          inputFormatters: [NegativeMoneyInputFormatter()],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: "Enter Discount",
              hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.discount_outlined,
                size: 24,
              ),
              suffix: SizedBox(
                width: 24,
              )),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: ProjectColors.background, borderRadius: BorderRadius.circular(5)),
          child: Table(
            // defaultColumnWidth: IntrinsicColumnWidth(),
            // columnWidths: const {0: FixedColumnWidth(100), 1: FlexColumnWidth()},
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
                      Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal),
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
                      "Header Discount",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      _textEditorDiscountController.text == "" ? "0" : _textEditorDiscountController.text,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Line Discounts",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "9,000,000",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14),
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
              const TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Grand Total",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "20,000,000",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
