import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class OpenPriceDialog extends StatefulWidget {
  const OpenPriceDialog({super.key, required this.receiptItemEntity, required this.quantity});

  final ReceiptItemEntity receiptItemEntity;
  final double quantity;

  @override
  State<OpenPriceDialog> createState() => _OpenPriceDialogState();
}

class _OpenPriceDialogState extends State<OpenPriceDialog> {
  final _textEditingControllerOpenPrice = TextEditingController();

  late final _focusNodeOpenPrice = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.f12) {
        context.pop(Helpers.revertMoneyToDecimalFormat(_textEditingControllerOpenPrice.text));
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
    _textEditingControllerOpenPrice.text = Helpers.parseMoney(widget.receiptItemEntity.itemEntity.price.toInt());
  }

  @override
  void dispose() {
    _textEditingControllerOpenPrice.dispose();
    _focusNodeOpenPrice.dispose();
    _keyboardFocusNode.dispose();
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
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Open Price',
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
      content: IntrinsicHeight(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              children: [
                TextFormField(
                  focusNode: _focusNodeOpenPrice,
                  controller: _textEditingControllerOpenPrice,
                  autofocus: true,
                  inputFormatters: [MoneyInputFormatter()],
                  keyboardType: TextInputType.none,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24),
                  onEditingComplete: () {
                    context.pop(Helpers.revertMoneyToDecimalFormat(_textEditingControllerOpenPrice.text));
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Enter Price",
                    hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.payments_outlined,
                      size: 24,
                    ),
                  ),
                ),
                (_showKeyboard)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: KeyboardWidget(
                          controller: _textEditingControllerOpenPrice,
                          isNumericMode: true,
                          customLayoutKeys: true,
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
                                default:
                                  break;
                              }
                            }
                            TextEditingValue formattedValue = MoneyInputFormatter().formatEditUpdate(
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
      ),

      // contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 20, vertical: 5),
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
                context.pop(Helpers.revertMoneyToDecimalFormat(_textEditingControllerOpenPrice.text));
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
