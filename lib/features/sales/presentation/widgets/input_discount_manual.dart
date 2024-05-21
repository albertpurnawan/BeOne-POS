import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/presentation/widgets/auth_input_discount_dialog.dart';

class InputDiscountManual extends StatefulWidget {
  const InputDiscountManual({super.key});

  @override
  State<InputDiscountManual> createState() => _InputDiscountManualState();
}

class _InputDiscountManualState extends State<InputDiscountManual> {
  final TextEditingController _textEditorDiscountController =
      TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();

  @override
  void dispose() {
    _textEditorDiscountController.dispose();
    _discountFocusNode.dispose();
    super.dispose();
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
          'Discount',
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
            focusNode: _discountFocusNode,
            controller: _textEditorDiscountController,
            autofocus: true,
            inputFormatters: [MoneyInputFormatter()],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
            // onEditingComplete: () {
            //   double discountValue = Helpers.revertMoneyToDecimalFormat(
            //       _textEditorDiscountController.text);

            //   context
            //       .read<ReceiptCubit>()
            //       .updateTotalAmountFromDiscount(discountValue);
            //   Navigator.of(context).pop();
            // },
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: "Enter Discount",
                hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.discount_outlined,
                  size: 24,
                )),
          ),
        ),
      ),

      // contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 20, vertical: 5),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Row(
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
                        (states) => ProjectColors.primary.withOpacity(.2))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                    child: Text(
                  "Cancel",
                  style: TextStyle(color: ProjectColors.primary),
                )),
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ProjectColors.primary),
                    )),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => ProjectColors.primary),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white.withOpacity(.2))),
                onPressed: () {
                  double input = Helpers.revertMoneyToDecimalFormat(
                      _textEditorDiscountController.text);
                  // context
                  //     .read<ReceiptCubit>()
                  //     .updateTotalAmountFromDiscount(discountValue);
                  // Navigator.of(context).pop();
                  // send input to auth
                  // double inputValue = Helpers.revertMoneyToDecimalFormatDouble(
                  //     _textEditorDiscountController.text);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          AuthInputDiscountDialog(discountValue: input));
                },
                child: const Center(
                    child: Text(
                  "Set",
                  style: TextStyle(color: Colors.white),
                )),
              )),
            ],
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    );
  }
}
