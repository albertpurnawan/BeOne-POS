import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_rounding.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/auth_input_discount_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/input_line_discount_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class DiscountAndRoundingDialog extends StatefulWidget {
  final String docnum;
  final bool manualRounded;
  const DiscountAndRoundingDialog(
      {super.key, required this.docnum, required this.manualRounded});

  @override
  State<DiscountAndRoundingDialog> createState() =>
      _DiscountAndRoundingDialogState();
}

class _DiscountAndRoundingDialogState extends State<DiscountAndRoundingDialog> {
  final TextEditingController _textEditorHeaderDiscountAmountController =
      TextEditingController();
  final TextEditingController _textEditorHeaderDiscountPercentController =
      TextEditingController();
  final TextEditingController _textEditorLineDiscountController =
      TextEditingController();

  final FocusNode _discountFocusNode = FocusNode();
  final FocusNode _discountPercentFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final FocusScopeNode _focusScopeWarningNode = FocusScopeNode();
  final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  int count = 0;

  bool isHeaderDiscount = true;
  bool isManualRounded = false;
  double initialGrandTotal = 0;
  double initialRounding = 0;
  List<LineDiscountParameter> lineDiscountInputs = [];
  List<LineDiscountParameter> searchedLineDiscountInputs = [];
  final FocusNode _searchLineDiscountFocusNode = FocusNode();

  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showKeyboard = true;
  bool _shiftEnabled = false;
  bool _currentNumericMode = true;
  bool _isDropdownShown = false;
  final GlobalKey _iconButtonKey = GlobalKey();
  TextEditingController _activeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDefaultKeyboardPOSParameter();
    _discountPercentFocusNode.requestFocus();
    final ReceiptEntity state = context.read<ReceiptCubit>().state;

    initialGrandTotal = (state.grandTotal -
            state.rounding +
            (state.discHeaderManual ?? 0) +
            state.receiptItems.fold(
                0.0,
                (previousValue, e1) =>
                    previousValue +
                    (((100 + e1.itemEntity.taxRate) / 100) *
                        e1.promos.where((e2) => e2.promoType == 998).fold(
                            0.0,
                            (previousValue, e3) =>
                                previousValue + (e3.discAmount ?? 0)))))
        .roundToDouble();
    lineDiscountInputs = context
        .read<ReceiptCubit>()
        .state
        .receiptItems
        .map((e) => LineDiscountParameter(
            receiptItemEntity: ReceiptHelper.updateReceiptItemAggregateFields(
                e.copyWith(
                    promos: e.promos
                        .where((element) => element.promoType != 998)
                        .map((e) => e.copyWith())
                        .toList(),
                    discAmount: e.promos
                        .where((element) => element.promoType != 998)
                        .fold(
                            0.0,
                            (previousValue, element) =>
                                (previousValue ?? 0) +
                                (element.discAmount ?? 0)))),
            lineDiscountAmount: (e.promos
                        .where((element) => element.promoType == 998)
                        .firstOrNull
                        ?.discAmount ??
                    0) *
                ((100 + e.itemEntity.taxRate) / 100)))
        .toList();
    searchedLineDiscountInputs = lineDiscountInputs;
    _textEditorHeaderDiscountAmountController.text =
        Helpers.parseMoney(state.discHeaderManual ?? 0);
    isManualRounded = widget.manualRounded;
    initialRounding = state.rounding.roundToDouble();

    _discountPercentFocusNode.addListener(() {
      if (_discountPercentFocusNode.hasFocus) {
        setState(() {
          _activeController = _textEditorHeaderDiscountPercentController;
        });
      }
    });
    _discountFocusNode.addListener(() {
      if (_discountFocusNode.hasFocus) {
        setState(() {
          _activeController = _textEditorHeaderDiscountAmountController;
        });
      }
    });

