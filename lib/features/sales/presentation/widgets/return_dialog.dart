import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/field_label.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/customer_dao.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/invoice_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/return_receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_customers.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/return_base_receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirmation_dialog.dart';

class ReturnDialog extends StatefulWidget {
  const ReturnDialog({super.key});

  @override
  State<ReturnDialog> createState() => _ReturnDialogState();
}

class _ReturnDialogState extends State<ReturnDialog> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _invoiceNumberController = TextEditingController();
  final FocusNode _remarksFocusNode = FocusNode();
  final FocusNode _invoiceNumberFocusNode = FocusNode();
  final FocusNode _searchAvailableItemsInputFocusNode = FocusNode();
  final TextEditingController _searchAvailableItemsInputTextController = TextEditingController();

  final FocusNode _searchReturnedItemsInputFocusNode = FocusNode();
  final TextEditingController _searchReturnedItemsInputTextController = TextEditingController();

  ReturnBaseReceiptEntity? returnBaseReceiptEntity;
  List<ReceiptItemEntity> availableReceiptItems = [];
  List<ReceiptItemEntity> returnedReceiptItems = [];

  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    initValues();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _remarksController.dispose();
    _invoiceNumberController.dispose();
    _remarksFocusNode.dispose();
    _invoiceNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(returnBaseReceiptEntity.toString());
    return Focus(
      focusNode: FocusNode(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: (node, event) {
          if (event.runtimeType == KeyUpEvent) {
            return KeyEventResult.handled;
          }

          if (event.physicalKey == PhysicalKeyboardKey.escape) {
            Navigator.of(context).pop();
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        },
      ),
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 244, 244, 244),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Container(
          decoration: const BoxDecoration(
            color: ProjectColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: const Row(
            children: [
              Text(
                'Return',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              Spacer(),
            ],
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          color: const Color.fromARGB(255, 244, 244, 244),
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width * 0.6,
          // height: MediaQuery.of(context).size.height * 0.7,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          FieldLabel(
                            label: "Invoice Number",
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 66, 66, 66)),
                              controller: _invoiceNumberController,
                              focusNode: _invoiceNumberFocusNode,
                              autofocus: true,
                              enabled: !isFetching,
                              onSubmitted: isFetching ? null : (_) async => await _fetchInvoiceByDocNum(),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.all(10),
                                border: const OutlineInputBorder(),
                                prefixIcon: const SizedBox(
                                  width: 80,
                                ),
                                suffixIcon: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 80,
                                  height: 50,
                                  child: OutlinedButton(
                                    focusNode: FocusNode(skipTraversal: true),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: ProjectColors.primary,
                                      padding: const EdgeInsets.all(5),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    onPressed: isFetching ? null : () async => await _fetchInvoiceByDocNum(),
                                    child: isFetching
                                        ? const SizedBox(width: 10, height: 10, child: CircularProgressIndicator())
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Check",
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                                    ),
                                                  ],
                                                  style: TextStyle(height: 1, fontSize: 10),
                                                ),
                                                overflow: TextOverflow.clip,
                                              ),
                                            ],
                                          ),
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
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Date & Time",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  returnBaseReceiptEntity == null
                                      ? "-"
                                      : Helpers.dateddMMMyyyyHHmmss(returnBaseReceiptEntity!.transDateTime),
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Store",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  returnBaseReceiptEntity?.storeMasterEntity.storeCode ?? "-",
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Customer",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  returnBaseReceiptEntity?.customerEntity.custName ?? "-",
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Grand Total",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  returnBaseReceiptEntity == null
                                      ? "-"
                                      : Helpers.parseMoney(returnBaseReceiptEntity!.grandTotal),
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              if (returnBaseReceiptEntity != null)
                const Divider(
                  height: 30,
                  color: Colors.grey,
                ),
              if (returnBaseReceiptEntity != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildAvailableItems()),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: _buildReturnedItems(),
                        ),
                      ],
                    ),
                  ),
                )

              // SingleChildScrollView(
              //     controller: _scrollController,
              //     padding: const EdgeInsets.symmetric(horizontal: 30),
              //     clipBehavior: Clip.antiAliasWithSaveLayer,
              //     child: _buildReturnItems()),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        actions: [
          Row(
            children: [
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
              const SizedBox(width: 10),
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ProjectColors.primary),
                    )),
                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                onPressed: () async => await _saveReturnedReceiptItems().then((value) {
                  if (value == true) context.pop(true);
                }),
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Save",
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
      ),
    );
  }

  Future<void> initValues() async {
    try {
      final List<ReceiptItemEntity> existingReturns = context
          .read<ReceiptCubit>()
          .state
          .receiptItems
          .where((element) => element.refpos3 != null)
          .map((e) => e.copyWith(quantity: e.quantity * -1))
          .toList();
      if (existingReturns.isEmpty) return;
      if (context.read<ReturnBaseReceiptCubit>().state == null ||
          (existingReturns.isNotEmpty &&
              existingReturns.firstOrNull?.refpos3 != context.read<ReturnBaseReceiptCubit>().state?.docNum)) {
        await _fetchInvoiceByDocNum(docNum: existingReturns.first.refpos3);
      } else {
        returnBaseReceiptEntity = context.read<ReturnBaseReceiptCubit>().state;
      }
      setState(() {
        _invoiceNumberController.text = returnBaseReceiptEntity!.docNum;
        availableReceiptItems = returnBaseReceiptEntity!.availableItems;
        returnedReceiptItems = existingReturns;
      });
    } catch (e) {
      context.pop();
    }
  }

  Widget _buildAvailableItems() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 5,
            ),
            const Text(
              "Available Items",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const Spacer(),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: ProjectColors.primary),
                  )),
                  backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
              onPressed: () async {
                for (final availableReceiptItem in availableReceiptItems) {
                  await _saveDraftReturnedReceiptItems(
                      availableReceiptItem.copyWith(quantity: _getRemainingQty(availableReceiptItem)));
                }
              },
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Return All",
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
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: ProjectColors.primary),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchAvailableItemsInputFocusNode.requestFocus(),
                  onChanged: (value) => setState(() {}),
                  controller: _searchAvailableItemsInputTextController,
                  // onSubmitted: (value) {
                  //   // log("value - $value");
                  //   try {
                  //     if (context.read<ReceiptCubit>().state.customerEntity == null) throw "Customer required";

                  //     log(_textEditingController.text);
                  //     searchItemYs();
                  //     log("displayedItemYs");
                  //     log(displayedItemYs.toString());

                  //     if (_scrollController.hasClients) {
                  //       Future.delayed(const Duration(milliseconds: 300)).then((value) {
                  //         SchedulerBinding.instance.addPostFrameCallback((_) {
                  //           _scrollController.animateTo(_scrollController.position.minScrollExtent,
                  //               duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                  //         });
                  //       });
                  //     }

                  //     _searchInputFocusNode.requestFocus();
                  //   } catch (e) {
                  //     SnackBarHelper.presentErrorSnackBar(context, e.toString());
                  //   }
                  // },
                  focusNode: _searchAvailableItemsInputFocusNode,
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
              Expanded(
                // constraints: BoxConstraints(
                //   maxHeight: MediaQuery.of(context).size.height * .3,
                // ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  shrinkWrap: true,
                  itemCount: availableReceiptItems
                      .where((element) =>
                          element.itemEntity.itemName
                              .toLowerCase()
                              .contains(_searchAvailableItemsInputTextController.text.toLowerCase()) ||
                          element.itemEntity.barcode
                              .toLowerCase()
                              .contains(_searchAvailableItemsInputTextController.text.toLowerCase()))
                      .length,
                  itemBuilder: (context, index) {
                    final ReceiptItemEntity e = availableReceiptItems
                        .where((element) =>
                            element.itemEntity.itemName
                                .toLowerCase()
                                .contains(_searchAvailableItemsInputTextController.text.toLowerCase()) ||
                            element.itemEntity.barcode
                                .toLowerCase()
                                .contains(_searchAvailableItemsInputTextController.text.toLowerCase()))
                        .toList()[index];
                    final bool isExistOnDraftReturnedReceiptItems = _isExistOnDraftReturnedReceiptItems(e);

                    return Material(
                      type: MaterialType.transparency,
                      elevation: 6.0,
                      color: Colors.transparent,
                      shadowColor: Colors.grey[50],
                      child: InkWell(
                        focusColor: const Color.fromARGB(255, 237, 200, 200),
                        onTap: _getRemainingQty(e) <= 0
                            ? null
                            : () async {
                                final double? returnedQuantity = await showDialog<double>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => ScaffoldMessenger(
                                    child: Builder(builder: (context) {
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: InputReturnQuantityDialog(
                                          receiptItemEntity: e.copyWith(quantity: _getRemainingQty(e)),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                                if (returnedQuantity != null) {
                                  await _saveDraftReturnedReceiptItems(e.copyWith(quantity: returnedQuantity));
                                }
                              },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.itemEntity.barcode,
                                        style: const TextStyle(fontSize: 12, height: 1),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        e.itemEntity.itemName,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    Container(
                                        alignment: Alignment.centerRight,
                                        width: 40,
                                        child: Text(
                                          Helpers.cleanDecimal(_getRemainingQty(e), 3),
                                          style: TextStyle(
                                            fontWeight: isExistOnDraftReturnedReceiptItems ? FontWeight.w700 : null,
                                            color: isExistOnDraftReturnedReceiptItems
                                                ? _getRemainingQty(e) <= 0
                                                    ? Colors.red
                                                    : Colors.orange
                                                : null,
                                          ),
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    if (_getRemainingQty(e) > 0)
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 20,
                                        color: ProjectColors.green,
                                      ),
                                    if (_getRemainingQty(e) <= 0)
                                      SizedBox(
                                        width: 20,
                                      )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              height: 0,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ]),
          ),
        )
      ],
    );
  }

  Widget _buildReturnedItems() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 5,
            ),
            const Text(
              "Return Items",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const Spacer(),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: ProjectColors.primary),
                  )),
                  backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
              onPressed: () => _resetDraftReturnedReceiptItems(),
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Reset",
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
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: ProjectColors.primary),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _searchReturnedItemsInputFocusNode.requestFocus(),
                  controller: _searchReturnedItemsInputTextController,
                  focusNode: _searchReturnedItemsInputFocusNode,
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
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    shrinkWrap: true,
                    itemCount: returnedReceiptItems
                        .where((element) =>
                            element.itemEntity.itemName
                                .toLowerCase()
                                .contains(_searchReturnedItemsInputTextController.text.toLowerCase()) ||
                            element.itemEntity.barcode
                                .toLowerCase()
                                .contains(_searchReturnedItemsInputTextController.text.toLowerCase()))
                        .length,
                    itemBuilder: (context, index) {
                      final ReceiptItemEntity e = returnedReceiptItems
                          .where((element) =>
                              element.itemEntity.itemName
                                  .toLowerCase()
                                  .contains(_searchReturnedItemsInputTextController.text.toLowerCase()) ||
                              element.itemEntity.barcode
                                  .toLowerCase()
                                  .contains(_searchReturnedItemsInputTextController.text.toLowerCase()))
                          .toList()[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.itemEntity.barcode,
                                      style: const TextStyle(fontSize: 12, height: 1),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(e.itemEntity.itemName)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 17,
                                  ),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      width: 40,
                                      child: Text(Helpers.cleanDecimal(e.quantity, 3))),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 17,
                                  ),
                                  InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => _removeDraftReturnedReceiptItem(e),
                                    splashColor: Colors.white38,
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                      child: const Icon(
                                        Icons.delete_forever_rounded,
                                        size: 20,
                                        color: Color.fromRGBO(243, 0, 0, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            height: 0,
                          )
                        ],
                      );
                    }),
              )
            ]),
          ),
        )
      ],
    );
  }

  Future<void> _fetchInvoiceByDocNum({String? docNum}) async {
    try {
      docNum = docNum ?? _invoiceNumberController.text;

      if (returnBaseReceiptEntity != null && returnBaseReceiptEntity?.docNum != docNum) {
        final bool? isProceed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const ConfirmationDialog(
            primaryMsg: "Different Invoice Detected",
            secondaryMsg: "Listed return items will be resetted if you proceed.",
          ),
        );
        if (isProceed == null || isProceed == false) return;
        _resetDraftReturnedReceiptItems();
        await _saveReturnedReceiptItems();
      }
      setState(() {
        isFetching = true;
      });
      final InvoiceHeaderEntity? targetInvoice =
          await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByDocNum(docNum, null);
      if (targetInvoice?.docId == null) throw "Invoice not found";
      final ReceiptEntity? targetReceipt =
          await GetIt.instance<ReceiptRepository>().getReceiptByInvoiceHeaderDocId(targetInvoice!.docId!, null);
      if (targetReceipt == null) throw "Issue found in invoice";

      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>().call(params: targetInvoice.tostrId);
      if (storeMasterEntity == null) throw "Store not found";

      await Future.delayed(Durations.extralong1);
      setState(() {
        final ReturnBaseReceiptEntity newState = ReturnBaseReceiptEntity(
            docNum: targetInvoice.docnum,
            transDateTime: targetReceipt.transDateTime ?? DateTime.now(),
            timezone: targetInvoice.timezone,
            storeMasterEntity: storeMasterEntity,
            grandTotal: targetInvoice.grandTotal,
            customerEntity: targetReceipt.customerEntity!,
            availableItems: targetReceipt.receiptItems);
        context.read<ReturnBaseReceiptCubit>().replace(newState);
        returnBaseReceiptEntity = newState;
        availableReceiptItems = newState.availableItems;
      });
      SnackBarHelper.presentSuccessSnackBar(context, "Fetch invoice success", null);
    } catch (e) {
      setState(() {
        context.read<ReturnBaseReceiptCubit>().replace(null);
        returnBaseReceiptEntity = null;
        availableReceiptItems = [];
      });
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    } finally {
      setState(() {
        isFetching = false;
      });
    }
  }

  Future<void> _saveDraftReturnedReceiptItems(ReceiptItemEntity receiptItemEntity) async {
    try {
      final ReceiptItemEntity? existing = returnedReceiptItems
          .where((element) => element.itemEntity.barcode == receiptItemEntity.itemEntity.barcode)
          .firstOrNull;
      returnedReceiptItems = returnedReceiptItems
          .where((element) => element.itemEntity.barcode != receiptItemEntity.itemEntity.barcode)
          .toList();
      returnedReceiptItems.add(ReceiptHelper.updateReceiptItemAggregateFields(
          receiptItemEntity.copyWith(quantity: (existing?.quantity ?? 0) + receiptItemEntity.quantity)));
      returnedReceiptItems = returnedReceiptItems.reversed.toList();
      setState(() {});
      SnackBarHelper.presentSuccessSnackBar(context, "Add return items success", null);
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  Future<bool> _saveReturnedReceiptItems() async {
    try {
      final List<ReceiptItemEntity> currentReturnedReceiptItems =
          context.read<ReceiptCubit>().state.receiptItems.where((element) => element.refpos3 != null).toList();
      for (final currentReturnedReceiptItem in currentReturnedReceiptItems) {
        await context.read<ReceiptCubit>().removeReceiptItem(currentReturnedReceiptItem, context);
      }
      for (final returnedReceiptItem in returnedReceiptItems) {
        await context.read<ReceiptCubit>().addUpdateReceiptItems(AddUpdateReceiptItemsParams(
            barcode: returnedReceiptItem.itemEntity.barcode,
            itemEntity: null,
            quantity: returnedReceiptItem.quantity * -1,
            context: context,
            onOpenPriceInputted: () {},
            refpos3: returnBaseReceiptEntity?.docNum));
      }
      return true;
    } catch (e) {
      final List<ReceiptItemEntity> currentReturnedReceiptItems =
          context.read<ReceiptCubit>().state.receiptItems.where((element) => element.refpos3 != null).toList();
      for (final currentReturnedReceiptItem in currentReturnedReceiptItems) {
        await context.read<ReceiptCubit>().removeReceiptItem(currentReturnedReceiptItem, context);
      }
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
      return false;
    }
  }

  void _resetDraftReturnedReceiptItems() {
    try {
      setState(() {
        returnedReceiptItems = [];
      });
      SnackBarHelper.presentSuccessSnackBar(context, "Reset return items success", null);
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  bool _isExistOnDraftReturnedReceiptItems(ReceiptItemEntity receiptItemEntity) {
    try {
      return returnedReceiptItems
          .where((element) => element.itemEntity.barcode == receiptItemEntity.itemEntity.barcode)
          .isNotEmpty;
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
      return false;
    }
  }

  double _getRemainingQty(ReceiptItemEntity receiptItemEntity) {
    try {
      final double returnedQuantity = returnedReceiptItems
              .where((element) => element.itemEntity.barcode == receiptItemEntity.itemEntity.barcode)
              .firstOrNull
              ?.quantity ??
          0;
      return receiptItemEntity.quantity - returnedQuantity;
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
      return 0;
    }
  }

  void _removeDraftReturnedReceiptItem(ReceiptItemEntity receiptItemEntity) {
    try {
      returnedReceiptItems = returnedReceiptItems
          .where((element) => element.itemEntity.barcode != receiptItemEntity.itemEntity.barcode)
          .toList();
      setState(() {});
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }
}

class InputReturnQuantityDialog extends StatelessWidget {
  final ReceiptItemEntity receiptItemEntity;
  final FocusNode _inputReturnedQtyFocusNode = FocusNode();
  final TextEditingController _inputReturnedQtyEditingController = TextEditingController();

  InputReturnQuantityDialog({super.key, required this.receiptItemEntity});

  @override
  Widget build(BuildContext context) {
    return Focus(
      skipTraversal: true,
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent) {
          return KeyEventResult.handled;
        }

        if (event.physicalKey == PhysicalKeyboardKey.escape) {
          Navigator.of(context).pop();
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
          child: const Row(
            children: [
              Text(
                'Return Quantity',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              Spacer(),
            ],
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            width: 400,
            // constraints: BoxConstraints(
            //   maxHeight: MediaQuery.of(context).size.height * 0.6,
            // ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            FieldLabel(
                              label: "Return Quantity",
                              child: TextField(
                                onSubmitted: (_) => _saveQty(context),
                                autofocus: true,
                                // inputFormatters: [NumberInputFormatter()],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 66, 66, 66)),
                                controller: _inputReturnedQtyEditingController,
                                focusNode: _inputReturnedQtyFocusNode,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(),
                                  // suffixIcon: Container(
                                  //   padding: const EdgeInsets.all(10),
                                  //   width: 80,
                                  //   height: 50,
                                  //   child: OutlinedButton(
                                  //     focusNode: FocusNode(skipTraversal: true),
                                  //     style: OutlinedButton.styleFrom(
                                  //       backgroundColor: ProjectColors.primary,
                                  //       padding: const EdgeInsets.all(5),
                                  //       foregroundColor: Colors.white,
                                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  //     ),
                                  //     onPressed: () async {},
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: [
                                  //         RichText(
                                  //           textAlign: TextAlign.center,
                                  //           text: const TextSpan(
                                  //             children: [
                                  //               TextSpan(
                                  //                 text: "Check",
                                  //                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                  //               ),
                                  //             ],
                                  //             style: TextStyle(height: 1, fontSize: 10),
                                  //           ),
                                  //           overflow: TextOverflow.clip,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: ProjectColors.background, borderRadius: BorderRadius.circular(5)),
                    child: Table(
                      // defaultColumnWidth: IntrinsicColumnWidth(),
                      columnWidths: const {0: FixedColumnWidth(100), 1: FlexColumnWidth()},
                      children: [
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Barcode",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                receiptItemEntity.itemEntity.barcode,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Name",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                receiptItemEntity.itemEntity.itemName,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Available Qty.",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                Helpers.cleanDecimal(receiptItemEntity.quantity, 3),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 30),
                //   child: Row(
                //     children: [
                //       Expanded(
                //           flex: 2,
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Row(
                //                 children: [
                //                   Text(
                //                     "Barcode",
                //                     style: TextStyle(fontSize: 12),
                //                   ),
                //                   SizedBox(
                //                     width: 8,
                //                   ),
                //                   Text(
                //                     "2302492309001",
                //                     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                //                   ),
                //                 ],
                //               ),
                //               Row(
                //                 children: [
                //                   Text(
                //                     "Name",
                //                     style: TextStyle(fontSize: 12),
                //                   ),
                //                   SizedBox(
                //                     width: 8,
                //                   ),
                //                   Text(
                //                     "HEAD IRON A GRIND BX-I #5-9PW",
                //                     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                //                   ),
                //                 ],
                //               ),
                //               Row(
                //                 children: [
                //                   Text(
                //                     "Available Qty.",
                //                     style: TextStyle(fontSize: 12),
                //                   ),
                //                   SizedBox(
                //                     width: 8,
                //                   ),
                //                   Text(
                //                     "5",
                //                     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           )),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        actions: [
          Row(
            children: [
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
              const SizedBox(width: 10),
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ProjectColors.primary),
                    )),
                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                onPressed: () => _saveQty(context),
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Save",
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
      ),
    );
  }

  void _saveQty(BuildContext context) {
    try {
      final double parsed = double.parse(_inputReturnedQtyEditingController.text);
      if (parsed <= 0) throw "Quantity must be positive";
      if (parsed > receiptItemEntity.quantity) throw "Quantity exceeds available quantity";
      context.pop(double.parse(_inputReturnedQtyEditingController.text));
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
      _inputReturnedQtyFocusNode.requestFocus();
    }
  }
}
