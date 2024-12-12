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
  State<InputLineDiscountDialog> createState() =>
      _InputLineDiscountDialogState();
}

class _InputLineDiscountDialogState extends State<InputLineDiscountDialog> {
  final FocusNode _inputAmountFocusNode = FocusNode();
  final FocusNode _inputPercentFocusNode = FocusNode();

  final TextEditingController _inputAmountController = TextEditingController();
  final TextEditingController _inputPercentController = TextEditingController();

  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showKeyboard = true;
  bool _shiftEnabled = false;
  bool _currentNumericMode = true;
  bool _isDropdownShown = false;
  final GlobalKey _iconButtonKey = GlobalKey();
  TextEditingController _activeController = TextEditingController();

  @override
  void initState() {
    getDefaultKeyboardPOSParameter();
    super.initState();
    _inputPercentFocusNode.requestFocus();
    _inputAmountController.text = Helpers.parseMoney(widget.lineDiscount);
    if (widget.lineDiscount != 0) {
      final percentage =
          (widget.lineDiscount / widget.receiptItemEntity.totalAmount * 100)
              .abs();
      _inputPercentController.text = '${percentage.toStringAsFixed(2)}%';
    }
    _activeController = _inputAmountController;
  }

  @override
  void dispose() {
    _inputAmountController.dispose();
    _inputPercentController.dispose();
    _inputAmountFocusNode.dispose();
    _inputPercentFocusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
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
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _showKeyboard
                          ? const Color.fromARGB(255, 110, 0, 0)
                          : ProjectColors.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(360)),
                    ),
                    child: IconButton(
                      focusColor: const Color.fromARGB(255, 110, 0, 0),
                      focusNode: _keyboardFocusNode,
                      key: _iconButtonKey,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                            focusNode: _inputPercentFocusNode,
                            controller: _inputPercentController,
                            keyboardType: TextInputType.none,
                            onTap: () {
                              setState(() {
                                _activeController = _inputPercentController;
                              });
                            },
                            onChanged: (value) {
                              final cleanValue = value.replaceAll('%', '');
                              if (cleanValue.isNotEmpty) {
                                final percentage =
                                    double.tryParse(cleanValue) ?? 0;
                                final amount =
                                    (widget.receiptItemEntity.totalAmount *
                                        percentage /
                                        100);
                                _inputAmountController.text =
                                    Helpers.parseMoney(amount);
                              } else {
                                _inputAmountController.text = '';
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
                            focusNode: _inputAmountFocusNode,
                            controller: _inputAmountController,
                            keyboardType: TextInputType.none,
                            onTap: () {
                              setState(() {
                                _activeController = _inputAmountController;
                              });
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final amount = double.tryParse(
                                        value.replaceAll(',', '')) ??
                                    0;
                                final percentage = (amount /
                                        widget.receiptItemEntity.totalAmount *
                                        100)
                                    .abs();
                                _inputPercentController.text =
                                    '${percentage.toStringAsFixed(2)}%';
                              } else {
                                _inputPercentController.text = '';
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
                              hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 24),
                              border: OutlineInputBorder(),
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ProjectColors.background,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Item Name",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            widget.receiptItemEntity.itemEntity.itemName,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            Helpers.parseMoney(
                                widget.receiptItemEntity.totalAmount),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_showKeyboard)
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                  child: KeyboardWidget(
                    controller: _activeController,
                    isNumericMode: _currentNumericMode,
                    customLayoutKeys: true,
                    height: 175,
                    isShiftEnabled: _shiftEnabled,
                    onKeyPress: (key) async {
                      String text = _activeController.text;
                      TextSelection currentSelection =
                          _activeController.selection;
                      int cursorPosition = currentSelection.start;

                      if (key.keyType == VirtualKeyboardKeyType.String) {
                        String inputText = key.text ?? '';
                        text = text.replaceRange(
                          (_activeController == _inputAmountController &&
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
                              text = text.replaceRange(
                                  cursorPosition - 1, cursorPosition, '');
                              cursorPosition -= 1;
                            }
                            break;
                          case VirtualKeyboardKeyAction.Return:
                            if (_shiftEnabled) {
                              FocusScope.of(context).nextFocus();
                            }
                            break;
                          case VirtualKeyboardKeyAction.Space:
                            text = text.replaceRange(
                                cursorPosition, cursorPosition, ' ');
                            cursorPosition += 1;
                            break;
                          case VirtualKeyboardKeyAction.Shift:
                            _shiftEnabled = !_shiftEnabled;
                            break;
                          default:
                            break;
                        }
                      }

                      if (_activeController == _inputAmountController) {
                        TextEditingValue formattedValue =
                            NegativeMoneyInputFormatter().formatEditUpdate(
                          TextEditingValue(
                            text: text,
                            selection:
                                TextSelection.collapsed(offset: cursorPosition),
                          ),
                          TextEditingValue(
                            text: text,
                            selection:
                                TextSelection.collapsed(offset: cursorPosition),
                          ),
                        );

                        _activeController.text = formattedValue.text;
                        _activeController.selection = formattedValue.selection;

                        // Update percentage
                        if (formattedValue.text.isNotEmpty) {
                          final amount = double.tryParse(
                                  formattedValue.text.replaceAll(',', '')) ??
                              0;
                          final percentage = (amount /
                                  widget.receiptItemEntity.totalAmount *
                                  100)
                              .abs();
                          _inputPercentController.text =
                              '${percentage.toStringAsFixed(2)}%';
                        } else {
                          _inputPercentController.text = '';
                        }
                      } else if (_activeController == _inputPercentController) {
                        // Handle percentage input with decimal formatting
                        if (text.isEmpty ||
                            RegExp(r'^\d*\.?\d{0,3}$')
                                .hasMatch(text.replaceAll('%', ''))) {
                          // Remove % if present for processing
                          final cleanText = text.replaceAll('%', '');

                          // Add % back when setting the text
                          _activeController.text =
                              cleanText.isEmpty ? '' : '$cleanText%';
                          _activeController.selection =
                              TextSelection.collapsed(offset: cleanText.length);

                          // Update amount
                          if (cleanText.isNotEmpty) {
                            final percentage = double.tryParse(cleanText) ?? 0;
                            final amount =
                                (widget.receiptItemEntity.totalAmount *
                                    percentage /
                                    100);
                            _inputAmountController.text =
                                Helpers.parseMoney(amount);
                          } else {
                            _inputAmountController.text = '';
                          }
                        }
                      } else {
                        _activeController.text = text;
                        _activeController.selection =
                            TextSelection.collapsed(offset: cursorPosition);
                      }

                      setState(() {});
                    },
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
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: ProjectColors.primary),
                      ),
                    ),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith(
                      (states) => ProjectColors.primary.withOpacity(.2),
                    ),
                  ),
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
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: ProjectColors.primary),
                      ),
                    ),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => ProjectColors.primary),
                    overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white.withOpacity(.2),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      if (_inputAmountController.text == "-") {
                        throw "Invalid discount amount";
                      }
                      double input = Helpers.revertMoneyToDecimalFormat(
                          _inputAmountController.text);
                      if (input > widget.max || input < widget.min) {
                        throw "Invalid discount amount";
                      }

                      Navigator.of(context).pop(input);
                    } catch (e) {
                      SnackBarHelper.presentErrorSnackBar(
                          context, e.toString());
                    }
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
                        style: TextStyle(color: Colors.white),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
