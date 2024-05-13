import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/vouchers_selection_service.dart';
import 'package:pos_fe/features/sales/data/models/vouchers_selection.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';

class VoucherCheckout extends StatefulWidget {
  final Function(
    List<VouchersSelectionModel>,
  ) onVouchersRedeemed;
  const VoucherCheckout(this.onVouchersRedeemed, {super.key});

  @override
  State<VoucherCheckout> createState() => _VoucherCheckoutState();
}

class _VoucherCheckoutState extends State<VoucherCheckout> {
  final _voucherCheckController = TextEditingController();
  List<VouchersSelectionModel> vouchers = [];
  int vouchersAmount = 0;
  bool minPurchaseFulfilled = true;
  VouchersSelectionModel? checkMinPurchase;

  @override
  Widget build(BuildContext context) {
    final receiptCubit = context.read<ReceiptCubit>();
    var checkVoucher;
    return Column(
      children: [
        const Text("Voucher Serial Number"),
        TextField(
          // focusNode: _focusNodeCashAmount,
          // onTapOutside: (event) => _focusNodeCashAmount.unfocus(),
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
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: "Serial Number",
              hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.price_check_outlined,
                size: 24,
              )),
          onSubmitted: (value) async {
            try {
              final voucher = await GetIt.instance<VouchersSelectionApi>()
                  .checkVoucher(value);
              checkVoucher = voucher;
              bool checkSerialNo =
                  vouchers.any((v) => v.serialNo == voucher.serialNo);

              if (receiptCubit.state.subtotal >= voucher.minPurchase) {
                if (!checkSerialNo) {
                  setState(() {
                    vouchers.add(voucher);
                    vouchersAmount += voucher.voucherAmount;
                    _voucherCheckController.clear();
                  });
                  minPurchaseFulfilled = true;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Voucher can\'t be used'),
                    ),
                  );
                }
              } else {
                minPurchaseFulfilled = false;
              }
            } catch (err) {
              handleError(err);
              rethrow;
            }
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                minPurchaseFulfilled
                    ? Text("")
                    : Text(
                        "Add more purchase to use voucher (min. Rp 500,000)"),
                Text(
                  "Vouchers Amount: $vouchersAmount",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...vouchers.map((voucher) {
                  return Text("${voucher.voucherAmount}");
                }).toList(),
              ],
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
                      side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.black.withOpacity(.2))),
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
            !minPurchaseFulfilled
                ? Expanded(
                    child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.black),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white.withOpacity(.2))),
                    onPressed: () async {},
                    child: const Center(
                        child: Text(
                      "Redeem",
                      style: TextStyle(color: Colors.white),
                    )),
                  ))
                : Expanded(
                    child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white.withOpacity(.2))),
                    onPressed: () async {
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
                          );
                          await GetIt.instance<AppDatabase>()
                              .vouchersSelectionDao
                              .create(data: voucherToSave);
                        }
                      }

                      widget.onVouchersRedeemed(vouchers);

                      setState(() {
                        vouchers.clear();
                        vouchersAmount = 0;
                      });

                      Navigator.of(context).pop();
                    },
                    child: const Center(
                        child: Text(
                      "Redeem",
                      style: TextStyle(color: Colors.white),
                    )),
                  )),
          ],
        ),
      ],
    );
  }
}
