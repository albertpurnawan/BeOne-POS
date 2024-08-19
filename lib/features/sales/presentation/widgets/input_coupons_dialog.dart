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
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promo_toprn_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_toprn_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
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
    if (context.read<ReceiptCubit>().state.coupons.isNotEmpty) {
      couponList = context.read<ReceiptCubit>().state.coupons;
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
    try {
      final GetPromoToprnHeaderAndDetailUseCaseResult couponHeaderAndDetail =
          await GetIt.instance<GetPromoToprnHeaderAndDetailUseCase>().call(params: couponCode);
      final CheckPromoToprnApplicabilityUseCaseResult checkCouponResult =
          await GetIt.instance<CheckPromoToprnApplicabilityUseCase>().call(
              params: CheckPromoToprnApplicabilityUseCaseParams(
                  toprnHeaderAndDetail: couponHeaderAndDetail,
                  handlePromosUseCaseParams:
                      HandlePromosUseCaseParams(receiptEntity: context.read<ReceiptCubit>().state)));

      if (checkCouponResult.isApplicable == false) throw checkCouponResult.failMsg;

      _saveCoupons(context.read<ReceiptCubit>().state.coupons + [couponHeaderAndDetail.toprn]);
      setState(() {});
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
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

  List<Widget> _buildCouponRows(
    List<PromoCouponHeaderEntity> coupons,
  ) {
    return coupons.asMap().entries.map((entry) {
      int index = entry.key;
      PromoCouponHeaderEntity coupon = entry.value;

      return SizedBox(
        width: double.infinity,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: Text(
                  coupon.couponCode,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${Helpers.cleanDecimal(coupon.generalDisc, 1)}%",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      Helpers.parseMoney(coupon.maxGeneralDisc),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
        ]),
      );
    }).toList();
  }

  Widget promoCouponWidget(BuildContext context) {
    // final receiptCubit = context.read<ReceiptCubit>().state;
    // log("receieptCubit - $receiptCubit");

    return BlocBuilder<ReceiptCubit, ReceiptEntity>(
      builder: (context, state) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                                        text: "Apply",
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
              if (state.coupons.isNotEmpty)
                const SizedBox(
                  width: double.infinity,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            "No",
                            style:
                                TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ProjectColors.lightBlack),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Coupon Code",
                            style:
                                TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ProjectColors.lightBlack),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "% Disc.",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700, color: ProjectColors.lightBlack),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Max Disc.",
                              style:
                                  TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ProjectColors.lightBlack),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ]),
                ),
              if (state.coupons.isNotEmpty)
                const SizedBox(
                  height: 7,
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.coupons.isEmpty)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: const EmptyList(
                                imagePath: "assets/images/empty-search.svg",
                                sentence: "Tadaa.. There is nothing here!\nInput a coupon code to start."),
                          ),
                        ..._buildCouponRows(state.coupons)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
