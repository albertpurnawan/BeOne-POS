import 'dart:developer';

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
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
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

  late TabController _tabController = TabController(length: tabs.length, vsync: this);
  final tabs = [
    const Tab(text: 'Discount Header'),
    const Tab(text: 'Coupon'),
  ];

  bool isDiscount = true;
  List<PromoCouponHeaderEntity> couponList = [];

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
    if (context.read<ReceiptCubit>().state.coupons != null) {
      couponList = context.read<ReceiptCubit>().state.coupons!;
    }
    // insertToprn();
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
  // Future<void> insertToprn() async {
  // final List<dynamic> toprn = [
  //   "1f027a2f-09aa-4dde-bc0b-fcc32cbef9a8",
  //   "2024-08-14T14:11:15.000Z",
  //   "2024-08-14T14:11:47.000Z",
  //   "dev_promo_couponxxx",
  //   "Dev Promo Couponxxx",
  //   "2024-08-01T00:00:00.000Z",
  //   "2025-12-31T00:00:00.000Z",
  //   "1970-01-01T00:00:00.000Z",
  //   "1970-01-01T11:30:00.000Z",
  //   "Promo Dev Coupon xxx Remarks",
  //   1,
  //   999999999,
  //   1,
  //   0.1,
  //   0.1,
  //   0.2,
  //   0.2,
  //   1
  // ];

  //   final List<dynamic> tprn2 = [
  //     "26d0bbc0-8598-4c21-a7d8-326a6815cd5a",
  //     "2024-07-29T04:15:38.000Z",
  //     "2024-08-16T03:09:18.000Z",
  //     "c01cad2f-b6a9-40c4-a50f-26a82ebdb1e1",
  //     "57d88de1-7160-41e3-827c-cf8da0b228b9",
  //     1,
  //     1,
  //     1,
  //     1,
  //     1,
  //     1,
  //     1,
  //     1
  //   ];

  //   await GetIt.instance<AppDatabase>().upsertToprn(tprn2);
  // }
  // --------------------------------------------------------------

  Future<void> _checkCoupons(BuildContext context, String couponCode) async {
    final coupon = await GetIt.instance<AppDatabase>().promoCouponHeaderDao.checkCoupons(couponCode);
    final DateTime now = DateTime.now();
    final TimeOfDay currentTime = TimeOfDay.fromDateTime(now);

    log("currentTime = $currentTime");

    if (coupon == null) {
      if (context.mounted) {
        SnackBarHelper.presentErrorSnackBar(context, "Coupon not found");
      }
    } else {
      final TimeOfDay couponStartTime = TimeOfDay.fromDateTime(coupon.startTime.toUtc());
      final TimeOfDay couponEndTime = TimeOfDay.fromDateTime(coupon.endTime.toUtc());

      if (couponList.any((c) => c.couponCode == couponCode)) {
        if (context.mounted) {
          SnackBarHelper.presentErrorSnackBar(context, "Coupon's already applied");
        }
        return;
      }
      if (coupon.startDate.isBefore(now) &&
          coupon.endDate.isAfter(now) &&
          Helpers.isTimeWithinRange(currentTime, couponStartTime, couponEndTime)) {
        setState(() {
          couponList.add(coupon);
        });
        if (context.mounted) {
          SnackBarHelper.presentSuccessSnackBar(context, "Coupon applied", 3);
        }
      } else {
        if (context.mounted) {
          SnackBarHelper.presentErrorSnackBar(context, "Coupon expired");
        }
      }
    }
  }

  Future<void> _saveCoupons(List<PromoCouponHeaderEntity> couponsList) async {
    await context.read<ReceiptCubit>().updateCoupons(couponsList);
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
                if (isDiscount) {
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
                }
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
                              discountHeaderWidget(childContext),
                              promoCouponWidget(childContext),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                FocusScope.of(context).unfocus();
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
                            : () async {
                                await _saveCoupons(couponList);
                                if (context.mounted) {
                                  final receiptCubit = context.read<ReceiptCubit>().state;
                                  log("receiptCubit - $receiptCubit");
                                  context.pop();
                                }
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
          onFieldSubmitted: isDiscount
              ? (value) async {
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
                }
              : null,
          autofocus: true,
          inputFormatters: [MoneyInputFormatter()],
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
    );
  }

  Widget promoCouponWidget(BuildContext context) {
    // final receiptCubit = context.read<ReceiptCubit>().state;
    // log("receieptCubit - $receiptCubit");

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextFormField(
              focusNode: _couponFocusNode,
              textInputAction: TextInputAction.search,
              controller: _textEditorCouponController,
              onFieldSubmitted: (value) async {
                await _checkCoupons(context, value);
              },
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
            const SizedBox(height: 10),
            const Text(
              "Coupons Applied:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.height * 0.5,
                height: MediaQuery.of(context).size.height * 0.3,
                child: couponList.isNotEmpty
                    ? ListView.builder(
                        itemCount: couponList.length,
                        itemBuilder: (context, index) {
                          final coupon = couponList[index];
                          return Container(
                            width: double.infinity,
                            height: 30,
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: Center(
                              child: SelectableText(
                                coupon.couponCode,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: ProjectColors.mediumBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            OutlinedButton(
              focusNode: FocusNode(skipTraversal: true),
              style: OutlinedButton.styleFrom(
                backgroundColor: ProjectColors.primary,
                padding: const EdgeInsets.all(10),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await _checkCoupons(context, _textEditorCouponController.text);
                _textEditorCouponController.text = "";
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Check Coupon",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
    );
  }
}
