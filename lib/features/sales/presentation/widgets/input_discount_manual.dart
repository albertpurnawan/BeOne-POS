import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/auth_input_discount_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputDiscountManual extends StatefulWidget {
  final String docnum;
  const InputDiscountManual({super.key, required this.docnum});

  @override
  State<InputDiscountManual> createState() => _InputDiscountManualState();
}

class _InputDiscountManualState extends State<InputDiscountManual> with SingleTickerProviderStateMixin {
  final TextEditingController _textEditorDiscountController = TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  int count = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      count = prefs.getInt("countDiscount") ?? 0;
    });
  }

  @override
  void dispose() {
    _textEditorDiscountController.dispose();
    _discountFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  Future<void> onSubmit() async {
    try {
      if (_textEditorDiscountController.text == "-" || _textEditorDiscountController.text == "") {
        context.pop();
        throw "Invalid discount amount";
      }
      double input = Helpers.revertMoneyToDecimalFormat(_textEditorDiscountController.text);
      final ReceiptEntity state = context.read<ReceiptCubit>().state;
      if (state.grandTotal < 0) {
        context.pop();
        throw "Discount & Rounding is inapplicable on negative grand total";
      }
      if ((input > state.grandTotal + (state.discHeaderManual ?? 0))) {
        context.pop();
        throw "Invalid discount amount";
      }

      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "POS Parameter not found";
      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>().call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) throw "Store master not found";

      if (input < (storeMasterEntity.minDiscount ?? 0) || input > (storeMasterEntity.maxDiscount ?? 0)) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AuthInputDiscountDialog(
                  discountValue: input,
                  docnum: widget.docnum,
                ));
      } else {
        await context.read<ReceiptCubit>().updateTotalAmountFromDiscount(input, context);
        // if (context.read<ReceiptCubit>().state.downPayments != null &&
        //     context.read<ReceiptCubit>().state.downPayments!.isNotEmpty) {
        //   await context.read<ReceiptCubit>().processReceiptBeforeCheckout(context);
        // }
        context.pop(input);
      }
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
          body: Focus(
            onKeyEvent: (node, value) {
              if (value.runtimeType == KeyUpEvent) return KeyEventResult.handled;

              if (value.physicalKey == PhysicalKeyboardKey.enter) {
                onSubmit();
                return KeyEventResult.handled;
              } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
                context.pop();
                return KeyEventResult.handled;
              } else if (value.physicalKey == PhysicalKeyboardKey.f9) {
                context
                    .read<ReceiptCubit>()
                    .updateTotalAmountFromDiscount(0, context)
                    .then((value) => SnackBarHelper.presentSuccessSnackBar(childContext, "Reset success", 3));
                return KeyEventResult.handled;
              }

              return KeyEventResult.ignored;
            },
            focusNode: _keyboardListenerFocusNode,
            child: Center(
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
                        child: const Text(
                          'Discount & Rounding',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        focusNode: FocusNode(skipTraversal: true),
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.all(10),
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          await context.read<ReceiptCubit>().updateTotalAmountFromDiscount(0, context);

                          if (context.mounted) {
                            SnackBarHelper.presentSuccessSnackBar(childContext, "Reset success", 3);
                            Future.delayed(const Duration(seconds: 3), () {
                              _discountFocusNode.requestFocus();
                            });
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.replay_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Reset",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: " (F9)",
                                    style: TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                ],
                                style: TextStyle(height: 1, fontSize: 12),
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ],
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
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        discountHeaderWidget(childContext),
                      ],
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
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(color: ProjectColors.primary))),
                            backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                            overlayColor:
                                MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          await onSubmit();
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
            ),
          ),
        );
      }),
    );
  }

  Widget discountHeaderWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          focusNode: _discountFocusNode,
          controller: _textEditorDiscountController,
          onFieldSubmitted: (value) async => await onSubmit(),
          autofocus: true,
          inputFormatters: [NegativeMoneyInputFormatter()],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
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
    );
  }
}
