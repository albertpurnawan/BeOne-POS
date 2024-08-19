import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';

class InputCouponsDialog extends StatefulWidget {
  const InputCouponsDialog({super.key});

  @override
  State<InputCouponsDialog> createState() => _InputCouponsDialogState();
}

class _InputCouponsDialogState extends State<InputCouponsDialog> {
  final TextEditingController _textEditorCouponController = TextEditingController();
  final FocusNode _couponFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  List<PromoCouponHeaderEntity> couponList = [];

  @override
  void initState() {
    super.initState();
    _couponFocusNode.requestFocus();
    if (context.read<ReceiptCubit>().state.coupons != null) {
      couponList = context.read<ReceiptCubit>().state.coupons!;
    }
  }

  @override
  void dispose() {
    _textEditorCouponController.dispose();
    _couponFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

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
                // apply key enter
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
                          'Coupon',
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
                        onPressed: null,
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
                        const SizedBox(height: 20),
                        promoCouponWidget(childContext),
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
                        onPressed: () async {
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

  Widget promoCouponWidget(BuildContext context) {
    // final receiptCubit = context.read<ReceiptCubit>().state;
    // log("receieptCubit - $receiptCubit");

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
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
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    hintText: "Enter Coupon Code",
                    hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(
                      Icons.confirmation_number_outlined,
                      size: 24,
                    ),
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      width: 80,
                      height: 60,
                      child: OutlinedButton(
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
                                    text: "Check",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ],
                                style: TextStyle(height: 1, fontSize: 10),
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            "Coupons Applied",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
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
        ],
      ),
    );
  }
}
