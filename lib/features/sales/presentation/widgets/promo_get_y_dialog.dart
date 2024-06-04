import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/loop_tracker.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_header.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';

class PromoGetYDialog extends StatefulWidget {
  const PromoGetYDialog({
    super.key,
    required this.conditionAndItemYs,
    required this.toprb,
    required this.loopTracker,
  });

  final List<PromoBuyXGetYGetConditionAndItemEntity> conditionAndItemYs;
  final PromoBuyXGetYHeaderEntity toprb;
  final LoopTracker loopTracker;

  @override
  State<PromoGetYDialog> createState() => _PromoGetYDialog();
}

class _PromoGetYDialog extends State<PromoGetYDialog> {
  PromoBuyXGetYGetConditionAndItemEntity? radioValue;
  List<PromoBuyXGetYGetConditionAndItemEntity> selectedItemYs = [];
  final ScrollController _scrollController = ScrollController();
  late bool isAndYCondition;
  late double remainingQty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAndYCondition = widget.toprb.getCondition == 1;
    remainingQty = isAndYCondition ? 0 : widget.toprb.maxGet;
    selectedItemYs = isAndYCondition ? widget.conditionAndItemYs : [];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Promo Buy X Get Y',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Text(
              '${widget.loopTracker.currentLoop}/${widget.loopTracker.totalLoop}',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: Theme(
        data: ThemeData(
          splashColor: const Color.fromARGB(40, 169, 0, 0),
          highlightColor: const Color.fromARGB(40, 169, 0, 0),
          colorScheme: ColorScheme.fromSeed(seedColor: ProjectColors.primary),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 0.65,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Get Items (${isAndYCondition ? "AND" : "OR"})",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: remainingQty > 0
                                ? const Color.fromARGB(255, 47, 143, 8)
                                : remainingQty == 0
                                    ? Colors.grey
                                    : ProjectColors.primary,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Remaining Get Qty.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                Helpers.cleanDecimal(remainingQty, 5),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                )
              ],
              ...widget.conditionAndItemYs.asMap().entries.map((entry) {
                int index = entry.key;
                final PromoBuyXGetYGetConditionAndItemEntity conditionAndItemY =
                    entry.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile.adaptive(
                      value: isAndYCondition
                          ? true
                          : selectedItemYs
                              .map((e) => e.itemEntity.barcode)
                              .contains(conditionAndItemY.itemEntity.barcode),
                      onChanged: isAndYCondition
                          ? (checked) {}
                          : (checked) {
                              if (checked!) {
                                selectedItemYs = [
                                  ...selectedItemYs,
                                  conditionAndItemY
                                ];

                                remainingQty -= conditionAndItemY
                                    .promoBuyXGetYGetConditionEntity.quantity;
                              } else {
                                selectedItemYs = selectedItemYs
                                    .where((element) =>
                                        element.itemEntity.barcode !=
                                        conditionAndItemY.itemEntity.barcode)
                                    .toList();
                                remainingQty += conditionAndItemY
                                    .promoBuyXGetYGetConditionEntity.quantity;
                              }
                              setState(() {});
                            },
                      title: Text(conditionAndItemY.itemEntity.itemName),
                      subtitle: SizedBox(
                        height: 25,
                        child: Row(
                          children: [
                            const Text(
                              "Quantity",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              Helpers.cleanDecimal(
                                  conditionAndItemY
                                      .promoBuyXGetYGetConditionEntity.quantity,
                                  5),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            const Text(
                              "Selling Price",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Rp ${Helpers.parseMoney((conditionAndItemY.itemEntity.includeTax == 1 ? conditionAndItemY.promoBuyXGetYGetConditionEntity.sellingPrice * (100 / (100 + conditionAndItemY.itemEntity.taxRate)) : conditionAndItemY.promoBuyXGetYGetConditionEntity.sellingPrice).round())}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Color.fromARGB(100, 118, 118, 118),
                    ),
                  ],
                );
              }).toList()
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            if (!isAndYCondition) ...[
              Expanded(
                  flex: 1,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                                color: ProjectColors.primary))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.black.withOpacity(.2))),
                    onPressed: () {
                      context.pop(<PromoBuyXGetYGetConditionAndItemEntity>[]);
                    },
                    child: const Center(
                        child: Text(
                      "Skip",
                      style: TextStyle(color: ProjectColors.primary),
                    )),
                  )),
              const SizedBox(
                width: 10,
              ),
            ],
            Expanded(
                flex: 2,
                child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) =>
                              selectedItemYs.isNotEmpty && remainingQty >= 0
                                  ? ProjectColors.primary
                                  : Colors.grey),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white.withOpacity(.2))),
                  onPressed: selectedItemYs.isNotEmpty && remainingQty >= 0
                      ? () {
                          context.pop(selectedItemYs);
                        }
                      : () {},
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
