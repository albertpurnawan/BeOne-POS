import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';

class OpenPriceDialog extends StatelessWidget {
  OpenPriceDialog(
      {super.key, required this.itemEntity, required this.quantity});

  final ItemEntity itemEntity;
  final double quantity;

  final _textEditingControllerOpenPrice = TextEditingController();
  final _focusNodeOpenPrice = FocusNode();

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
            // onChanged: (value) => setState(() {
            //   _cashAmount =
            //       Helpers.revertMoneyToDecimalFormat(
            //               value)
            //           .toInt();
            //   updateReceiptMop();
            // }),
            inputFormatters: [MoneyInputFormatter()],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
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
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.black.withOpacity(.2))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                  child: Text(
                "Cancel",
                style: TextStyle(color: ProjectColors.primary),
              )),
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
              onPressed: () {
                // selectedCustomer = radioValue;
                context
                    .read<ReceiptCubit>()
                    .addOrUpdateReceiptItemWithOpenPrice(
                        itemEntity,
                        quantity,
                        Helpers.revertMoneyToDecimalFormat(
                            _textEditingControllerOpenPrice.text));
                Navigator.of(context).pop();
                // Future.delayed(
                //     const Duration(milliseconds: 200),
                //     () => _newReceiptItemCodeFocusNode
                //         .requestFocus());
              },
              child: const Center(
                  child: Text(
                "Set",
                style: TextStyle(color: Colors.white),
              )),
            )),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    );
  }
}
