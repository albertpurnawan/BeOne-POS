import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class QuantityReceiveDPDialog extends StatefulWidget {
  const QuantityReceiveDPDialog({super.key, required this.quantity});
  final double quantity;

  @override
  State<QuantityReceiveDPDialog> createState() => _QuantityReceiveDPDialogState();
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

  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showKeyboard = true;

  @override
  initState() {
    super.initState();
    _textEditingControllerQuantity.text = Helpers.cleanDecimal(widget.quantity, 1);
    getDefaultKeyboardPOSParameter();
  }

  @override
  void dispose() {
    _textEditingControllerQuantity.dispose();
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
              'Input Quantity',
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
                keyboardType: TextInputType.none,
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
                  hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
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
            (_showKeyboard)
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 5),
                    child: KeyboardWidget(
                      controller: _textEditingControllerQuantity,
                      isNumericMode: true,
                      customLayoutKeys: true,
                      onKeyPress: (key) async {
                        String text = _textEditingControllerQuantity.text;
                        TextSelection currentSelection = _textEditingControllerQuantity.selection;
                        int cursorPosition = currentSelection.end;

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
                            default:
                              break;
                          }
                        }
                        _textEditingControllerQuantity.text = text;
                        _textEditingControllerQuantity.selection = TextSelection.collapsed(offset: cursorPosition);
                        setState(() {});
                      },
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
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
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
