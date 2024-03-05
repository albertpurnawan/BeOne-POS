import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  ReceiptItemEntity? activeReceiptItem;
  bool isEditingNewReceiptItemQty = false;
  List<int> indexIsSelect = [-1, 0];
  bool isUpdatingReceiptItemQty = false;
  bool isEditingReceiptItemQty = false;
  int? radioValue;

  final ScrollController _scrollControllerReceiptItems = ScrollController();
  final ScrollController _scrollControllerReceiptSummary = ScrollController();

  late final FocusNode _newReceiptItemQuantityFocusNode = FocusNode(
      skipTraversal: true,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          return KeyEventResult.skipRemainingHandlers;
        } else {
          return KeyEventResult.ignored;
        }
      });
  late final FocusNode _newReceiptItemCodeFocusNode = FocusNode(
      skipTraversal: true,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          return KeyEventResult.skipRemainingHandlers;
        } else {
          return KeyEventResult.ignored;
        }
      });
  late final FocusNode _customerInputFocusNode = FocusNode();

  late final TextEditingController
      _textEditingControllerNewReceiptItemQuantity = TextEditingController()
        ..text = "1";
  late final TextEditingController _textEditingControllerNewReceiptItemCode =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerReceiptItems.dispose();
    _scrollControllerReceiptSummary.dispose();
    _newReceiptItemCodeFocusNode.dispose();
    _newReceiptItemQuantityFocusNode.dispose();
    _textEditingControllerNewReceiptItemCode.dispose();
    _textEditingControllerNewReceiptItemQuantity.dispose();
    _customerInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isUpdatingReceiptItemQty = indexIsSelect[1] == 1;
    print(isUpdatingReceiptItemQty.toString());
    isEditingReceiptItemQty =
        isEditingNewReceiptItemQty || isUpdatingReceiptItemQty;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 169, 0, 0),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      // backgroundColor: Color.fromRGBO(175, 47, 47, 1),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      // backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      body: ScrollWidget(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(38, 38, 38, 20),
            child: Row(
              children: [
                // Start - Column 1
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _receiptItemsList(),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            _buttonGroup1(),
                            const SizedBox(
                              width: 15,
                            ),
                            _receiptItemForm()
                          ],
                        ),
                      ),
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
                        child: Column(
                          children: [
                            _transactionSummary(),
                            const SizedBox(
                              height: 10,
                            ),
                            // _buttonGroup2()
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
    );
  }

  Widget _receiptItemsList() {
    return Expanded(
      flex: 14,
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
                color: Color.fromRGBO(220, 220, 220, 1),
              ),
            ],
          ),
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
                  color: Color.fromARGB(255, 169, 0, 0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            height: 50,
                            width: 160,
                            padding: const EdgeInsets.fromLTRB(20, 15, 10, 16),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 134, 1, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomRight: Radius.circular(45),
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/logo/white.svg",
                              alignment: Alignment.centerLeft,
                            )),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_outlined, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "8000818",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // decoration: BoxDecoration(
                        //   color: Color.fromRGBO(71, 168, 0, 1),
                        //   border: Border.all(
                        //       color: Color.fromRGBO(0, 0, 0, 0.1), width: 3),
                        //   borderRadius: BorderRadius.circular(5),
                        //   // boxShadow: const [
                        //   //   BoxShadow(
                        //   //     spreadRadius: 0.5,
                        //   //     blurRadius: 5,
                        //   //     color: Color.fromRGBO(132, 0, 0, 0.608),
                        //   //   ),
                        //   // ],
                        // ),
                        padding: const EdgeInsets.only(right: 20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.stars, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Ronaldo",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
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
                child: Scrollbar(
                  controller: _scrollControllerReceiptItems,
                  thumbVisibility: true,
                  child: Column(
                    children: [
                      BlocBuilder<ReceiptCubit, ReceiptEntity>(
                        builder: (context, state) {
                          if (state.receiptItems.isEmpty) {
                            return const Expanded(child: EmptyList());
                          }
                          return Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              controller: _scrollControllerReceiptItems,
                              itemCount: state.receiptItems.length,
                              itemBuilder: (context, index) {
                                final e = state.receiptItems[index];

                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => setState(() {
                                    if (indexIsSelect[0] == index) {
                                      indexIsSelect = [-1, 0];
                                      _textEditingControllerNewReceiptItemQuantity
                                          .text = "1";
                                      _textEditingControllerNewReceiptItemCode
                                          .text = "";
                                      _newReceiptItemQuantityFocusNode
                                          .unfocus();
                                      _newReceiptItemCodeFocusNode
                                          .requestFocus();
                                    } else {
                                      indexIsSelect = [index, 1];
                                      _textEditingControllerNewReceiptItemQuantity
                                          .text = "";
                                      // Helpers.cleanDecimal(e.quantity, 3);
                                      _textEditingControllerNewReceiptItemCode
                                          .text = e.itemEntity.barcode;
                                      _newReceiptItemCodeFocusNode.unfocus();
                                      _newReceiptItemQuantityFocusNode
                                          .requestFocus();
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
                                              color: Color.fromARGB(
                                                  100, 118, 118, 118),
                                            ),
                                          ],
                                        ),
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        color: index == indexIsSelect[0] &&
                                                indexIsSelect[1] == 1
                                            ? const Color.fromARGB(
                                                20, 169, 0, 0)
                                            : null,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture
                                                                        .asset(
                                                                      "assets/images/inventory.svg",
                                                                      height:
                                                                          18,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      e.itemEntity
                                                                          .itemCode,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    SvgPicture
                                                                        .asset(
                                                                      "assets/images/barcode.svg",
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      e.itemEntity
                                                                          .barcode,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Text(
                                                                e.itemEntity
                                                                    .itemName,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "${Helpers.cleanDecimal(e.quantity, 3)} x",
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "@ ${Helpers.parseMoney(e.itemEntity.price)}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  Helpers.parseMoney(
                                                                      e.subtotal),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    index % 3 == 0
                                                        ? const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Aeon card disc",
                                                                style: TextStyle(
                                                                    // color: Color
                                                                    //     .fromARGB(
                                                                    //         255,
                                                                    //         243,
                                                                    //         109,
                                                                    //         0),
                                                                    fontSize: 16,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                              Text(
                                                                "-26,568",
                                                                style: TextStyle(
                                                                    // color: Color
                                                                    //     .fromARGB(
                                                                    //         255,
                                                                    //         243,
                                                                    //         109,
                                                                    //         0),
                                                                    fontSize: 16,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    index % 4 == 0
                                                        ? const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "PROMO LEBARAN",
                                                                style: TextStyle(
                                                                    // color: Color
                                                                    //     .fromRGBO(
                                                                    //         14,
                                                                    //         68,
                                                                    //         193,
                                                                    //         1),
                                                                    fontSize: 16,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                              Text(
                                                                "-32,568",
                                                                style: TextStyle(
                                                                    // color: Color
                                                                    //     .fromRGBO(
                                                                    //         14,
                                                                    //         68,
                                                                    //         193,
                                                                    //         1),
                                                                    fontSize: 16,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // index == indexIsSelect[0] - 1 ||
                                      //         index == indexIsSelect[0] &&
                                      //             indexIsSelect[1] == 1
                                      //     ? const Divider(
                                      //         height: 1,
                                      //         thickness: 0.5,
                                      //         color: Color.fromARGB(
                                      //             0, 118, 118, 118),
                                      //       )
                                      const Divider(
                                        height: 1,
                                        thickness: 0.5,
                                        color:
                                            Color.fromARGB(100, 118, 118, 118),
                                      ),
                                      // if (index !=
                                      //     state.receiptItems.length - 1)
                                      //   const SizedBox(height: 5),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
    // End - Item List
  }

  Widget _receiptItemForm() {
    return Expanded(
      flex: 4,
      child: Container(
          decoration: BoxDecoration(
            color: indexIsSelect[1] == 1
                ? const Color.fromARGB(20, 169, 0, 0)
                : Colors.white,
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
            children: [
              Container(
                height: 25,
                width: double.infinity,
                decoration: const BoxDecoration(
                  // border: Border.all(
                  //     color: Color.fromRGBO(195, 53, 53, 1),
                  //     width: 4.0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  color: Color.fromARGB(255, 169, 0, 0),
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
                              20,
                              0,
                              20,
                              (isEditingNewReceiptItemQty ||
                                      isUpdatingReceiptItemQty)
                                  ? 10
                                  : 0),
                          child: Center(
                            child: (isEditingNewReceiptItemQty ||
                                    isUpdatingReceiptItemQty)
                                ? SizedBox(
                                    height: 40,
                                    child: RawKeyboardListener(
                                      onKey: (event) => handlePhysicalKeyboard(
                                          event,
                                          _textEditingControllerNewReceiptItemQuantity,
                                          _newReceiptItemQuantityFocusNode,
                                          true),
                                      focusNode:
                                          FocusNode(canRequestFocus: false),
                                      child: TextField(
                                        // readOnly: !isEditingReceiptItemQty,
                                        focusNode:
                                            _newReceiptItemQuantityFocusNode,
                                        controller:
                                            _textEditingControllerNewReceiptItemQuantity,
                                        enableInteractiveSelection: false,
                                        // showCursor: false,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.none,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                        decoration: const InputDecoration(
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10)),
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      _textEditingControllerNewReceiptItemQuantity
                                          .text,
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
                          child: !(isEditingNewReceiptItemQty ||
                                  isUpdatingReceiptItemQty)
                              ? RawKeyboardListener(
                                  onKey: (event) => handlePhysicalKeyboard(
                                      event,
                                      _textEditingControllerNewReceiptItemCode,
                                      _newReceiptItemCodeFocusNode,
                                      false),
                                  focusNode: FocusNode(canRequestFocus: false),
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      // "00000001283",
                                      // enabled: !isEditingReceiptItemQty,
                                      // readOnly: isEditingReceiptItemQty,

                                      autofocus: true,
                                      focusNode: _newReceiptItemCodeFocusNode,
                                      controller:
                                          _textEditingControllerNewReceiptItemCode,
                                      enableInteractiveSelection: false,
                                      // showCursor: false,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.none,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Scan or Type an Item Barcode",
                                          hintStyle: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          isCollapsed: true,
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: _textEditingControllerNewReceiptItemCode
                                          .text.isEmpty
                                      ? const Text(
                                          "Scan or Type an Item Barcode",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.italic))
                                      : Text(
                                          _textEditingControllerNewReceiptItemCode
                                              .text,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 24)),
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

  Widget _buttonGroup1() {
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox.expand(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              padding: const EdgeInsets.all(3),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 169, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                            ),
                            // style: ButtonStyle(
                            //   foregroundColor:
                            //       MaterialStatePropertyAll<Color>(
                            //           Color.fromRGBO(195, 53, 53, 1)),
                            //   side: MaterialStatePropertyAll<BorderSide>(
                            //     BorderSide(
                            //       color: Color.fromRGBO(195, 53, 53, 1),
                            //       width: 3,
                            //     ),
                            //   ),
                            // ),
                            child: const Text(
                              "Item Disc %",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
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
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              backgroundColor:
                                  const Color.fromARGB(255, 169, 0, 0),
                              padding: const EdgeInsets.all(3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                            ),
                            child: const Text(
                              "Item Disc \$",
                              style: TextStyle(fontWeight: FontWeight.w600),
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
                        child: SizedBox.expand(
                          child: OutlinedButton(
                            onPressed: () {
                              final strdt =
                                  DateTime.now().toUtc().toIso8601String();
                              print(strdt);
                              print(DateTime.parse(strdt).toLocal());
                            },
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              backgroundColor:
                                  const Color.fromARGB(255, 169, 0, 0),
                              padding: const EdgeInsets.all(3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                            ),
                            child: const Text(
                              "MFR Disc %",
                              style: TextStyle(fontWeight: FontWeight.w600),
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
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              backgroundColor:
                                  const Color.fromARGB(255, 169, 0, 0),
                              padding: const EdgeInsets.all(3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                            ),
                            child: const Text(
                              "MFR Disc \$",
                              style: TextStyle(fontWeight: FontWeight.w600),
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
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<ReceiptCubit>().clearReceiptItems();
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black87,
                        backgroundColor: const Color.fromARGB(255, 169, 0, 0),
                        padding: const EdgeInsets.all(3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide.none,
                      ),
                      child: const Text(
                        "Clear Orders",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: SizedBox.expand(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black87,
                        backgroundColor: const Color.fromARGB(255, 169, 0, 0),
                        padding: const EdgeInsets.all(3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide.none,
                      ),
                      child: const Text(
                        "Print Validation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _transactionSummary() {
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                      color: Color.fromARGB(255, 169, 0, 0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.assignment_ind_outlined,
                                      color: Colors.white),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "rachman01",
                                    style: TextStyle(
                                      fontSize: 22,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.schedule, color: Colors.white),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "16:39:21",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
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
                                "Sub Total",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                Helpers.parseMoney(state.totalPrice),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AKHIRTAHUN20",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "- 1.504.468",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Annual Member Disc",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "- 262.611",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tax A",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "45.611",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tax B",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "26.611",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
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
                          "Total Amount",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          Helpers.parseMoney(state.totalPrice),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
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

    // End - Receipt Summary
  }

  Widget _buttonGroup2() {
    return SizedBox(
        // flex: 1,
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: SizedBox.expand(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(3),
                    // elevation: 5,
                    backgroundColor: const Color.fromARGB(255, 166, 0, 0),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.queue_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Suspend",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
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
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(3),
                    // elevation: 5,
                    backgroundColor: const Color.fromARGB(255, 47, 143, 8),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_rounded),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Checkout",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buttonGroup3() {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Expanded(
            child: SizedBox.expand(
              child: OutlinedButton(
                onPressed: () async {
                  return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
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
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: const Text(
                            'Add Customer',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        contentPadding: EdgeInsets.all(0),
                        content: Theme(
                          data: ThemeData(
                            splashColor: const Color.fromARGB(40, 169, 0, 0),
                            highlightColor: const Color.fromARGB(40, 169, 0, 0),
                            colorScheme:
                                ColorScheme.fromSeed(seedColor: Colors.red),
                            fontFamily: 'Roboto',
                            useMaterial3: true,
                          ),
                          child: StatefulBuilder(builder: (context, setState) {
                            return SizedBox(
                              width: 350,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: TextField(
                                      autofocus: true,
                                      focusNode: _customerInputFocusNode,
                                      decoration: const InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.search,
                                          size: 16,
                                        ),
                                        hintText: "Enter customer's name",
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  // Text(
                                  //   "Name",
                                  //   textAlign: TextAlign.left,
                                  // ),
                                  Expanded(
                                    child: ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        itemCount: 5,
                                        itemBuilder: ((context, index) {
                                          return RadioListTile<int>(
                                              activeColor:
                                                  ProjectColors.primary,
                                              hoverColor: ProjectColors.primary,
                                              // selected: index == radioValue,
                                              selectedTileColor:
                                                  ProjectColors.primary,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .trailing,
                                              value: index,
                                              groupValue: radioValue,
                                              title: Text("Jatmiko"),
                                              subtitle: Text("0912830918203"),
                                              // shape: RoundedRectangleBorder(
                                              //     borderRadius:
                                              //         BorderRadius.circular(5)),
                                              onChanged: (val) {
                                                setState(() {
                                                  radioValue = val;
                                                });
                                              });
                                        })),
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                        // contentPadding: const EdgeInsets.symmetric(
                        //     horizontal: 20, vertical: 5),
                        actions: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: const BorderSide(
                                                color: ProjectColors.primary))),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.white),
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Colors.black.withOpacity(.2))),
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                    Future.delayed(
                                        const Duration(milliseconds: 200),
                                        () => _newReceiptItemCodeFocusNode
                                            .requestFocus());
                                  });
                                },
                                child: const Center(
                                    child: Text(
                                  "Cancel",
                                  style:
                                      TextStyle(color: ProjectColors.primary),
                                )),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => ProjectColors.primary),
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Colors.white.withOpacity(.2))),
                                onPressed: () async {
                                  // try {
                                  //   final response = await api.trading
                                  //       .deleteTradingPost(tradingPost.id)
                                  //       .timeout(const Duration(seconds: 10));
                                  //   if (response.response.success) {
                                  //     Helpers.showSnackbar(context,
                                  //         content:
                                  //             const Text("Delete success"));
                                  //   } else {
                                  //     Helpers.showSnackbar(context,
                                  //         content: const Text("Delete failed"));
                                  //   }
                                  //   Navigator.of(context).pop();
                                  //   refresh();
                                  // } catch (e) {
                                  //   Navigator.of(context).pop();
                                  //   Navigator.of(context).pop();
                                  //   Helpers.showSnackbar(context,
                                  //       content:
                                  //           const Text("Connection timed out"));
                                  //   // refresh();
                                  // }
                                },
                                child: const Center(
                                    child: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                )),
                              )),
                            ],
                          ),
                        ],
                        actionsPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      );
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(7),
                  elevation: 5,
                  shadowColor: Colors.black87,
                  backgroundColor: const Color.fromARGB(255, 169, 0, 0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: BorderSide.none,
                ),
                child: const Text(
                  "Add Cust.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
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
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(7),
                  elevation: 5,
                  shadowColor: Colors.black87,
                  backgroundColor: const Color.fromARGB(255, 169, 0, 0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: BorderSide.none,
                ),
                child: const Text(
                  "Check Price",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
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
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(7),
                  elevation: 5,
                  shadowColor: Colors.black87,
                  backgroundColor: const Color.fromARGB(255, 169, 0, 0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: BorderSide.none,
                ),
                child: const Text(
                  "Remove Item",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
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
                    _textEditingControllerNewReceiptItemQuantity.text = "";
                    // _newReceiptItemCodeFocusNode.unfocus();
                    _newReceiptItemQuantityFocusNode.requestFocus();
                  } else {
                    isEditingNewReceiptItemQty = false;
                    _textEditingControllerNewReceiptItemQuantity
                        .text = _textEditingControllerNewReceiptItemQuantity
                                    .text ==
                                "" ||
                            double.parse(
                                    _textEditingControllerNewReceiptItemQuantity
                                        .text) <=
                                0
                        ? "1"
                        : Helpers.cleanDecimal(
                            double.parse(
                                _textEditingControllerNewReceiptItemQuantity
                                    .text),
                            3);

                    // _newReceiptItemQuantityFocusNode.unfocus();
                    _newReceiptItemCodeFocusNode.requestFocus();
                  }
                }),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(7),
                  elevation: isEditingNewReceiptItemQty ? 0 : 5,
                  shadowColor: Colors.black87,
                  backgroundColor: isEditingNewReceiptItemQty
                      ? const Color.fromARGB(255, 113, 0, 0)
                      : const Color.fromARGB(255, 169, 0, 0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: BorderSide.none,
                ),
                child: const Text(
                  "Order Quantity",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // End - Menu 2
  }

  Widget _numpad() {
    return // Start - Num Only Keypad
        Expanded(
      flex: 4,
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
                                if (!_newReceiptItemCodeFocusNode
                                    .hasPrimaryFocus) {
                                  _newReceiptItemCodeFocusNode.requestFocus();
                                  _textEditingControllerNewReceiptItemCode
                                      .text = "00";
                                } else if (_newReceiptItemCodeFocusNode
                                    .hasPrimaryFocus) {
                                  _textEditingControllerNewReceiptItemCode
                                      .text += "00";
                                }
                              });
                            },
                            style: FilledButton.styleFrom(
                                elevation: 5,
                                backgroundColor:
                                    const Color.fromRGBO(48, 48, 48, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text(
                              "00",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w700),
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
                              if (_newReceiptItemCodeFocusNode
                                  .hasPrimaryFocus) {
                                final currentLength =
                                    _textEditingControllerNewReceiptItemCode
                                        .text.length;
                                if (currentLength == 0) return;
                                _textEditingControllerNewReceiptItemCode.text =
                                    _textEditingControllerNewReceiptItemCode
                                        .text
                                        .substring(0, currentLength - 1);
                              } else if (_newReceiptItemQuantityFocusNode
                                  .hasPrimaryFocus) {
                                final currentLength =
                                    _textEditingControllerNewReceiptItemQuantity
                                        .text.length;
                                if (currentLength == 0) return;
                                _textEditingControllerNewReceiptItemQuantity
                                        .text =
                                    _textEditingControllerNewReceiptItemQuantity
                                        .text
                                        .substring(0, currentLength - 1);
                              }
                            },
                            style: FilledButton.styleFrom(
                                padding: const EdgeInsets.fromLTRB(3, 3, 6, 3),
                                elevation: 5,
                                backgroundColor:
                                    const Color.fromRGBO(243, 0, 0, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
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
                              if (_newReceiptItemCodeFocusNode
                                  .hasPrimaryFocus) {
                                _textEditingControllerNewReceiptItemCode.text =
                                    "";
                              } else if (_newReceiptItemQuantityFocusNode
                                  .hasPrimaryFocus) {
                                _textEditingControllerNewReceiptItemQuantity
                                    .text = "";
                              }
                            },
                            style: FilledButton.styleFrom(
                                elevation: 5,
                                backgroundColor:
                                    const Color.fromRGBO(255, 113, 5, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text(
                              "C",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w600),
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
                        if (_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
                          context.read<ReceiptCubit>().addOrUpdateReceiptItems(
                              _textEditingControllerNewReceiptItemCode.text,
                              double.parse(
                                  _textEditingControllerNewReceiptItemQuantity
                                      .text));
                          setState(() {
                            _textEditingControllerNewReceiptItemCode.text = "";
                            _textEditingControllerNewReceiptItemQuantity.text =
                                "1";
                          });

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final position = _scrollControllerReceiptItems
                                    .position.maxScrollExtent +
                                100;
                            _scrollControllerReceiptItems.animateTo(
                              position,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                          });
                        } else if (isUpdatingReceiptItemQty) {
                          context.read<ReceiptCubit>().updateQuantity(
                              context
                                  .read<ReceiptCubit>()
                                  .state
                                  .receiptItems[indexIsSelect[0]],
                              double.parse(
                                  _textEditingControllerNewReceiptItemQuantity
                                      .text));

                          setState(() {
                            indexIsSelect = [-1, 0];
                            _textEditingControllerNewReceiptItemQuantity.text =
                                "1";
                            _textEditingControllerNewReceiptItemCode.text = "";
                            _newReceiptItemQuantityFocusNode.unfocus();
                            _newReceiptItemCodeFocusNode.requestFocus();
                          });

                          // setState(() {
                          //   isUpdatingReceiptItemQty = false;
                          //   indexIsSelect = [-1, 0];

                          //   _textEditingControllerNewReceiptItemCode.text = "";
                          //   _textEditingControllerNewReceiptItemQuantity.text =
                          //       "1";

                          //   _newReceiptItemQuantityFocusNode.unfocus();
                          //   _newReceiptItemCodeFocusNode.requestFocus();
                          // }
                          // );
                        } else if (_newReceiptItemQuantityFocusNode
                            .hasPrimaryFocus) {
                          setState(() {
                            isEditingNewReceiptItemQty = false;
                            _textEditingControllerNewReceiptItemQuantity
                                .text = _textEditingControllerNewReceiptItemQuantity
                                            .text ==
                                        "" ||
                                    double.parse(
                                            _textEditingControllerNewReceiptItemQuantity
                                                .text) <=
                                        0
                                ? "1"
                                : Helpers.cleanDecimal(
                                    double.parse(
                                        _textEditingControllerNewReceiptItemQuantity
                                            .text),
                                    3);

                            _newReceiptItemQuantityFocusNode.unfocus();
                            _newReceiptItemCodeFocusNode.requestFocus();
                          });
                        }
                      },
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(3),
                          elevation: 5,
                          backgroundColor: const Color.fromRGBO(14, 68, 193, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
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
              if (!_newReceiptItemCodeFocusNode.hasPrimaryFocus &&
                  !isEditingNewReceiptItemQty &&
                  !isUpdatingReceiptItemQty) {
                _newReceiptItemCodeFocusNode.requestFocus();
                _textEditingControllerNewReceiptItemCode.text = buttonNumber;
              } else if (_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
                _textEditingControllerNewReceiptItemCode.text += buttonNumber;
              } else if (isEditingNewReceiptItemQty ||
                  isUpdatingReceiptItemQty) {
                _textEditingControllerNewReceiptItemQuantity.text +=
                    buttonNumber;
              }
            });
          },
          style: FilledButton.styleFrom(
              backgroundColor: const Color.fromRGBO(48, 48, 48, 1),
              elevation: 5,
              shadowColor: Colors.black87,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(
            buttonNumber,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  void handlePhysicalKeyboard(
      RawKeyEvent event,
      TextEditingController textEditingController,
      FocusNode textFieldFocusNode,
      bool isNumOnly) {
    if (textFieldFocusNode.hasPrimaryFocus) {
      if (event.character != null &&
          RegExp(isNumOnly ? r'^[0-9.]+$' : r'^[A-Za-z0-9_.]+$')
              .hasMatch(event.character!)) {
        textEditingController.text += event.character!;
      } else if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
          event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
        if (_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
          context.read<ReceiptCubit>().addOrUpdateReceiptItems(
              _textEditingControllerNewReceiptItemCode.text,
              double.parse(_textEditingControllerNewReceiptItemQuantity.text));

          setState(() {
            _textEditingControllerNewReceiptItemCode.text = "";
            _textEditingControllerNewReceiptItemQuantity.text = "1";
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final position =
                _scrollControllerReceiptItems.position.maxScrollExtent + 100;
            _scrollControllerReceiptItems.animateTo(
              position,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          });
        } else if (isUpdatingReceiptItemQty) {
          context.read<ReceiptCubit>().updateQuantity(
              context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]],
              double.parse(_textEditingControllerNewReceiptItemQuantity.text));

          setState(() {
            indexIsSelect = [-1, 0];
            _textEditingControllerNewReceiptItemQuantity.text = "1";
            _textEditingControllerNewReceiptItemCode.text = "";
            _newReceiptItemQuantityFocusNode.unfocus();
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        } else if (_newReceiptItemQuantityFocusNode.hasPrimaryFocus) {
          setState(() {
            isEditingNewReceiptItemQty = false;
            _textEditingControllerNewReceiptItemQuantity.text =
                _textEditingControllerNewReceiptItemQuantity.text == "" ||
                        double.parse(
                                _textEditingControllerNewReceiptItemQuantity
                                    .text) <=
                            0
                    ? "1"
                    : Helpers.cleanDecimal(
                        double.parse(
                            _textEditingControllerNewReceiptItemQuantity.text),
                        3);
            // _newReceiptItemQuantityFocusNode.unfocus();
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
      } else if (!event.isKeyPressed(LogicalKeyboardKey.backspace)) {
        return;
      }
    } else {
      textFieldFocusNode.requestFocus();
      if (event.character != null &&
          RegExp(isNumOnly ? r'^[0-9.]+$' : r'^[A-Za-z0-9_.]+$')
              .hasMatch(event.character!)) {
        textEditingController.text += event.character!;
      }
    }
  }
}
