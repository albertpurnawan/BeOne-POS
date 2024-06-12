import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class OpenPriceDialog extends StatefulWidget {
  OpenPriceDialog(
      {super.key, required this.receiptItemEntity, required this.quantity});

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
        context.pop(Helpers.revertMoneyToDecimalFormat(
            _textEditingControllerOpenPrice.text));
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
  );

  @override
  initState() {
    super.initState();
    _textEditingControllerOpenPrice.text =
        Helpers.parseMoney(widget.receiptItemEntity.itemEntity.dpp.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'Open Price',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: TextFormField(
            focusNode: _focusNodeOpenPrice,
            controller: _textEditingControllerOpenPrice,
            autofocus: true,
            inputFormatters: [MoneyInputFormatter()],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
            onEditingComplete: () {
              context.pop(Helpers.revertMoneyToDecimalFormat(
                  _textEditingControllerOpenPrice.text));
            },
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: "Enter Price",
                hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.payments_outlined,
                  size: 24,
                )),
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
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white.withOpacity(.2))),
              onPressed: () {
                context.pop(Helpers.revertMoneyToDecimalFormat(
                    _textEditingControllerOpenPrice.text));
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
