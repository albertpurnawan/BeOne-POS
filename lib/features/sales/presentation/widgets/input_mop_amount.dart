// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

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

  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showKeyboard = true;
  bool _isDropdownShown = false;
  final GlobalKey _iconButtonKey = GlobalKey();
  bool _currentNumericMode = true;
  bool _shiftEnabled = false;
  String initialAmount = "";

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
    getDefaultKeyboardPOSParameter();
    super.initState();
    if (widget.max != double.infinity) {
      initialAmount = Helpers.parseMoney(widget.max);
      _textEditingControllerOpenPrice = TextEditingController.fromValue(TextEditingValue(
        text: initialAmount,
        selection: TextSelection(
          baseOffset: 0,
          extentOffset: initialAmount.length,
        ),
      ));
    }
  }

  @override
  void dispose() {
    _textEditingControllerOpenPrice.dispose();
    _focusNodeOpenPrice.dispose();
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
    return AlertDialog(
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
              'Input Amount',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            Container(
              decoration: BoxDecoration(
                color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                borderRadius: const BorderRadius.all(Radius.circular(360)),
              ),
              child: IconButton(
                key: _iconButtonKey,
                focusColor: const Color.fromARGB(255, 110, 0, 0),
                focusNode: _keyboardFocusNode,
                icon: Icon(
                  _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
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
                  keyboardType: TextInputType.none,
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
              (_showKeyboard)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: KeyboardWidget(
                        controller: _textEditingControllerOpenPrice,
                        isNumericMode: _currentNumericMode,
                        customLayoutKeys: true,
                        isShiftEnabled: _shiftEnabled,
                        onKeyPress: (key) async {
                          String text = _textEditingControllerOpenPrice.text;
                          TextSelection currentSelection = _textEditingControllerOpenPrice.selection;
                          int cursorPosition = currentSelection.end;

                          if (key.keyType == VirtualKeyboardKeyType.String) {
                            String inputText = key.text ?? '';
                            text = text.replaceRange(cursorPosition, cursorPosition, inputText);
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
                                _textEditingControllerOpenPrice.text = _textEditingControllerOpenPrice.text.trimRight();
                                final double mopAmount =
                                    Helpers.revertMoneyToDecimalFormat(_textEditingControllerOpenPrice.text);
                                if (mopAmount == double.infinity) return;
                                if (mopAmount > widget.max) return;
                                context.pop(mopAmount);

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

                          _textEditingControllerOpenPrice.text = formattedValue.text;

                          _textEditingControllerOpenPrice.selection = formattedValue.selection;

                          setState(() {});
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
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
