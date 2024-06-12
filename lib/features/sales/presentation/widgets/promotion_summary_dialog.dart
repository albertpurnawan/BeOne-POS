import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/promotion_detail.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class PromotionSummaryDialog extends StatelessWidget {
  PromotionSummaryDialog({super.key, required this.receiptEntity});

  final ReceiptEntity receiptEntity;
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  List<Widget> _buildBuyXGetYDetails() {
    final List<Widget> widgets = [
      const Text(
        "Buy X Get Y",
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ProjectColors.primary,
            fontSize: 16),
      ),
      SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> buyXGetYpromos = receiptEntity.promos
        .where((element) => element.promoType == 103)
        .toList();
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
      SizedBox(
        height: 5,
      )
    ]);

    double subtotal = 0;
    double taxAmount = 0;
    double totalPrice = 0;

    for (final buyXGetYpromo in buyXGetYpromos) {
      final List<ReceiptItemEntity> itemYs = receiptEntity.receiptItems
          .where((e1) => e1.promos
              .where((e2) =>
                  e2.promoId == buyXGetYpromo.promoId &&
                  (e2.promotionDetails as PromoBuyXGetYDetails).isY)
              .isNotEmpty)
          .toList();
      final List<Widget> itemYUIs = [];

      for (final itemY in itemYs) {
        final PromoBuyXGetYDetails associatedPromo = itemY.promos
            .firstWhere((element) => element.promoId == buyXGetYpromo.promoId)
            .promotionDetails as PromoBuyXGetYDetails;

        final priceQty =
            associatedPromo.sellingPrice * associatedPromo.quantity;
        subtotal += priceQty;
        taxAmount += (itemY.itemEntity.taxRate / 100) * priceQty;

        itemYUIs.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 175,
                child: itemYUIs.length == 0
                    ? Text(
                        buyXGetYpromo.promoDescription,
                        style: const TextStyle(fontSize: 14),
                      )
                    : SizedBox.shrink()),
            SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Text(
                  itemY.itemEntity.barcode,
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Text(
                  itemY.itemEntity.itemName,
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      Helpers.cleanDecimal(associatedPromo.quantity, 3),
                      style: const TextStyle(fontSize: 14),
                    ))),
            SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      Helpers.parseMoney(associatedPromo.sellingPrice.round()),
                      style: const TextStyle(fontSize: 14),
                    ))),
            SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 150,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      Helpers.parseMoney(priceQty.round()),
                      style: const TextStyle(fontSize: 14),
                    ))),
          ],
        ));
        itemYUIs.add(SizedBox(
          height: 10,
        ));
      }

      widgets.addAll(itemYUIs);
    }

    totalPrice = subtotal + taxAmount;

    widgets.addAll([
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 80,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Subtotal",
                  style: const TextStyle(fontSize: 14),
                )),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    Helpers.parseMoney(subtotal.round()),
                    style: const TextStyle(fontSize: 14),
                  ))),
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 80,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total Tax",
                  style: const TextStyle(fontSize: 14),
                )),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 150,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    Helpers.parseMoney(taxAmount.round()),
                    style: const TextStyle(fontSize: 14),
                  ))),
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 80,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total Price",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                )),
          ),
          SizedBox(
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
      SizedBox(
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
      Divider(),
    ];
  }

  List<Widget> _buildDiscountItemByItemDetails() {
    final List<Widget> widgets = [
      const Text(
        "Discount Item (Item)",
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ProjectColors.primary,
            fontSize: 16),
      ),
      SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> discountItemByItemPromos = receiptEntity.promos
        .where((element) => element.promoType == 203)
        .toList();
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
      SizedBox(
        height: 5,
      )
    ]);

    double totalDisc = 0;

    for (final discountItemByItemPromo in discountItemByItemPromos) {
      final List<ReceiptItemEntity> appliedItems = receiptEntity.receiptItems
          .where((e1) => e1.promos
              .where((e2) =>
                  e2.promoId == discountItemByItemPromo.promoId &&
                  (e2.discAmount ?? 0) != 0)
              .isNotEmpty)
          .toList();
      final double totalDiscByPromoId = appliedItems
          .map((e1) =>
              e1.promos
                  .where((e2) => e2.promoId == discountItemByItemPromo.promoId)
                  .first
                  .discAmount ??
              0)
          .reduce((value, e3) => value + e3);

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
              SizedBox(
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
          SizedBox(
            height: 5,
          ),
        ],
      ));
    }
    widgets.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            SizedBox(
                width: 345,
                child: Text(
                  "Total Discount",
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(
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
        SizedBox(
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
      Divider(),
    ];
  }

  List<Widget> _buildDiscountItemByGroupDetails() {
    final List<Widget> widgets = [
      const Text(
        "Discount Item (Group)",
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ProjectColors.primary,
            fontSize: 16),
      ),
      SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> discountItemByItemPromos = receiptEntity.promos
        .where((element) => element.promoType == 204)
        .toList();
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
      SizedBox(
        height: 5,
      )
    ]);

    double totalDisc = 0;
    for (final discountItemByItemPromo in discountItemByItemPromos) {
      final List<ReceiptItemEntity> appliedItems = receiptEntity.receiptItems
          .where((e1) => e1.promos
              .where((e2) =>
                  e2.promoId == discountItemByItemPromo.promoId &&
                  (e2.discAmount ?? 0) != 0)
              .isNotEmpty)
          .toList();
      final double totalDiscByPromoId = appliedItems
          .map((e1) =>
              e1.promos
                  .where((e2) => e2.promoId == discountItemByItemPromo.promoId)
                  .first
                  .discAmount ??
              0)
          .reduce((value, e3) => value + e3);
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
              SizedBox(
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
          SizedBox(
            height: 5,
          ),
        ],
      ));
    }

    widgets.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 345,
                child: Text(
                  "Total Discount",
                  style: const TextStyle(fontSize: 14),
                )),
            SizedBox(
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
        SizedBox(
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
      Divider(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      focusNode: _keyboardListenerFocusNode,
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent) {
          return KeyEventResult.handled;
        }

        if (event.physicalKey == PhysicalKeyboardKey.f12) {
          context.pop(true);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
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
          child: const Text(
            'Promotion Check',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
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
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Previous Grand Total",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 150,
                      alignment: Alignment.centerRight,
                      child: Text(
                        Helpers.parseMoney(
                            receiptEntity.previousReceiptEntity!.grandTotal),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Promotion Adjustment",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 150,
                      alignment: Alignment.centerRight,
                      child: Text(
                        Helpers.parseMoney(receiptEntity.grandTotal -
                            receiptEntity.previousReceiptEntity!.grandTotal),
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Final Grand Total",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 150,
                        alignment: Alignment.centerRight,
                        child: Text(
                          Helpers.parseMoney(receiptEntity.grandTotal),
                          style: const TextStyle(fontSize: 14),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Applied Promotions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Divider(),
                ..._buildBuyXGetYDetails(),
                SizedBox(
                  height: 5,
                ),
                ..._buildDiscountItemByItemDetails(),
                SizedBox(
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
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => ProjectColors.primary),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white.withOpacity(.2))),
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
                        TextSpan(
                          text: "  (F12)",
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
    );
  }
}
