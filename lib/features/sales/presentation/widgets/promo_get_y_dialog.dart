import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/loop_tracker.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_header.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';

import '../cubit/receipt_cubit.dart';

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
  List<PromoBuyXGetYGetConditionAndItemEntity> displayedItemYs = [];
  PromoBuyXGetYGetConditionAndItemEntity? radioValue;
  List<PromoBuyXGetYGetConditionAndItemEntity> selectedItemYs = [];
  final ScrollController _scrollController = ScrollController();
  late bool isAndYCondition;
  late double remainingQty;
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  late final FocusNode _searchInputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    isAndYCondition = widget.toprb.getCondition == 1;
    remainingQty = isAndYCondition ? 0 : widget.toprb.maxGet;
    selectedItemYs = isAndYCondition ? widget.conditionAndItemYs : [];
    displayedItemYs = widget.conditionAndItemYs;
    _searchInputFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  void searchItemYs() {
    displayedItemYs = widget.conditionAndItemYs
        .where((element) =>
            element.itemEntity.itemName.contains(RegExp('${_textEditingController.text}', caseSensitive: false)) ||
            element.itemEntity.itemCode.contains(RegExp('${_textEditingController.text}', caseSensitive: false)) ||
            element.itemEntity.barcode.contains(RegExp('${_textEditingController.text}', caseSensitive: false)))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      focusNode: _keyboardListenerFocusNode,
      onKeyEvent: (node, event) {
        final List<PhysicalKeyboardKey> alphanumericKeys = [
          PhysicalKeyboardKey.keyA,
          PhysicalKeyboardKey.keyB,
          PhysicalKeyboardKey.keyC,
          PhysicalKeyboardKey.keyD,
          PhysicalKeyboardKey.keyE,
          PhysicalKeyboardKey.keyF,
          PhysicalKeyboardKey.keyG,
          PhysicalKeyboardKey.keyH,
          PhysicalKeyboardKey.keyI,
          PhysicalKeyboardKey.keyJ,
          PhysicalKeyboardKey.keyK,
          PhysicalKeyboardKey.keyL,
          PhysicalKeyboardKey.keyM,
          PhysicalKeyboardKey.keyN,
          PhysicalKeyboardKey.keyO,
          PhysicalKeyboardKey.keyP,
          PhysicalKeyboardKey.keyQ,
          PhysicalKeyboardKey.keyR,
          PhysicalKeyboardKey.keyS,
          PhysicalKeyboardKey.keyT,
          PhysicalKeyboardKey.keyU,
          PhysicalKeyboardKey.keyV,
          PhysicalKeyboardKey.keyW,
          PhysicalKeyboardKey.keyX,
          PhysicalKeyboardKey.keyY,
          PhysicalKeyboardKey.keyZ,
          PhysicalKeyboardKey.digit0,
          PhysicalKeyboardKey.digit1,
          PhysicalKeyboardKey.digit2,
          PhysicalKeyboardKey.digit3,
          PhysicalKeyboardKey.digit4,
          PhysicalKeyboardKey.digit5,
          PhysicalKeyboardKey.digit6,
          PhysicalKeyboardKey.digit7,
          PhysicalKeyboardKey.digit8,
          PhysicalKeyboardKey.digit9,
          PhysicalKeyboardKey.numpad0,
          PhysicalKeyboardKey.numpad1,
          PhysicalKeyboardKey.numpad2,
          PhysicalKeyboardKey.numpad3,
          PhysicalKeyboardKey.numpad4,
          PhysicalKeyboardKey.numpad5,
          PhysicalKeyboardKey.numpad6,
          PhysicalKeyboardKey.numpad7,
          PhysicalKeyboardKey.numpad8,
          PhysicalKeyboardKey.numpad9,
        ];

        if (event.runtimeType == KeyUpEvent) {
          return KeyEventResult.handled;
        }

        if (event.physicalKey == PhysicalKeyboardKey.f12) {
          if (selectedItemYs.isNotEmpty && remainingQty >= 0) {
            context.pop(selectedItemYs);
          }
          // context.pop(true);
          return KeyEventResult.handled;
        } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
          context.pop(<PromoBuyXGetYGetConditionAndItemEntity>[]);
          return KeyEventResult.handled;
        } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown) {
          node.nextFocus();
          return KeyEventResult.handled;
        } else if (event.physicalKey == PhysicalKeyboardKey.arrowUp) {
          node.previousFocus();
          return KeyEventResult.handled;
        } else if (alphanumericKeys.contains(event.physicalKey)) {
          _searchInputFocusNode.requestFocus();
          return KeyEventResult.skipRemainingHandlers;
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
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Promo Buy X Get Y',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              Text(
                '${widget.loopTracker.currentLoop}/${widget.loopTracker.totalLoop}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
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
            // color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      ExcludeFocus(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Get Items (${isAndYCondition ? "AND" : "OR"})",
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
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
                                      const Text(
                                        "Remaining Get Qty.",
                                        style:
                                            TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Helpers.cleanDecimal(remainingQty, 5),
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          controller: _textEditingController,
                          onSubmitted: (value) {
                            // log("value - $value");
                            try {
                              if (context.read<ReceiptCubit>().state.customerEntity == null) throw "Customer required";

                              log(_textEditingController.text);
                              searchItemYs();
                              log("displayedItemYs");
                              log(displayedItemYs.toString());

                              if (_scrollController.hasClients) {
                                Future.delayed(const Duration(milliseconds: 300)).then((value) {
                                  SchedulerBinding.instance.addPostFrameCallback((_) {
                                    _scrollController.animateTo(_scrollController.position.minScrollExtent,
                                        duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                                  });
                                });
                              }

                              _searchInputFocusNode.requestFocus();
                            } catch (e) {
                              SnackBarHelper.presentErrorSnackBar(context, e.toString());
                            }
                          },
                          autofocus: true,
                          focusNode: _searchInputFocusNode,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              size: 16,
                            ),
                            hintText: "Enter item name, code, or barcode",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            // isCollapsed: true,
                            // contentPadding:
                            //     EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: SingleChildScrollView(
                    child: Column(
                        children: ([
                      ...displayedItemYs.asMap().entries.map((entry) {
                        final PromoBuyXGetYGetConditionAndItemEntity conditionAndItemY = entry.value;
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
                                        selectedItemYs = [...selectedItemYs, conditionAndItemY];

                                        remainingQty -= conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity;
                                      } else {
                                        selectedItemYs = selectedItemYs
                                            .where((element) =>
                                                element.itemEntity.barcode != conditionAndItemY.itemEntity.barcode)
                                            .toList();
                                        remainingQty += conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity;
                                      }
                                      setState(() {});
                                    },
                              title:
                                  Text(conditionAndItemY.itemEntity.shortName ?? conditionAndItemY.itemEntity.itemName),
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
                                          conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity, 5),
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
                                      "Rp ${Helpers.parseMoney((conditionAndItemY.itemEntity.includeTax == 1 ? conditionAndItemY.promoBuyXGetYGetConditionEntity.sellingPrice : conditionAndItemY.promoBuyXGetYGetConditionEntity.sellingPrice * (100 / (100 + conditionAndItemY.itemEntity.taxRate))).round())}",
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
                    ])),
                  ),
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: ProjectColors.primary))),
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
                    onPressed: () {
                      context.pop(<PromoBuyXGetYGetConditionAndItemEntity>[]);
                    },
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Skip",
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
                  flex: 2,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith((states) =>
                            selectedItemYs.isNotEmpty && remainingQty >= 0 ? ProjectColors.primary : Colors.grey),
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                    onPressed: selectedItemYs.isNotEmpty && remainingQty >= 0
                        ? () {
                            context.pop(selectedItemYs);
                          }
                        : () {},
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
