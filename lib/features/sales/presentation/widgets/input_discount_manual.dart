import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/auth_input_discount_dialog.dart';

class InputDiscountManual extends StatefulWidget {
  const InputDiscountManual({super.key});

  @override
  State<InputDiscountManual> createState() => _InputDiscountManualState();
}

class _InputDiscountManualState extends State<InputDiscountManual> {
  final TextEditingController _textEditorDiscountController = TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  @override
  void dispose() {
    _textEditorDiscountController.dispose();
    _discountFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, value) {
        if (value.runtimeType == KeyUpEvent) return KeyEventResult.handled;

        if (value.physicalKey == PhysicalKeyboardKey.enter) {
          double input = Helpers.revertMoneyToDecimalFormat(_textEditorDiscountController.text);
          final ReceiptEntity state = context.read<ReceiptCubit>().state;
          if ((input > state.subtotal - (state.discAmount ?? 0)) || input <= 0) {
            context.pop();
            ErrorHandler.presentErrorSnackBar(context, "Invalid discount amount");
            return KeyEventResult.handled;
          }
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AuthInputDiscountDialog(discountValue: input));
          return KeyEventResult.handled;
        } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
          context.pop();
        }

        return KeyEventResult.ignored;
      },
      focusNode: _keyboardListenerFocusNode,
      child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        title: Container(
          decoration: const BoxDecoration(
            color: ProjectColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Handle Header Discount tap
                  log('Header Discount tapped');
                },
                child: const Text(
                  'Header Discount',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Show Promo Code dialog
              //     showDialog(
              //       context: context,
              //       builder: (context) => const InputPromoCodeDialog(),
              //     );
              //   },
              //   child: const Text(
              //     'Promo Code',
              //     style: TextStyle(
              //       fontSize: 22,
              //       fontWeight: FontWeight.w500,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            child: TextFormField(
              focusNode: _discountFocusNode,
              controller: _textEditorDiscountController,
              onFieldSubmitted: (value) async {
                double input = Helpers.revertMoneyToDecimalFormat(value);
                final ReceiptEntity state = context.read<ReceiptCubit>().state;
                if (input > state.subtotal - (state.discAmount ?? 0)) {
                  context.pop();
                  return ErrorHandler.presentErrorSnackBar(context, "Invalid discount amount");
                }
                // context
                //     .read<ReceiptCubit>()
                //     .updateTotalAmountFromDiscount(discountValue);
                // Navigator.of(context).pop();
                // send input to auth
                // double inputValue = Helpers.revertMoneyToDecimalFormatDouble(
                //     _textEditorDiscountController.text);
                await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AuthInputDiscountDialog(discountValue: input))
                    .then((value) => _discountFocusNode.requestFocus());
              },
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
        actions: <Widget>[
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
                onPressed: () {
                  double input = Helpers.revertMoneyToDecimalFormat(_textEditorDiscountController.text);
                  final ReceiptEntity state = context.read<ReceiptCubit>().state;
                  if (input > state.subtotal - (state.discAmount ?? 0)) {
                    context.pop();
                    return ErrorHandler.presentErrorSnackBar(context, "Invalid discount amount");
                  }
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AuthInputDiscountDialog(discountValue: input));
                },
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Enter",
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
        actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
}
