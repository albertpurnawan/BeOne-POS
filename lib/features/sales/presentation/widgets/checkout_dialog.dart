import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/netzme_service.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/netzme_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/presentation/cubit/mop_selections_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirm_reset_vouchers_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/promotion_summary_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/qris_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/voucher_redeem_dialog.dart';

final List<MopType> mopTypes = [
  MopType(name: "Tunai", payTypeCodes: ["1"]),
  MopType(name: "E-Wallet", payTypeCodes: ["5"]),
  MopType(name: "Debit", payTypeCodes: ["2"]),
  MopType(name: "Kredit", payTypeCodes: ["3"]),
  MopType(name: "Voucher", payTypeCodes: ["6"]),
  MopType(name: "Lainnya", payTypeCodes: ["4"])
];

class MopType {
  final String name;
  final List<String> payTypeCodes;

  MopType({required this.name, required this.payTypeCodes});
}

class CheckoutDialog extends StatefulWidget {
  final bool? isCharged;
  const CheckoutDialog({super.key, this.isCharged});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  bool isPrinting = false;
  bool isCharged = false;
  bool isPaymentSufficient = true;
  bool isLoadingQRIS = false;
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  String generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  void showQRISDialog(
      BuildContext context, NetzMeEntity data, String accessToken) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return QRISDialog(
          data: data,
          accessToken: accessToken,
          onPaymentSuccess: (String status) async {
            if (status == 'paid') {
              await context.read<ReceiptCubit>().charge();

              await Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (context) {
                      return const CheckoutDialog(
                        isCharged: true,
                      );
                    });
              });
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    isCharged = widget.isCharged ?? false;
  }

  Future<void> charge() async {
    try {
      final ReceiptEntity state = context.read<ReceiptCubit>().state;
      if ((state.totalPayment ?? 0) < state.grandTotal) {
        // context.pop(false);
        setState(() {
          isPaymentSufficient = false;
        });
        Future.delayed(const Duration(milliseconds: 2000),
            () => setState(() => isPaymentSufficient = true));
        return;
      }

      // Edit to QRIS here
      final mopSelected = context.read<ReceiptCubit>().state.mopSelection;
      final grandTotal = Helpers.revertMoneyToString(
          context.read<ReceiptCubit>().state.grandTotal);
      final invoiceDocNum = context.read<ReceiptCubit>().state.docNum;

      if (mopSelected!.payTypeCode == '5') {
        setState(() {
          isLoadingQRIS = true;
        });
        final netzme = await GetIt.instance<AppDatabase>().netzmeDao.readAll();
        final url = netzme[0].url;
        final clientKey = netzme[0].clientKey;
        final clientSecret = netzme[0].clientSecret;
        final privateKey = netzme[0].privateKey;

        final signature = await GetIt.instance<NetzmeApi>()
            .createSignature(url, clientKey, privateKey);

        final accessToken = await GetIt.instance<NetzmeApi>()
            .requestAccessToken(url, clientKey, privateKey, signature);

        final bodyDetail = {
          "custIdMerchant": netzme[0].custIdMerchant, // constant
          "partnerReferenceNo": invoiceDocNum +
              generateRandomString(5), // invoice docnum + channel
          "amount": {
            "value": grandTotal,
            "currency": "IDR"
          }, // value grandtotal idr
          "amountDetail": {
            "basicAmount": {
              "value": grandTotal,
              "currency": "IDR"
            }, // total semua item
            "shippingAmount": {"value": "0", "currency": "IDR"}
          },
          "PayMethod": "QRIS", // constant
          "commissionPercentage": "0",
          "expireInSecond": "3600",
          "feeType": "on_buyer",
          "apiSource": "topup_deposit",
          "additionalInfo": {
            "email": "testabc@gmail.com",
            "notes": "desc",
            "description": "description",
            "phoneNumber": "+6285270427851",
            "imageUrl": "a",
            "fullname": "Tester 213@"
          }
        };
        final serviceSignature = await GetIt.instance<NetzmeApi>()
            .createSignatureService(url, clientKey, clientSecret, privateKey,
                accessToken, "api/v1.0/invoice/create-transaction", bodyDetail);

        final transactionQris = await GetIt.instance<NetzmeApi>()
            .createTransactionQRIS(url, clientKey, clientSecret, privateKey,
                serviceSignature, bodyDetail);
        // dev.log("transactionQris - $transactionQris");

        setState(() {
          isLoadingQRIS = false;
        });

        showQRISDialog(context, transactionQris, accessToken);
      } else {
        context.read<ReceiptCubit>().charge();
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            isCharged = true;
          });
        });
      }
    } catch (e, s) {
      dev.log(e.toString());
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> printDraftBill() async {
    try {
      setState(() {
        isPrinting = true;
      });
      await Future.delayed(Durations.extralong1, null);
      await GetIt.instance<PrintReceiptUseCase>().call(
          params: PrintReceiptUseCaseParams(
              isDraft: true,
              receiptEntity: context.read<ReceiptCubit>().state));
      setState(() {
        isPrinting = false;
      });
    } catch (e) {
      setState(() {
        isPrinting = false;
      });
      SnackBarHelper.presentFailSnackBar(context, "Failed to print draft bill");
    }
  }

  Future<void> showAppliedPromotions() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PromotionSummaryDialog(
              receiptEntity: context.read<ReceiptCubit>().state,
            ));

    _keyboardListenerFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, value) {
        if (value.runtimeType == KeyUpEvent) return KeyEventResult.handled;

        if (value.physicalKey == PhysicalKeyboardKey.f12 && !isCharged) {
          charge();
          return KeyEventResult.handled;
        } else if (value.physicalKey == PhysicalKeyboardKey.f12 && isCharged) {
          isCharged = false;
          Navigator.of(context).pop();
          context.read<ReceiptCubit>().resetReceipt();
          return KeyEventResult.handled;
        } else if (value.physicalKey == PhysicalKeyboardKey.escape &&
            !isCharged) {
          context.pop();
          return KeyEventResult.handled;
        } else if (value.physicalKey == PhysicalKeyboardKey.arrowDown &&
            node.hasPrimaryFocus) {
          node.nextFocus();
          return KeyEventResult.handled;
        } else if (value.physicalKey == PhysicalKeyboardKey.f10 && !isCharged) {
          showAppliedPromotions();
          return KeyEventResult.handled;
        } else if (value.physicalKey == PhysicalKeyboardKey.f11 && !isCharged) {
          printDraftBill();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      focusNode: _keyboardListenerFocusNode,
      child: AlertDialog(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Checkout',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              isCharged
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: () async => await showAppliedPromotions(),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.discount_outlined,
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
                                      text: "Applied Promotions",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: " (F10)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                  style: TextStyle(height: 1),
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OutlinedButton(
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: () async => await printDraftBill(),
                          child: isPrinting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator.adaptive())
                              : Row(
                                  children: [
                                    const Icon(
                                      Icons.print_outlined,
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
                                            text: "Print Draft Bill",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: " (F11)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                        style: TextStyle(height: 1),
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    )
            ],
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: isCharged
            ? const _CheckoutSuccessDialogContent()
            : const CheckoutDialogContent(),
        actions: isCharged
            ? [
                Column(
                  children: [
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: TextButton(
                    //       style: ButtonStyle(
                    //           shape: MaterialStatePropertyAll(
                    //               RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(5),
                    //                   side: const BorderSide(
                    //                       color: ProjectColors.primary))),
                    //           backgroundColor: MaterialStateColor.resolveWith(
                    //               (states) => Colors.white),
                    //           overlayColor: MaterialStateColor.resolveWith(
                    //               (states) => Colors.black.withOpacity(.2))),
                    //       onPressed: () {
                    //         // Navigator.of(context).pop();
                    //       },
                    //       child: const Center(
                    //           child: Text(
                    //         "Send Receipt",
                    //         style: TextStyle(color: ProjectColors.primary),
                    //       )),
                    //     )),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     Expanded(
                    //         child: TextButton(
                    //       style: ButtonStyle(
                    //           shape: MaterialStatePropertyAll(
                    //               RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(5),
                    //                   side: const BorderSide(
                    //                       color: ProjectColors.primary))),
                    //           backgroundColor: MaterialStateColor.resolveWith(
                    //               (states) => Colors.white),
                    //           overlayColor: MaterialStateColor.resolveWith(
                    //               (states) => Colors.black.withOpacity(.2))),
                    //       onPressed: () {
                    //         GetIt.instance<PrintReceiptUseCase>()
                    //             .call(params: context.read<ReceiptCubit>().state);
                    //         // Navigator.of(context).pop();
                    //       },
                    //       child: const Center(
                    //           child: Text(
                    //         "Print Receipt",
                    //         style: TextStyle(color: ProjectColors.primary),
                    //       )),
                    //     )),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => ProjectColors.primary),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white.withOpacity(.2))),
                      onPressed: () {
                        isCharged = false;
                        Navigator.of(context).pop();
                        context.read<ReceiptCubit>().resetReceipt();
                      },
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Done",
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
                    ),
                  ],
                )
              ]
            : <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(
                                      color: ProjectColors.primary))),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black.withOpacity(.2))),
                      onPressed: () async {
                        if (context
                            .read<ReceiptCubit>()
                            .state
                            .vouchers
                            .isNotEmpty) {
                          final bool? isProceed = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                const ConfirmResetVouchersDialog(),
                          );
                          if (isProceed == null) return;
                          if (!isProceed) return;
                        }
                        context.pop(false);
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
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      isPaymentSufficient
                          ? const SizedBox.shrink()
                          : const Text(
                              "Insufficient total payment",
                              style: TextStyle(
                                  color: ProjectColors.primary,
                                  fontWeight: FontWeight.w700),
                            ),
                      TextButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => ProjectColors.primary),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white.withOpacity(.2))),
                        onPressed:
                            isLoadingQRIS ? null : () async => await charge(),
                        child: Center(
                          child: isLoadingQRIS
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator.adaptive(
                                      // backgroundColor: Colors.white,
                                      ),
                                )
                              : RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Charge",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                        text: "  (F12)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                        ),
                      )
                    ])),
                  ],
                ),
              ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
}

