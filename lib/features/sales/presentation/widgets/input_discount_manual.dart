import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/auth_input_discount_dialog.dart';

class InputDiscountManual extends StatefulWidget {
  final String docnum;
  const InputDiscountManual({super.key, required this.docnum});

  @override
  State<InputDiscountManual> createState() => _InputDiscountManualState();
}

class _InputDiscountManualState extends State<InputDiscountManual> with SingleTickerProviderStateMixin {
  final TextEditingController _textEditorDiscountController = TextEditingController();
  final TextEditingController _textEditorCouponController = TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();
  final FocusNode _couponFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final tabs = [
    const Tab(text: 'Discount Header'),
    const Tab(text: 'Coupon'),
  ];
  bool isDiscount = true;
  late TabController _tabController = TabController(length: tabs.length, vsync: this);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        isDiscount = _tabController.index == 0;

        if (_tabController.index == 1) {
          _couponFocusNode.requestFocus();
        } else {
          _couponFocusNode.unfocus();
        }
      });
    });
    insertToprn();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textEditorDiscountController.dispose();
    _textEditorCouponController.dispose();
    _discountFocusNode.dispose();
    _couponFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  // -------------- DELETE THIS AFTER API AVAILABLE --------------
  Future<void> insertToprn() async {
    final List<dynamic> toprn = [
      "c01cad2f-b6a9-40c4-a50f-26a82ebdb1e1",
      "2024-07-29T04:15:38.000Z",
      "2024-08-14T07:24:44.000Z",
      "Test_Adidas_Percentage",
      "Test_Adidas_Percentage",
      "2024-07-01T00:00:00.000Z",
      "2026-01-01T00:00:00.000Z",
      "1970-01-01T00:00:00.000Z",
      "1970-01-01T11:59:00.000Z",
      "Test_Adidas_Percentage_Remarks",
      1,
      999999999,
      1,
      0.1,
      0.1,
      0.2,
      0.2,
      1
    ];

    final List<dynamic> tprn2 = [
      "5a92c2f5-3435-4712-802a-46c98e952227",
      "2024-08-14T08:52:13.000Z",
      "2024-08-14T08:52:13.000Z",
      "c01cad2f-b6a9-40c4-a50f-26a82ebdb1e1",
      "57d88de1-7160-41e3-827c-cf8da0b228b9",
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1
    ];

    await GetIt.instance<AppDatabase>().upsertToprn(toprn, tprn2);
  }
  // --------------------------------------------------------------

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
                double input = Helpers.revertMoneyToDecimalFormat(_textEditorDiscountController.text);
                final ReceiptEntity state = context.read<ReceiptCubit>().state;
                if ((input > state.grandTotal + (state.discHeaderManual ?? 0)) || input <= 0) {
                  context.pop();
                  ErrorHandler.presentErrorSnackBar(context, "Invalid discount amount");
                  return KeyEventResult.handled;
                }
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AuthInputDiscountDialog(
                          discountValue: input,
                          docnum: widget.docnum,
                        ));
                return KeyEventResult.handled;
              } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
                context.pop();
              } else if (value.physicalKey == PhysicalKeyboardKey.f9) {
                context
                    .read<ReceiptCubit>()
                    .updateTotalAmountFromDiscount(0)
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
                          'Discount & Coupon',
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
                        onPressed: isDiscount
                            ? () async {
                                await context.read<ReceiptCubit>().updateTotalAmountFromDiscount(0);
                                if (context.mounted) {
                                  SnackBarHelper.presentSuccessSnackBar(childContext, "Reset success", 3);
                                }
                              }
                            : null,
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
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: _tabController,
                          tabs: tabs,
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          dividerHeight: 4,
                          dividerColor: Colors.transparent,
                          indicatorColor: ProjectColors.primary,
                          indicatorWeight: 4,
                          labelColor: ProjectColors.primary,
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        const SizedBox(height: 20),
                        Flexible(
                          child: AutoScaleTabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              discountHeaderWidget(context),
                              promoCouponWidget(context),
                            ],
                          ),
                        ),
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
                        onPressed: isDiscount
                            ? () async {
                                double input = Helpers.revertMoneyToDecimalFormat(_textEditorDiscountController.text);
                                final ReceiptEntity state = context.read<ReceiptCubit>().state;
                                if ((input > state.grandTotal + (state.discHeaderManual ?? 0)) || input < 0) {
                                  return ErrorHandler.presentErrorSnackBar(childContext, "Invalid discount amount");
                                }
                                await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AuthInputDiscountDialog(
                                          discountValue: input,
                                          docnum: widget.docnum,
                                        ));
                              }
                            : null,
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
      child: TextFormField(
        focusNode: _discountFocusNode,
        controller: _textEditorDiscountController,
        onFieldSubmitted: (value) async {
          double input = Helpers.revertMoneyToDecimalFormat(value);
          final ReceiptEntity state = context.read<ReceiptCubit>().state;
          if ((input > state.grandTotal + (state.discHeaderManual ?? 0)) || input < 0) {
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
                  builder: (context) => AuthInputDiscountDialog(discountValue: input, docnum: widget.docnum))
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
    );
  }

  Widget promoCouponWidget(BuildContext context) {
    return Center(
      child: TextFormField(
        focusNode: _couponFocusNode,
        controller: _textEditorCouponController,
        onFieldSubmitted: (value) async {},
        autofocus: true,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            hintText: "Enter Coupon Code",
            hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
            border: OutlineInputBorder(),
            prefixIcon: Icon(
              Icons.confirmation_number_outlined,
              size: 24,
            )),
      ),
    );
  }
}
