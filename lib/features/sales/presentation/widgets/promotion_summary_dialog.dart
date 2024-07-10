import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/promotion_detail.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class PromotionSummaryDialog extends StatefulWidget {
  PromotionSummaryDialog({super.key, required this.receiptEntity});

  final ReceiptEntity receiptEntity;

  @override
  State<PromotionSummaryDialog> createState() => _PromotionSummaryDialogState();
}

class _PromotionSummaryDialogState extends State<PromotionSummaryDialog> {
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  late final double previousGrandTotal;

  List<Widget> _buildBuyXGetYDetails() {
    final List<Widget> widgets = [
      const Text(
        "Buy X Get Y",
        style: TextStyle(fontWeight: FontWeight.w700, color: ProjectColors.primary, fontSize: 16),
      ),
      const SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> buyXGetYpromos =
        widget.receiptEntity.promos.where((element) => element.promoType == 103).toList();
    if (buyXGetYpromos.isEmpty) return [];

    widgets.addAll([
      const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 175,
            child: Text(
              "Description",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ProjectColors.lightBlack,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Text("Item Barcode",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ProjectColors.lightBlack,
                  ))),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Text("Item Name",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ProjectColors.lightBlack,
                  ))),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Qty",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ProjectColors.lightBlack,
                      )))),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Selling Price",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ProjectColors.lightBlack,
                      )))),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Total",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ProjectColors.lightBlack,
                      )))),
        ],
      ),
      const SizedBox(
        height: 5,
      )
    ]);

    double subtotal = 0;
    double taxAmount = 0;
    double totalPrice = 0;

    for (final buyXGetYpromo in buyXGetYpromos) {
      final List<ReceiptItemEntity> itemYs = widget.receiptEntity.receiptItems
          .where((e1) => e1.promos
              .where((e2) => e2.promoId == buyXGetYpromo.promoId && (e2.promotionDetails as PromoBuyXGetYDetails).isY)
              .isNotEmpty)
          .toList();
      final List<Widget> itemYUIs = [];

      for (final itemY in itemYs) {
        final PromoBuyXGetYDetails associatedPromo = itemY.promos
            .firstWhere((element) => element.promoId == buyXGetYpromo.promoId)
            .promotionDetails as PromoBuyXGetYDetails;

        final priceQty = associatedPromo.sellingPrice * associatedPromo.quantity;
        subtotal += priceQty;
        taxAmount += (itemY.itemEntity.taxRate / 100) * priceQty;

        itemYUIs.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 175,
                child: itemYUIs.isEmpty
                    ? Text(
                        buyXGetYpromo.promoDescription,
                        style: const TextStyle(fontSize: 14),
                      )
                    : const SizedBox.shrink()),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Text(
                  itemY.itemEntity.barcode,
                  style: const TextStyle(fontSize: 14),
                )),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Text(
                  itemY.itemEntity.itemName,
                  style: const TextStyle(fontSize: 14),
                )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      Helpers.cleanDecimal(associatedPromo.quantity, 3),
                      style: const TextStyle(fontSize: 14),
                    ))),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Align(
                    // PromoPriceUI
                    alignment: Alignment.centerRight,
                    child: Text(
                      (itemY.itemEntity.includeTax == 1)
                          ? Helpers.parseMoney(
                              (((associatedPromo.sellingPrice) * ((100 + itemY.itemEntity.taxRate) / 100)).round()))
                          : Helpers.parseMoney(((associatedPromo.sellingPrice).round())),
                      style: const TextStyle(fontSize: 14),
                    ))),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      (itemY.itemEntity.includeTax == 1)
                          ? Helpers.parseMoney((((priceQty) * ((100 + itemY.itemEntity.taxRate) / 100)).round()))
                          : Helpers.parseMoney(priceQty.round()),
                      style: const TextStyle(fontSize: 14),
                    ))),
          ],
        ));
        itemYUIs.add(const SizedBox(
          height: 10,
        ));
      }

      widgets.addAll(itemYUIs);
    }

    totalPrice = subtotal + taxAmount;

    widgets.addAll([
      const SizedBox(
        height: 15,
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     const SizedBox(
      //       width: 80,
      //       child: Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text(
      //             "Subtotal",
      //             style: TextStyle(fontSize: 14),
      //           )),
      //     ),
      //     const SizedBox(
      //       width: 20,
      //     ),
      //     SizedBox(
      //         width: 150,
      //         child: Align(
      //             alignment: Alignment.centerRight,
      //             child: Text(
      //               Helpers.parseMoney(subtotal.round()),
      //               style: const TextStyle(fontSize: 14),
      //             ))),
      //   ],
      // ),
      // const SizedBox(
      //   height: 5,
      // ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     const SizedBox(
      //       width: 80,
      //       child: Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text(
      //             "Total Tax",
      //             style: TextStyle(fontSize: 14),
      //           )),
      //     ),
      //     const SizedBox(
      //       width: 20,
      //     ),
      //     SizedBox(
      //         width: 150,
      //         child: Align(
      //             alignment: Alignment.centerRight,
      //             child: Text(
      //               Helpers.parseMoney(taxAmount.round()),
      //               style: const TextStyle(fontSize: 14),
      //             ))),
      //   ],
      // ),
      // const SizedBox(
      //   height: 5,
      // ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            width: 80,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total Price",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                )),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    Helpers.parseMoney(totalPrice.round()),
                    style: const TextStyle(fontSize: 14),
                  ))),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
    ]);

    return [
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          )),
      const Divider(),
    ];
  }

  List<Widget> _buildDiscountItemByItemDetails() {
    final List<Widget> widgets = [
      const Text(
        "Discount Item (Item)",
        style: TextStyle(fontWeight: FontWeight.w700, color: ProjectColors.primary, fontSize: 16),
      ),
      const SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> discountItemByItemPromos =
        widget.receiptEntity.promos.where((element) => element.promoType == 203).toList();
    if (discountItemByItemPromos.isEmpty) return [];

    widgets.addAll([
      const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 345,
            child: Text(
              "Description",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ProjectColors.lightBlack,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Text("Discount",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ProjectColors.lightBlack,
                  ))),
        ],
      ),
      const SizedBox(
        height: 5,
      )
    ]);

    double totalDisc = 0;

    for (final discountItemByItemPromo in discountItemByItemPromos) {
      final List<ReceiptItemEntity> appliedItems = widget.receiptEntity.receiptItems
          .where((e1) => e1.promos
              .where((e2) => e2.promoId == discountItemByItemPromo.promoId && (e2.discAmount ?? 0) != 0)
              .isNotEmpty)
          .toList();
      final double totalDiscByPromoId = appliedItems.map((e1) {
        final double discAmount =
            e1.promos.where((e2) => e2.promoId == discountItemByItemPromo.promoId).first.discAmount ?? 0;

        return e1.itemEntity.includeTax == 1 ? discAmount * (100 + e1.itemEntity.taxRate) / 100 : discAmount;
      }).reduce((value, e3) => value + e3);

      totalDisc += totalDiscByPromoId;
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 345,
                  child: Text(
                    discountItemByItemPromo.promoDescription,
                    style: const TextStyle(fontSize: 14),
                  )),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 150,
                  child: Text(
                    Helpers.parseMoney(totalDiscByPromoId.round()),
                    style: const TextStyle(fontSize: 14),
                  )),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ));
    }
    widgets.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            const SizedBox(
                width: 345,
                child: Text(
                  "Total Discount",
                  style: TextStyle(fontSize: 14),
                )),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Text(
                  Helpers.parseMoney(totalDisc.round()),
                  style: const TextStyle(fontSize: 14),
                )),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    ));

    return [
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          )),
      const Divider(),
    ];
  }

  List<Widget> _buildDiscountItemByGroupDetails() {
    final List<Widget> widgets = [
      const Text(
        "Discount Item (Group)",
        style: TextStyle(fontWeight: FontWeight.w700, color: ProjectColors.primary, fontSize: 16),
      ),
      const SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> discountItemByItemPromos =
        widget.receiptEntity.promos.where((element) => element.promoType == 204).toList();
    if (discountItemByItemPromos.isEmpty) return [];

    widgets.addAll([
      const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 345,
            child: Text(
              "Description",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ProjectColors.lightBlack,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Text("Discount",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ProjectColors.lightBlack,
                  ))),
        ],
      ),
      const SizedBox(
        height: 5,
      )
    ]);

    double totalDisc = 0;
    for (final discountItemByItemPromo in discountItemByItemPromos) {
      final List<ReceiptItemEntity> appliedItems = widget.receiptEntity.receiptItems
          .where((e1) => e1.promos
              .where((e2) => e2.promoId == discountItemByItemPromo.promoId && (e2.discAmount ?? 0) != 0)
              .isNotEmpty)
          .toList();
      final double totalDiscByPromoId = appliedItems.map((e1) {
        final double discAmount =
            e1.promos.where((e2) => e2.promoId == discountItemByItemPromo.promoId).first.discAmount ?? 0;

        return e1.itemEntity.includeTax == 1 ? discAmount * (100 + e1.itemEntity.taxRate) / 100 : discAmount;
      }).reduce((value, e3) => value + e3);
      totalDisc += totalDiscByPromoId;
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 345,
                  child: Text(
                    discountItemByItemPromo.promoDescription,
                    style: const TextStyle(fontSize: 14),
                  )),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 150,
                  child: Text(
                    Helpers.parseMoney(totalDiscByPromoId.round()),
                    style: const TextStyle(fontSize: 14),
                  )),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ));
    }

    widgets.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
                width: 345,
                child: Text(
                  "Total Discount",
                  style: TextStyle(fontSize: 14),
                )),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Text(
                  Helpers.parseMoney(totalDisc.round()),
                  style: const TextStyle(fontSize: 14),
                )),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    ));

    return [
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          )),
      const Divider(),
    ];
  }

  @override
  void initState() {
    super.initState();
    log("init promotion");
    FocusManager.instance.primaryFocus?.unfocus();

    _keyboardListenerFocusNode.requestFocus();

    _keyboardListenerFocusNode.addListener(() {
      if (!_keyboardListenerFocusNode.hasFocus) {
        _keyboardListenerFocusNode.requestFocus();
        setState(() {});
      }
    });
    previousGrandTotal = widget.receiptEntity.previousReceiptEntity!.grandTotal;
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
      focusNode: _keyboardListenerFocusNode,
      onKeyEvent: (node, event) {
        log("masuk applied $event");
        if (event.runtimeType == KeyUpEvent) {
          return KeyEventResult.handled;
        }

        if (event.physicalKey == PhysicalKeyboardKey.f12) {
          log("masuk applied f12");

          context.pop(true);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Container(
          decoration: const BoxDecoration(
            color: ProjectColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: const Text(
            'Promotion Check',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Text(
                        "Previous Grand Total",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 150,
                      alignment: Alignment.centerRight,
                      child: Text(
                        Helpers.parseMoney(previousGrandTotal),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Text(
                        "Promotions & Tax Adjustment",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 150,
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.receiptEntity.grandTotal - previousGrandTotal >= 0
                            ? Helpers.parseMoney(widget.receiptEntity.grandTotal - previousGrandTotal)
                            : "(${Helpers.parseMoney(widget.receiptEntity.grandTotal - previousGrandTotal)})",
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Text(
                        "Final Grand Total",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 150,
                        alignment: Alignment.centerRight,
                        child: Text(
                          Helpers.parseMoney(widget.receiptEntity.grandTotal),
                          style: const TextStyle(fontSize: 14),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Applied Promotions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Divider(),
                ..._buildBuyXGetYDetails(),
                const SizedBox(
                  height: 5,
                ),
                ..._buildDiscountItemByItemDetails(),
                const SizedBox(
                  height: 5,
                ),
                ..._buildDiscountItemByGroupDetails(),
              ],
            ),
          ),
        ),

        // contentPadding: const EdgeInsets.symmetric(
        //     horizontal: 20, vertical: 5),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                onPressed: () {
                  context.pop(true);
                },
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Done",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        // TextSpan(
                        //   text: "  (F12)",
                        //   style: TextStyle(fontWeight: FontWeight.w300),
                        // ),
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
    );
  }
}
