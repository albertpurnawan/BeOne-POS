import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_all_queued_receipts.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_queued_receipt_by_docId.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_queued_receipts.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_queued_receipts.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QueueListDialog extends StatefulWidget {
  const QueueListDialog({super.key});

  @override
  State<QueueListDialog> createState() => _QueueListDialogState();
}

class _QueueListDialogState extends State<QueueListDialog> {
  List<ItemEntity> itemEntities = [];
  final ScrollController _scrollController = ScrollController();
  List<ReceiptEntity> queuedReceipts = [];
  int currentIndex = 0;
  late final FocusNode _keyboardListenerFocusNode = FocusNode();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _keyboardListenerFocusNode.requestFocus();
    getQueuedReceipts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  Future<void> getQueuedReceipts() async {
    queuedReceipts = await GetIt.instance<GetQueuedReceiptsUseCase>().call();
    setState(() {});
  }

  Future<void> scrollToReceiptItemByIndex(int index) async {
    await itemScrollController.scrollTo(
        index: index,
        duration: Duration(milliseconds: 10),
        curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      focusNode: _keyboardListenerFocusNode,
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;
        log("event queue list");
        log(event.physicalKey.toString());
        if (event.physicalKey == PhysicalKeyboardKey.arrowDown &&
            currentIndex < queuedReceipts.length - 1) {
          scrollToReceiptItemByIndex(currentIndex + 1);
          currentIndex += 1;
          setState(() {});

          return KeyEventResult.skipRemainingHandlers;
        } else if (event.physicalKey == PhysicalKeyboardKey.arrowUp &&
            currentIndex > 0) {
          scrollToReceiptItemByIndex(currentIndex - 1);
          currentIndex -= 1;
          setState(() {});

          return KeyEventResult.skipRemainingHandlers;
        } else if (event.physicalKey == PhysicalKeyboardKey.enter &&
            queuedReceipts.isNotEmpty) {
          context
              .read<ReceiptCubit>()
              .retrieveFromQueue(queuedReceipts[currentIndex], context);
          Navigator.pop(context);
          return KeyEventResult.skipRemainingHandlers;
        } else if (event.physicalKey == PhysicalKeyboardKey.f12) {
          Navigator.pop(context);
          return KeyEventResult.skipRemainingHandlers;
        }
        setState(() {});
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
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: const Text(
            'Queue List',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: EdgeInsets.all(10),
        content: Theme(
          data: ThemeData(
            splashColor: const Color.fromARGB(40, 169, 0, 0),
            highlightColor: const Color.fromARGB(40, 169, 0, 0),
            colorScheme: ColorScheme.fromSeed(seedColor: ProjectColors.primary),
            fontFamily: 'Roboto',
            useMaterial3: true,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.65,
            child: queuedReceipts.length != 0
                ? RawScrollbar(
                    thumbColor: const Color.fromARGB(255, 192, 192, 192),
                    controller: _scrollController,
                    thickness: 4,
                    radius: Radius.circular(30),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      scrollOffsetController: scrollOffsetController,
                      itemPositionsListener: itemPositionsListener,
                      scrollOffsetListener: scrollOffsetListener,
                      padding: EdgeInsets.all(15),
                      itemCount: queuedReceipts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ReceiptEntity queuedReceipt =
                            queuedReceipts[index];
                        print(queuedReceipt.receiptItems.length);
                        return InkWell(
                          onTap: () {
                            context
                                .read<ReceiptCubit>()
                                .retrieveFromQueue(queuedReceipt, context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: index == currentIndex
                                ? Color.fromARGB(20, 128, 0, 0)
                                : null,
                            child: Column(
                              children: [
                                index == 0
                                    ? Divider(
                                        height: 0,
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 60,
                                              child: Text(
                                                (index + 1).toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  queuedReceipt.receiptItems
                                                          .take(4)
                                                          .map((e) => e
                                                              .itemEntity
                                                              .itemName)
                                                          .join("   |   ") +
                                                      "${queuedReceipt.receiptItems.length > 4 ? "    |   ..." : ""}",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // alignment: Alignment.center,
                                      width: 100,
                                      child: Icon(
                                        Icons.navigate_next,
                                        size: 30,
                                        color: Color.fromARGB(255, 66, 66, 66),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      child: InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () async {
                                          GetIt.instance<
                                                  DeleteQueuedReceiptUseCase>()
                                              .call(
                                                  params:
                                                      queuedReceipt.toinvId);
                                          await getQueuedReceipts();
                                        },
                                        splashColor: Colors.white38,
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                            // boxShadow: const [
                                            //   BoxShadow(
                                            //     spreadRadius: 0.5,
                                            //     blurRadius: 5,
                                            //     color: Color.fromRGBO(
                                            //         220, 220, 220, 1),
                                            //   ),
                                            // ],
                                          ),
                                          padding: EdgeInsets.all(7),
                                          child: Center(
                                            child: Icon(
                                              Icons.delete_forever_rounded,
                                              color: ProjectColors.swatch,
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Total Qty",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              139,
                                                              139,
                                                              139)),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Helpers.cleanDecimal(
                                                      queuedReceipt.receiptItems
                                                                  .length >
                                                              1
                                                          ? queuedReceipt
                                                              .receiptItems
                                                              .map((e) =>
                                                                  e.quantity)
                                                              .reduce((value,
                                                                      element) =>
                                                                  value +
                                                                  element)
                                                          : queuedReceipt
                                                              .receiptItems[0]
                                                              .quantity,
                                                      3),
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Grand Total",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              139,
                                                              139,
                                                              139)),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Rp ${Helpers.parseMoney(queuedReceipt.grandTotal.toInt())}",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Queued at",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              139,
                                                              139,
                                                              139)),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  DateFormat.Hm().format(
                                                      queuedReceipt
                                                          .transDateTime!),
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  height: 0,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : EmptyList(
                    imagePath: "assets/images/empty-search.svg",
                    sentence: "Tadaa.. There is nothing here!",
                  ),
          ),
        ),
        // contentPadding: const EdgeInsets.symmetric(
        //     horizontal: 20, vertical: 5),
        actions: <Widget>[
          Row(
            children: [
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
                    onPressed: () async {
                      await GetIt.instance<DeleteAllQueuedReceiptsUseCase>()
                          .call();

                      setState(() {
                        queuedReceipts.clear();
                      });
                    },
                    child: const Center(
                        child: Text(
                      "Clear All",
                      style: TextStyle(color: ProjectColors.primary),
                    )),
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 3,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white.withOpacity(.2))),
                    onPressed: () {
                      Navigator.pop(context);
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
