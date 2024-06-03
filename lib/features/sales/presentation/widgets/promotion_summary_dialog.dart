import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class PromotionSummaryDialog extends StatelessWidget {
  const PromotionSummaryDialog({super.key, required this.receiptEntity});

  final ReceiptEntity receiptEntity;

  List<Widget> _buildBuyXGetYDetails() {
    final List<Widget> widgets = [
      const Text(
        "Buy X Get Y",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> buyXGetYpromos = receiptEntity.promos
        .where((element) => element.promoType == 103)
        .toList();
    if (buyXGetYpromos.isEmpty) return [];

    for (final buyXGetYpromo in buyXGetYpromos) {
      final List<ReceiptItemEntity> itemYs = receiptEntity.receiptItems
          .where((e1) => e1.promos
              .where((e2) =>
                  e2.promoId == buyXGetYpromo.promoId &&
                  (e2.discAmount ?? 0) != 0)
              .isNotEmpty)
          .toList();
      final List<Widget> itemYUIs = [];

      for (final itemY in itemYs) {
        itemYUIs.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 250,
                child: itemYUIs.length == 0
                    ? Text(buyXGetYpromo.promoDescription)
                    : SizedBox.shrink()),
            SizedBox(
              width: 20,
            ),
            SizedBox(width: 150, child: Text(itemY.itemEntity.barcode)),
            SizedBox(
              width: 20,
            ),
            SizedBox(width: 150, child: Text(itemY.itemEntity.itemName)),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(itemY.quantity.toString()))),
          ],
        ));
        itemYUIs.add(SizedBox(
          height: 10,
        ));
      }

      widgets.addAll(itemYUIs);
    }

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
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> discountItemByItemPromos = receiptEntity.promos
        .where((element) => element.promoType == 203)
        .toList();
    if (discountItemByItemPromos.isEmpty) return [];

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
                  width: 250,
                  child: Text(discountItemByItemPromo.promoDescription)),
              SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 150,
                  child: Text(Helpers.parseMoney(totalDiscByPromoId))),
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
            SizedBox(width: 250, child: Text("Total Discount")),
            SizedBox(
              width: 20,
            ),
            SizedBox(width: 150, child: Text(Helpers.parseMoney(totalDisc))),
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
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      SizedBox(
        height: 15,
      ),
    ];

    final List<PromotionsEntity> discountItemByItemPromos = receiptEntity.promos
        .where((element) => element.promoType == 204)
        .toList();
    if (discountItemByItemPromos.isEmpty) return [];

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
                  width: 250,
                  child: Text(discountItemByItemPromo.promoDescription)),
              SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 150,
                  child: Text(Helpers.parseMoney(totalDiscByPromoId))),
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
            SizedBox(width: 250, child: Text("Total Discount")),
            SizedBox(
              width: 20,
            ),
            SizedBox(width: 150, child: Text(Helpers.parseMoney(totalDisc))),
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
    return AlertDialog(
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
        width: MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: Text("Previous Grand Total"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(Helpers.parseMoney(
                      receiptEntity.previousReceiptEntity!.grandTotal)),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: Text("Promotion Adjustment"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(Helpers.parseMoney(receiptEntity.grandTotal -
                      receiptEntity.previousReceiptEntity!.grandTotal))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      "Final Grand Total",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(Helpers.parseMoney(receiptEntity.grandTotal)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Applied Promotions",
                style: TextStyle(fontSize: 18),
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
              child: const Center(
                  child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              )),
            )),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    );
  }
}
