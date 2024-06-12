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
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/vouchers_selection_service.dart';
import 'package:pos_fe/features/sales/data/models/vouchers_selection.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirm_redeem_vouchers_fail_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirm_redeem_vouchers_success_dialog.dart';

class VoucherCheckout extends StatefulWidget {
  final Function(
    List<VouchersSelectionModel>,
  ) onVouchersRedeemed;
  final String tpmt3Id;
  final int voucherType;

  const VoucherCheckout({
    super.key,
    required this.tpmt3Id,
    required this.onVouchersRedeemed,
    required this.voucherType,
  });

  @override
  State<VoucherCheckout> createState() => _VoucherCheckoutState();
}

class _VoucherCheckoutState extends State<VoucherCheckout> {
  final _voucherCheckController = TextEditingController();
  late final FocusNode _voucherFocusNode = FocusNode(
      // onKeyEvent: (node, value) {
      //   log(value.physicalKey.toString());
      //   if (value.runtimeType == KeyUpEvent) return KeyEventResult.handled;

      //   if (value.physicalKey == PhysicalKeyboardKey.f12) {
      //     _redeemVouchers();
      //     return KeyEventResult.handled;
      //   } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
      //     context.pop();
      //     return KeyEventResult.handled;
      //   } else if ((value.physicalKey == PhysicalKeyboardKey.enter ||
      //           value.physicalKey == PhysicalKeyboardKey.arrowDown) &&
      //       !node.hasPrimaryFocus) {
      //     node.requestFocus();
      //     return KeyEventResult.handled;
      //   }

      //   return KeyEventResult.ignored;
      // },
      );
  List<VouchersSelectionModel> vouchers = [];
  int vouchersAmount = 0;
  bool minPurchaseFulfilled = true;
  VouchersSelectionModel? checkMinPurchase;
  String errMessage = "";
  bool isError = false;
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  List<Widget> _buildVoucherRows(
    List<VouchersSelectionModel> vouchers,
    bool isExisting,
  ) {
    return vouchers.asMap().entries.map((entry) {
      int index = entry.key;
      VouchersSelectionModel voucher = entry.value;
      // return Text(
      //     "${voucher.voucherAlias} - ${voucher.voucherAmount}");

      return SizedBox(
        width: double.infinity,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  "${isExisting ? index + 1 : index + 1 + context.read<ReceiptCubit>().state.vouchers.length}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  voucher.serialNo,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  voucher.voucherAlias,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isExisting
                        ? Icon(
                            Icons.done_rounded,
                            size: 18,
                            weight: 2,
                            color: const Color.fromARGB(255, 86, 147, 99),
                          )
                        : SizedBox.shrink(),
                    isExisting
                        ? SizedBox(
                            width: 10,
                          )
                        : SizedBox.shrink(),
                    Text(
                      Helpers.parseMoney(voucher.voucherAmount),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
        ]),
      );
    }).toList();
  }

  Future<void> _checkVoucher(String serialNumber) async {
    final receiptCubit = context.read<ReceiptCubit>();
    VouchersSelectionModel checkVoucher;
    try {
      final voucher = await GetIt.instance<VouchersSelectionApi>()
          .checkVoucher(serialNumber);
      if (voucher == null) throw "Voucher not found";
      checkVoucher = voucher..tpmt3Id = widget.tpmt3Id;
      bool checkSerialNo = vouchers.any((v) => v.serialNo == voucher.serialNo);
      log("vouchertype ${widget.voucherType} checkVoucher ${checkVoucher.type}");
      // if (checkVoucher.type != widget.voucherType) return;

      log("${receiptCubit.state.subtotal} ${voucher.minPurchase}");

      if (receiptCubit.state.subtotal >= voucher.minPurchase) {
        if (!checkSerialNo) {
          setState(() {
            vouchers.add(voucher);
            vouchersAmount += voucher.voucherAmount;
            _voucherCheckController.clear();
            minPurchaseFulfilled = true;
          });
          _voucherFocusNode.unfocus();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Voucher can\'t be used'),
            ),
          );
        }
      } else {
        setState(() {
          // vouchers.add(voucher);
          // vouchersAmount += voucher.voucherAmount;
          // _voucherCheckController.clear();
          errMessage =
              "Minimum purchase is Rp ${Helpers.parseMoney(voucher.minPurchase)}";
          minPurchaseFulfilled = false;
        });
      }

      isError = false;
    } catch (err) {
      isError = true;
      errMessage = err.toString();
      setState(() {});

      Future.delayed(Duration(seconds: 2), () {
        isError = false;
        errMessage = "";
        setState(() {});
      });
      handleError(err);
      rethrow;
    }
  }

  Future<void> _redeemVouchers() async {
    final int toRedeemCount = vouchers.length;
    int redeemedCount = 0;

    try {
      if (vouchers.isEmpty) throw "There is no voucher scanned.";
      for (var voucher in vouchers) {
        await GetIt.instance<VouchersSelectionApi>()
            .redeemVoucher(voucher.serialNo);

        final checkVoucher = await GetIt.instance<AppDatabase>()
            .vouchersSelectionDao
            .readByDocId(voucher.docId, null);

        if (checkVoucher == null) {
          final voucherToSave = VouchersSelectionModel(
            docId: voucher.docId,
            tpmt3Id: voucher.tpmt3Id,
            tovcrId: voucher.tovcrId,
            voucherAlias: voucher.voucherAlias,
            voucherAmount: voucher.voucherAmount,
            validFrom: voucher.validFrom,
            validTo: voucher.validTo,
            serialNo: voucher.serialNo,
            voucherStatus: 1,
            statusActive: voucher.statusActive,
            minPurchase: voucher.minPurchase,
            redeemDate: voucher.redeemDate,
            tinv2Id: "",
            type: widget.voucherType,
          );
          await GetIt.instance<AppDatabase>()
              .vouchersSelectionDao
              .create(data: voucherToSave);
          widget.onVouchersRedeemed([voucher]);
          vouchers = vouchers
              .where((element) => element.docId != voucher.docId)
              .toList();
          vouchersAmount -= voucher.voucherAmount;
          redeemedCount += 1;
          setState(() {});
        }
      }

      if (toRedeemCount > redeemedCount) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const ConfirmRedeemVouchersFailDialog(),
        );
      } else if (toRedeemCount == redeemedCount) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const ConfirmRedeemVouchersSuccessDialog(),
        );
        context.pop();
      }
    } catch (e) {
      if (toRedeemCount > redeemedCount) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const ConfirmRedeemVouchersFailDialog(),
        );
        return;
      }

      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => ConfirmRedeemVouchersFailDialog(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _voucherFocusNode.dispose();
    _voucherCheckController.dispose();
    _keyboardListenerFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiptCubit = context.read<ReceiptCubit>();

    return Focus(
      // autofocus: true,
      onKeyEvent: (node, value) {
        log(value.physicalKey.toString());
        log(_voucherFocusNode.hasPrimaryFocus.toString());
        if (value.runtimeType == KeyUpEvent) return KeyEventResult.handled;

        if (value.physicalKey == PhysicalKeyboardKey.f12) {
          _redeemVouchers();
          return KeyEventResult.handled;
        } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
          context.pop();
          return KeyEventResult.handled;
        } else if ((value.physicalKey == PhysicalKeyboardKey.enter ||
                value.physicalKey == PhysicalKeyboardKey.arrowDown) &&
            !_voucherFocusNode.hasPrimaryFocus) {
          _voucherFocusNode.requestFocus();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _voucherFocusNode,
                    onTapOutside: (event) => _voucherFocusNode.requestFocus(),
                    controller: _voucherCheckController,
                    // onTap: () {
                    //   _value = mopsByType[0].tpmt3Id;
                    //   updateReceiptMop();
                    // },
                    // onChanged: (value) => setState(() {
                    //   _cashAmount = Helpers.revertMoneyToDecimalFormat(value).toInt();
                    //   updateReceiptMop();
                    // }),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      constraints: BoxConstraints(minHeight: 48, maxHeight: 48),
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Serial Number",
                      hintStyle:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.confirmation_number_outlined,
                        size: 24,
                        color: _voucherFocusNode.hasFocus
                            ? ProjectColors.primary
                            : null,
                      ),
                    ),
                    onSubmitted: (value) async {
                      try {
                        await _checkVoucher(value);
                        _voucherFocusNode.requestFocus();
                      } catch (e) {
                        _voucherFocusNode.requestFocus();
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    width: 80,
                    height: 48,
                    child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => ProjectColors.primary),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white.withOpacity(.2))),
                      onPressed: () async =>
                          await _checkVoucher(_voucherCheckController.text),
                      child: const Center(
                          child: Text(
                        "Check",
                        style: TextStyle(color: Colors.white),
                      )),
                    ))
              ],
            ),
            minPurchaseFulfilled && !isError
                ? const Text("")
                : Text(
                    errMessage,
                    style: TextStyle(color: Colors.red),
                  ),
            Row(children: [
              SizedBox(
                width: 140,
                child: Text(
                  "Count",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Text(
                ":  ${(vouchers.length + receiptCubit.state.vouchers.length).toString()}",
                style: const TextStyle(fontSize: 18),
              ),
            ]),
            Row(children: [
              SizedBox(
                width: 140,
                child: Text(
                  "Total Amount",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Text(
                ":  ${Helpers.parseMoney(vouchersAmount + (receiptCubit.state.totalVoucher ?? 0))}",
                style: const TextStyle(fontSize: 18),
              ),
            ]),
            Divider(
              color: Colors.black,
            ),
            if (vouchers.isNotEmpty || receiptCubit.state.vouchers.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          "No",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ProjectColors.lightBlack),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          "Serial Number",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ProjectColors.lightBlack),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ProjectColors.lightBlack),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Amount",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: ProjectColors.lightBlack),
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
            if (vouchers.isNotEmpty || receiptCubit.state.vouchers.isNotEmpty)
              SizedBox(
                height: 7,
              ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (vouchers.isEmpty &&
                          receiptCubit.state.vouchers.isEmpty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: EmptyList(
                              height: 70,
                              imagePath: "assets/images/empty-search.svg",
                              sentence:
                                  "Tadaa.. There is nothing here!\nInput a voucher to start."),
                        ),
                      ..._buildVoucherRows(
                          context
                              .read<ReceiptCubit>()
                              .state
                              .vouchers
                              .map((e) => VouchersSelectionModel.fromEntity(e))
                              .toList(),
                          true),
                      ..._buildVoucherRows(vouchers, false).toList(),
                      // ...[
                      //   ...context
                      //       .read<ReceiptCubit>()
                      //       .state
                      //       .vouchers
                      //       .map((e) => VouchersSelectionModel.fromEntity(e)),
                      //   ...vouchers
                      // ].asMap().entries.map((entry) {
                      //   int index = entry.key;
                      //   VouchersSelectionModel voucher = entry.value;
                      //   // return Text(
                      //   //     "${voucher.voucherAlias} - ${voucher.voucherAmount}");

                      //   return SizedBox(
                      //     width: double.infinity,
                      //     child:
                      //         Column(mainAxisSize: MainAxisSize.min, children: [
                      //       Row(
                      //         children: [
                      //           SizedBox(
                      //             width: 20,
                      //             child: Text(
                      //               "${index + 1}",
                      //               style: TextStyle(fontSize: 18),
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             width: 15,
                      //           ),
                      //           Expanded(
                      //             child: Text(
                      //               voucher.serialNo,
                      //               style: TextStyle(fontSize: 18),
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             width: 15,
                      //           ),
                      //           Expanded(
                      //             child: Text(
                      //               voucher.voucherAlias,
                      //               style: TextStyle(fontSize: 18),
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             width: 15,
                      //           ),
                      //           Expanded(
                      //             child: Align(
                      //               alignment: Alignment.centerRight,
                      //               child: Text(
                      //                 Helpers.parseMoney(voucher.voucherAmount),
                      //                 style: TextStyle(fontSize: 18),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 3,
                      //       ),
                      //     ]),
                      //   );
                      // }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side:
                              const BorderSide(color: ProjectColors.primary))),
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
                  onPressed: () async => await _redeemVouchers(),
                  child: const Center(
                      child: Text(
                    "Redeem",
                    style: TextStyle(color: Colors.white),
                  )),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
