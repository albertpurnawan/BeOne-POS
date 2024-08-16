// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/presentation/cubit/customers_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/items_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/invoice_details_dialog.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/item_details_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/checkout_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/input_coupons_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/item_search_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/promotion_summary_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/queue_list_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_customer_dialog.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({
    Key? key,
    required this.salesViewType,
    this.onFirstBuild,
  }) : super(key: key);
  final int salesViewType;
  final Function(BuildContext)? onFirstBuild;

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  // =================================================
  //             [START] Variables
  // =================================================

  // States for handling focus
  ReceiptItemEntity? activeReceiptItem;
  bool isEditingNewReceiptItemCode = true;
  bool isEditingNewReceiptItemQty = false;
  List<int> indexIsSelect = [-1, 0];
  bool isUpdatingReceiptItemQty = false;
  bool isEditingReceiptItemQty = false;
  bool isNewItemAdded = false;
  late int salesViewType;

  // States for handling current time
  late Timer _timer;
  ValueNotifier<String> currentTime = ValueNotifier<String>(DateFormat.Hms().format(DateTime.now()));

  // Scroll Controllers
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();
  final ScrollController _scrollControllerMain = ScrollController();
  final ScrollController _scrollControllerReceiptItems = ScrollController();
  final ScrollController _scrollControllerReceiptSummary = ScrollController();

  // Focus Nodes
  late final FocusNode _newReceiptItemQuantityFocusNode = FocusNode(
    skipTraversal: true,
    descendantsAreFocusable: false,
    descendantsAreTraversable: false,
    onKeyEvent: (node, event) {
      final ReceiptEntity state = context.read<ReceiptCubit>().state;

      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.skipRemainingHandlers;
      }

      if (event.physicalKey == PhysicalKeyboardKey.arrowUp &&
          (indexIsSelect[0] > 0 || (indexIsSelect[1] == 0 && state.receiptItems.length - 1 > 0))) {
        setState(() {
          indexIsSelect = [indexIsSelect[1] == 1 ? indexIsSelect[0] - 1 : state.receiptItems.length - 1, 1];
          _textEditingControllerNewReceiptItemQuantity.text = "";
          // Helpers.cleanDecimal(e.quantity, 3);
          _textEditingControllerNewReceiptItemCode.text = state.receiptItems[indexIsSelect[0]].itemEntity.barcode;
          _newReceiptItemCodeFocusNode.unfocus();
          isUpdatingReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _newReceiptItemQuantityFocusNode.requestFocus();
        });
        scrollToReceiptItemByIndex(indexIsSelect[0]);

        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown && indexIsSelect[0] < state.receiptItems.length) {
        if (indexIsSelect[1] == 0) return KeyEventResult.skipRemainingHandlers;
        setState(() {
          indexIsSelect = [indexIsSelect[0] + 1, 1];
          _textEditingControllerNewReceiptItemQuantity.text = "";
          // Helpers.cleanDecimal(e.quantity, 3);
          _textEditingControllerNewReceiptItemCode.text = state.receiptItems[indexIsSelect[0]].itemEntity.barcode;
          _newReceiptItemCodeFocusNode.unfocus();
          isUpdatingReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _newReceiptItemQuantityFocusNode.requestFocus();
        });

        scrollToReceiptItemByIndex(indexIsSelect[0]);

        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft ||
          event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        return KeyEventResult.skipRemainingHandlers;
      } else if ( // F1 is Item Attr.
          event.physicalKey == PhysicalKeyboardKey.f2 ||
              event.physicalKey == PhysicalKeyboardKey.f3 ||
              event.physicalKey == PhysicalKeyboardKey.f4 ||
              event.physicalKey == PhysicalKeyboardKey.f5 ||
              event.physicalKey == PhysicalKeyboardKey.f6 ||
              // F7 is Remove item
              event.physicalKey == PhysicalKeyboardKey.f8 ||
              event.physicalKey == PhysicalKeyboardKey.f9 ||
              // event.physicalKey == PhysicalKeyboardKey.f10 ||
              event.physicalKey == PhysicalKeyboardKey.f11 ||
              event.physicalKey == PhysicalKeyboardKey.f12) {
        if (isUpdatingReceiptItemQty) {
          setState(() {
            indexIsSelect = [-1, 0];
            _textEditingControllerNewReceiptItemQuantity.text = "1";
            _textEditingControllerNewReceiptItemCode.text = "";
            _newReceiptItemQuantityFocusNode.unfocus();
            isUpdatingReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }

        if (isEditingNewReceiptItemQty && event.physicalKey != PhysicalKeyboardKey.f6) {
          setState(() {
            isEditingNewReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
            _textEditingControllerNewReceiptItemQuantity.text = qtyToDouble == null || qtyToDouble == 0
                ? "1"
                : Helpers.cleanDecimal(double.parse(_textEditingControllerNewReceiptItemQuantity.text), 3);

            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
        return KeyEventResult.ignored;
      } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
        if (isUpdatingReceiptItemQty) {
          setState(() {
            indexIsSelect = [-1, 0];
            _textEditingControllerNewReceiptItemQuantity.text = "1";
            _textEditingControllerNewReceiptItemCode.text = "";
            _newReceiptItemQuantityFocusNode.unfocus();
            isUpdatingReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }

        if (isEditingNewReceiptItemQty && event.physicalKey != PhysicalKeyboardKey.f6) {
          setState(() {
            isEditingNewReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
            _textEditingControllerNewReceiptItemQuantity.text = qtyToDouble == null || qtyToDouble == 0
                ? "1"
                : Helpers.cleanDecimal(double.parse(_textEditingControllerNewReceiptItemQuantity.text), 3);

            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.f10) {
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );
  late final FocusNode _newReceiptItemCodeFocusNode = FocusNode(
    skipTraversal: true,
    descendantsAreFocusable: false,
    descendantsAreTraversable: false,
    onKeyEvent: (node, event) {
      final ReceiptEntity state = context.read<ReceiptCubit>().state;
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.skipRemainingHandlers;
      }

      if (event.physicalKey == PhysicalKeyboardKey.arrowUp &&
          (indexIsSelect[0] > 0 || (indexIsSelect[1] == 0 && state.receiptItems.isNotEmpty))) {
        setState(() {
          indexIsSelect = [indexIsSelect[1] == 1 ? indexIsSelect[0] - 1 : state.receiptItems.length - 1, 1];
          _textEditingControllerNewReceiptItemQuantity.text = "";
          _textEditingControllerNewReceiptItemCode.text = state.receiptItems[indexIsSelect[0]].itemEntity.barcode;
          _newReceiptItemCodeFocusNode.unfocus();
          isUpdatingReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _newReceiptItemQuantityFocusNode.requestFocus();
        });

        scrollToReceiptItemByIndex(indexIsSelect[0]);

        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown && indexIsSelect[0] < state.receiptItems.length) {
        if (indexIsSelect[1] == 0) return KeyEventResult.skipRemainingHandlers;
        setState(() {
          indexIsSelect = [indexIsSelect[0] + 1, 1];
          _textEditingControllerNewReceiptItemQuantity.text = "";
          // Helpers.cleanDecimal(e.quantity, 3);
          _textEditingControllerNewReceiptItemCode.text = state.receiptItems[indexIsSelect[0]].itemEntity.barcode;
          _newReceiptItemCodeFocusNode.unfocus();
          isUpdatingReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _newReceiptItemQuantityFocusNode.requestFocus();
        });

        scrollToReceiptItemByIndex(indexIsSelect[0]);

        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft ||
          event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.f10) {
        Future.delayed(Durations.medium1, () => _newReceiptItemCodeFocusNode.requestFocus());
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  // Text Editing Controllers
  late final TextEditingController _textEditingControllerNewReceiptItemQuantity = TextEditingController()..text = "1";
  late final TextEditingController _textEditingControllerNewReceiptItemCode = TextEditingController();

  // =================================================
  //             [END] Variables
  // =================================================

  @override
  void initState() {
    super.initState();
    // Initialize timer for time UI
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat.Hms().format(DateTime.now());
    });

    // Set Sales View Type
    salesViewType = widget.salesViewType;

    // Reset receipt if no items listed on state
    final ReceiptCubit receiptCubit = context.read<ReceiptCubit>();
    if (receiptCubit.state.receiptItems.isEmpty) context.read<ReceiptCubit>().resetReceipt();

    // Run a function (if any) on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onFirstBuild != null) widget.onFirstBuild!(context);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollControllerMain.dispose();
    _scrollControllerReceiptItems.dispose();
    _scrollControllerReceiptSummary.dispose();
    _newReceiptItemCodeFocusNode.dispose();
    _newReceiptItemQuantityFocusNode.dispose();
    _textEditingControllerNewReceiptItemCode.dispose();
    _textEditingControllerNewReceiptItemQuantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isUpdatingReceiptItemQty = indexIsSelect[1] == 1;
    isEditingReceiptItemQty = isEditingNewReceiptItemQty || isUpdatingReceiptItemQty;

    if (!Platform.isWindows) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: ProjectColors.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light));
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        // backgroundColor: Color.fromRGBO(175, 47, 47, 1),
        backgroundColor: const Color.fromARGB(255, 234, 234, 234),
        // backgroundColor: Colors.white,
        // resizeToAvoidBottomInset: false,
        body: ScrollWidget(
          controller: _scrollControllerMain,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.98,
            child: Padding(
              padding: EdgeInsets.fromLTRB(38, Platform.isWindows ? 28 : 38, 38, 10),
              child: Row(
                children: [
                  // Start - Column 1
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _receiptItemsList(),
                        SizedBox(height: salesViewType == 1 ? 20 : 0),
                        salesViewType == 1
                            ? Expanded(
                                flex: salesViewType == 1 ? 2 : 1,
                                child: Row(
                                  children: [
                                    _buttonGroup1V1(),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(flex: 4, child: _receiptItemForm())
                                  ],
                                ))
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  // End - Column 1

                  const SizedBox(
                    width: 20,
                  ),

                  // Start - Column 2
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 12,
                          child: salesViewType == 1
                              ? Column(
                                  children: [
                                    _transactionSummaryV1(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _transactionSummaryV2(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: _buttonGroup1V3(),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(flex: 2, child: _receiptItemForm()),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // Start - Numpad & ButtonGroup 2
                        Expanded(
                          flex: 8,
                          child: Row(
                            children: [
                              _numpad(),
                              const SizedBox(
                                width: 15,
                              ),
                              _buttonGroup3()
                            ],
                          ),
                        )
                        // End - Numeric Keypad & ButtonGroup 2
                      ],
                    ),
                  ),
                  // End - Column 2
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =================================================
  //             [START] Widgets
  // =================================================

  Widget _receiptItemsList() {
    return BlocBuilder<ReceiptCubit, ReceiptEntity>(
      builder: (context, state) {
        return Expanded(
          flex: 16,
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: Color.fromRGBO(195, 53, 53, 1),
                //     width: 4.0),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    color: Color.fromRGBO(197, 197, 197, 1),
                  ),
                ],
              ),
              child: Stack(children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        height: 50,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          // border: Border.all(
                          //     color: Color.fromRGBO(195, 53, 53, 1),
                          //     width: 4.0),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                          color: Color.fromRGBO(128, 0, 0, 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    height: 50,
                                    width: 120,
                                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 234, 234, 234),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(45),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 0.5,
                                          blurRadius: 10,
                                          color: Color.fromRGBO(212, 212, 212, 0.211),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      "assets/logo/ruby_pos.png",
                                      alignment: Alignment.centerLeft,
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.receipt_outlined, color: Colors.white),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        context.read<ReceiptCubit>().state.docNum,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.stars, color: Colors.white),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        child: Text(
                                          context.read<ReceiptCubit>().state.customerEntity != null
                                              ? context.read<ReceiptCubit>().state.customerEntity!.custName
                                              : " - ",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            if (state.receiptItems.isEmpty)
                              const Expanded(
                                child: EmptyList(
                                  imagePath: "assets/images/empty-item.svg",
                                  sentence: "Tadaa.. There is nothing here!\nInput item barcode to start adding item.",
                                ),
                              )
                            else
                              Expanded(
                                child: ScrollablePositionedList.builder(
                                  padding: const EdgeInsets.symmetric(vertical: 0),
                                  itemScrollController: itemScrollController,
                                  scrollOffsetController: scrollOffsetController,
                                  itemPositionsListener: itemPositionsListener,
                                  scrollOffsetListener: scrollOffsetListener,
                                  itemCount: state.receiptItems.length,
                                  itemBuilder: (context, index) {
                                    final e = state.receiptItems[index];
                                    // final hasPromos = e.promos.isNotEmpty;
                                    final test = e.promos.map(
                                      (promo) => Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            promo.promoDescription,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                          Expanded(
                                              // DiscountUI
                                              child: promo.discAmount == null || promo.discAmount == 0
                                                  ? const SizedBox.shrink()
                                                  : Text(
                                                      (e.itemEntity.includeTax == 1)
                                                          ? "${Helpers.parseMoney(((-1 * (promo.discAmount!) * ((100 + e.itemEntity.taxRate) / 100)).round()))}"
                                                          : "${Helpers.parseMoney(((promo.discAmount! * -1).round()))}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.right,
                                                    )),
                                        ],
                                      ),
                                    );

                                    return TapRegion(
                                      groupId: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => setState(() {
                                          if (indexIsSelect[0] == index) {
                                            indexIsSelect = [-1, 0];
                                            _textEditingControllerNewReceiptItemQuantity.text = "1";
                                            _textEditingControllerNewReceiptItemCode.text = "";
                                            _newReceiptItemQuantityFocusNode.unfocus();
                                            isUpdatingReceiptItemQty = false;
                                            isEditingNewReceiptItemCode = true;
                                            _newReceiptItemCodeFocusNode.requestFocus();
                                          } else {
                                            indexIsSelect = [index, 1];
                                            _textEditingControllerNewReceiptItemQuantity.text = "";
                                            // Helpers.cleanDecimal(e.quantity, 3);
                                            _textEditingControllerNewReceiptItemCode.text = e.itemEntity.barcode;
                                            _newReceiptItemCodeFocusNode.unfocus();
                                            isUpdatingReceiptItemQty = true;
                                            isEditingNewReceiptItemCode = false;
                                            _newReceiptItemQuantityFocusNode.requestFocus();
                                          }
                                        }),
                                        child: Column(
                                          children: [
                                            if (index == 0)
                                              const Column(
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    thickness: 0.5,
                                                    color: Color.fromARGB(100, 118, 118, 117),
                                                  ),
                                                ],
                                              ),
                                            AnimatedContainer(
                                              duration: index == indexIsSelect[0] && indexIsSelect[1] == 1
                                                  ? Duration.zero
                                                  : const Duration(milliseconds: 200),
                                              padding: const EdgeInsets.all(0),
                                              color: index == indexIsSelect[0] && indexIsSelect[1] == 1
                                                  ? const Color.fromARGB(255, 255, 222, 222)
                                                  : isNewItemAdded && (index == state.receiptItems.length - 1)
                                                      ? const Color.fromARGB(95, 100, 202, 122)
                                                      : Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        (index + 90).toString(),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 6,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                flex: 3,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    FittedBox(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Row(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                            "assets/images/inventory.svg",
                                                                            height: 16,
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Text(
                                                                            e.itemEntity.itemCode,
                                                                            style: const TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 15,
                                                                          ),
                                                                          SvgPicture.asset(
                                                                            "assets/images/barcode.svg",
                                                                            height: 20,
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Text(
                                                                            e.itemEntity.barcode,
                                                                            style: const TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      e.itemEntity.shortName ?? e.itemEntity.itemName,
                                                                      style: const TextStyle(
                                                                          fontSize: 16, fontWeight: FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Column(
                                                                  // QuantityUI
                                                                  children: [
                                                                    Text(
                                                                      "${Helpers.cleanDecimal(e.quantity, 3)} x",
                                                                      textAlign: TextAlign.right,
                                                                      style: const TextStyle(
                                                                          fontSize: 16, fontWeight: FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Column(
                                                                  // PriceUI
                                                                  children: [
                                                                    Text(
                                                                      "@ ${Helpers.parseMoney((e.sellingPrice).round())}",
                                                                      textAlign: TextAlign.right,
                                                                      style: const TextStyle(
                                                                          fontSize: 16, fontWeight: FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  // TotalPriceUI
                                                                  children: [
                                                                    Text(
                                                                      Helpers.parseMoney(
                                                                          (e.sellingPrice * e.quantity).round()),
                                                                      style: const TextStyle(
                                                                          fontSize: 16, fontWeight: FontWeight.w500),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 6,
                                                                    ),
                                                                    e.tohemId != null || state.salesTohemId != null
                                                                        ? FutureBuilder(
                                                                            future: getSalesPerson(
                                                                                e.tohemId, state.salesTohemId),
                                                                            builder: (context, snapshot) {
                                                                              if (snapshot.hasData) {
                                                                                return Text(
                                                                                  snapshot.data?.empName ?? "",
                                                                                  textAlign: TextAlign.right,
                                                                                  style: const TextStyle(
                                                                                      height: 1,
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w500),
                                                                                );
                                                                              } else {
                                                                                return const SizedBox.shrink();
                                                                              }
                                                                            })
                                                                        : const SizedBox.shrink(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // SHOW PROMO HERE
                                                          ...test,
                                                        ],
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
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: 20,
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: const BoxDecoration(
                              // border: Border.all(
                              //     color: Color.fromRGBO(195, 53, 53, 1),
                              //     width: 4.0),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),

                              color: Colors.grey,
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, 0.248),
                                ),
                              ],
                            ),
                            child: const Text(
                              "Total Qty.",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ))
              ])),
        );
      },
    );
    // End - Item List
  }

  Widget _receiptItemForm() {
    return FocusScope(
      autofocus: true,
      child: Container(
          decoration: BoxDecoration(
            color: indexIsSelect[1] == 1 ? const Color.fromARGB(20, 169, 0, 0) : Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                spreadRadius: 0.5,
                blurRadius: 5,
                color: Color.fromRGBO(220, 220, 220, 1),
              )
            ],
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 25,
                width: double.infinity,
                decoration: const BoxDecoration(
                  // border: Border.all(
                  //     color: Color.fromRGBO(195, 53, 53, 1),
                  //     width: 4.0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  color: ProjectColors.primary,
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "Qty",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Text(
                          "Item Code",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              20, 0, 20, (isEditingNewReceiptItemQty || isUpdatingReceiptItemQty) ? 10 : 0),
                          child: Center(
                            child: (isEditingNewReceiptItemQty || isUpdatingReceiptItemQty)
                                ? SizedBox(
                                    height: 40,
                                    child: KeyboardListener(
                                      onKeyEvent: (event) => handlePhysicalKeyboard(
                                          event,
                                          _textEditingControllerNewReceiptItemQuantity,
                                          _newReceiptItemQuantityFocusNode,
                                          true,
                                          context),
                                      focusNode: FocusNode(
                                        canRequestFocus: false,
                                      ),
                                      child: TextField(
                                        // readOnly: !isEditingReceiptItemQty,
                                        focusNode: _newReceiptItemQuantityFocusNode,
                                        controller: _textEditingControllerNewReceiptItemQuantity,
                                        enableInteractiveSelection: false,
                                        // showCursor: false,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.none,
                                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                                        decoration: const InputDecoration(
                                            isCollapsed: true, contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      _textEditingControllerNewReceiptItemQuantity.text,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: isEditingNewReceiptItemCode
                              ? KeyboardListener(
                                  onKeyEvent: (event) {
                                    handlePhysicalKeyboard(
                                      event,
                                      _textEditingControllerNewReceiptItemCode,
                                      _newReceiptItemCodeFocusNode,
                                      false,
                                      context,
                                    );
                                  },
                                  focusNode: FocusNode(
                                    canRequestFocus: false,
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      // "00000001283",
                                      // enabled: !isEditingReceiptItemQty,
                                      // readOnly: isEditingReceiptItemQty,

                                      autofocus: true,
                                      focusNode: _newReceiptItemCodeFocusNode,
                                      controller: _textEditingControllerNewReceiptItemCode,
                                      enableInteractiveSelection: false,
                                      // showCursor: false,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.none,
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                                      decoration: const InputDecoration(
                                          hintText: "Scan or Type an Item Barcode",
                                          hintStyle: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: _textEditingControllerNewReceiptItemCode.text.isEmpty
                                      ? const Text("Scan or Type an Item Barcode",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic))
                                      : Text(_textEditingControllerNewReceiptItemCode.text,
                                          textAlign: TextAlign.center, style: const TextStyle(fontSize: 24)),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buttonGroup1V1() {
    return Expanded(
      flex: 3,
      child: ExcludeFocus(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: () async {
                            // await context.read<ReceiptCubit>().resetReceipt();
                            setState(() {});
                            // Navigator.pop(context);
                            context.goNamed(RouteConstants.home);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            backgroundColor: ProjectColors.primary,
                            padding: const EdgeInsets.all(3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Icon(Icons.home_outlined)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<ReceiptCubit>().resetReceipt();
                          setState(() {
                            isEditingNewReceiptItemQty = false;
                            isUpdatingReceiptItemQty = false;
                            isEditingNewReceiptItemCode = true;
                            _newReceiptItemCodeFocusNode.requestFocus();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.all(3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                        ),
                        child: const Icon(Icons.remove_shopping_cart_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) => const InvoiceDetailsDialog(),
                                );
                                setState(() {
                                  isEditingNewReceiptItemCode = true;
                                  Future.delayed(const Duration(milliseconds: 50),
                                      () => _newReceiptItemCodeFocusNode.requestFocus());
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.black87,
                                padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                foregroundColor: Colors.white,
                                backgroundColor: ProjectColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                side: BorderSide.none,
                              ),
                              child: const SizedBox(
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Header Attr.",
                                      softWrap: true,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "F2",
                                          style: TextStyle(fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TapRegion(
                            groupId: 1,
                            child: OutlinedButton(
                                onPressed: indexIsSelect[1] == 0
                                    ? null
                                    : () {
                                        final ReceiptItemEntity receiptItemTarget =
                                            context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]];
                                        log("receiptTarget - $receiptItemTarget");
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ItemDetailsDialog(indexSelected: indexIsSelect[0]),
                                        ).then((value) {
                                          setState(() {
                                            indexIsSelect = [-1, 0];
                                            _textEditingControllerNewReceiptItemQuantity.text = "1";
                                            _textEditingControllerNewReceiptItemCode.text = "";
                                            _newReceiptItemQuantityFocusNode.unfocus();
                                            isUpdatingReceiptItemQty = false;
                                            isEditingNewReceiptItemCode = true;
                                            _newReceiptItemCodeFocusNode.requestFocus();
                                          });
                                        });
                                      },
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      indexIsSelect[0] == -1 ? ProjectColors.lightBlack : ProjectColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: BorderSide.none,
                                ),
                                child: const SizedBox(
                                  height: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Item Attr.",
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "F1",
                                            style: TextStyle(fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: null,
                          // onPressed: () async {
                          //   setState(() {
                          //     isEditingNewReceiptItemCode = false;
                          //     isEditingNewReceiptItemQty = false;
                          //     isUpdatingReceiptItemQty = false;
                          //   });

                          //   await showDialog(
                          //       context: context,
                          //       barrierDismissible: false,
                          //       builder: (context) => const InputCouponsDialog());

                          //   setState(() {
                          //     isEditingNewReceiptItemCode = true;
                          //     Future.delayed(
                          //         const Duration(milliseconds: 50), () => _newReceiptItemCodeFocusNode.requestFocus());
                          //   });
                          // },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.grey,
                            backgroundColor: ProjectColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Coupon",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                              ),
                              Text(
                                "F5",
                                style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isEditingNewReceiptItemCode = false;
                              isEditingNewReceiptItemQty = false;
                              isUpdatingReceiptItemQty = false;
                            });

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const QueueListDialog()).then((value) {
                              setState(() {
                                context.read<ItemsCubit>().clearItems();
                                isEditingNewReceiptItemCode = true;
                                _newReceiptItemCodeFocusNode.requestFocus();
                              });
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            backgroundColor: ProjectColors.primary,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pending Orders",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "F4",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            // Expanded(
            //   flex: 2,
            //   child: SizedBox(
            //     height: double.infinity,
            //     child: OutlinedButton(
            //       onPressed: () {
            //         context.read<ReceiptCubit>().resetReceipt();
            //         setState(() {});
            //       },
            //       style: OutlinedButton.styleFrom(
            //         elevation: 5,
            //         shadowColor: Colors.black87,
            //         backgroundColor: ProjectColors.primary,
            //         padding: const EdgeInsets.all(25),
            //         foregroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         side: BorderSide.none,
            //       ),
            //       child: SizedBox.expand(
            //         child: FittedBox(
            //           fit: BoxFit.cover,
            //           child: Icon(
            //             Icons.search,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buttonGroup1V2() {
    return Expanded(
      flex: 3,
      child: ExcludeFocus(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: () {
                            // context.read<ReceiptCubit>().resetReceipt();
                            setState(() {});
                            context.goNamed(RouteConstants.home);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            backgroundColor: ProjectColors.primary,
                            padding: const EdgeInsets.all(3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Icon(Icons.home_outlined)),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<ReceiptCubit>().resetReceipt();
                          setState(() {
                            isEditingNewReceiptItemQty = false;
                            isUpdatingReceiptItemQty = false;
                            isEditingNewReceiptItemCode = true;
                            _newReceiptItemCodeFocusNode.requestFocus();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.all(3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                        ),
                        child: const Icon(Icons.remove_shopping_cart_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) => const InvoiceDetailsDialog(),
                                );
                                setState(() {
                                  isEditingNewReceiptItemCode = true;
                                  Future.delayed(const Duration(milliseconds: 50),
                                      () => _newReceiptItemCodeFocusNode.requestFocus());
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.black87,
                                padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                foregroundColor: Colors.white,
                                backgroundColor: ProjectColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                side: BorderSide.none,
                              ),
                              child: const SizedBox(
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Header Attr.",
                                      softWrap: true,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "F2",
                                          style: TextStyle(fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TapRegion(
                            groupId: 1,
                            child: OutlinedButton(
                                onPressed: indexIsSelect[1] == 0
                                    ? null
                                    : () {
                                        final ReceiptItemEntity receiptItemTarget =
                                            context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]];
                                        log("receiptTarget - $receiptItemTarget");
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ItemDetailsDialog(indexSelected: indexIsSelect[0]),
                                        ).then((value) {
                                          setState(() {
                                            indexIsSelect = [-1, 0];
                                            _textEditingControllerNewReceiptItemQuantity.text = "1";
                                            _textEditingControllerNewReceiptItemCode.text = "";
                                            _newReceiptItemQuantityFocusNode.unfocus();
                                            isUpdatingReceiptItemQty = false;
                                            isEditingNewReceiptItemCode = true;
                                            _newReceiptItemCodeFocusNode.requestFocus();
                                          });
                                        });
                                      },
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      indexIsSelect[0] == -1 ? ProjectColors.lightBlack : ProjectColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: BorderSide.none,
                                ),
                                child: const SizedBox(
                                  height: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Item Attr.",
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "F1",
                                            style: TextStyle(fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: null,

                          // onPressed: () async {
                          //   setState(() {
                          //     isEditingNewReceiptItemCode = false;
                          //     isEditingNewReceiptItemQty = false;
                          //     isUpdatingReceiptItemQty = false;
                          //   });

                          //   await showDialog(
                          //       context: context,
                          //       barrierDismissible: false,
                          //       builder: (context) => const InputCouponsDialog());

                          //   setState(() {
                          //     isEditingNewReceiptItemCode = true;
                          //     Future.delayed(
                          //         const Duration(milliseconds: 50), () => _newReceiptItemCodeFocusNode.requestFocus());
                          //   });
                          // },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.grey,
                            backgroundColor: ProjectColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Coupon",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                              ),
                              Text(
                                "F5",
                                style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isEditingNewReceiptItemCode = false;
                              isEditingNewReceiptItemQty = false;
                              isUpdatingReceiptItemQty = false;
                            });

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const QueueListDialog()).then((value) {
                              setState(() {
                                context.read<ItemsCubit>().clearItems();
                                isEditingNewReceiptItemCode = true;
                                _newReceiptItemCodeFocusNode.requestFocus();
                              });
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            backgroundColor: ProjectColors.primary,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pending Orders",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "F4",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonGroup1V3() {
    return ExcludeFocus(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) => const InvoiceDetailsDialog(),
                            );
                            setState(() {
                              isEditingNewReceiptItemCode = true;
                              Future.delayed(
                                  const Duration(milliseconds: 50), () => _newReceiptItemCodeFocusNode.requestFocus());
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.white,
                            backgroundColor: ProjectColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                            child: Stack(
                              children: [
                                const Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "F2",
                                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Header\nAttributes",
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TapRegion(
                          groupId: 1,
                          child: OutlinedButton(
                            onPressed: indexIsSelect[1] == 0
                                ? null
                                : () {
                                    final ReceiptItemEntity receiptItemTarget =
                                        context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]];
                                    log("receiptTarget - $receiptItemTarget");
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ItemDetailsDialog(indexSelected: indexIsSelect[0]),
                                    ).then((value) {
                                      setState(() {
                                        indexIsSelect = [-1, 0];
                                        _textEditingControllerNewReceiptItemQuantity.text = "1";
                                        _textEditingControllerNewReceiptItemCode.text = "";
                                        _newReceiptItemQuantityFocusNode.unfocus();
                                        isUpdatingReceiptItemQty = false;
                                        isEditingNewReceiptItemCode = true;
                                        _newReceiptItemCodeFocusNode.requestFocus();
                                      });
                                    });
                                  },
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  indexIsSelect[0] == -1 ? ProjectColors.lightBlack : ProjectColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "F1",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14,
                                                color: indexIsSelect[0] == -1 ? Colors.grey : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Item\nAttributes",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: indexIsSelect[0] == -1 ? Colors.grey : Colors.white),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  BlocBuilder<ReceiptCubit, ReceiptEntity>(
                    builder: (context, state) {
                      return Expanded(
                        child: SizedBox.expand(
                          child: OutlinedButton(
                            onPressed: null
                            // () async {
                            //   setState(() {
                            //     isEditingNewReceiptItemCode = false;
                            //     isEditingNewReceiptItemQty = false;
                            //     isUpdatingReceiptItemQty = false;
                            //   });

                            //   await showDialog(
                            //       context: context,
                            //       barrierDismissible: false,
                            //       builder: (context) => const InputCouponsDialog());

                            //   setState(() {
                            //     isEditingNewReceiptItemCode = true;
                            //     Future.delayed(const Duration(milliseconds: 50),
                            //         () => _newReceiptItemCodeFocusNode.requestFocus());
                            //   });
                            // }
                            ,
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              foregroundColor: Colors.grey,
                              backgroundColor: ProjectColors.lightBlack,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                              child: Stack(
                                children: [
                                  const Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "F5",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300, fontSize: 14, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Coupon",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                        onPressed: () async {
                          setState(() {
                            isEditingNewReceiptItemCode = false;
                            isEditingNewReceiptItemQty = false;
                            isUpdatingReceiptItemQty = false;
                          });

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const QueueListDialog()).then((value) {
                            setState(() {
                              context.read<ItemsCubit>().clearItems();
                              isEditingNewReceiptItemCode = true;
                              _newReceiptItemCodeFocusNode.requestFocus();
                            });
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                          child: Stack(
                            children: [
                              const Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "F4",
                                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Pending\nOrders",
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   width: 5,
          // ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: OutlinedButton(
                        onPressed: () async {
                          // await context.read<ReceiptCubit>().resetReceipt();
                          setState(() {});
                          // Navigator.pop(context);
                          context.goNamed(RouteConstants.home);
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.all(3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                        ),
                        child: const Icon(Icons.home_outlined)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: SizedBox.expand(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<ReceiptCubit>().resetReceipt();
                        setState(() {
                          isEditingNewReceiptItemQty = false;
                          isUpdatingReceiptItemQty = false;
                          isEditingNewReceiptItemCode = true;
                          _newReceiptItemCodeFocusNode.requestFocus();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black87,
                        backgroundColor: ProjectColors.primary,
                        padding: const EdgeInsets.all(3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide.none,
                      ),
                      child: const Icon(Icons.remove_shopping_cart_outlined),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionSummaryV1() {
    return BlocBuilder<ReceiptCubit, ReceiptEntity>(
      builder: (context, state) {
        return Expanded(
          flex: 6,
          child: Container(
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: Color.fromRGBO(195, 53, 53, 1),
                //     width: 4.0),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    color: Color.fromRGBO(220, 220, 220, 1),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                      color: ProjectColors.primary,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.assignment_ind_outlined, color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    GetIt.instance<SharedPreferences>().getString("username") ?? "-",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  // color: Color.fromRGBO(
                                  //     71, 168, 0, 1),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.schedule, color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: currentTime,
                                    builder: (context, value, child) {
                                      return Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollControllerReceiptSummary,
                      thumbVisibility: true,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        controller: _scrollControllerReceiptSummary,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Subtotal",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                Helpers.parseMoney((state.subtotal - (state.discAmount ?? 0)).round()),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Header Discount",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "(${Helpers.parseMoney((state.discHeaderManual ?? 0).round())})",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Tax",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                Helpers.parseMoney(state.taxAmount.round()),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Rounding",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                Helpers.parseMoney(state.rounding.round()),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      thickness: 1,
                      color: Color.fromARGB(100, 118, 118, 118),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Grand Total",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          Helpers.parseMoney(state.grandTotal.round()),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buttonGroup2()
                ],
              )),
        );
      },
    );
  }

  Widget _transactionSummaryV2() {
    return BlocBuilder<ReceiptCubit, ReceiptEntity>(
      builder: (context, state) {
        return Expanded(
          flex: 4,
          child: Container(
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: Color.fromRGBO(195, 53, 53, 1),
                //     width: 4.0),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    color: Color.fromRGBO(220, 220, 220, 1),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                      color: ProjectColors.primary,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.assignment_ind_outlined, color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    GetIt.instance<SharedPreferences>().getString("username") ?? "-",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  // color: Color.fromRGBO(
                                  //     71, 168, 0, 1),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.schedule, color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: currentTime,
                                    builder: (context, value, child) {
                                      return Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Grand Total",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          Helpers.parseMoney(state.grandTotal.round()),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  (state.discHeaderManual ?? 0) > 0
                      ? Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "*${Helpers.parseMoney(state.discHeaderManual ?? 0)} header discount applied",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const Spacer(),
                  // const SizedBox(height: 15),
                  _buttonGroup2()
                ],
              )),
        );
      },
    );
  }

  Widget _buttonGroup2() {
    return SizedBox(
        // flex: 1,
        height: 50,
        child: ExcludeFocus(
          child: Row(
            children: [
              Expanded(
                child: SizedBox.expand(
                  child: OutlinedButton(
                    onPressed: () {
                      if (context.read<ReceiptCubit>().state.receiptItems.isEmpty) {
                        return SnackBarHelper.presentErrorSnackBar(context, "Receipt cannot be empty");
                      }
                      context.read<ReceiptCubit>().queueReceipt();
                      SnackBarHelper.presentSuccessSnackBar(context, "Pending order added", 3);

                      setState(() {
                        isEditingNewReceiptItemQty = false;
                        isUpdatingReceiptItemQty = false;
                        isEditingNewReceiptItemCode = true;
                        _newReceiptItemCodeFocusNode.requestFocus();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      // elevation: 5,
                      backgroundColor: ProjectColors.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          // bottomRight: Radius.circular(5),
                        ),
                      ),
                      side: BorderSide.none,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.queue_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Pending Order",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "F11",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: SizedBox.expand(
                  child: OutlinedButton(
                    onPressed: () async => await checkout(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      // elevation: 5,
                      backgroundColor: ProjectColors.green,
                      // 48, 107, 52
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                          // bottomLeft: Radius.circular(5),
                        ),
                      ),
                      side: BorderSide.none,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Checkout",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        Text(
                          "F12",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buttonGroup3() {
    return Expanded(
      flex: 2,
      child: ExcludeFocus(
        child: Column(
          children: [
            Expanded(
              child: SizedBox.expand(
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      isEditingNewReceiptItemCode = false;
                      isEditingNewReceiptItemQty = false;
                      isUpdatingReceiptItemQty = false;
                    });

                    final ItemEntity? itemEntitySearch = await showDialog<ItemEntity>(
                        context: context, barrierDismissible: false, builder: (context) => const ItemSearchDialog());

                    if (itemEntitySearch != null) {
                      await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
                          barcode: null,
                          itemEntity: itemEntitySearch,
                          quantity: double.parse(_textEditingControllerNewReceiptItemQuantity.text),
                          context: context,
                          onOpenPriceInputted: () => setState(() {
                                isEditingNewReceiptItemCode = true;
                                _newReceiptItemCodeFocusNode.requestFocus();
                              })));
                    }

                    setState(() {
                      context.read<ItemsCubit>().clearItems();
                      isEditingNewReceiptItemCode = true;
                      _newReceiptItemCodeFocusNode.requestFocus();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    elevation: 5,
                    shadowColor: Colors.black87,
                    backgroundColor: salesViewType == 1 ? ProjectColors.primary : ProjectColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "F9",
                                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Item\nSearch",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox.expand(
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      isEditingNewReceiptItemCode = false;
                      isEditingNewReceiptItemQty = false;
                      isUpdatingReceiptItemQty = false;
                    });
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const SelectCustomerDialog();
                      },
                    ).then((value) => setState(() {
                          context.read<CustomersCubit>().clearCustomers();
                          isEditingNewReceiptItemCode = true;
                          _newReceiptItemCodeFocusNode.requestFocus();
                        }));
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    elevation: 5,
                    shadowColor: Colors.black87,
                    backgroundColor: salesViewType == 1 ? ProjectColors.primary : ProjectColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "F8",
                                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Select\nCust.",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox.expand(
                child: TapRegion(
                  groupId: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      final ReceiptItemEntity receiptItemTarget =
                          context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]];

                      setState(() {
                        indexIsSelect = [-1, 0];
                        _textEditingControllerNewReceiptItemQuantity.text = "1";
                        _textEditingControllerNewReceiptItemCode.text = "";
                        _newReceiptItemQuantityFocusNode.unfocus();
                        isUpdatingReceiptItemQty = false;
                        isEditingNewReceiptItemCode = true;
                        _newReceiptItemCodeFocusNode.requestFocus();
                      });

                      context.read<ReceiptCubit>().removeReceiptItem(receiptItemTarget, context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      elevation: 5,
                      shadowColor: Colors.black87,
                      backgroundColor: salesViewType == 1 ? ProjectColors.primary : ProjectColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide.none,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "F7",
                                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Remove\nItem",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox.expand(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    if (isEditingNewReceiptItemQty == false) {
                      isEditingNewReceiptItemQty = true;
                      isEditingNewReceiptItemCode = false;
                      _textEditingControllerNewReceiptItemQuantity.text = "";
                      // _newReceiptItemCodeFocusNode.unfocus();
                      _newReceiptItemQuantityFocusNode.requestFocus();
                    } else {
                      isEditingNewReceiptItemQty = false;
                      isEditingNewReceiptItemCode = true;
                      final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
                      _textEditingControllerNewReceiptItemQuantity.text = qtyToDouble == null
                          ? "1"
                          : Helpers.cleanDecimal(double.parse(_textEditingControllerNewReceiptItemQuantity.text), 3);

                      _newReceiptItemCodeFocusNode.requestFocus();
                    }
                  }),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    elevation: isEditingNewReceiptItemQty ? 0 : 5,
                    shadowColor: Colors.black87,
                    backgroundColor: isEditingNewReceiptItemQty
                        ? const Color.fromARGB(255, 113, 0, 0)
                        : salesViewType == 1
                            ? ProjectColors.primary
                            : ProjectColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "F6",
                                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Order\nQuantity",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // End - Menu 2
  }

  Widget _numpad() {
    return // Start - Num Only Keypad
        Expanded(
      flex: 8,
      child: ExcludeFocus(
        child: TapRegion(
          groupId: isUpdatingReceiptItemQty ? 1 : null,
          onTapOutside: (event) {
            // log("ontapoutside");
            if (ModalRoute.of(context)?.isCurrent != true) return;

            if (isUpdatingReceiptItemQty) {
              setState(() {
                indexIsSelect = [-1, 0];
                _textEditingControllerNewReceiptItemQuantity.text = "1";
                _textEditingControllerNewReceiptItemCode.text = "";
                _newReceiptItemQuantityFocusNode.unfocus();
                isUpdatingReceiptItemQty = false;
                isEditingNewReceiptItemCode = true;
                _newReceiptItemCodeFocusNode.requestFocus();
              });
            } else if (isEditingNewReceiptItemQty) {
              setState(() {
                isEditingNewReceiptItemQty = false;
                isEditingNewReceiptItemCode = true;
                final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
                _textEditingControllerNewReceiptItemQuantity.text = qtyToDouble == null || qtyToDouble == 0
                    ? "1"
                    : Helpers.cleanDecimal(double.parse(_textEditingControllerNewReceiptItemQuantity.text), 3);

                _newReceiptItemCodeFocusNode.requestFocus();
              });
            } else {
              setState(() {
                // indexIsSelect = [-1, 0];
                // _textEditingControllerNewReceiptItemQuantity.text = "1";
                // _textEditingControllerNewReceiptItemCode.text = "";
                _newReceiptItemQuantityFocusNode.unfocus();
                isUpdatingReceiptItemQty = false;
                isEditingNewReceiptItemCode = true;

                Future.delayed(const Duration(milliseconds: 20), () => _newReceiptItemCodeFocusNode.requestFocus());
              });
            }
          },
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _numpadNumButton("7"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("8"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("9"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _numpadNumButton("4"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("5"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("6")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _numpadNumButton("1"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("2"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("3")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _numpadNumButton("0"),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox.expand(
                              child: FilledButton(
                                onPressed: () {
                                  setState(() {
                                    if (!_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
                                      _newReceiptItemCodeFocusNode.requestFocus();
                                      _textEditingControllerNewReceiptItemCode.text = "00";
                                    } else if (_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
                                      _textEditingControllerNewReceiptItemCode.text += "00";
                                    }
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: const Color.fromRGBO(48, 48, 48, 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "00",
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox.expand(
                              child: FilledButton(
                                onPressed: () {
                                  if (_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
                                    final currentLength = _textEditingControllerNewReceiptItemCode.text.length;
                                    if (currentLength == 0) return;
                                    _textEditingControllerNewReceiptItemCode.text =
                                        _textEditingControllerNewReceiptItemCode.text.substring(0, currentLength - 1);
                                  } else if (_newReceiptItemQuantityFocusNode.hasPrimaryFocus) {
                                    final currentLength = _textEditingControllerNewReceiptItemQuantity.text.length;
                                    if (currentLength == 0) return;
                                    _textEditingControllerNewReceiptItemQuantity.text =
                                        _textEditingControllerNewReceiptItemQuantity.text
                                            .substring(0, currentLength - 1);
                                  }
                                },
                                style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(3, 3, 6, 3),
                                    elevation: 5,
                                    backgroundColor: const Color.fromRGBO(243, 0, 0, 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Icon(
                                  Icons.backspace_outlined,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox.expand(
                              child: FilledButton(
                                onPressed: () {
                                  if (_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
                                    _textEditingControllerNewReceiptItemCode.text = "";
                                  } else if (_newReceiptItemQuantityFocusNode.hasPrimaryFocus) {
                                    _textEditingControllerNewReceiptItemQuantity.text = "";
                                  }
                                },
                                style: FilledButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: const Color.fromRGBO(255, 113, 5, 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "C",
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox.expand(
                        child: FilledButton(
                          onPressed: () async {
                            if (isEditingNewReceiptItemCode) {
                              final double? qtyToDouble =
                                  double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
                              if (qtyToDouble == null) {
                                _textEditingControllerNewReceiptItemQuantity.text = "0";
                              }

                              await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
                                  barcode: _textEditingControllerNewReceiptItemCode.text,
                                  itemEntity: null,
                                  quantity: double.parse(_textEditingControllerNewReceiptItemQuantity.text),
                                  context: context,
                                  onOpenPriceInputted: () => setState(() {
                                        isEditingNewReceiptItemCode = true;
                                        _newReceiptItemCodeFocusNode.requestFocus();
                                      })));
                            } else if (isUpdatingReceiptItemQty) {
                              final double? qtyToDouble =
                                  double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
                              if (qtyToDouble == null) {
                                _textEditingControllerNewReceiptItemQuantity.text = "0";
                              }
                              await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
                                  barcode: _textEditingControllerNewReceiptItemCode.text,
                                  itemEntity: null,
                                  quantity: double.parse(_textEditingControllerNewReceiptItemQuantity.text),
                                  context: context,
                                  onOpenPriceInputted: () => setState(() {
                                        isEditingNewReceiptItemCode = true;
                                        _newReceiptItemCodeFocusNode.requestFocus();
                                      })));
                            } else if (isEditingNewReceiptItemQty) {
                              setState(() {
                                final double? qtyToDouble =
                                    double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
                                _textEditingControllerNewReceiptItemQuantity.text =
                                    qtyToDouble == null || qtyToDouble == 0
                                        ? "1"
                                        : Helpers.cleanDecimal(
                                            double.parse(_textEditingControllerNewReceiptItemQuantity.text), 3);

                                _newReceiptItemQuantityFocusNode.unfocus();
                                isEditingNewReceiptItemQty = false;
                                isEditingNewReceiptItemCode = true;
                                Future.delayed(const Duration(milliseconds: 20),
                                    () => _newReceiptItemCodeFocusNode.requestFocus());
                              });
                            }
                          },
                          style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(3),
                              elevation: 5,
                              backgroundColor: const Color.fromRGBO(14, 68, 193, 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "OK",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    // End - Num Only Keypad 60 80 40 40
  }

  Widget _numpadNumButton(String buttonNumber) {
    return Expanded(
      child: SizedBox.expand(
        child: FilledButton(
          onPressed: () {
            setState(() {
              if (!isEditingNewReceiptItemCode && !isEditingNewReceiptItemQty && !isUpdatingReceiptItemQty) {
                // log("numpadnumbutton 1");

                _textEditingControllerNewReceiptItemCode.text = buttonNumber;
                Future.delayed(const Duration(milliseconds: 20), () => _newReceiptItemCodeFocusNode.requestFocus());
              } else if (isEditingNewReceiptItemCode) {
                // log("numpadnumbutton 2");

                _textEditingControllerNewReceiptItemCode.text += buttonNumber;
                Future.delayed(const Duration(milliseconds: 20), () => _newReceiptItemCodeFocusNode.requestFocus());
              } else if (isEditingNewReceiptItemQty || isUpdatingReceiptItemQty) {
                // log("numpadnumbutton 3");

                _textEditingControllerNewReceiptItemQuantity.text += buttonNumber;
                Future.delayed(const Duration(milliseconds: 20), () => _newReceiptItemQuantityFocusNode.requestFocus());
              }
            });
          },
          style: FilledButton.styleFrom(
              backgroundColor: const Color.fromRGBO(48, 48, 48, 1),
              elevation: 5,
              shadowColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: FittedBox(
            child: Text(
              buttonNumber,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  // =================================================
  //              [END] Widgets
  // =================================================

  // =================================================
  //             [START] Other Functions
  // =================================================

  void handlePhysicalKeyboard(
    KeyEvent event,
    TextEditingController textEditingController,
    FocusNode textFieldFocusNode,
    bool isNumOnly,
    BuildContext context,
  ) async {
    // log("Handle physical keyboard ${event.physicalKey}");
    if (event.runtimeType == KeyUpEvent) return;
    if (textFieldFocusNode.hasPrimaryFocus) {
      if (event.character != null &&
          RegExp(isNumOnly ? r'^[0-9.]+$' : r'^[A-Za-z0-9_.]+$').hasMatch(event.character!)) {
        if (Platform.isWindows) return;
        textEditingController.text += event.character!;
      } else if (event.physicalKey == PhysicalKeyboardKey.enter ||
          event.physicalKey == (PhysicalKeyboardKey.numpadEnter)) {
        if (_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
          final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
          if (qtyToDouble == null) {
            _textEditingControllerNewReceiptItemQuantity.text = "0";
          }
          await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
              barcode: _textEditingControllerNewReceiptItemCode.text,
              itemEntity: null,
              quantity: double.parse(_textEditingControllerNewReceiptItemQuantity.text),
              context: context,
              onOpenPriceInputted: () => setState(() {
                    isEditingNewReceiptItemCode = true;
                    _newReceiptItemCodeFocusNode.requestFocus();
                  })));
        } else if (isUpdatingReceiptItemQty) {
          final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
          if (qtyToDouble == null) {
            _textEditingControllerNewReceiptItemQuantity.text = "0";
          }
          await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
              barcode: _textEditingControllerNewReceiptItemCode.text,
              itemEntity: null,
              quantity: double.parse(_textEditingControllerNewReceiptItemQuantity.text),
              context: context,
              onOpenPriceInputted: () => setState(() {
                    isEditingNewReceiptItemCode = true;
                    _newReceiptItemCodeFocusNode.requestFocus();
                  })));
        } else if (_newReceiptItemQuantityFocusNode.hasPrimaryFocus) {
          setState(() {
            final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
            _textEditingControllerNewReceiptItemQuantity.text = qtyToDouble == null || qtyToDouble == 0
                ? "1"
                : Helpers.cleanDecimal(double.parse(_textEditingControllerNewReceiptItemQuantity.text), 3);
            // _newReceiptItemQuantityFocusNode.unfocus();
            isEditingNewReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;

            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
      } else if (event.physicalKey == (PhysicalKeyboardKey.f12)) {
        await checkout();
      } else if (event.physicalKey == (PhysicalKeyboardKey.f11)) {
        if (context.read<ReceiptCubit>().state.receiptItems.isEmpty) {
          return SnackBarHelper.presentErrorSnackBar(context, "Receipt cannot be empty");
        }
        context.read<ReceiptCubit>().queueReceipt();
        SnackBarHelper.presentSuccessSnackBar(context, "Pending order added", 3);
      } else if (event.physicalKey == (PhysicalKeyboardKey.f9)) {
        setState(() {
          isEditingNewReceiptItemCode = false;
          isEditingNewReceiptItemQty = false;
          isUpdatingReceiptItemQty = false;
        });

        final ItemEntity? itemEntitySearch = await showDialog<ItemEntity>(
            context: context, barrierDismissible: false, builder: (context) => const ItemSearchDialog());

        if (itemEntitySearch != null) {
          await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
              barcode: null,
              itemEntity: itemEntitySearch,
              quantity: double.parse(_textEditingControllerNewReceiptItemQuantity.text),
              context: context,
              onOpenPriceInputted: () => setState(() {
                    isEditingNewReceiptItemCode = true;
                    _newReceiptItemCodeFocusNode.requestFocus();
                  })));
        }

        setState(() {
          context.read<ItemsCubit>().clearItems();
          isEditingNewReceiptItemCode = true;
          _newReceiptItemCodeFocusNode.requestFocus();
        });
      } else if (event.physicalKey == (PhysicalKeyboardKey.f8)) {
        setState(() {
          isEditingNewReceiptItemCode = false;
          isEditingNewReceiptItemQty = false;
          isUpdatingReceiptItemQty = false;
        });
        return await showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return const SelectCustomerDialog();
          },
        ).then((value) => setState(() {
              context.read<CustomersCubit>().clearCustomers();
              isEditingNewReceiptItemCode = true;
              _newReceiptItemCodeFocusNode.requestFocus();
            }));
      } else if (event.physicalKey == (PhysicalKeyboardKey.f7)) {
        final ReceiptItemEntity receiptItemTarget = context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]];

        setState(() {
          indexIsSelect = [-1, 0];
          _textEditingControllerNewReceiptItemQuantity.text = "1";
          _textEditingControllerNewReceiptItemCode.text = "";
          _newReceiptItemQuantityFocusNode.unfocus();
          isUpdatingReceiptItemQty = false;
          isEditingNewReceiptItemCode = true;
          _newReceiptItemCodeFocusNode.requestFocus();
        });

        context.read<ReceiptCubit>().removeReceiptItem(receiptItemTarget, context);
      } else if (event.physicalKey == (PhysicalKeyboardKey.f6)) {
        if (isEditingNewReceiptItemQty == false) {
          isEditingNewReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _textEditingControllerNewReceiptItemQuantity.text = "";
          // _newReceiptItemCodeFocusNode.unfocus();
          _newReceiptItemQuantityFocusNode.requestFocus();
        } else {
          isEditingNewReceiptItemQty = false;
          isEditingNewReceiptItemCode = true;
          final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
          _textEditingControllerNewReceiptItemQuantity.text = qtyToDouble == null || qtyToDouble == 0
              ? "1"
              : Helpers.cleanDecimal(double.parse(_textEditingControllerNewReceiptItemQuantity.text), 3);

          // _newReceiptItemQuantityFocusNode.unfocus();
          _newReceiptItemCodeFocusNode.requestFocus();
        }
        setState(() {});
      } else if (event.physicalKey == (PhysicalKeyboardKey.f5)) {
        setState(() {
          isEditingNewReceiptItemCode = false;
          isEditingNewReceiptItemQty = false;
          isUpdatingReceiptItemQty = false;
        });
        await showDialog(context: context, barrierDismissible: false, builder: (context) => const InputCouponsDialog());

        setState(() {
          isEditingNewReceiptItemCode = true;
          _newReceiptItemCodeFocusNode.requestFocus();
        });
      } else if (event.physicalKey == (PhysicalKeyboardKey.f4)) {
        setState(() {
          isEditingNewReceiptItemCode = false;
          isEditingNewReceiptItemQty = false;
          isUpdatingReceiptItemQty = false;
        });

        await showDialog(context: context, barrierDismissible: false, builder: (context) => const QueueListDialog())
            .then((value) {
          setState(() {
            context.read<ItemsCubit>().clearItems();
            isEditingNewReceiptItemCode = true;
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        });
      } else if (event.physicalKey == (PhysicalKeyboardKey.f2)) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => const InvoiceDetailsDialog(),
        );
        setState(() {
          isEditingNewReceiptItemCode = true;
          Future.delayed(const Duration(milliseconds: 50), () => _newReceiptItemCodeFocusNode.requestFocus());
        });
      } else if (event.physicalKey == (PhysicalKeyboardKey.f1)) {
        if (indexIsSelect[1] != 0) {
          final ReceiptItemEntity receiptItemTarget = context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]];
          await showDialog(
            context: context,
            builder: (BuildContext context) => ItemDetailsDialog(indexSelected: indexIsSelect[0]),
          );
          setState(() {
            indexIsSelect = [-1, 0];
            _textEditingControllerNewReceiptItemQuantity.text = "1";
            _textEditingControllerNewReceiptItemCode.text = "";
            _newReceiptItemQuantityFocusNode.unfocus();
            isUpdatingReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
      } else {
        textFieldFocusNode.requestFocus();
        setState(() {});
      }
    } else {
      textFieldFocusNode.requestFocus();
      if (event.character != null &&
          RegExp(isNumOnly ? r'^[0-9.]+$' : r'^[A-Za-z0-9_.]+$').hasMatch(event.character!)) {
        textEditingController.text += event.character!;
      }
    }
  }

  Future<void> scrollToReceiptItemByIndex(int index) async {
    if (itemScrollController.isAttached) {
      await itemScrollController.scrollTo(
          index: index, duration: const Duration(milliseconds: 10), curve: Curves.easeInOutCubic);
    }
  }

  void checkIsEditingNewReceiptItemQty() {
    if (isEditingNewReceiptItemQty) {
      setState(() {
        isEditingNewReceiptItemQty = false;
        isEditingNewReceiptItemCode = true;
        final double? qtyToDouble = double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
        _textEditingControllerNewReceiptItemQuantity.text = qtyToDouble == null || qtyToDouble == 0
            ? "1"
            : Helpers.cleanDecimal(double.parse(_textEditingControllerNewReceiptItemQuantity.text), 3);

        _newReceiptItemCodeFocusNode.requestFocus();
      });
    }
  }

  Future<void> addUpdateReceiptItems(AddUpdateReceiptItemsParams params) async {
    try {
      await context.read<ReceiptCubit>().addUpdateReceiptItems(params);

      indexIsSelect = [-1, 0];
      _textEditingControllerNewReceiptItemCode.text = "";
      _textEditingControllerNewReceiptItemQuantity.text = "1";
      isEditingNewReceiptItemQty = false;
      isUpdatingReceiptItemQty = false;
      isEditingNewReceiptItemCode = true;

      _newReceiptItemQuantityFocusNode.unfocus();
      _newReceiptItemCodeFocusNode.requestFocus();
      isNewItemAdded = true;
      setState(() {});

      Future.delayed(
          const Duration(milliseconds: 400),
          () => setState(() {
                isNewItemAdded = false;
              }));

      if (itemScrollController.isAttached) {
        await scrollToReceiptItemByIndex(context.read<ReceiptCubit>().state.receiptItems.length - 1);
      }
    } catch (e) {
      SnackBarHelper.presentFailSnackBar(params.context, e.toString());

      indexIsSelect = [-1, 0];
      _textEditingControllerNewReceiptItemCode.text = "";
      _textEditingControllerNewReceiptItemQuantity.text = "1";
      isEditingNewReceiptItemQty = false;
      isUpdatingReceiptItemQty = false;
      isEditingNewReceiptItemCode = true;

      _newReceiptItemQuantityFocusNode.unfocus();
      _newReceiptItemCodeFocusNode.requestFocus();
      setState(() {});
    }
  }

  Future<void> checkout() async {
    try {
      if (context.read<ReceiptCubit>().state.receiptItems.isEmpty) {
        return SnackBarHelper.presentErrorSnackBar(context, "Receipt cannot be empty");
      }

      if (context.read<ReceiptCubit>().state.grandTotal < 0) {
        return SnackBarHelper.presentErrorSnackBar(context, "Grand total cannot be negative");
      }

      final ReceiptItemEntity? dpItem =
          context.read<ReceiptCubit>().state.receiptItems.where((e) => e.itemEntity.barcode == "99").firstOrNull;
      if (dpItem != null && dpItem.quantity > 0 && context.read<ReceiptCubit>().state.receiptItems.length > 2) {
        return SnackBarHelper.presentErrorSnackBar(context, "Down payment has to be excluded from other transactions");
      }

      setState(() {
        isEditingNewReceiptItemCode = false;
        isEditingNewReceiptItemQty = false;
        isUpdatingReceiptItemQty = false;
      });

      await context.read<ReceiptCubit>().processReceiptBeforeCheckout(context);

      await Future.delayed(const Duration(milliseconds: 300), null);

      final ReceiptEntity receiptEntity = context.read<ReceiptCubit>().state;

      if (receiptEntity.promos.length != receiptEntity.previousReceiptEntity?.promos.length) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => PromotionSummaryDialog(
                  receiptEntity: context.read<ReceiptCubit>().state,
                ));
      }

      await showDialog(context: context, barrierDismissible: false, builder: (context) => const CheckoutDialog())
          .then((value) {
        setState(() {
          isEditingNewReceiptItemCode = true;
          _newReceiptItemCodeFocusNode.requestFocus();
        });
      });
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  Future<EmployeeEntity?> getSalesPerson(String? itemSalesTohemId, String? headerSalesTohemId) async {
    try {
      EmployeeEntity? employeeEntity;
      if (headerSalesTohemId != null && headerSalesTohemId != "") {
        employeeEntity = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(headerSalesTohemId, null);
      }
      if (itemSalesTohemId != null && itemSalesTohemId != "") {
        employeeEntity = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(itemSalesTohemId, null);
      }
      return employeeEntity;
    } catch (e) {
      return null;
    }
  }

  // Future<void> applyHeaderDiscount(BuildContext childContext) async {
  //   try {
  //     final ReceiptItemEntity? dpItem =
  //         context.read<ReceiptCubit>().state.receiptItems.where((e) => e.itemEntity.barcode == "99").firstOrNull;
  //     if (dpItem != null && dpItem.quantity > 0) {
  //       throw "Header discount cannot be applied on down payment deposit";
  //     }

  //     await showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) => InputDiscountManual(docnum: context.read<ReceiptCubit>().state.docNum)).then((value) {
  //       if (value != null) {
  //         SnackBarHelper.presentSuccessSnackBar(
  //             childContext, "Header discount applied: ${Helpers.parseMoney(value)}", 3);
  //       }
  //     });
  //   } catch (e) {
  //     SnackBarHelper.presentErrorSnackBar(context, e.toString());
  //   }
  // }
  // =================================================
  //             [END] Other Functions
  // =================================================
}
