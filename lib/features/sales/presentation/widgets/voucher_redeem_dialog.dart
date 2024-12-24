import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/vouchers_selection_service.dart';
import 'package:pos_fe/features/sales/data/models/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
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
  late final FocusNode _voucherFocusNode = FocusNode();
  List<VouchersSelectionModel> vouchers = [];
  int vouchersAmount = 0;
  bool minPurchaseFulfilled = true;
  VouchersSelectionModel? checkMinPurchase;
  String errMessage = "";
  bool isError = false;
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showKeyboard = true;

  List<Widget> _buildVoucherRows(
    List<VouchersSelectionModel> vouchers,
    bool isExisting,
  ) {
    return vouchers.where((element) => element.type == widget.voucherType).toList().asMap().entries.map((entry) {
      int index = entry.key;
      VouchersSelectionModel voucher = entry.value;

      return SizedBox(
        width: double.infinity,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  "${isExisting ? index + 1 : index + 1 + context.read<ReceiptCubit>().state.vouchers.length}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  voucher.serialNo,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  voucher.voucherAlias,
                  style: const TextStyle(fontSize: 18),
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
                        ? const Icon(
                            Icons.done_rounded,
                            size: 18,
                            weight: 2,
                            color: Color.fromARGB(255, 86, 147, 99),
                          )
                        : const SizedBox.shrink(),
                    isExisting
                        ? const SizedBox(
                            width: 10,
                          )
                        : const SizedBox.shrink(),
                    Text(
                      Helpers.parseMoney(voucher.voucherAmount),
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

  Future<void> _checkVoucher(String serialNumber) async {
    final receiptCubit = context.read<ReceiptCubit>();
    VouchersSelectionModel checkVoucher;
    try {
      final voucher = await GetIt.instance<VouchersSelectionApi>().checkVoucher(serialNumber);
      log("voucher - $voucher");
      checkVoucher = voucher..tpmt3Id = widget.tpmt3Id;
      bool checkSerialNo = vouchers.any((v) => v.serialNo == voucher.serialNo);
      log("vouchertype ${widget.voucherType} checkVoucher ${checkVoucher.type}");
      if (checkVoucher.type != widget.voucherType) throw "Invalid voucher type";

      // log("${receiptCubit.state.grandTotal} ${voucher.minPurchase}");

      if (receiptCubit.state.grandTotal >= voucher.minPurchase) {
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
            const SnackBar(
              content: Text('Voucher can\'t be used'),
            ),
          );
        }
      } else {
        setState(() {
          errMessage = "Minimum purchase is Rp ${Helpers.parseMoney(voucher.minPurchase)}";
          minPurchaseFulfilled = false;
        });
      }

      isError = false;
    } catch (err) {
      isError = true;
      errMessage = err.toString();
      setState(() {});

      Future.delayed(const Duration(seconds: 2), () {
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
        await GetIt.instance<VouchersSelectionApi>().redeemVoucher(voucher.serialNo);

        final checkVoucher = await GetIt.instance<AppDatabase>().vouchersSelectionDao.readByDocId(voucher.docId, null);

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
          await GetIt.instance<AppDatabase>().vouchersSelectionDao.create(data: voucherToSave);
          widget.onVouchersRedeemed([voucher]);
          vouchers = vouchers.where((element) => element.docId != voucher.docId).toList();
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
  void initState() {
    getDefaultKeyboardPOSParameter();
    super.initState();
  }

  @override
  void dispose() {
    _voucherFocusNode.dispose();
    _voucherCheckController.dispose();
    _keyboardListenerFocusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  Future<void> getDefaultKeyboardPOSParameter() async {
    try {
      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      setState(() {
        _showKeyboard = (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
      });
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentFailSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final receiptCubit = context.read<ReceiptCubit>();

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Redeem Voucher',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            Container(
              decoration: BoxDecoration(
                color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                borderRadius: const BorderRadius.all(Radius.circular(360)),
              ),
              child: IconButton(
                focusColor: const Color.fromARGB(255, 110, 0, 0),
                focusNode: _keyboardFocusNode,
                icon: Icon(
                  _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showKeyboard = !_showKeyboard;
                  });
                },
                tooltip: 'Toggle Keyboard',
              ),
            ),
          ],
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Focus(
          // autofocus: true,
          onKeyEvent: (node, value) {
            // log(value.physicalKey.toString());
            // log(_voucherFocusNode.hasPrimaryFocus.toString());
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
                const SizedBox(
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
                          constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: "Serial Number",
                          hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
                          border: const OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.confirmation_number_outlined,
                            size: 24,
                            color: _voucherFocusNode.hasFocus ? ProjectColors.primary : null,
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
                        keyboardType: TextInputType.none,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 80,
                        height: 48,
                        child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                              backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                              overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                          onPressed: () async => await _checkVoucher(_voucherCheckController.text),
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
                        style: const TextStyle(color: Colors.red),
                      ),
                Row(children: [
                  const SizedBox(
                    width: 140,
                    child: Text(
                      "Count",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Text(
                    ":  ${(vouchers.length + receiptCubit.state.vouchers.where((element) => element.type == widget.voucherType).length).toString()}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ]),
                Row(children: [
                  const SizedBox(
                    width: 140,
                    child: Text(
                      "Total Amount",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Text(
                    ":  ${Helpers.parseMoney(vouchersAmount + (receiptCubit.state.vouchers.where((element) => element.type == widget.voucherType).map((e) => e.voucherAmount).fold<num>(0, (value, element) => value + element)))}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ]),
                const Divider(
                  color: Colors.black,
                ),
                if (vouchers.isNotEmpty || receiptCubit.state.vouchers.isNotEmpty)
                  const SizedBox(
                    width: double.infinity,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
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
                            child: Text(
                              "Serial Number",
                              style:
                                  TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ProjectColors.lightBlack),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                              "Name",
                              style:
                                  TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ProjectColors.lightBlack),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Amount",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700, color: ProjectColors.lightBlack),
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
                  const SizedBox(
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
                          if (vouchers.isEmpty && receiptCubit.state.vouchers.isEmpty)
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: EmptyList(
                                  height: 70,
                                  imagePath: "assets/images/empty-search.svg",
                                  sentence: "Tadaa.. There is nothing here!\nInput a voucher to start."),
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
                (_showKeyboard)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: KeyboardWidget(
                          controller: _voucherCheckController,
                          isNumericMode: false,
                          customLayoutKeys: true,
                          focusNodeAndTextController: FocusNodeAndTextController(
                            focusNode: _voucherFocusNode,
                            textEditingController: _voucherCheckController,
                          ),
                          onSubmit: () async {
                            try {
                              String text = _voucherCheckController.text.trimRight();
                              await _checkVoucher(text);
                              _voucherCheckController.text = "";
                              _voucherFocusNode.requestFocus();
                            } catch (e) {
                              _voucherFocusNode.requestFocus();
                            }
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
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
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                      onPressed: () async => await _redeemVouchers(),
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Redeem",
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
                    ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
