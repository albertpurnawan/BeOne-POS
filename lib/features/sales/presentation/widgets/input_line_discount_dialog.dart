import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/field_label.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

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
  State<InputLineDiscountDialog> createState() => _InputLineDiscountDialogState();
}

class _InputLineDiscountDialogState extends State<InputLineDiscountDialog> {
  final FocusNode _inputReturnedQtyFocusNode = FocusNode();

  final TextEditingController _inputReturnedQtyEditingController = TextEditingController();

  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showKeyboard = true;
  bool _shiftEnabled = false;
  bool _currentNumericMode = true;
  bool _isDropdownShown = false;
  final GlobalKey _iconButtonKey = GlobalKey();

  @override
  void initState() {
    getDefaultKeyboardPOSParameter();
    super.initState();
    _inputReturnedQtyEditingController.text = Helpers.parseMoney(widget.lineDiscount);
  }

  @override
  void dispose() {
    _inputReturnedQtyEditingController.dispose();
    _inputReturnedQtyFocusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  Future<void> getDefaultKeyboardPOSParameter() async {
    try {
      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      setState(() {
        _showKeyboard = (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
      });
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentFailSnackBar(context, e.toString());
      }
    }
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
    final RenderBox renderBox = _iconButtonKey.currentContext!.findRenderObject() as RenderBox;
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(360)),
                    ),
                    child: IconButton(
                      focusColor: const Color.fromARGB(255, 110, 0, 0),
                      focusNode: _keyboardFocusNode,
                      key: _iconButtonKey,
                      icon: Icon(
                        _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _toggleKeyboard();
                        });
                      },
                      tooltip: 'Toggle Keyboard',
                    ),
                  ),
                  const SizedBox(width: 10),
                  ExcludeFocus(
                    child: InkWell(
                      onTap: () => _saveLineDiscount(amount: 0),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
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
                                inputFormatters: [NegativeMoneyInputFormatter()],
                                keyboardType: TextInputType.none,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 66, 66, 66)),
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
                    decoration: BoxDecoration(color: ProjectColors.background, borderRadius: BorderRadius.circular(5)),
                    child: Table(
                      // defaultColumnWidth: IntrinsicColumnWidth(),
                      columnWidths: const {0: FixedColumnWidth(150), 1: FlexColumnWidth()},
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
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
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
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
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
                                Helpers.cleanDecimal(widget.receiptItemEntity.quantity, 3),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
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
                                Helpers.parseMoney(widget.receiptItemEntity.totalAmount.round()),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
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
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
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
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                Helpers.parseMoney((widget.receiptItemEntity.totalAmount -
                                        Helpers.revertMoneyToDecimalFormatDouble(
                                            _inputReturnedQtyEditingController.text))
                                    .round()),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
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
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: KeyboardWidget(
                          controller: _inputReturnedQtyEditingController,
                          isNumericMode: _currentNumericMode,
                          customLayoutKeys: true,
                          isShiftEnabled: _shiftEnabled,
                          onKeyPress: (key) async {
                            String text = _inputReturnedQtyEditingController.text;
                            TextSelection currentSelection = _inputReturnedQtyEditingController.selection;
                            int cursorPosition = currentSelection.start;

                            if (key.keyType == VirtualKeyboardKeyType.String) {
                              String inputText = key.text ?? '';
                              text = text.replaceRange(
                                  (text == '0') ? cursorPosition - 1 : cursorPosition, cursorPosition, inputText);
                              cursorPosition += inputText.length;
                            } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                              switch (key.action) {
                                case VirtualKeyboardKeyAction.Backspace:
                                  if (text.isNotEmpty && cursorPosition > 0) {
                                    text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
                                    cursorPosition -= 1;
                                  }
                                  break;

                                case VirtualKeyboardKeyAction.Return:
                                  text = text.trimRight();
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
                            TextEditingValue formattedValue = NegativeMoneyInputFormatter().formatEditUpdate(
                              TextEditingValue(
                                text: text,
                                selection: TextSelection.collapsed(offset: cursorPosition),
                              ),
                              TextEditingValue(
                                text: text,
                                selection: TextSelection.collapsed(offset: cursorPosition),
                              ),
                            );

                            _inputReturnedQtyEditingController.text = formattedValue.text;
                            _inputReturnedQtyEditingController.selection = formattedValue.selection;

                            setState(() {});
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
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
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
      final double lineDiscountAmount =
          amount ?? Helpers.revertMoneyToDecimalFormatDouble(_inputReturnedQtyEditingController.text);
      if (lineDiscountAmount < widget.min || lineDiscountAmount > widget.max) throw "Invalid amount";
      context.pop(lineDiscountAmount);
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }
}
