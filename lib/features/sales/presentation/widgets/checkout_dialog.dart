// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import 'package:pos_fe/core/widgets/progress_indicator.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/netzme_service.dart';
import 'package:pos_fe/features/sales/domain/entities/currency.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/netzme_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/payment_type.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/mop_selection_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/presentation/cubit/mop_selections_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/approval_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirm_reset_vouchers_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/edc_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/input_discount_manual.dart';
import 'package:pos_fe/features/sales/presentation/widgets/input_mop_amount.dart';
import 'package:pos_fe/features/sales/presentation/widgets/promotion_summary_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/qris_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/voucher_redeem_dialog.dart';

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
  bool isCharging = false;
  bool isMultiMOPs = true;
  List<PaymentTypeEntity> paymentType = [];
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  String generateRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  void showQRISDialog(BuildContext context, NetzMeEntity data, String accessToken) {
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

  Future<void> charge() async {
    try {
      setState(() {
        isCharging = true;
      });
      final ReceiptEntity state = context.read<ReceiptCubit>().state;

      // Validate total payment must be greater than grand total
      if ((state.totalPayment ?? 0) < state.grandTotal) {
        setState(() {
          isPaymentSufficient = false;
          isCharging = false;
        });
        Future.delayed(const Duration(milliseconds: 2000), () => setState(() => isPaymentSufficient = true));
        return;
      }

      // Trigger approval when grand total is 0
      if (state.grandTotal == 0) {
        final bool? isAuthorized = await showDialog<bool>(
            context: context, barrierDismissible: false, builder: (context) => const ApprovalDialog());
        if (isAuthorized != true) return;
      }

      // Edit to QRIS here
      final selectedMOPs = state.mopSelections;
      // final grandTotal = Helpers.revertMoneyToString(state.grandTotal);
      final invoiceDocNum = state.docNum;

      final List<MopSelectionEntity> qrisMop = selectedMOPs.where((element) => element.payTypeCode == '5').toList();
      if (qrisMop.isNotEmpty) {
        setState(() {
          isLoadingQRIS = true;
        });
        final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
        final tostr = await GetIt.instance<AppDatabase>().storeMasterDao.readByDocId(topos[0].tostrId!, null);
        if (tostr == null) {
          throw Exception("Store data not found.");
        }
        final url = tostr.netzmeUrl;
        final clientKey = tostr.netzmeClientKey;
        final clientSecret = tostr.netzmeClientSecret;
        final privateKey = tostr.netzmeClientPrivateKey;
        final channelId = tostr.netzmeChannelId;

        if (url == null || clientKey == null || clientSecret == null || privateKey == null || channelId == null) {
          setState(() {
            isLoadingQRIS = false;
            isCharging = false;
          });
          throw Exception("Missing required Netzme data. Please check Store data.");
        }

        final signature = await GetIt.instance<NetzmeApi>().createSignature(url, clientKey, privateKey);

        final accessToken = await GetIt.instance<NetzmeApi>().requestAccessToken(url, clientKey, privateKey, signature);

        final bodyDetail = {
          "custIdMerchant": tostr.netzmeCustidMerchant,
          "partnerReferenceNo": invoiceDocNum + tostr.otpChannel! + generateRandomString(5),
          "amount": {
            "value": Helpers.revertMoneyToString(qrisMop.first.amount!),
            "currency": "IDR"
          }, // value grandtotal idr
          "amountDetail": {
            "basicAmount": {
              "value": Helpers.revertMoneyToString(qrisMop.first.amount!),
              "currency": "IDR"
            }, // total semua item
            "shippingAmount": {"value": "0", "currency": "IDR"}
          },
          "PayMethod": "QRIS", // constant
          "commissionPercentage": "0",
          "expireInSecond": "3600",
          "feeType": "on_seller",
          "apiSource": "topup_deposit",
          "additionalInfo": {
            "email": "testabc@gmail.com", // diambil dari customer kalau member
            "notes": "desc",
            "description": "description",
            "phoneNumber": "+6285270427851", // diambil dari customer kalau member
            "imageUrl": "a",
            "fullname": "Tester 213@" // diambil dari customer kalau member
          }
        };
        final serviceSignature = await GetIt.instance<NetzmeApi>().createSignatureService(
            url, clientKey, clientSecret, privateKey, accessToken, "api/v1.0/invoice/create-transaction", bodyDetail);

        final transactionQris = await GetIt.instance<NetzmeApi>().createTransactionQRIS(
          url,
          clientKey,
          clientSecret,
          privateKey,
          serviceSignature,
          channelId,
          bodyDetail,
        );
        // dev.log("transactionQris - $transactionQris");

        setState(() {
          isLoadingQRIS = false;
        });

        showQRISDialog(context, transactionQris, accessToken);
      } else {
        await context.read<ReceiptCubit>().charge();
        await Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            isCharged = true;
          });
        });
      }
      setState(() {
        isCharging = false;
      });
    } catch (e) {
      SnackBarHelper.presentFailSnackBar(context, e.toString());
      return;
    }
  }

  Future<void> printDraftBill() async {
    try {
      setState(() {
        isPrinting = true;
      });
      await Future.delayed(Durations.extralong1, null);
      await GetIt.instance<PrintReceiptUseCase>()
          .call(params: PrintReceiptUseCaseParams(printType: 2, receiptEntity: context.read<ReceiptCubit>().state));
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

  Future<void> applyHeaderDiscount(BuildContext childContext) async {
    try {
      final ReceiptItemEntity? dpItem =
          context.read<ReceiptCubit>().state.receiptItems.where((e) => e.itemEntity.barcode == "99").firstOrNull;
      if (dpItem != null && dpItem.quantity > 0) {
        throw "Header discount cannot be applied on down payment deposit";
      }

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => InputDiscountManual(docnum: context.read<ReceiptCubit>().state.docNum)).then((value) {
        if (value != null) {
          SnackBarHelper.presentSuccessSnackBar(
              childContext, "Header discount applied: ${Helpers.parseMoney(value)}", 3);
        }
      });
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  Future<void> toggleMultiMOPs() async {
    setState(() {
      isMultiMOPs = !isMultiMOPs;
    });
  }

  @override
  void initState() {
    super.initState();
    isCharged = widget.isCharged ?? false;
  }

  @override
  void dispose() {
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (childContext) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: FocusScope(
          // skipTraversal: true,
          onKeyEvent: (node, event) {
            if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;

            if (event.physicalKey == PhysicalKeyboardKey.f12 && !isCharged) {
              charge();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f12 && isCharged) {
              isCharged = false;
              Navigator.of(context).pop();
              context.read<ReceiptCubit>().resetReceipt();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.escape && !isCharged) {
              context.pop();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown && node.hasPrimaryFocus) {
              node.nextFocus();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f6 && !isCharged) {
              applyHeaderDiscount(childContext);
            } else if (event.physicalKey == PhysicalKeyboardKey.f7 && !isCharged) {
              showAppliedPromotions().then((value) => _focusScopeNode.requestFocus());
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f8 && !isCharged) {
              printDraftBill();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f9 && !isCharged) {
              toggleMultiMOPs();
              return KeyEventResult.handled;
            }

            return KeyEventResult.ignored;
          },
          node: _focusScopeNode,
          autofocus: true,
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: ExcludeFocusTraversal(
              child: Container(
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
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () async => await applyHeaderDiscount(childContext),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.cut,
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
                                            text: "Discount &\nRounding",
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: " (F6)",
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
                              const SizedBox(
                                width: 10,
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
                                            text: "Applied\nPromos",
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: " (F7)",
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () async => await printDraftBill(),
                                child: isPrinting
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator.adaptive())
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
                                                  text: "Print Pending\nOrder",
                                                  style: TextStyle(fontWeight: FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text: " (F8)",
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
                              const SizedBox(
                                width: 30,
                              ),
                              Row(
                                children: [
                                  Switch(
                                      thumbIcon: MaterialStatePropertyAll(Icon(
                                        isMultiMOPs ? Icons.check : Icons.close,
                                        color: isMultiMOPs ? ProjectColors.green : ProjectColors.lightBlack,
                                      )),
                                      trackOutlineWidth: const MaterialStatePropertyAll(0),
                                      value: isMultiMOPs,
                                      onChanged: (value) => setState(() {
                                            isMultiMOPs = value;
                                          })),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: isMultiMOPs ? "Multi MOPs ON" : "Multi MOPs OFF",
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const TextSpan(
                                          text: " (F9)",
                                          style: TextStyle(fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                      style: const TextStyle(height: 1, fontSize: 12),
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              )
                            ],
                          )
                  ],
                ),
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.all(0),
            content: isCharged
                ? const _CheckoutSuccessDialogContent()
                : isCharging
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: progressDialog,
                      )
                    : CheckoutDialogContent(
                        isMultiMOPs: isMultiMOPs,
                      ),
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
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                              backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                              overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
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
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(color: ProjectColors.primary))),
                              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                              overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
                          onPressed: isCharging
                              ? null
                              : () async {
                                  if (context.read<ReceiptCubit>().state.vouchers.isNotEmpty) {
                                    final bool? isProceed = await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const ConfirmResetVouchersDialog(),
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
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                          isPaymentSufficient
                              ? const SizedBox.shrink()
                              : const Text(
                                  "Insufficient total payment",
                                  style: TextStyle(color: ProjectColors.primary, fontWeight: FontWeight.w700),
                                ),
                          TextButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                            onPressed: isCharging
                                ? null
                                : isLoadingQRIS
                                    ? null
                                    : () async => await charge(),
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
                                            text: "Paid",
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
                          )
                        ])),
                      ],
                    ),
                  ],
            actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
        ),
      );
    });
  }
}