class CheckoutDialogContent extends StatefulWidget {
  const CheckoutDialogContent({super.key});

  @override
  State<CheckoutDialogContent> createState() => _CheckoutDialogContentState();
}

class _CheckoutDialogContentState extends State<CheckoutDialogContent> {
  double chipCount = 0;
  String _value = "";
  int _cashAmount = 0;
  int _vouchersAmount = 0;
  bool voucherIsExceedPurchase = false;

  final List<MopSelectionEntity> _voucherMopSelections = [];
  final List<VouchersSelectionEntity> _vouchers = [];
  List<MopSelectionEntity> mopSelectionModels = [];
  final _textEditingControllerCashAmount = TextEditingController();
  final _focusNodeCashAmount = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;

      if (event.physicalKey == PhysicalKeyboardKey.arrowDown &&
          node.hasPrimaryFocus) {
        node.nextFocus();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    },
  );

  @override
  void initState() {
    super.initState();
    context.read<MopSelectionsCubit>().getMopSelections();
  }

  Widget _selectedMopChip(String mopName, num amount, int color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 0.5,
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.222),
          ),
        ],
        color: color == 1
            ? const Color.fromARGB(255, 11, 57, 84)
            // : const Color.fromARGB(255, 255, 102, 99),
            : const Color.fromARGB(255, 255, 149, 5),
      ),
      child: Row(
        children: [
          Text(
            mopName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              // color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            "Rp ${Helpers.parseMoney(amount)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              // color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerCashAmount.dispose();
    _focusNodeCashAmount.dispose();
  }

  List<MopSelectionEntity> getMopByPayTypeCode(String payTypeCode) {
    /**
     * 1 - Tunai
     * 2 - Debit
     * 3 - Kredit
     * 4 - Lainnya
     * 5 - E-Wallet
     * 6 - Voucher */
    final List<MopSelectionEntity> mopsByPayTypeCode = context
        .read<MopSelectionsCubit>()
        .state
        .where((element) => element.payTypeCode == payTypeCode)
        .toList();
    return mopsByPayTypeCode;
  }

  List<int> generateCashAmountSuggestions(int receiptTotalAmount) {
    List<int> cashAmountSuggestions = [receiptTotalAmount - _vouchersAmount];
    if (voucherIsExceedPurchase) {
      cashAmountSuggestions = [0];
    } else {
      final List<int> multipliers = [5000, 10000, 50000, 100000];

      for (final multiplier in multipliers) {
        if (cashAmountSuggestions.last % multiplier != 0) {
          cashAmountSuggestions.add((receiptTotalAmount - _vouchersAmount) +
              multiplier -
              ((receiptTotalAmount - _vouchersAmount) % multiplier));
        }
      }
    }
    return cashAmountSuggestions;
  }

  List<MopSelectionEntity> getMopByPayTypeCodes(List<String> payTypeCodes) {
    List<MopSelectionEntity> mops = [];
    for (final payTypeCode in payTypeCodes) {
      final List<MopSelectionEntity> temp = context
          .read<MopSelectionsCubit>()
          .state
          .where((element) => element.payTypeCode == payTypeCode)
          .toList();
      mops.addAll(temp);
    }
    return mops;
  }

  void updateReceiptMop() {
    final MopSelectionEntity mopSelectionEntity = context
        .read<MopSelectionsCubit>()
        .state
        .where((element) => element.tpmt3Id == _value)
        .first;
    context.read<ReceiptCubit>().updateMopSelection(
        mopSelectionEntity: mopSelectionEntity.copyWith(
            amount: context.read<ReceiptCubit>().state.grandTotal -
                (context.read<ReceiptCubit>().state.totalVoucher ?? 0)),
        amountReceived: mopSelectionEntity.payTypeCode == "1"
            ? _cashAmount.toDouble() +
                (context.read<ReceiptCubit>().state.totalVoucher ?? 0)
            : context.read<ReceiptCubit>().state.grandTotal);
  }

  void handleVouchersRedeemed(List<VouchersSelectionEntity> vouchers) {
    int totalVoucherAmount = 0;
    for (var voucher in vouchers) {
      totalVoucherAmount += voucher.voucherAmount;
    }

    setState(() {
      _vouchers.addAll(vouchers);
      _vouchersAmount += totalVoucherAmount;
    });
    context.read<ReceiptCubit>().updateVouchersSelection(
        vouchersSelectionEntity: _vouchers, vouchersAmount: _vouchersAmount);
    final receiptGrandTotal =
        context.read<ReceiptCubit>().state.grandTotal.toInt();
    final receiptTotalVouchers =
        context.read<ReceiptCubit>().state.totalVoucher;
    if (receiptTotalVouchers! >= receiptGrandTotal) {
      dev.log("receiptTotal - $receiptGrandTotal");
      dev.log("receiptTotalVouchers - $receiptTotalVouchers");
      setState(() {
        voucherIsExceedPurchase = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          fontFamily: 'Roboto',
          useMaterial3: true,
          chipTheme: const ChipThemeData(
              showCheckmark: true,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.transparent,
              selectedColor: ProjectColors.primary,
              labelStyle: TextStyle(color: ChipLabelColor(), fontSize: 18))),
      child: BlocBuilder<MopSelectionsCubit, List<MopSelectionEntity>>(
        builder: (context, state) {
          final ReceiptEntity receipt = context.read<ReceiptCubit>().state;

          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  // color: const Color.fromARGB(255, 86, 147, 99),
                  color: const Color.fromARGB(255, 231, 231, 231),

                  child: Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 60,
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "Grand Total",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal.toInt())}",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "Total Payment",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Rp ${Helpers.parseMoney(receipt.totalPayment ?? 0)}",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  // color: const Color.fromARGB(255, 58, 104, 68),
                  color: const Color.fromARGB(255, 223, 223, 223),
                  child: Row(
                    children: [
                      const Text(
                        "Selected MOP",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      if (receipt.mopSelection == null &&
                          receipt.vouchers.isEmpty)
                        const Text(
                          "Not set",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      Wrap(
                        spacing: 15,
                        children: [
                          receipt.mopSelection != null
                              ? _selectedMopChip(
                                  receipt.mopSelection!.mopAlias,
                                  (receipt.totalPayment ?? 0) -
                                      (receipt.totalVoucher ?? 0),
                                  1)
                              : const SizedBox.shrink(),
                          receipt.vouchers.isNotEmpty
                              ? _selectedMopChip(
                                  "Voucher", receipt.totalVoucher!, 2)
                              : const SizedBox.shrink()
                        ],
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      receipt.grandTotal -
                                  _vouchersAmount -
                                  (receipt.mopSelection?.amount ?? 0) >
                              0.5
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber,
                                  size: 16,
                                  // color: Color.fromARGB(255, 253, 185, 148),
                                  color: ProjectColors.swatch,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Due  Rp ${Helpers.parseMoney((context.read<ReceiptCubit>().state.grandTotal.toInt()) - (receipt.totalVoucher ?? 0) - (receipt.totalNonVoucher ?? 0))}",
                                  style: const TextStyle(
                                      // color: Color.fromARGB(255, 253, 185, 148),
                                      color: ProjectColors.swatch,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: FocusTraversalGroup(
                            policy: ReadingOrderTraversalPolicy(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<Widget>.generate(
                                mopTypes.length,
                                (int index) {
                                  final mopType = mopTypes[index];
                                  final List<MopSelectionEntity> mopsByType =
                                      getMopByPayTypeCodes(
                                          mopType.payTypeCodes);

                                  if (mopsByType.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  // [START] UI for TUNAI MOP
                                  if (mopType.payTypeCodes[0] == "1") {
                                    final List<int> cashAmountSuggestions =
                                        generateCashAmountSuggestions(context
                                            .read<ReceiptCubit>()
                                            .state
                                            .grandTotal
                                            .toInt());

                                    return SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mopType.name,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            // height: 60,
                                            // width: 400,
                                            child: TextField(
                                              onSubmitted: (value) =>
                                                  _focusNodeCashAmount
                                                      .requestFocus(),
                                              focusNode: _focusNodeCashAmount,
                                              onTapOutside: (event) =>
                                                  _focusNodeCashAmount
                                                      .unfocus(),
                                              controller:
                                                  _textEditingControllerCashAmount,
                                              onTap: () {
                                                _value = mopsByType[0].tpmt3Id;
                                                updateReceiptMop();
                                              },
                                              onChanged: (value) =>
                                                  setState(() {
                                                _value = mopsByType[0].tpmt3Id;

                                                _cashAmount = Helpers
                                                        .revertMoneyToDecimalFormat(
                                                            value)
                                                    .toInt();
                                                updateReceiptMop();
                                              }),
                                              inputFormatters: [
                                                MoneyInputFormatter()
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 24),
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  hintText: "Cash Amount",
                                                  hintStyle: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 24),
                                                  border: OutlineInputBorder(),
                                                  prefixIcon: Icon(
                                                    Icons.payments_outlined,
                                                    size: 24,
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: List<Widget>.generate(
                                              cashAmountSuggestions.length,
                                              (int index) {
                                                return ChoiceChip(
                                                  side: const BorderSide(
                                                      color:
                                                          ProjectColors.primary,
                                                      width: 1.5),
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  label: Text(
                                                      Helpers.parseMoney(
                                                          cashAmountSuggestions[
                                                              index])),
                                                  selected: _value ==
                                                          mopsByType[0]
                                                              .tpmt3Id &&
                                                      _cashAmount ==
                                                          cashAmountSuggestions[
                                                              index],
                                                  onSelected: (bool selected) {
                                                    setState(() {
                                                      _value =
                                                          mopsByType[0].tpmt3Id;
                                                      _cashAmount =
                                                          cashAmountSuggestions[
                                                              index];
                                                      _textEditingControllerCashAmount
                                                              .text =
                                                          Helpers.parseMoney(
                                                              cashAmountSuggestions[
                                                                  index]);
                                                      updateReceiptMop();
                                                    });
                                                  },
                                                );
                                              },
                                            ).toList(),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  // [END] UI for TUNAI MOP

                                  // [START] UI for other MOPs
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mopType.name,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: List<Widget>.generate(
                                            mopsByType.length,
                                            (int index) {
                                              final mop = mopsByType[index];
                                              return ChoiceChip(
                                                side: const BorderSide(
                                                    color:
                                                        ProjectColors.primary,
                                                    width: 1.5),
                                                padding:
                                                    const EdgeInsets.all(20),
                                                label: Text(
                                                  mop.mopAlias,
                                                ),
                                                // CONDITIONAL FOR SET SELECTED
                                                selected: mopType
                                                            .payTypeCodes[0] ==
                                                        "6"
                                                    ? receipt.vouchers
                                                        .map((e) => e.tpmt3Id)
                                                        .contains(mop.tpmt3Id)
                                                    : _value == mop.tpmt3Id,
                                                onSelected:
                                                    (bool selected) async {
                                                  // VOUCHERS DIALOG HERE
                                                  if (mopType.payTypeCodes[0] ==
                                                      "6") {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors.white,
                                                          surfaceTintColor:
                                                              Colors
                                                                  .transparent,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5.0))),
                                                          title: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  ProjectColors
                                                                      .primary,
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              5.0)),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    25,
                                                                    10,
                                                                    25,
                                                                    10),
                                                            child: const Text(
                                                              'Redeem Voucher',
                                                              style: TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          titlePadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          content: SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.5,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.6,
                                                            child:
                                                                VoucherCheckout(
                                                              onVouchersRedeemed:
                                                                  handleVouchersRedeemed,
                                                              tpmt3Id:
                                                                  mop.tpmt3Id,
                                                              voucherType:
                                                                  mop.subType,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    setState(() {
                                                      _voucherMopSelections
                                                          .add(mop);
                                                      _value = selected
                                                          ? mop.tpmt3Id
                                                          : "";
                                                      _cashAmount = 0;
                                                      _textEditingControllerCashAmount
                                                          .text = "";
                                                      context
                                                          .read<ReceiptCubit>()
                                                          .resetMop();
                                                    });
                                                    return;
                                                  }
                                                  setState(() {
                                                    _value = selected
                                                        ? mop.tpmt3Id
                                                        : "";
                                                    _cashAmount = 0;
                                                    _textEditingControllerCashAmount
                                                        .text = "";
                                                    updateReceiptMop();
                                                  });
                                                },
                                              );
                                            },
                                          ).toList(),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                  );
                                  // [END] UI for other MOPs
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChipLabelColor extends Color implements MaterialStateColor {
  const ChipLabelColor() : super(_default);

  static const int _default = 0xFF000000;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.white; // Selected text color
    }
    return ProjectColors.primary; // normal text color
  }
}

class _CheckoutSuccessDialogContent extends StatefulWidget {
  const _CheckoutSuccessDialogContent();

  @override
  State<_CheckoutSuccessDialogContent> createState() =>
      __CheckoutSuccessDialogContentState();
}

class __CheckoutSuccessDialogContentState
    extends State<_CheckoutSuccessDialogContent> {
  @override
  Widget build(BuildContext context) {
    dev.log("CHECKOUT STATE - ${context.read<ReceiptCubit>().state}");
    return Theme(
        data: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            fontFamily: 'Roboto',
            useMaterial3: true,
            chipTheme: const ChipThemeData(
                showCheckmark: true,
                checkmarkColor: Colors.white,
                backgroundColor: Colors.transparent,
                selectedColor: ProjectColors.primary,
                labelStyle: TextStyle(color: ChipLabelColor(), fontSize: 18))),
        child: SingleChildScrollView(
          child: SizedBox(
            // width: MediaQuery.of(context).size.width * 0.7,
            width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  width: double.infinity,
                  color: const Color.fromARGB(255, 134, 1, 1),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 0.5,
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.097),
                              ),
                            ],
                            color: const Color.fromARGB(255, 47, 143, 8),
                          ),
                          child: const Text(
                            "Transaction Success",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/icon-success.svg",
                              height: 42,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal.toInt())}",
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 52,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          context.read<ReceiptCubit>().state.transDateTime !=
                                  null
                              ? DateFormat("EEE, dd MMM yyyy - hh:mm aaa")
                                  .format(context
                                      .read<ReceiptCubit>()
                                      .state
                                      .transDateTime!)
                              : "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    width: double.infinity,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Divider()
                      ],
                    )),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    width: double.infinity,
                    child: Table(columnWidths: const {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(4),
                    }, children: [
                      TableRow(
                        children: [
                          const Text(
                            "Invoice Number",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            context.read<ReceiptCubit>().state.docNum,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text(
                            "Payment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            context
                                .read<ReceiptCubit>()
                                .state
                                .mopSelection!
                                .mopAlias,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text(
                            "Total Bill",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal.toInt())}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      if (context
                          .read<ReceiptCubit>()
                          .state
                          .vouchers
                          .isNotEmpty)
                        TableRow(
                          children: [
                            const Text(
                              "Vouchers",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.totalVoucher!.toInt())}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      TableRow(
                        children: [
                          const Text(
                            "Received",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.totalPayment!.toInt())}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            context.read<ReceiptCubit>().state.changed != null
                                ? "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.changed!.round())}"
                                : "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ])),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }
}