    _searchLineDiscountFocusNode.addListener(() {
      if (_searchLineDiscountFocusNode.hasFocus) {
        setState(() {
          _activeController = _textEditorLineDiscountController;
        });
      }
    });
  }

  @override
  void dispose() {
    _textEditorHeaderDiscountAmountController.dispose();
    _textEditorHeaderDiscountPercentController.dispose();
    _discountFocusNode.dispose();
    _discountPercentFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    _focusScopeNode.dispose();
    _focusScopeWarningNode.dispose();
    _keyboardFocusNode.dispose();
    // _activeController.dispose();
    super.dispose();
  }

  void _toggleKeyboard() {
    if (_isDropdownShown) {
      setState(() {
        _showKeyboard = !_showKeyboard;
      });
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() async {
    final RenderBox renderBox =
        _iconButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    await showMenu(
      context: context,
      surfaceTintColor: Colors.transparent,
      color: const Color.fromARGB(255, 245, 245, 245),
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      items: [
        const PopupMenuItem(
          value: "Alphanumeric",
          child: Text("Alphanumeric"),
        ),
        const PopupMenuItem(
          value: "Numeric",
          child: Text("Numeric"),
        ),
        const PopupMenuItem(
          value: "Off",
          child: Text("Off"),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'Off':
            setState(() {
              _showKeyboard = false;
            });
            break;
          case 'Alphanumeric':
            setState(() {
              _showKeyboard = true;
              _currentNumericMode = false;
            });
            break;
          case 'Numeric':
            setState(() {
              _showKeyboard = true;
              _currentNumericMode = true;
            });
            break;
          default:
            setState(() {
              _showKeyboard = true;
            });
            break;
        }
      }
    });
  }

  Future<void> getDefaultKeyboardPOSParameter() async {
    try {
      final POSParameterEntity? posParameterEntity =
          await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      setState(() {
        _showKeyboard =
            (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
      });
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentFailSnackBar(context, e.toString());
      }
    }
  }

  double getLineDiscountsTotal() {
    try {
      final double lineDiscountsTotal = lineDiscountInputs.fold(
          0,
          (previousValue, element) =>
              previousValue + element.lineDiscountAmount);

      return lineDiscountsTotal;
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
      context.pop();
      return 0;
    }
  }

  double getSimulatedGrandTotal() {
    try {
      final double simulatedGrandTotal = initialGrandTotal -
          Helpers.revertMoneyToDecimalFormatDouble(
              _textEditorHeaderDiscountAmountController.text) -
          lineDiscountInputs.fold(
              0,
              (previousValue, element) =>
                  previousValue + element.lineDiscountAmount) +
          context.read<ReceiptCubit>().state.rounding;

      return simulatedGrandTotal.roundToDouble();
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
      context.pop();
      return 0;
    }
  }

  Future<void> onSubmit() async {
    try {
      if (_textEditorHeaderDiscountAmountController.text == "-") {
        context.pop();
        throw "Invalid discount amount";
      }
      double input = Helpers.revertMoneyToDecimalFormat(
          _textEditorHeaderDiscountAmountController.text);
      final ReceiptEntity state = context.read<ReceiptCubit>().state;
      if (state.grandTotal < 0 && input != 0) {
        context.pop();
        throw "Header discount is inapplicable on negative grand total";
      }
      if (state.grandTotal > 0 &&
          (input > state.grandTotal + (state.discHeaderManual ?? 0))) {
        context.pop();
        throw "Invalid discount amount";
      }

      final POSParameterEntity? posParameterEntity =
          await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "POS Parameter not found";
      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>()
              .call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) throw "Store master not found";
      if (isManualRounded) {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return _warningResetRounding(isManualRounded,
                  onComplete: () async {
                context.read<ReceiptCubit>().resetRounding(initialGrandTotal);
                context.read<ReceiptCubit>().replaceState(
                    await GetIt.instance<ApplyRoundingUseCase>()
                        .call(params: context.read<ReceiptCubit>().state));
                setState(() {
                  initialRounding = context.read<ReceiptCubit>().state.rounding;
                });
              });
            });
        return;
      }

      if (input < (storeMasterEntity.minDiscount ?? 0) ||
          input > (storeMasterEntity.maxDiscount ?? 0) ||
          lineDiscountInputs
              .any((element) => element.lineDiscountAmount != 0)) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AuthInputDiscountDialog(
                  initialGrandTotal: initialGrandTotal,
                  finalGrandTotal: getSimulatedGrandTotal(),
                  discountValue: input,
                  docnum: widget.docnum,
                  lineDiscountParameters: lineDiscountInputs,
                ));
      } else {
        await context
            .read<ReceiptCubit>()
            .updateTotalAmountFromDiscount(input, lineDiscountInputs);
        context.pop(input);
      }
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  void _searchItemLineDiscount() {
    log("_textEditorLineDiscountController.text - ${_textEditorLineDiscountController.text}");
    setState(() {
      searchedLineDiscountInputs = lineDiscountInputs
          .where((element) =>
              element.receiptItemEntity.itemEntity.itemName.contains(RegExp(
                  _textEditorLineDiscountController.text,
                  caseSensitive: false)) ||
              element.receiptItemEntity.itemEntity.itemCode.contains(RegExp(
                  _textEditorLineDiscountController.text,
                  caseSensitive: false)) ||
              element.receiptItemEntity.itemEntity.barcode.contains(RegExp(
                  _textEditorLineDiscountController.text,
                  caseSensitive: false)))
          .toList();
      // log(lineDiscountInputs
      //     .where((element) =>
      //         element.receiptItemEntity.itemEntity.itemName
      //             .contains(RegExp(_textEditorLineDiscountController.text, caseSensitive: false)) ||
      //         element.receiptItemEntity.itemEntity.itemCode
      //             .contains(RegExp(_textEditorLineDiscountController.text, caseSensitive: false)) ||
      //         element.receiptItemEntity.itemEntity.barcode
      //             .contains(RegExp(_textEditorLineDiscountController.text, caseSensitive: false)))
      //     .toList()
      //     .toString());
      log(searchedLineDiscountInputs.toString());
    });
  }

  void _resetLineDiscounts() {
    try {
      setState(() {
        lineDiscountInputs =
            lineDiscountInputs.map((e) => e..lineDiscountAmount = 0).toList();
      });
      SnackBarHelper.presentSuccessSnackBar(
          context, "Reset line discounts success", null);
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  void _resetHeaderDiscount() {
    try {
      setState(() {
        _textEditorHeaderDiscountAmountController.text = "0";
        _textEditorHeaderDiscountPercentController.text = "0";
        _discountPercentFocusNode.requestFocus();
      });
      SnackBarHelper.presentSuccessSnackBar(
          context, "Reset header discount success", null);
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
          body: FocusScope(
            autofocus: true,
            skipTraversal: true,
            node: _focusScopeNode,
            onKeyEvent: (node, event) {
              if (event.runtimeType == KeyUpEvent)
                return KeyEventResult.handled;
              if (event.physicalKey == PhysicalKeyboardKey.f12) {
                onSubmit();
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
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Container(
                decoration: const BoxDecoration(
                  color: ProjectColors.primary,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(5.0)),
                ),
                padding: const EdgeInsets.fromLTRB(25, 5, 10, 5),
                child: Row(
                  children: [
                    const Text(
                      'Discount',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const Spacer(),
                    Row(
                      children: [
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
                          inactiveBgColor:
                              const Color.fromARGB(255, 211, 211, 211),
                          inactiveFgColor: ProjectColors.lightBlack,
                          initialLabelIndex: isHeaderDiscount ? 0 : 1,
                          totalSwitches: 2,
                          labels: const ['Header', 'Line'],
                          customTextStyles: const [
                            TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700),
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
                        const SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: _showKeyboard
                                ? const Color.fromARGB(255, 110, 0, 0)
                                : ProjectColors.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(360)),
                          ),
                          child: IconButton(
                            key: _iconButtonKey,
                            focusColor: const Color.fromARGB(255, 110, 0, 0),
                            focusNode: _keyboardFocusNode,
                            icon: Icon(
                              _showKeyboard
                                  ? Icons.keyboard_hide_outlined
                                  : Icons.keyboard_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _toggleKeyboard();
                            },
                            tooltip: 'Toggle Keyboard',
                          ),
                        ),
                      ],
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
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...(isHeaderDiscount
                        ? _buildHeaderDiscount(context)
                        : _buildLineDiscounts(context)),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ProjectColors.background,
                            borderRadius: BorderRadius.circular(5)),
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
                                    "Header Discount",
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
                                          _textEditorHeaderDiscountAmountController
                                                          .text ==
                                                      "" ||
                                                  _textEditorHeaderDiscountAmountController
                                                          .text ==
                                                      "0" ||
                                                  _textEditorHeaderDiscountAmountController
                                                          .text ==
                                                      "-"
                                              ? "0"
                                              : _textEditorHeaderDiscountAmountController
                                                  .text,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ExcludeFocus(
                                          child: InkWell(
                                              onTap: () =>
                                                  _resetHeaderDiscount(),
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
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Text(
                                    "Line Discounts",
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
                                          Helpers.parseMoney(
                                              getLineDiscountsTotal()),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ExcludeFocus(
                                          child: InkWell(
                                              onTap: () =>
                                                  _resetLineDiscounts(),
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
                                          Helpers.parseMoney(initialRounding),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 5,
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    Helpers.parseMoney(
                                        getSimulatedGrandTotal()),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
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
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: _buildKeyboard(),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: ProjectColors.primary))),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      ProjectColors.primary.withOpacity(.2))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Cancel",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: "  (Esc)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
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
                        flex: 2,
                        child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    color: ProjectColors.primary),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () async {
                            await onSubmit();
                          },
                          child: Center(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Save",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: "  (F12)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
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

  Widget _buildKeyboard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      child: KeyboardWidget(
        controller: _activeController,
        isNumericMode: _currentNumericMode,
        customLayoutKeys: true,
        height: 175,
        isShiftEnabled: _shiftEnabled,
        onKeyPress: (key) async {
          String text = _activeController.text;
          TextSelection currentSelection = _activeController.selection;
          int cursorPosition = currentSelection.start;

          if (key.keyType == VirtualKeyboardKeyType.String) {
            String inputText = key.text ?? '';
            text = text.replaceRange(
              (_activeController == _textEditorHeaderDiscountAmountController &&
                      text == '0')
                  ? cursorPosition - 1
                  : cursorPosition,
              cursorPosition,
              inputText,
            );
            cursorPosition += inputText.length;
          } else if (key.keyType == VirtualKeyboardKeyType.Action) {
            switch (key.action) {
              case VirtualKeyboardKeyAction.Backspace:
                if (text.isNotEmpty && cursorPosition > 0) {
                  text =
                      text.replaceRange(cursorPosition - 1, cursorPosition, '');
                  cursorPosition -= 1;
                }
                break;
              case VirtualKeyboardKeyAction.Return:
                if (_shiftEnabled) {
                  FocusScope.of(context).nextFocus();
                }
                break;

              case VirtualKeyboardKeyAction.Space:
                text = text.replaceRange(cursorPosition, cursorPosition, ' ');
                cursorPosition += 1;
                break;

              case VirtualKeyboardKeyAction.Shift:
                _shiftEnabled = !_shiftEnabled;
                break;

              default:
                break;
            }
          }

          if (_activeController == _textEditorHeaderDiscountAmountController) {
            TextEditingValue formattedValue =
                NegativeMoneyInputFormatter().formatEditUpdate(
              TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: cursorPosition),
              ),
              TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: cursorPosition),
              ),
            );

            _activeController.text = formattedValue.text;
            _activeController.selection = formattedValue.selection;

            // Update percentage
            if (formattedValue.text.isNotEmpty) {
              final amount =
                  double.tryParse(formattedValue.text.replaceAll(',', '')) ?? 0;
              final percentage = (amount / initialGrandTotal * 100).abs();
              _textEditorHeaderDiscountPercentController.text =
                  percentage.toStringAsFixed(2);
            } else {
              _textEditorHeaderDiscountPercentController.text = '';
            }
          } else if (_activeController ==
              _textEditorHeaderDiscountPercentController) {
            // Handle percentage input with decimal formatting
            if (text.isEmpty ||
                RegExp(r'^\d*\.?\d{0,3}$').hasMatch(text.replaceAll('%', ''))) {
              // Remove % if present for processing
              final cleanText = text.replaceAll('%', '');

              // Add % back when setting the text
              _activeController.text = cleanText.isEmpty ? '' : '$cleanText%';
              _activeController.selection =
                  TextSelection.collapsed(offset: cleanText.length);

              // Update amount
              if (cleanText.isNotEmpty) {
                final percentage = double.tryParse(cleanText) ?? 0;
                final amount = (initialGrandTotal * percentage / 100);
                _textEditorHeaderDiscountAmountController.text =
                    Helpers.parseMoney(amount);
              } else {
                _textEditorHeaderDiscountAmountController.text = '';
              }
            }
          } else {
            _activeController.text = text;
            _activeController.selection =
                TextSelection.collapsed(offset: cursorPosition);
          }

          setState(() {});

          if (_activeController == _textEditorLineDiscountController) {
            try {
              _searchItemLineDiscount();
              _searchLineDiscountFocusNode.requestFocus();
            } catch (e) {
              SnackBarHelper.presentErrorSnackBar(context, e.toString());
            }
          }
        },
      ),
    );
  }

  List<Widget> _buildHeaderDiscount(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Discount Percentage'),
                  TextFormField(
                    focusNode: _discountPercentFocusNode,
                    controller: _textEditorHeaderDiscountPercentController,
                    keyboardType: TextInputType.none,
                    onFieldSubmitted: (value) async => await onSubmit(),
                    onChanged: (value) {
                      final cleanValue = value.replaceAll('%', '');
                      if (cleanValue.isNotEmpty) {
                        final percentage = double.tryParse(cleanValue) ?? 0;
                        final amount = (initialGrandTotal * percentage / 100);
                        _textEditorHeaderDiscountAmountController.text =
                            Helpers.parseMoney(amount);
                      } else {
                        _textEditorHeaderDiscountAmountController.text = '';
                      }
                      setState(() {});
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,3}%?$')),
                    ],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: "ex. 10%",
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 24),
                        border: OutlineInputBorder(),
                        suffixText: '%'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Discount Amount'),
                  TextFormField(
                    focusNode: _discountFocusNode,
                    controller: _textEditorHeaderDiscountAmountController,
                    keyboardType: TextInputType.none,
                    onFieldSubmitted: (value) async => await onSubmit(),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final amount =
                            double.tryParse(value.replaceAll(',', '')) ?? 0;
                        final percentage =
                            (amount / initialGrandTotal * 100).abs();
                        _textEditorHeaderDiscountPercentController.text =
                            percentage.toStringAsFixed(2);
                      } else {
                        _textEditorHeaderDiscountPercentController.text = '';
                      }
                      setState(() {});
                    },
                    autofocus: true,
                    inputFormatters: [NegativeMoneyInputFormatter()],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "ex. 100,000",
                      hintStyle:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildLineDiscounts(BuildContext context) {
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          textInputAction: TextInputAction.search,
          focusNode: _searchLineDiscountFocusNode,
          controller: _textEditorLineDiscountController,
          keyboardType: TextInputType.none,
          onChanged: (value) {
            try {
              _searchItemLineDiscount();
              _searchLineDiscountFocusNode.requestFocus();
            } catch (e) {
              SnackBarHelper.presentErrorSnackBar(context, e.toString());
            }
          },
          onSubmitted: (value) {
            try {
              _searchItemLineDiscount();
              _searchLineDiscountFocusNode.requestFocus();
            } catch (e) {
              SnackBarHelper.presentErrorSnackBar(context, e.toString());
            }
          },
          autofocus: true,
          // focusNode: _searchInputFocusNode,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              size: 16,
            ),
            hintText: "Enter item name, code, or barcode",
            hintStyle: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            // isCollapsed: true,
            // contentPadding:
            //     EdgeInsets.fromLTRB(0, 0, 0, 0),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      if (searchedLineDiscountInputs.isEmpty)
        const Expanded(
          child: EmptyList(
            imagePath: "assets/images/empty-item.svg",
            height: 80,
            sentence:
                "Tadaa.. There is nothing here!\nInput item barcode to start adding item.",
          ),
        )
      else
        Expanded(
          child: ScrollablePositionedList.builder(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            // itemScrollController: itemScrollController,
            // scrollOffsetController: scrollOffsetController,
            // itemPositionsListener: itemPositionsListener,
            // scrollOffsetListener: scrollOffsetListener,
            itemCount: searchedLineDiscountInputs.length,
            itemBuilder: (context, index) {
              final e = searchedLineDiscountInputs[index];

              return Material(
                type: MaterialType.transparency,
                elevation: 6.0,
                color: Colors.transparent,
                shadowColor: Colors.grey[50],
                child: InkWell(
                  focusColor: const Color.fromARGB(255, 237, 200, 200),
                  onTap: () async {
                    try {
                      final double? lineDiscount = await showDialog<double>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => ScaffoldMessenger(
                          child: Builder(builder: (context) {
                            return Scaffold(
                              backgroundColor: Colors.transparent,
                              body: InputLineDiscountDialog(
                                  receiptItemEntity: e.receiptItemEntity
                                      .copyWith(
                                          promos: e.receiptItemEntity.promos
                                              .map((e) => e.copyWith())
                                              .toList()),
                                  lineDiscount: e.lineDiscountAmount,
                                  max: e.receiptItemEntity.quantity >= 0
                                      ? e.receiptItemEntity.totalAmount + 0.49
                                      : double.infinity,
                                  min: e.receiptItemEntity.quantity >= 0
                                      ? double.negativeInfinity
                                      : e.receiptItemEntity.totalAmount - 0.49),
                            );
                          }),
                        ),
                      );

                      if (lineDiscount == null) return;

                      setState(() {
                        e.lineDiscountAmount = lineDiscount;
                      });
                    } catch (e) {
                      SnackBarHelper.presentErrorSnackBar(
                          context, e.toString());
                    }
                  },
                  child: Column(
                    children: [
                      if (index == 0)
                        const Column(
                          children: [
                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Color.fromARGB(100, 118, 118, 117),
                            ),
                          ],
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            5,
                            10,
                            0,
                            e.receiptItemEntity.quantity < 0 ||
                                    e.lineDiscountAmount != 0
                                ? 0
                                : 10),
                        child: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    children: [
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment
                                        //         .spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FittedBox(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/inventory.svg",
                                                        height: 16,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        e
                                                            .receiptItemEntity
                                                            .itemEntity
                                                            .itemCode,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/images/barcode.svg",
                                                        height: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        e.receiptItemEntity
                                                            .itemEntity.barcode,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  e.receiptItemEntity.itemEntity
                                                          .shortName ??
                                                      e.receiptItemEntity
                                                          .itemEntity.itemName,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              // QuantityUI
                                              children: [
                                                Text(
                                                  "${Helpers.cleanDecimal(e.receiptItemEntity.quantity, 3)} x",
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              // PriceUI
                                              children: [
                                                Text(
                                                  "@ ${Helpers.parseMoney((e.receiptItemEntity.sellingPrice).round())}",
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // TotalPriceUI
                                              children: [
                                                Text(
                                                  Helpers.parseMoney((e
                                                              .receiptItemEntity
                                                              .totalAmount -
                                                          e.lineDiscountAmount)
                                                      .round()),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          e.lineDiscountAmount !=
                                                                  0
                                                              ? FontWeight.w700
                                                              : FontWeight
                                                                  .w500),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                // e.tohemId != null || state.salesTohemId != null
                                                //     ? FutureBuilder(
                                                //         future: getSalesPerson(
                                                //             e.tohemId, state.salesTohemId),
                                                //         builder: (context, snapshot) {
                                                //           if (snapshot.hasData) {
                                                //             return Text(
                                                //               snapshot.data?.empName ?? "",
                                                //               textAlign: TextAlign.right,
                                                //               style: const TextStyle(
                                                //                   height: 1,
                                                //                   fontSize: 12,
                                                //                   fontWeight: FontWeight.w500),
                                                //             );
                                                //           } else {
                                                //             return const SizedBox.shrink();
                                                //           }
                                                //         })
                                                //     : const SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if ((e.receiptItemEntity.quantity < 0 &&
                                              e.receiptItemEntity.refpos3 !=
                                                  null) ||
                                          e.lineDiscountAmount != 0)
                                        const SizedBox(
                                          height: 24,
                                        )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    5,
                                    (e.receiptItemEntity.quantity < 0 &&
                                                e.receiptItemEntity.refpos3 !=
                                                    null) ||
                                            e.lineDiscountAmount != 0
                                        ? 10
                                        : 0),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                ),
                              ),
                            ),
                            if ((e.receiptItemEntity.quantity < 0 &&
                                    e.receiptItemEntity.refpos3 != null) ||
                                e.lineDiscountAmount != 0)
                              Positioned.fill(
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        if (e.lineDiscountAmount != 0)
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 2, 10, 2),
                                            decoration: const BoxDecoration(
                                              // border: Border.all(
                                              //     color: Color.fromRGBO(195, 53, 53, 1),
                                              //     width: 4.0),
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(5)),

                                              color: Color.fromARGB(
                                                  255, 11, 57, 84),
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     spreadRadius: 0.5,
                                              //     blurRadius: 5,
                                              //     color: Color.fromRGBO(0, 0, 0, 0.111),
                                              //   ),
                                              // ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    "LD ${Helpers.parseMoney(e.lineDiscountAmount)}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        if (e.receiptItemEntity.quantity < 0 &&
                                            e.receiptItemEntity.refpos3 != null)
                                          const SizedBox(
                                            width: 8,
                                          ),
                                        if (e.receiptItemEntity.quantity < 0 &&
                                            e.receiptItemEntity.refpos3 != null)
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 2, 10, 2),
                                            decoration: const BoxDecoration(
                                              // border: Border.all(
                                              //     color: Color.fromRGBO(195, 53, 53, 1),
                                              //     width: 4.0),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5)),

                                              color: Colors.orange,
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     spreadRadius: 0.5,
                                              //     blurRadius: 5,
                                              //     color: Color.fromRGBO(0, 0, 0, 0.111),
                                              //   ),
                                              // ],
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Return",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Color.fromARGB(100, 118, 118, 118),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
    ];
  }

  Widget _warningResetRounding(bool manualRounded,
      {required Function onComplete}) {
    return FocusScope(
      autofocus: false,
      skipTraversal: true,
      node: _focusScopeWarningNode,
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;
        if (event.physicalKey == PhysicalKeyboardKey.f12) {
          if (mounted && manualRounded == false) {
            context.pop(true);
            onComplete();
          } else if (manualRounded == true) {
            setState(() {
              isManualRounded = false;
            });

            onComplete();
            context.pop(true);
            _discountPercentFocusNode.requestFocus();
          }
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Container(
          decoration: const BoxDecoration(
            color: ProjectColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
          child: const Text(
            'Caution',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.fromLTRB(40, 20, 30, 10),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/caution.png",
              width: 70,
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              width: 400,
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "Rounding will be reset, you'll need to reinput\nthe discount and rounding again.\nProceed?",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
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
                onPressed: () async {
                  if (mounted && manualRounded == false) {
                    context.pop(true);
                    onComplete();
                  } else if (manualRounded == true) {
                    setState(() {
                      isManualRounded = false;
                    });

                    await onComplete();
                    context.pop(true);
                    _discountPercentFocusNode.requestFocus();
                  }
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

class LineDiscountParameter {
  final ReceiptItemEntity receiptItemEntity;
  double lineDiscountAmount = 0;

  LineDiscountParameter(
      {required this.receiptItemEntity, required this.lineDiscountAmount});
}