class CheckoutDialogContent extends StatefulWidget {
  const CheckoutDialogContent({
    Key? key,
    required this.isMultiMOPs,
  }) : super(key: key);
  final bool isMultiMOPs;

  @override
  State<CheckoutDialogContent> createState() => _CheckoutDialogContentState();
}

class _CheckoutDialogContentState extends State<CheckoutDialogContent> {
  double chipCount = 0;
  List<MopSelectionEntity> _values = [];
  int _vouchersAmount = 0;
  bool voucherIsExceedPurchase = false;
  List<PaymentTypeEntity> paymentTypes = [];
  bool isZeroGrandTotal = false;
  List<Widget> selectedVoucherChips = [];

  final List<VouchersSelectionEntity> _vouchers = [];
  final _textEditingControllerCashAmount = TextEditingController();
  final _focusNodeCashAmount = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;

      if (event.physicalKey == PhysicalKeyboardKey.arrowDown && node.hasPrimaryFocus) {
        node.nextFocus();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    },
  );

  String currencyName = "";

  @override
  void initState() {
    super.initState();
    context.read<MopSelectionsCubit>().getMopSelections();
    getPaymentTypes();
    // getCurrencyName();
    checkAndHandleZeroGrandTotal();
    refreshQRISChip();
  }

  void getCurrencyName() async {
    try {
      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) return;
      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>().call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) return;
      if (storeMasterEntity.tcurrId == null) return;
      final CurrencyEntity? currencyEntity =
          await GetIt.instance<AppDatabase>().currencyDao.readByDocId(storeMasterEntity.tcurrId!, null);
      if (currencyEntity == null) return;

      setState(() {
        currencyName = "${currencyEntity.curCode} ";
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Widget _selectedMopChip(MopSelectionEntity mop, int color, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (mop.tpmt2Id != null) ? "${mop.mopAlias} - ${mop.cardName}" : mop.mopAlias,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              // color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            "$currencyName${Helpers.parseMoney(mop.amount ?? 0)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              // color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: !isZeroGrandTotal
                ? () {
                    setState(() {
                      _values.removeAt(index);
                      if (mop.payTypeCode == "1") {
                        _textEditingControllerCashAmount.text = "";
                      }
                    });

                    updateReceiptMop();
                  }
                : null,
            child: const Icon(
              Icons.close,
              size: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshQRISChip() async {
    final mopState = context.read<ReceiptCubit>().state.mopSelections;
    final filteredMopState = mopState.where((mop) => mop.payTypeCode == "1").toList();

    if (mopState.isEmpty) return;
    if (filteredMopState.isEmpty) {
      setState(() {
        _values = context.read<ReceiptCubit>().state.mopSelections;
      });
    } else {
      setState(() {
        _values = context.read<ReceiptCubit>().state.mopSelections;
        _textEditingControllerCashAmount.text = Helpers.parseMoney(filteredMopState[0].amount!.toInt());
      });
    }
  }

  Future<void> _refreshVouchersChips(List<VouchersSelectionEntity> vouchers, int color) async {
    final Map<String, num> amountByTpmt3Ids = {};
    final List<Widget> result = [];

    for (final voucher in vouchers) {
      if (amountByTpmt3Ids[voucher.tpmt3Id] == null) {
        amountByTpmt3Ids[voucher.tpmt3Id!] = voucher.voucherAmount;
      } else {
        amountByTpmt3Ids[voucher.tpmt3Id!] = amountByTpmt3Ids[voucher.tpmt3Id!]! + voucher.voucherAmount;
      }
    }

    for (final tpmt3Id in amountByTpmt3Ids.keys) {
      final MopSelectionEntity? mopSelectionEntity =
          await GetIt.instance<MopSelectionRepository>().getMopSelectionByTpmt3Id(tpmt3Id);
      result.add(Container(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mopSelectionEntity?.mopAlias ?? "Unknown Voucher",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                // color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              "$currencyName${Helpers.parseMoney(amountByTpmt3Ids[tpmt3Id]!)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                // color: Colors.black,
              ),
            ),
          ],
        ),
      ));
    }

    setState(() {
      selectedVoucherChips = result;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerCashAmount.dispose();
    _focusNodeCashAmount.dispose();
  }

  List<int> generateCashAmountSuggestions(int targetAmount) {
    List<int> cashAmountSuggestions = [targetAmount];
    if (voucherIsExceedPurchase) {
      cashAmountSuggestions = [0];
    } else {
      final List<int> multipliers = [5000, 10000, 50000, 100000];

      for (final multiplier in multipliers) {
        if (cashAmountSuggestions.last % multiplier != 0) {
          cashAmountSuggestions.add(targetAmount + multiplier - (targetAmount % multiplier));
        }
      }
    }
    return cashAmountSuggestions;
  }

  List<MopSelectionEntity> getMopByPayTypeCode(String payTypeCode) {
    /**
     * 1 - Tunai
     * 2 - EDC
     * 3 - Others
     * 4 - QRIS
     * 5 - Voucher
    */

    List<MopSelectionEntity> mops = [];

    final List<MopSelectionEntity> temp =
        context.read<MopSelectionsCubit>().state.where((element) => element.payTypeCode == payTypeCode).toList();
    mops.addAll(temp);

    return mops;
  }

  Future<void> getPaymentTypes() async {
    final List<PaymentTypeEntity> paymentTypeEntities = await GetIt.instance<AppDatabase>().paymentTypeDao.readAll();
    setState(() {
      paymentTypes = paymentTypeEntities;
    });
    return;
  }

  void updateReceiptMop() {
    context.read<ReceiptCubit>().updateMopSelection(mopSelectionEntities: _values.map((e) => e.copyWith()).toList());
  }

  void handleVouchersRedeemed(List<VouchersSelectionEntity> vouchers) async {
    int totalVoucherAmount = 0;
    for (var voucher in vouchers) {
      totalVoucherAmount += voucher.voucherAmount;
    }

    setState(() {
      _vouchers.addAll(vouchers);
      _vouchersAmount += totalVoucherAmount;
    });
    context
        .read<ReceiptCubit>()
        .updateVouchersSelection(vouchersSelectionEntity: _vouchers, vouchersAmount: _vouchersAmount);
    final receiptGrandTotal = context.read<ReceiptCubit>().state.grandTotal;
    final receiptTotalVouchers = context.read<ReceiptCubit>().state.totalVoucher;
    if (receiptTotalVouchers! >= receiptGrandTotal) {
      // dev.log("receiptTotal - $receiptGrandTotal");
      // dev.log("receiptTotalVouchers - $receiptTotalVouchers");
      setState(() {
        voucherIsExceedPurchase = true;
      });
    }

    await _refreshVouchersChips(context.read<ReceiptCubit>().state.vouchers, 2);
  }

  // void handleEDCSelected(MopSelectionEntity mop, EDCSelectionEntity edc) {}

  void checkAndHandleZeroGrandTotal() async {
    try {
      if (context.read<ReceiptCubit>().state.grandTotal != 0) {
        return;
      }

      // Set state isZeroGrandTotal
      setState(() {
        isZeroGrandTotal = true;
      });

      // Set default MOP
      final MopSelectionEntity cashMopSelection = await GetIt.instance<MopSelectionRepository>().getCashMopSelection();
      setState(() {
        _values = [cashMopSelection.copyWith(amount: 0)];
      });
      updateReceiptMop();
    } catch (e) {
      // dev.log(e.toString());
      context.pop();
      SnackBarHelper.presentFailSnackBar(context, e.toString());
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
          return BlocBuilder<ReceiptCubit, ReceiptEntity>(
            builder: (context, receipt) {
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      height: 35,
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
                                      height: 5,
                                    ),
                                    Text(
                                      "$currencyName${Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal.round())}",
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    (receipt.discHeaderManual ?? 0) > 0
                                        ? Container(
                                            height: 35,
                                            alignment: Alignment.topCenter,
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Text(
                                              "*${Helpers.parseMoney(receipt.discHeaderManual ?? 0)} header discount applied",
                                              style: const TextStyle(fontStyle: FontStyle.italic),
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 35,
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
                                      height: 35,
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
                                      height: 5,
                                    ),
                                    Text(
                                      "$currencyName${Helpers.parseMoney(receipt.totalPayment ?? 0)}",
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      height: 35,
                                      alignment: Alignment.topCenter,
                                      child: receipt.grandTotal -
                                                  (receipt.totalVoucher ?? 0) -
                                                  (receipt.totalNonVoucher ?? 0) >
                                              0
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.warning_rounded,
                                                  size: 20,
                                                  // color: Color.fromARGB(255, 253, 185, 148),
                                                  color: ProjectColors.swatch,
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  "Due  $currencyName${Helpers.parseMoney((context.read<ReceiptCubit>().state.grandTotal.toInt()) - (receipt.totalVoucher ?? 0) - (receipt.totalNonVoucher ?? 0))}",
                                                  style: const TextStyle(
                                                      // color: Color.fromARGB(255, 253, 185, 148),
                                                      color: ProjectColors.swatch,
                                                      fontSize: 16,
                                                      height: 1,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ],
                                            )
                                          : receipt.grandTotal -
                                                      (receipt.totalVoucher ?? 0) -
                                                      (receipt.totalNonVoucher ?? 0) <
                                                  0
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.change_circle_rounded,
                                                      size: 20,
                                                      // color: Color.fromARGB(255, 253, 185, 148),
                                                      color: ProjectColors.green,
                                                    ),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text(
                                                      "Change  $currencyName${Helpers.parseMoney(voucherIsExceedPurchase ? 0 : (receipt.totalPayment ?? 0) - receipt.grandTotal)}",
                                                      style: const TextStyle(
                                                          // color: Color.fromARGB(255, 253, 185, 148),
                                                          color: ProjectColors.green,
                                                          fontSize: 16,
                                                          height: 1,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selected MOP",
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          if (receipt.mopSelections.isEmpty && receipt.vouchers.isEmpty)
                            const Text(
                              "Not set",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          Expanded(
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 5,
                              children: (receipt.mopSelections.isNotEmpty
                                      ? receipt.mopSelections
                                          .asMap()
                                          .entries
                                          .map((entry) => _selectedMopChip(entry.value, 1, entry.key))
                                          .toList()
                                      : <Widget>[const SizedBox.shrink()]) +
                                  (selectedVoucherChips.isNotEmpty
                                      ? selectedVoucherChips
                                      : <Widget>[const SizedBox.shrink()]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isZeroGrandTotal
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 20,
                          ),
                    isZeroGrandTotal
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    // padding:
                                    //     const EdgeInsets.symmetric(horizontal: 20),
                                    child: FocusTraversalGroup(
                                      policy: WidgetOrderTraversalPolicy(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List<Widget>.generate(
                                          paymentTypes.length,
                                          (int index) {
                                            final paymentType = paymentTypes[index];
                                            final List<MopSelectionEntity> mopsByType =
                                                getMopByPayTypeCode(paymentType.payTypeCode);

                                            if (mopsByType.isEmpty) {
                                              return const SizedBox.shrink();
                                            }

                                            // [START] UI for TUNAI MOP
                                            if (paymentType.payTypeCode[0] == "1") {
                                              final MopSelectionEntity? cashMopSelection = receipt.mopSelections
                                                  .where((element) => element.payTypeCode == "1")
                                                  .firstOrNull;
                                              final double totalCash =
                                                  cashMopSelection == null ? 0 : cashMopSelection.amount!;
                                              final List<int> cashAmountSuggestions = generateCashAmountSuggestions(
                                                  (widget.isMultiMOPs
                                                          ? receipt.grandTotal - (receipt.totalPayment ?? 0) + totalCash
                                                          : receipt.grandTotal - (receipt.totalVoucher ?? 0))
                                                      .round());

                                              return Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          paymentType.description,
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        SizedBox(
                                                          // height: 50,
                                                          // width: 400,
                                                          child: TextField(
                                                            onSubmitted: (value) => _focusNodeCashAmount.requestFocus(),
                                                            focusNode: _focusNodeCashAmount,
                                                            onTapOutside: (event) => _focusNodeCashAmount.unfocus(),
                                                            controller: _textEditingControllerCashAmount,
                                                            onChanged: (value) {
                                                              final double cashAmount =
                                                                  Helpers.revertMoneyToDecimalFormat(value);

                                                              if (cashAmount <= 0) {
                                                                setState(() {
                                                                  _values = (widget.isMultiMOPs
                                                                      ? _values
                                                                          .where(
                                                                              (e) => e.tpmt3Id != mopsByType[0].tpmt3Id)
                                                                          .toList()
                                                                      : <MopSelectionEntity>[]);
                                                                });
                                                                updateReceiptMop();
                                                                return;
                                                              }

                                                              setState(() {
                                                                _values = (widget.isMultiMOPs
                                                                        ? _values
                                                                            .where((e) =>
                                                                                e.tpmt3Id != mopsByType[0].tpmt3Id)
                                                                            .toList()
                                                                        : <MopSelectionEntity>[]) +
                                                                    [mopsByType[0].copyWith(amount: cashAmount)];
                                                              });
                                                              updateReceiptMop();
                                                            },
                                                            inputFormatters: [MoneyInputFormatter()],
                                                            keyboardType: TextInputType.number,
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(fontSize: 24, height: 1),
                                                            decoration: InputDecoration(
                                                                contentPadding: const EdgeInsets.all(5),
                                                                hintText: "Cash Amount",
                                                                hintStyle: const TextStyle(
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: 24,
                                                                    height: 1),
                                                                border: const OutlineInputBorder(),
                                                                prefixIcon: const Icon(
                                                                  Icons.payments_outlined,
                                                                  size: 24,
                                                                ),
                                                                suffixIcon: _textEditingControllerCashAmount.text == ""
                                                                    ? null
                                                                    : InkWell(
                                                                        onTap: () {
                                                                          setState(() {
                                                                            _values = (widget.isMultiMOPs
                                                                                ? _values
                                                                                    .where((e) =>
                                                                                        e.tpmt3Id !=
                                                                                        mopsByType[0].tpmt3Id)
                                                                                    .toList()
                                                                                : <MopSelectionEntity>[]);
                                                                          });
                                                                          _textEditingControllerCashAmount.text = "";
                                                                          updateReceiptMop();
                                                                        },
                                                                        child: const Icon(
                                                                          Icons.close,
                                                                          size: 24,
                                                                        ),
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
                                                              if (cashAmountSuggestions[index] <= 0) {
                                                                return const SizedBox.shrink();
                                                              }
                                                              return ChoiceChip(
                                                                side: const BorderSide(
                                                                    color: ProjectColors.primary, width: 1.5),
                                                                padding: const EdgeInsets.all(20),
                                                                label: Text(
                                                                    Helpers.parseMoney(cashAmountSuggestions[index])),
                                                                selected: _values
                                                                    .where((e) =>
                                                                        e.tpmt3Id == mopsByType[0].tpmt3Id &&
                                                                        e.amount == cashAmountSuggestions[index])
                                                                    .isNotEmpty,
                                                                onSelected: (bool selected) {
                                                                  if (voucherIsExceedPurchase) return;
                                                                  setState(() {
                                                                    if (selected) {
                                                                      _values = widget.isMultiMOPs
                                                                          ? _values
                                                                                  .where((e) =>
                                                                                      e.tpmt3Id !=
                                                                                      mopsByType[0].tpmt3Id)
                                                                                  .toList() +
                                                                              [
                                                                                mopsByType[0].copyWith(
                                                                                    amount: cashAmountSuggestions[index]
                                                                                        .toDouble())
                                                                              ]
                                                                          : <MopSelectionEntity>[] +
                                                                              [
                                                                                mopsByType[0].copyWith(
                                                                                    amount: cashAmountSuggestions[index]
                                                                                        .toDouble())
                                                                              ];
                                                                      _textEditingControllerCashAmount.text =
                                                                          Helpers.parseMoney(
                                                                              cashAmountSuggestions[index]);
                                                                    } else {
                                                                      _values = _values
                                                                          .where(
                                                                              (e) => e.tpmt3Id != mopsByType[0].tpmt3Id)
                                                                          .toList();
                                                                      _textEditingControllerCashAmount.text = "";
                                                                    }
                                                                    updateReceiptMop();
                                                                  });
                                                                },
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }
                                            // [END] UI for TUNAI MOP

                                            // [START] UI for EDC MOP
                                            if (paymentType.payTypeCode[0] == "2") {
                                              return Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          paymentType.description,
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 15),
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: List<Widget>.generate(
                                                            mopsByType.map((mop) => mop.tpmt4Id).toSet().length,
                                                            (int index) {
                                                              final distinctEdc =
                                                                  mopsByType.map((mop) => mop.tpmt4Id).toSet().toList();
                                                              final mop = mopsByType.firstWhere(
                                                                  (mop) => mop.tpmt4Id == distinctEdc[index]);
                                                              List<MopSelectionEntity> filteredMops = _values
                                                                  .where((edc) => edc.tpmt4Id == mop.tpmt4Id)
                                                                  .toList();

                                                              return ChoiceChip(
                                                                side: const BorderSide(
                                                                    color: ProjectColors.primary, width: 1.5),
                                                                padding: const EdgeInsets.all(20),
                                                                label: Text(mop.edcDesc ?? mop.mopAlias),
                                                                selected:
                                                                    _values.map((e) => e.tpmt4Id).contains(mop.tpmt4Id),
                                                                onSelected: (bool selected) async {
                                                                  if (voucherIsExceedPurchase) return;

                                                                  double? mopAmount = 0;
                                                                  if (selected) {
                                                                    if (widget.isMultiMOPs) {
                                                                      if ((receipt.totalPayment ?? 0) >=
                                                                          receipt.grandTotal) {
                                                                        return;
                                                                      }
                                                                      mopAmount = await showDialog<double>(
                                                                        context: context,
                                                                        barrierDismissible: false,
                                                                        builder: (context) => EDCDialog(
                                                                          onEDCSelected: (mopEDC) {
                                                                            setState(() {
                                                                              _values = _values.toList() + [mopEDC];
                                                                              // dev.log("mopEDC Multi - $mopEDC");
                                                                              // dev.log("values - $_values");
                                                                            });
                                                                          },
                                                                          onEDCRemoved: (mopEDC) {
                                                                            setState(() {
                                                                              _values.removeWhere(
                                                                                  (item) => item == mopEDC);
                                                                            });
                                                                          },
                                                                          mopSelectionEntity: mop,
                                                                          values: filteredMops,
                                                                          max: receipt.grandTotal -
                                                                              (receipt.totalPayment ?? 0),
                                                                          isMultiMOPs: true,
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      // dev.log("values1 - $_values");
                                                                      mopAmount = await showDialog<double>(
                                                                        context: context,
                                                                        barrierDismissible: false,
                                                                        builder: (context) => EDCDialog(
                                                                          onEDCSelected: (mopEDC) {
                                                                            setState(() {
                                                                              _values = [mopEDC];
                                                                              // _values = _values.toList() + [mopEDC];
                                                                            });
                                                                            // dev.log("values2 - $_values");
                                                                            // dev.log("mopEDC not Multi - $mopEDC");
                                                                          },
                                                                          onEDCRemoved: (mopEDC) {
                                                                            setState(() {
                                                                              _values.removeWhere(
                                                                                  (item) => item == mopEDC);
                                                                            });
                                                                          },
                                                                          mopSelectionEntity: mop,
                                                                          values: filteredMops,
                                                                          max: receipt.grandTotal -
                                                                              (receipt.totalVoucher ?? 0),
                                                                          isMultiMOPs: false,
                                                                        ),
                                                                      );
                                                                    }

                                                                    if (!widget.isMultiMOPs) {
                                                                      _textEditingControllerCashAmount.text = "";
                                                                    }
                                                                  } else {
                                                                    if (widget.isMultiMOPs) {
                                                                      if ((receipt.totalPayment ?? 0) >=
                                                                          receipt.grandTotal) {
                                                                        return;
                                                                      }
                                                                      // dev.log("filteredMops - $filteredMops");
                                                                      mopAmount = await showDialog<double>(
                                                                        context: context,
                                                                        barrierDismissible: false,
                                                                        builder: (context) => EDCDialog(
                                                                          onEDCSelected: (mopEDC) {
                                                                            setState(() {
                                                                              _values = _values.toList() + [mopEDC];
                                                                              // dev.log("mopEDC Multi - $mopEDC");
                                                                              // dev.log("values - $_values");
                                                                            });
                                                                          },
                                                                          onEDCRemoved: (mopEDC) {
                                                                            setState(() {
                                                                              _values.removeWhere(
                                                                                  (item) => item == mopEDC);
                                                                            });
                                                                          },
                                                                          mopSelectionEntity: mop,
                                                                          values: filteredMops,
                                                                          max: receipt.grandTotal -
                                                                              (receipt.totalPayment ?? 0),
                                                                          isMultiMOPs: true,
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      mopAmount = await showDialog<double>(
                                                                        context: context,
                                                                        barrierDismissible: false,
                                                                        builder: (context) => EDCDialog(
                                                                          onEDCSelected: (mopEDC) {
                                                                            setState(() {
                                                                              _values = [mopEDC];
                                                                              // _values = _values.toList() + [mopEDC];
                                                                            });
                                                                            // dev.log("values2 - $_values");
                                                                            // dev.log("mopEDC not Multi - $mopEDC");
                                                                          },
                                                                          onEDCRemoved: (mopEDC) {
                                                                            setState(() {
                                                                              _values.removeWhere(
                                                                                  (item) => item == mopEDC);
                                                                            });
                                                                          },
                                                                          mopSelectionEntity: mop,
                                                                          values: filteredMops,
                                                                          max: receipt.grandTotal -
                                                                              (receipt.totalVoucher ?? 0),
                                                                          isMultiMOPs: false,
                                                                        ),
                                                                      );
                                                                    }
                                                                  }

                                                                  setState(() {});
                                                                  updateReceiptMop();
                                                                },
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                        const SizedBox(height: 20),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }
                                            // [END] UI for EDC MOP

                                            // [START] UI for other MOPs
                                            return Column(
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        paymentType.description,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w700,
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
                                                                  color: ProjectColors.primary, width: 1.5),
                                                              padding: const EdgeInsets.all(20),
                                                              label: Text(
                                                                mop.mopAlias,
                                                              ),
                                                              // CONDITIONAL FOR SET SELECTED
                                                              selected: paymentType.payTypeCode == "6"
                                                                  ? receipt.vouchers
                                                                      .map((e) => e.tpmt3Id)
                                                                      .contains(mop.tpmt3Id)
                                                                  : _values.map((e) => e.tpmt3Id).contains(mop.tpmt3Id),
                                                              onSelected: (bool selected) async {
                                                                // VOUCHERS DIALOG HERE
                                                                if (paymentType.payTypeCode == "6") {
                                                                  await showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        backgroundColor: Colors.white,
                                                                        surfaceTintColor: Colors.transparent,
                                                                        shape: const RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(5.0))),
                                                                        title: Container(
                                                                          decoration: const BoxDecoration(
                                                                            color: ProjectColors.primary,
                                                                            borderRadius: BorderRadius.vertical(
                                                                                top: Radius.circular(5.0)),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.fromLTRB(25, 10, 25, 10),
                                                                          child: const Text(
                                                                            'Redeem Voucher',
                                                                            style: TextStyle(
                                                                                fontSize: 22,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        titlePadding:
                                                                            const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                        contentPadding: const EdgeInsets.all(0),
                                                                        content: SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.5,
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.6,
                                                                          child: VoucherCheckout(
                                                                            onVouchersRedeemed: handleVouchersRedeemed,
                                                                            tpmt3Id: mop.tpmt3Id,
                                                                            voucherType: mop.subType,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                  setState(() {
                                                                    _textEditingControllerCashAmount.text = "";
                                                                    context.read<ReceiptCubit>().resetMop();
                                                                    _values = [];
                                                                  });
                                                                  return;
                                                                }

                                                                if (voucherIsExceedPurchase) return;

                                                                if (selected) {
                                                                  double? mopAmount = 0;
                                                                  if (widget.isMultiMOPs) {
                                                                    if ((receipt.totalPayment ?? 0) >=
                                                                        receipt.grandTotal) {
                                                                      return;
                                                                    }
                                                                    mopAmount = await showDialog<double>(
                                                                      context: context,
                                                                      barrierDismissible: false,
                                                                      builder: (context) => InputMopAmountDialog(
                                                                        mopSelectionEntity: mop,
                                                                        max: receipt.grandTotal -
                                                                            (receipt.totalPayment ?? 0),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    mopAmount = receipt.grandTotal -
                                                                        (receipt.totalVoucher ?? 0);
                                                                  }

                                                                  if (mopAmount == null || mopAmount == 0) {
                                                                    return;
                                                                  }

                                                                  _values = (widget.isMultiMOPs
                                                                          ? _values
                                                                              .where((e) => e.tpmt3Id != mop.tpmt3Id)
                                                                              .toList()
                                                                          : <MopSelectionEntity>[]) +
                                                                      [mop.copyWith(amount: mopAmount)];

                                                                  if (!widget.isMultiMOPs) {
                                                                    _textEditingControllerCashAmount.text = "";
                                                                  }
                                                                } else {
                                                                  _values = _values
                                                                      .where((e) => e.tpmt3Id != mop.tpmt3Id)
                                                                      .toList();
                                                                }

                                                                setState(() {});
                                                                updateReceiptMop();
                                                              },
                                                            );
                                                          },
                                                        ).toList(),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(),
                                              ],
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
  State<_CheckoutSuccessDialogContent> createState() => __CheckoutSuccessDialogContentState();
}

class __CheckoutSuccessDialogContentState extends State<_CheckoutSuccessDialogContent> {
  String currencyName = "";
  List<TableRow> voucherDetails = [];

  Future<void> _refreshVouchersChips(int color) async {
    final List<VouchersSelectionEntity> vouchers = context.read<ReceiptCubit>().state.vouchers;
    final Map<String, num> amountByTpmt3Ids = {};
    final List<TableRow> result = [];

    for (final voucher in vouchers) {
      if (amountByTpmt3Ids[voucher.tpmt3Id] == null) {
        amountByTpmt3Ids[voucher.tpmt3Id!] = voucher.voucherAmount;
      } else {
        amountByTpmt3Ids[voucher.tpmt3Id!] = amountByTpmt3Ids[voucher.tpmt3Id!]! + voucher.voucherAmount;
      }
    }

    for (final tpmt3Id in amountByTpmt3Ids.keys) {
      final MopSelectionEntity? mopSelectionEntity =
          await GetIt.instance<MopSelectionRepository>().getMopSelectionByTpmt3Id(tpmt3Id);
      result.add(
        TableRow(
          children: [
            Text(
              mopSelectionEntity?.mopAlias ?? "Unknown Voucher",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              Helpers.parseMoney(amountByTpmt3Ids[tpmt3Id]!),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      );
    }

    setState(() {
      voucherDetails = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrencyName();
    _refreshVouchersChips(2);
  }

  void getCurrencyName() async {
    try {
      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) return;
      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>().call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) return;
      if (storeMasterEntity.tcurrId == null) return;
      final CurrencyEntity? currencyEntity =
          await GetIt.instance<AppDatabase>().currencyDao.readByDocId(storeMasterEntity.tcurrId!, null);
      if (currencyEntity == null) return;

      setState(() {
        currencyName = "${currencyEntity.curCode} ";
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

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
            // width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  // width: double.infinity,
                  color: const Color.fromARGB(255, 134, 1, 1),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
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
                              "$currencyName${Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal.toInt())}",
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
                          context.read<ReceiptCubit>().state.transDateTime != null
                              ? DateFormat("EEE, dd MMM yyyy hh:mm aaa")
                                  .format(context.read<ReceiptCubit>().state.transDateTime!)
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
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    // width: double.infinity,
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
                    // width: double.infinity,
                    child: Table(columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(5),
                    }, children: [
                      TableRow(
                        children: [
                          const Text(
                            "Invoice Number",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            context.read<ReceiptCubit>().state.docNum,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            textAlign: TextAlign.right,
                            Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal.round()),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const TableRow(children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ]),
                      ...List.generate(context.read<ReceiptCubit>().state.mopSelections.length, (index) {
                        final MopSelectionEntity mop = context.read<ReceiptCubit>().state.mopSelections[index];

                        return TableRow(
                          children: [
                            Text(
                              (mop.tpmt2Id != null) ? mop.cardName! : mop.mopAlias,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(mop.payTypeCode == "1"
                                  ? mop.amount! + (context.read<ReceiptCubit>().state.changed ?? 0)
                                  : mop.amount!),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        );
                      }),
                      if (voucherDetails.isNotEmpty) ...voucherDetails,
                      // const TableRow(children: [
                      //   SizedBox(
                      //     height: 10,
                      //   ),
                      //   SizedBox(
                      //     height: 10,
                      //   ),
                      //   SizedBox(
                      //     height: 10,
                      //   )
                      // ]),
                      TableRow(
                        children: [
                          const Text(
                            "Total Payment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            Helpers.parseMoney(context.read<ReceiptCubit>().state.totalPayment!.toInt()),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            context.read<ReceiptCubit>().state.changed != null
                                ? Helpers.parseMoney(context.read<ReceiptCubit>().state.changed!.round())
                                : "",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
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
