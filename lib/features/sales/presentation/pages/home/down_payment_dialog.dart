import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/down_payment_service.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_items_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_down_payment.dart';
import 'package:pos_fe/features/sales/presentation/cubit/items_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/quantity_receive_dp_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/item_search_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_employee_dialog.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';

class DownPaymentDialog extends StatefulWidget {
  const DownPaymentDialog({super.key});

  @override
  State<DownPaymentDialog> createState() => _DownPaymentDialogState();
}

class _DownPaymentDialogState extends State<DownPaymentDialog> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _remarksFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  List<TextEditingController> _drawAmountControllers = [];
  List<FocusNode> _drawAmountFocusNodes = [];
  List<bool> _isExceeding = [];
  List<bool> _isZero = [];
  List<bool> _selectedItems = [];
  List<List<bool>> isCheckedBox = [];
  List<DownPaymentEntity> membersDP = [];
  List<ItemEntity> itemsDP = [];
  List<double> qtyDP = [];
  List<List<DownPaymentItemsEntity>> _selectedTinv7Items = [];

  String? salesSelected;
  String? tohemIdSelected;

  late ReceiptEntity stateInvoice;
  ReceiptItemEntity? currentReceiptItemEntity;
  ItemEntity? dp;
  double grandTotalReceiveDP = 0;

  String customerSelected = "Not Set*";
  bool isReceive = true;
  bool isEdit = false;
  bool receiveZero = false;
  bool isLoadingDraw = true;
  bool isLoadingReceive = true;

  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    stateInvoice = context.read<ReceiptCubit>().state;
    readInvoiceState();
    readCustomer();
    tohemIdSelected = stateInvoice.salesTohemId;
    getEmployee(tohemIdSelected ?? "");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _remarksController.dispose();
    _amountController.dispose();
    _remarksFocusNode.dispose();
    _amountFocusNode.dispose();
    for (var controller in _drawAmountControllers) {
      controller.dispose();
    }
    for (var focusNode in _drawAmountFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void getEmployee(String tohemId) async {
    final result = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(tohemId, null);
    if (result != null) {
      setState(() {
        salesSelected = result.empName;
      });
    } else {
      setState(() {
        salesSelected = "Not Set*";
      });
    }
  }

  void removeSalesPerson() async {
    setState(() {
      salesSelected = "Not Set*";
      tohemIdSelected = "";
    });
  }

  void readInvoiceState() async {
    setState(() {
      isLoadingReceive = true;
    });
    dp = await GetIt.instance<GetDownPaymentUseCase>().call();
    if (dp != null) {
      currentReceiptItemEntity =
          stateInvoice.receiptItems.where((e) => e.itemEntity.barcode == dp!.barcode).firstOrNull;

      _remarksController.text = stateInvoice.remarks ?? "";

      if (currentReceiptItemEntity != null) {
        _amountController.text = Helpers.parseMoney(currentReceiptItemEntity!.itemEntity.price);
      } else {
        _amountController.text = "";
      }
      if (stateInvoice.downPayments != null && stateInvoice.downPayments!.isNotEmpty) {
        for (DownPaymentEntity dp in stateInvoice.downPayments!) {
          if (dp.isReceive == true) {
            final List<DownPaymentItemsEntity> dpItems = dp.tinv7 ?? [];
            for (int itemIndex = 0; itemIndex < dpItems.length; itemIndex++) {
              final DownPaymentItemsEntity item = dpItems[itemIndex];
              final String dpItemId = item.toitmId ?? "";
              final ItemModel? dbItem = await GetIt.instance<AppDatabase>().itemsDao.readByToitmId(dpItemId, null);
              if (dbItem != null) {
                itemsDP.add(ItemEntity(
                  id: null,
                  itemName: dbItem.itemName,
                  itemCode: dbItem.itemCode,
                  barcode: dbItem.barcode,
                  price: item.sellingPrice,
                  toitmId: item.toitmId ?? "",
                  tbitmId: item.tbitmId ?? "",
                  tpln2Id: dbItem.tpln2Id,
                  openPrice: dbItem.openPrice,
                  tovenId: item.tovenId,
                  includeTax: item.includeTax,
                  tovatId: item.tovatId ?? "",
                  taxRate: dbItem.taxRate,
                  dpp: dbItem.dpp,
                  tocatId: dbItem.tocatId,
                  shortName: dbItem.shortName,
                  toplnId: dbItem.toplnId,
                  scaleActive: dbItem.scaleActive,
                ));

                qtyDP.add(item.quantity);
                grandTotalReceiveDP += (item.sellingPrice * item.quantity);
              }
            }
          }
        }
      }
    } else {
      _amountController.text = "";
    }
    setState(() {
      isLoadingReceive = false;
    });
  }

  void readCustomer() async {
    setState(() {
      isLoadingDraw = true;
    });
    try {
      String customer = stateInvoice.customerEntity!.custName;

      setState(() {
        customerSelected = customer;
      });
      membersDP = await getMembersDownPayments();
      if (membersDP.isNotEmpty) {
        _setupControllers();
        if (stateInvoice.downPayments != null &&
            stateInvoice.downPayments!.isNotEmpty &&
            stateInvoice.downPayments!.any((dp) => dp.isReceive == false)) {
          isCheckedBox = List.generate(
            membersDP.length,
            (index) {
              var tinv7List = membersDP[index].tinv7 ?? [];
              return List.generate(
                tinv7List.length,
                (innerIndex) => tinv7List[innerIndex].isSelected == 1 ? true : false,
              );
            },
          );
        } else {
          isCheckedBox = List.generate(
            membersDP.length,
            (index) {
              var tinv7Length = membersDP[index].tinv7?.length ?? 0;
              return List.generate(tinv7Length, (innerIndex) => true);
            },
          );
        }
      } else {
        _setupControllers();
      }
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        isLoadingDraw = false;
      });
    }
  }

  Future<void> _resetDPItems(BuildContext childContext) async {
    SnackBarHelper.presentSuccessSnackBar(childContext, "All items removed", 2);
    final receipt = context.read<ReceiptCubit>();
    setState(() {
      itemsDP = [];
      qtyDP = [];
      grandTotalReceiveDP = 0;
      salesSelected = "Not Set*";
      _remarksController.text = "";
      _amountController.text = "";
    });

    if (receipt.state.receiptItems.isNotEmpty) {
      await receipt.removeReceiptItem(receipt.state.receiptItems[0], context);
    }
    await receipt.updateSalesTohemIdRemarksOnReceipt("", "");
    await receipt.addOrUpdateDownPayments(downPaymentEntities: [], amountDifference: 0);
  }

  Future<List<DownPaymentEntity>> getMembersDownPayments() async {
    // log("stateInvoice - ${stateInvoice.downPayments}");
    if (stateInvoice.downPayments != null &&
        stateInvoice.downPayments!.isNotEmpty &&
        stateInvoice.downPayments!.any((dp) => dp.isReceive == false)) {
      return stateInvoice.downPayments!;
    }
    return await GetIt.instance<DownPaymentApi>().fetchData(stateInvoice.customerEntity!.custCode);
  }

  void _setupControllers() {
    totalAmount = 0.0;

    _drawAmountControllers = List.generate(membersDP.length, (index) {
      TextEditingController controller = TextEditingController();
      controller.text = Helpers.parseMoney(membersDP[index].amount);
      return controller;
    });

    _drawAmountFocusNodes = List.generate(membersDP.length, (index) => FocusNode());

    _isExceeding = List.generate(membersDP.length, (index) => false);
    _isZero = List.generate(membersDP.length, (index) => false);

    _selectedItems = List.generate(membersDP.length, (index) {
      int selectedIndex = stateInvoice.downPayments
              ?.indexWhere((dp) => dp.refpos2 == membersDP[index].refpos2 && dp.isSelected == true) ??
          -1;

      if (selectedIndex != -1) {
        double amount = stateInvoice.downPayments![selectedIndex].amount;
        _drawAmountControllers[index].text = Helpers.parseMoney(amount);
        totalAmount += amount;
        return true;
      } else {
        return false;
      }
    });
  }

  Future<void> _addOrUpdateReceiveDownPayment() async {
    final receipt = context.read<ReceiptCubit>();
    if (stateInvoice.receiptItems.isNotEmpty) {
      if (currentReceiptItemEntity != null) {
        await receipt.removeReceiptItem(currentReceiptItemEntity!, context);
      }
    }

    final double amount = Helpers.revertMoneyToDecimalFormat(_amountController.text);
    if (!mounted) return;
    final AddUpdateReceiptItemsParams params = AddUpdateReceiptItemsParams(
      barcode: null,
      itemEntity: dp,
      quantity: 1,
      context: context,
      onOpenPriceInputted: () {},
      setOpenPrice: amount,
      remarks: null,
      refpos2: null,
    );

    final List<DownPaymentItemsEntity> dpItems = [];
    for (int itemIndex = 0; itemIndex < itemsDP.length; itemIndex++) {
      final ItemEntity item = itemsDP[itemIndex];
      dpItems.add(DownPaymentItemsEntity(
        docId: const Uuid().v4(),
        createDate: null,
        updateDate: null,
        toinvId: stateInvoice.toinvId,
        docNum: stateInvoice.docNum,
        idNumber: itemIndex * 10,
        toitmId: item.toitmId,
        quantity: qtyDP[itemIndex],
        sellingPrice: item.price,
        totalAmount: qtyDP[itemIndex] * item.price,
        // taxPrctg: item.taxRate,
        remarks: _remarksController.text,
        tovatId: item.tovatId,
        includeTax: item.includeTax,
        tovenId: item.tovenId,
        tbitmId: item.tbitmId,
        tohemId: tohemIdSelected ?? "",
        refpos2: null,
        qtySelected: qtyDP[itemIndex],
        isSelected: null,
      ));
    }

    final DownPaymentEntity dpEntity =
        DownPaymentEntity(amount: amount, tempItems: itemsDP, isReceive: true, tinv7: dpItems);

    await receipt.addUpdateReceiptItems(params);
    await receipt.updateSalesTohemIdRemarksOnReceipt(tohemIdSelected ?? "", _remarksController.text);
    await receipt.addOrUpdateDownPayments(downPaymentEntities: [dpEntity], amountDifference: amount);
    // log("receipt 2 - ${receipt.state}");
  }

  Future<void> _addOrUpdateDrawDownPayment(BuildContext childContext) async {
    final receipt = context.read<ReceiptCubit>();
    double totalSelectedAmount = 0;
    double previousSelectedAmount = stateInvoice.downPayments?.fold(0.0, (sum, dp) => sum! + dp.amount) ?? 0.0;

    List<DownPaymentEntity> selectedDownPayments = [];
    DownPaymentEntity? selectedDP;

    // log("stateInvoiceReceipt - ${stateInvoice.receiptItems}");

    if (_selectedItems.isNotEmpty) {
      for (int i = 0; i < _selectedItems.length; i++) {
        selectedDP = membersDP[i].copyWith(isSelected: _selectedItems[i]);
        double amount = double.tryParse(_drawAmountControllers[i].text.replaceAll(',', '')) ?? 0.0;
        if (_selectedItems[i]) {
          List<DownPaymentItemsEntity>? tinv7List = selectedDP.tinv7;
          List<DownPaymentItemsEntity> updatedTinv7List = tinv7List!.map((tinv7Item) {
            int index = tinv7List.indexOf(tinv7Item);
            return tinv7Item.copyWith(isSelected: isCheckedBox[i][index] ? 1 : 0);
          }).toList();

          selectedDP = selectedDP.copyWith(tinv7: updatedTinv7List, amount: amount);
        }
        selectedDownPayments.add(selectedDP);
        totalSelectedAmount += amount;
      }
    }

    if (selectedDownPayments.isNotEmpty) {
      for (DownPaymentEntity dp in selectedDownPayments) {
        if (dp.isSelected != null && dp.isSelected == true && dp.tinv7 != null && dp.tinv7!.isNotEmpty) {
          log("dp.salesTohemId - ${dp.salesTohemId}");
          for (DownPaymentItemsEntity dpItem in dp.tinv7 ?? []) {
            if (dpItem.isSelected == 1) {
              final itemEntity = await GetIt.instance<AppDatabase>().itemsDao.readByToitmId(dpItem.toitmId ?? "", null);
              // log("dpItem.docNum  -${dpItem.docNum}");
              final AddUpdateReceiptItemsParams paramAdd = AddUpdateReceiptItemsParams(
                barcode: itemEntity?.barcode ?? "",
                itemEntity: itemEntity,
                quantity: dpItem.quantity,
                context: context,
                onOpenPriceInputted: () {},
                refpos2: dpItem.docNum,
                tohemId: dp.salesTohemId,
                remarks: dp.remarks,
              );
              await receipt.addUpdateReceiptItems(paramAdd);
            }
          }
        }
      }
    }
    double grandTotalDifference = previousSelectedAmount - totalSelectedAmount;
    receipt.addOrUpdateDownPayments(downPaymentEntities: selectedDownPayments, amountDifference: grandTotalDifference);
    context.pop();
  }

  Future<void> _resetDrawDownPayment() async {
    final receipt = context.read<ReceiptCubit>();
    List<DownPaymentEntity> downPaymentList = stateInvoice.downPayments ?? [];
    List<ReceiptItemEntity> receiptItemList = stateInvoice.receiptItems;

    if (downPaymentList.isNotEmpty && receiptItemList.isNotEmpty) {
      for (DownPaymentEntity dp in downPaymentList) {
        for (DownPaymentItemsEntity dpItem in dp.tinv7 ?? []) {
          for (ReceiptItemEntity itemReceipt in receiptItemList) {
            log("itemReceipt - $itemReceipt");
            if (dpItem.toitmId == itemReceipt.itemEntity.toitmId &&
                dpItem.tbitmId == itemReceipt.itemEntity.tbitmId &&
                itemReceipt.refpos2 != null) {
              final AddUpdateReceiptItemsParams param = AddUpdateReceiptItemsParams(
                barcode: itemReceipt.itemEntity.barcode,
                itemEntity: itemReceipt.itemEntity,
                quantity: dpItem.quantity * -1,
                context: context,
                onOpenPriceInputted: () {},
                refpos2: dpItem.docNum,
              );
              await receipt.addUpdateReceiptItems(param);
            }
          }
        }
      }
    }
    await receipt.addOrUpdateDownPayments(downPaymentEntities: [], amountDifference: 0);
    stateInvoice = receipt.state.copyWith();
  }

  Future<void> _resetDownPayment() async {
    final receipt = context.read<ReceiptCubit>();
    List<DownPaymentEntity> downPaymentList = stateInvoice.downPayments ?? [];
    List<ReceiptItemEntity> receiptItemList = stateInvoice.receiptItems;

    setState(() {
      _selectedItems = List.generate(membersDP.length, (_) => false);
      totalAmount = 0;
      for (int index = 0; index < _drawAmountControllers.length; index++) {
        _drawAmountControllers[index].text = Helpers.parseMoney(membersDP[index].amount);
      }
    });
    if (downPaymentList.isNotEmpty && receiptItemList.isNotEmpty) {
      for (DownPaymentEntity dp in downPaymentList) {
        for (DownPaymentItemsEntity dpItem in dp.tinv7 ?? []) {
          for (ReceiptItemEntity itemReceipt in receiptItemList) {
            if (dpItem.toitmId == itemReceipt.itemEntity.toitmId && dpItem.tbitmId == itemReceipt.itemEntity.tbitmId) {
              final AddUpdateReceiptItemsParams param = AddUpdateReceiptItemsParams(
                barcode: itemReceipt.itemEntity.barcode,
                itemEntity: itemReceipt.itemEntity,
                quantity: dpItem.quantity * -1,
                context: context,
                onOpenPriceInputted: () {},
                refpos2: dpItem.docNum,
              );
              await receipt.addUpdateReceiptItems(param);
            }
          }
        }
      }
    }

    await receipt.addOrUpdateDownPayments(downPaymentEntities: [], amountDifference: 0);
    stateInvoice = receipt.state.copyWith();
  }

  Future<bool> _checkDrawDownPayment() async {
    final receiptEntity = context.read<ReceiptCubit>().state;
    bool dpAllocated = receiptEntity.downPayments != null &&
        receiptEntity.downPayments!.isNotEmpty &&
        receiptEntity.downPayments!.any((dp) => dp.isReceive == false);
    return dpAllocated;
  }

  Future<bool> _checkReceiveDownPayment() async {
    final receiptItems = context.read<ReceiptCubit>().state.receiptItems;
    final bool itemDP =
        receiptItems.any((item) => item.itemEntity.itemCode == "99" || item.itemEntity.itemCode == "08700000002");

    return itemDP;
  }

  Future<void> _recalculateDownPayment(double grandTotal) async {
    final defaultDP = 0.3 * grandTotal;
    setState(() {
      _amountController.text = Helpers.parseMoney(defaultDP);
    });
  }

  Future<ItemMasterModel> _getItem(String toitmId) async {
    final item = await GetIt.instance<AppDatabase>().itemMasterDao.readByDocId(toitmId, null);
    return item!;
  }

  Future<void> updateSalesAndRemarks() async {
    List<DownPaymentEntity> selectedDownPayments = [];

    if (_selectedItems.isNotEmpty) {
      for (int i = 0; i < _selectedItems.length; i++) {
        DownPaymentEntity dp = membersDP[i].copyWith(isSelected: _selectedItems[i]);
        double amount = double.tryParse(_drawAmountControllers[i].text.replaceAll(',', '')) ?? 0.0;

        if (_selectedItems[i]) {
          List<DownPaymentItemsEntity>? tinv7List = dp.tinv7;
          List<DownPaymentItemsEntity> updatedTinv7List = tinv7List!.map((tinv7Item) {
            int index = tinv7List.indexOf(tinv7Item);
            return tinv7Item.copyWith(isSelected: isCheckedBox[i][index] ? 1 : 0);
          }).toList();

          dp = dp.copyWith(tinv7: updatedTinv7List, amount: amount);
        }
        selectedDownPayments.add(dp);
      }
    }

    final receiptCubit = context.read<ReceiptCubit>();
    List<ReceiptItemEntity> receiptItems = receiptCubit.state.receiptItems;

    for (DownPaymentEntity dp in selectedDownPayments) {
      for (int tinv7Index = 0; tinv7Index < (dp.tinv7?.length ?? 0); tinv7Index++) {
        DownPaymentItemsEntity tinv7Item = dp.tinv7![tinv7Index];

        for (int receiptIndex = 0; receiptIndex < receiptItems.length; receiptIndex++) {
          ReceiptItemEntity receiptItem = receiptItems[receiptIndex];

          if (tinv7Item.docNum == receiptItem.refpos2) {
            String tohemId = dp.salesTohemId ?? "";
            String remarks = tinv7Item.remarks ?? "";
            await receiptCubit.updateTohemIdRemarksOnReceiptItem(tohemId, remarks, receiptIndex);
          }
        }
      }
    }
  }

  List<ItemEntity> groupItems(List<ItemEntity> items) {
    Map<String, ItemEntity> groupedItemsMap = {};

    for (var item in items) {
      String key = "${item.itemCode}_${item.barcode}";

      if (!groupedItemsMap.containsKey(key)) {
        groupedItemsMap[key] = item;
      }
    }

    return groupedItemsMap.values.toList();
  }

  List<double> groupQtys(List<ItemEntity> items, List<double> qtys) {
    Map<String, double> groupedQtysMap = {};

    for (int i = 0; i < items.length; i++) {
      ItemEntity item = items[i];
      double quantity = qtys[i];

      String key = "${item.itemCode}_${item.barcode}";

      if (groupedQtysMap.containsKey(key)) {
        groupedQtysMap[key] = (groupedQtysMap[key] ?? 0) + quantity;
      } else {
        groupedQtysMap[key] = quantity;
      }
    }

    return groupedQtysMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Focus(
            autofocus: true,
            skipTraversal: true,
            onKeyEvent: (node, event) {
              if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;
              if (event.physicalKey == PhysicalKeyboardKey.f12) {
                isReceive
                    ? () async {
                        FocusScope.of(context).unfocus();
                        final receiptItems = context.read<ReceiptCubit>().state.receiptItems;
                        if (receiptItems.any((item) => item.itemEntity.itemCode != "99") &&
                            receiptItems.any((item) => item.itemEntity.itemCode != "08700000002")) {
                          SnackBarHelper.presentErrorSnackBar(
                              childContext, "Down payment has to be excluded from other transactions");
                          return;
                        }
                        if (salesSelected == "Not Set*") {
                          SnackBarHelper.presentErrorSnackBar(childContext, "Please select the salesperson");
                          return;
                        }
                        if (receiveZero || _amountController.text == "") {
                          SnackBarHelper.presentErrorSnackBar(childContext, "Please input the Down Payment amount");
                          return;
                        }
                        if (_remarksController.text.isEmpty) {
                          SnackBarHelper.presentErrorSnackBar(childContext, "Please fill in the remarks");
                          return;
                        }
                        if (await _checkDrawDownPayment()) {
                          if (childContext.mounted) {
                            SnackBarHelper.presentErrorSnackBar(childContext,
                                "Receiving and drawing down payment cannot be processed in a single transaction");
                          }
                          return;
                        }
                        if (context.mounted) {
                          context.pop();
                        }
                        await _addOrUpdateReceiveDownPayment();
                      }
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (await _checkReceiveDownPayment()) {
                          if (childContext.mounted) {
                            SnackBarHelper.presentErrorSnackBar(childContext,
                                "Receiving and drawing down payment cannot be processed in a single transaction");
                          }
                          return;
                        }

                        await _resetDrawDownPayment();

                        if (childContext.mounted) {
                          await _addOrUpdateDrawDownPayment(childContext);
                        }

                        await updateSalesAndRemarks();
                      };
              } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
                context.pop();
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
                padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                child: Row(
                  children: [
                    const Text(
                      'Down Payment',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const Spacer(),
                    ToggleSwitch(
                      minHeight: 30,
                      minWidth: 70.0,
                      cornerRadius: 20.0,
                      animate: true,
                      animationDuration: 400,
                      curve: Curves.easeInOut,
                      activeBgColors: const [
                        [ProjectColors.green],
                        [ProjectColors.green]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: const Color.fromARGB(255, 211, 211, 211),
                      inactiveFgColor: ProjectColors.lightBlack,
                      initialLabelIndex: isReceive ? 0 : 1,
                      totalSwitches: 2,
                      labels: const ['Receive', 'Draw'],
                      customTextStyles: const [
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700)
                      ],
                      radiusStyle: true,
                      onToggle: (index) {
                        if (index == 0) {
                          setState(() {
                            isReceive = true;
                          });
                        }
                        if (index == 1) {
                          setState(() {
                            isReceive = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.all(0),
              content: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Scrollbar(
                    controller: _scrollController,
                    thickness: 4,
                    radius: const Radius.circular(30),
                    thumbVisibility: true,
                    child: isReceive ? _buildReceiveDownPayment() : _buildDrawDownPayment(),
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(color: ProjectColors.primary))),
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          overlayColor:
                              MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
                      onPressed: isReceive
                          ? () async {
                              FocusScope.of(context).unfocus();
                              final receiptItems = context.read<ReceiptCubit>().state.receiptItems;
                              if (receiptItems.any((item) => item.itemEntity.itemCode != "99") &&
                                  receiptItems.any((item) => item.itemEntity.itemCode != "08700000002")) {
                                SnackBarHelper.presentErrorSnackBar(
                                    childContext, "Down payment has to be excluded from other transactions");
                                return;
                              }
                              if (salesSelected == "Not Set*") {
                                SnackBarHelper.presentErrorSnackBar(childContext, "Please select the salesperson");
                                return;
                              }
                              if (receiveZero || _amountController.text == "") {
                                SnackBarHelper.presentErrorSnackBar(
                                    childContext, "Please input the Down Payment amount");
                                return;
                              }
                              if (_remarksController.text.isEmpty) {
                                SnackBarHelper.presentErrorSnackBar(childContext, "Please fill in the remarks");
                                return;
                              }
                              if (await _checkDrawDownPayment()) {
                                if (childContext.mounted) {
                                  SnackBarHelper.presentErrorSnackBar(childContext,
                                      "Receiving and drawing down a payment cannot be processed in a single transaction");
                                }
                                return;
                              }
                              if (context.mounted) {
                                context.pop();
                              }
                              await _addOrUpdateReceiveDownPayment();
                            }
                          : () async {
                              FocusScope.of(context).unfocus();
                              if (await _checkReceiveDownPayment()) {
                                if (childContext.mounted) {
                                  SnackBarHelper.presentErrorSnackBar(childContext,
                                      "Receiving and drawing down payment cannot be processed in a single transaction");
                                }
                                return;
                              }

                              await _resetDrawDownPayment();

                              if (childContext.mounted) {
                                await _addOrUpdateDrawDownPayment(childContext);
                              }

                              await updateSalesAndRemarks();
                            },
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
              actionsPadding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReceiveDownPayment() {
    List<ItemEntity> groupedItems = groupItems(itemsDP);
    List<double> groupedQtys = groupQtys(itemsDP, qtyDP);

    return Builder(builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: Tooltip(
                      message: "Receipt Number: ${stateInvoice.docNum}",
                      child: Row(
                        children: [
                          const Icon(
                            Icons.receipt_outlined,
                            color: Color.fromARGB(255, 66, 66, 66),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            stateInvoice.docNum,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 66, 66, 66),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tooltip(
                    message: "Customer Name: $customerSelected",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.face_outlined,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          customerSelected,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 66, 66, 66),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tooltip(
                    message: "Salesperson: $salesSelected",
                    child: Row(
                      children: [
                        const Icon(
                          Icons.handshake_outlined,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => showDialog<EmployeeEntity>(
                            context: context,
                            builder: (BuildContext context) => const SelectEmployee(),
                          ).then((selectedEmployee) {
                            if (selectedEmployee != null) {
                              setState(() {
                                salesSelected = selectedEmployee.empName;
                                tohemIdSelected = selectedEmployee.docId;
                              });
                            }
                          }),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                salesSelected.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 66, 66, 66),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              (salesSelected != "Not Set*" && salesSelected != null)
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: ProjectColors.primary,
                                      ),
                                      onPressed: () {
                                        removeSalesPerson();
                                      },
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.navigate_next,
                                        color: Color.fromARGB(255, 66, 66, 66),
                                      ),
                                      onPressed: () => showDialog<EmployeeEntity>(
                                        context: context,
                                        builder: (BuildContext context) => const SelectEmployee(),
                                      ).then(
                                        (selectedEmployee) {
                                          if (selectedEmployee != null) {
                                            setState(() {
                                              salesSelected = selectedEmployee.empName;
                                              tohemIdSelected = selectedEmployee.docId;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final check = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return _warningCloseDPDialog();
                                });
                            if (check) {
                              await _resetDPItems(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                            decoration: BoxDecoration(
                              color: ProjectColors.primary,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, 0.222),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.remove_shopping_cart_outlined,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () async {
                            context.read<ItemsCubit>().clearItems();
                            if (mounted) {
                              FocusScope.of(context).unfocus();
                            }
                            final ItemEntity? itemEntitySearch = await showDialog<ItemEntity>(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const ItemSearchDialog());

                            context.read<ItemsCubit>().clearItems();

                            if (itemEntitySearch != null) {
                              final double quantity = double.parse((await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const QuantityReceiveDPDialog(
                                            quantity: 0,
                                          )))
                                  .replaceAll(',', ''));
                              setState(() {
                                itemsDP.add(itemEntitySearch);
                                qtyDP.add(quantity);
                                grandTotalReceiveDP += (itemEntitySearch.price * quantity);
                              });
                              await _recalculateDownPayment(grandTotalReceiveDP);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                            decoration: BoxDecoration(
                              color: ProjectColors.primary,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, 0.222),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_outlined,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 250,
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      decoration: BoxDecoration(
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
                                      child: Column(
                                        children: [
                                          (isLoadingReceive)
                                              ? const Center(child: CircularProgressIndicator())
                                              : (groupedItems.isEmpty)
                                                  ? const Expanded(
                                                      child: Center(
                                                        child: EmptyList(
                                                          imagePath: "assets/images/empty-item.svg",
                                                          sentence:
                                                              "Tadaa.. There is nothing here!\nPress icon + to start adding item.",
                                                          height: 100,
                                                        ),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: ListView.separated(
                                                          itemBuilder: (BuildContext context, int index) {
                                                            return Material(
                                                              type: MaterialType.transparency,
                                                              elevation: 6,
                                                              color: Colors.transparent,
                                                              shadowColor: Colors.grey[50],
                                                              child: InkWell(
                                                                focusColor: const Color.fromRGBO(255, 220, 221, 1.0),
                                                                onTap: () {},
                                                                child: SizedBox(
                                                                  height: 50,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 30,
                                                                          child: Text(
                                                                            (index + 1).toString(),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 10),
                                                                        Expanded(
                                                                          flex: 3,
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.start,
                                                                                children: [
                                                                                  SvgPicture.asset(
                                                                                    "assets/images/inventory.svg",
                                                                                    height: 18,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    groupedItems[index].itemCode,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Color.fromARGB(
                                                                                          255, 66, 66, 66),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  SvgPicture.asset(
                                                                                    "assets/images/barcode.svg",
                                                                                    height: 20,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    groupedItems[index].barcode,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Color.fromARGB(
                                                                                          255, 66, 66, 66),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Text(
                                                                                groupedItems[index].itemName,
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color:
                                                                                      Color.fromARGB(255, 66, 66, 66),
                                                                                ),
                                                                                textAlign: TextAlign.start,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            Helpers.parseMoney(
                                                                                groupedItems[index].price),
                                                                            textAlign: TextAlign.end,
                                                                            style: const TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color.fromARGB(255, 66, 66, 66),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                                                            child: Text(
                                                                              "${Helpers.cleanDecimal(groupedQtys[index], 1)} x",
                                                                              textAlign: TextAlign.end,
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Color.fromARGB(255, 66, 66, 66),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            flex: 1,
                                                                            child: Text(
                                                                              Helpers.parseMoney(groupedQtys[index] *
                                                                                  groupedItems[index].price),
                                                                              textAlign: TextAlign.end,
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Color.fromARGB(255, 66, 66, 66),
                                                                              ),
                                                                            )),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                IntrinsicHeight(
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      final double quantity =
                                                                                          double.parse(
                                                                                              (await showDialog(
                                                                                        context: context,
                                                                                        barrierDismissible: false,
                                                                                        builder: (context) =>
                                                                                            QuantityReceiveDPDialog(
                                                                                          quantity: groupedQtys[index],
                                                                                        ),
                                                                                      ))
                                                                                                  .replaceAll(',', ''));
                                                                                      setState(() {
                                                                                        grandTotalReceiveDP -=
                                                                                            groupedItems[index].price *
                                                                                                qtyDP[index];
                                                                                        groupedQtys[index] = quantity;
                                                                                        grandTotalReceiveDP +=
                                                                                            groupedItems[index].price *
                                                                                                groupedQtys[index];
                                                                                      });
                                                                                      await _recalculateDownPayment(
                                                                                          grandTotalReceiveDP);
                                                                                    },
                                                                                    child: Container(
                                                                                      alignment: Alignment.center,
                                                                                      padding:
                                                                                          const EdgeInsets.fromLTRB(
                                                                                              6, 6, 6, 6),
                                                                                      decoration: BoxDecoration(
                                                                                        color: ProjectColors.blue,
                                                                                        borderRadius:
                                                                                            BorderRadius.circular(5),
                                                                                        boxShadow: const [
                                                                                          BoxShadow(
                                                                                            spreadRadius: 0.5,
                                                                                            blurRadius: 5,
                                                                                            color: Color.fromRGBO(
                                                                                                0, 0, 0, 0.222),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      child: const Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.edit_outlined,
                                                                                            size: 18,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(width: 5),
                                                                                IntrinsicHeight(
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      setState(() {
                                                                                        grandTotalReceiveDP -=
                                                                                            (groupedItems[index].price *
                                                                                                groupedQtys[index]);
                                                                                        groupedItems
                                                                                            .remove(itemsDP[index]);
                                                                                        groupedQtys
                                                                                            .remove(qtyDP[index]);
                                                                                      });
                                                                                      await _recalculateDownPayment(
                                                                                          grandTotalReceiveDP);
                                                                                      if (context.mounted) {
                                                                                        SnackBarHelper
                                                                                            .presentSuccessSnackBar(
                                                                                                context,
                                                                                                "Item ${itemsDP[index].itemName} removed",
                                                                                                2);
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      alignment: Alignment.center,
                                                                                      padding:
                                                                                          const EdgeInsets.fromLTRB(
                                                                                              6, 6, 6, 6),
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.deepOrange,
                                                                                        borderRadius:
                                                                                            BorderRadius.circular(5),
                                                                                        boxShadow: const [
                                                                                          BoxShadow(
                                                                                            spreadRadius: 0.5,
                                                                                            blurRadius: 5,
                                                                                            color: Color.fromRGBO(
                                                                                                0, 0, 0, 0.222),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      child: const Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.close_outlined,
                                                                                            size: 18,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ],
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
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          separatorBuilder: (BuildContext context, int index) =>
                                                              const Divider(
                                                                height: 10,
                                                                thickness: 0.5,
                                                                color: Color.fromARGB(100, 118, 118, 117),
                                                              ),
                                                          itemCount: groupedItems.length),
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 15, 20, 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 30),
                                        const Expanded(
                                          flex: 3,
                                          child: Text(
                                            "GRAND TOTAL",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                            child: Text(
                                              "${Helpers.cleanDecimal((qtyDP.isEmpty) ? 0 : qtyDP.reduce((a, b) => a + b), 1)} x",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(255, 66, 66, 66),
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            Helpers.parseMoney(grandTotalReceiveDP),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 30),
                                        const Expanded(
                                          flex: 3,
                                          child: Text(
                                            "DP Amount*",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(255, 66, 66, 66),
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                                            child: TextField(
                                              maxLines: 1,
                                              maxLength: 21,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(255, 66, 66, 66),
                                              ),
                                              inputFormatters: [MoneyInputFormatter()],
                                              controller: _amountController,
                                              focusNode: _amountFocusNode,
                                              textAlign: TextAlign.end,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: "Input Amount*",
                                                hintStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                contentPadding: const EdgeInsets.all(10),
                                                border: const OutlineInputBorder(),
                                                // enabledBorder: const UnderlineInputBorder(
                                                //   borderSide: BorderSide(color: Colors.black, width: 1),
                                                // ),
                                                // focusedBorder: const UnderlineInputBorder(
                                                //   borderSide: BorderSide(color: ProjectColors.primary, width: 2),
                                                // ),
                                                counterText: "",
                                                prefixText: receiveZero ? "Amount can't be zero" : null,
                                                prefixStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w700,
                                                  color: ProjectColors.swatch,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                final amount = double.tryParse(value.replaceAll(',', '')) ?? 0;
                                                setState(() {
                                                  receiveZero = amount == 0;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 30),
                                        const Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Remarks*",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(255, 66, 66, 66),
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: SingleChildScrollView(
                                            child: Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                                                child: TextField(
                                                  maxLines: null,
                                                  maxLength: 300,
                                                  controller: _remarksController,
                                                  focusNode: _remarksFocusNode,
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(255, 66, 66, 66),
                                                  ),
                                                  decoration: const InputDecoration(
                                                    contentPadding: EdgeInsets.all(10),
                                                    isDense: true,
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: ProjectColors.lightBlack,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: ProjectColors.lightBlack,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: ProjectColors.primary,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    counterText: "",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDrawDownPayment() {
    return isLoadingDraw
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double itemHeight = 100.0;
                double totalHeight = (membersDP.isEmpty) ? 60 : itemHeight * membersDP.length;
                double maxHeight = constraints.maxHeight;
                double height = totalHeight < maxHeight ? (totalHeight * 1.75) : maxHeight;

                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: height,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ExcludeFocus(
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                decoration: BoxDecoration(
                                  color: ProjectColors.primary,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      spreadRadius: 0.5,
                                      blurRadius: 5,
                                      color: Color.fromRGBO(0, 0, 0, 0.222),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Customer:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      customerSelected,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              ExcludeFocus(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    decoration: BoxDecoration(
                                      color: ProjectColors.green,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: const [
                                        BoxShadow(
                                          spreadRadius: 0.5,
                                          blurRadius: 5,
                                          color: Color.fromRGBO(0, 0, 0, 0.222),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Total Draw:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          Helpers.parseMoney(totalAmount),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              ExcludeFocus(
                                child: GestureDetector(
                                  onTap: () async {
                                    await _resetDownPayment();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                      decoration: BoxDecoration(
                                        color: ProjectColors.primary,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                            spreadRadius: 0.5,
                                            blurRadius: 5,
                                            color: Color.fromRGBO(0, 0, 0, 0.222),
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.replay_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      (membersDP.isEmpty)
                          ? const Center(
                              child: Text(
                                  "No prior down payments found for this customer, or you may be offline.\nPlease check your internet connection and try again.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700,
                                  )),
                            )
                          : const SizedBox.shrink(),
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      (_selectedItems[index]) ? const Color.fromARGB(96, 201, 236, 209) : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ProjectColors.primary,
                                    width: 2.0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                (_selectedItems[index])
                                                    ? const Icon(
                                                        Icons.done_all_outlined,
                                                        size: 24,
                                                        color: Colors.green,
                                                      )
                                                    : const SizedBox(width: 24),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "${membersDP[index].refpos2}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: ProjectColors.primary,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Available",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: ProjectColors.mediumBlack,
                                                  ),
                                                ),
                                                Text(
                                                  Helpers.parseMoney(membersDP[index].amount),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: ProjectColors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.2,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          TextField(
                                                            maxLines: 1,
                                                            maxLength: 21,
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w700,
                                                              color: Colors.black,
                                                            ),
                                                            inputFormatters: [MoneyInputFormatter()],
                                                            controller: _drawAmountControllers[index],
                                                            focusNode: _drawAmountFocusNodes[index],
                                                            decoration: const InputDecoration(
                                                              isDense: true,
                                                              contentPadding: EdgeInsets.all(10),
                                                              border: OutlineInputBorder(),
                                                              counterText: "",
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: ProjectColors.lightBlack,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: ProjectColors.primary,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Colors.transparent,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                            ),
                                                            enabled: !_selectedItems[index],
                                                            onEditingComplete: () {
                                                              setState(() {
                                                                double enteredAmount = double.parse(
                                                                    _drawAmountControllers[index]
                                                                        .text
                                                                        .replaceAll(',', ''));

                                                                _isExceeding[index] =
                                                                    enteredAmount > membersDP[index].amount;
                                                                _isZero[index] = enteredAmount == 0;

                                                                _selectedItems[index] = !_selectedItems[index];

                                                                if (_selectedItems[index]) {
                                                                  totalAmount += enteredAmount;
                                                                } else {
                                                                  totalAmount -= enteredAmount;
                                                                }
                                                              });
                                                            },
                                                            onChanged: (value) {
                                                              setState(() {
                                                                double enteredAmount =
                                                                    double.tryParse(value.replaceAll(',', '')) ?? 0.0;
                                                                _isExceeding[index] =
                                                                    enteredAmount > membersDP[index].amount;
                                                                _isZero[index] = enteredAmount == 0;

                                                                _selectedItems[index] = false;
                                                              });
                                                            },
                                                          ),
                                                          _isExceeding[index]
                                                              ? const Text(
                                                                  "Max Amount Exceeded",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: ProjectColors.swatch,
                                                                  ),
                                                                )
                                                              : const SizedBox.shrink(),
                                                          _isZero[index]
                                                              ? const Text(
                                                                  "Amount can't be zero",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: ProjectColors.swatch,
                                                                  ),
                                                                )
                                                              : const SizedBox.shrink(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IntrinsicWidth(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      // log("Edit button pressed");
                                                      if (!_isExceeding[index] && !_isZero[index]) {
                                                        setState(() {
                                                          _selectedItems[index] = !_selectedItems[index];

                                                          double amount = double.tryParse(_drawAmountControllers[index]
                                                                  .text
                                                                  .replaceAll(',', '')) ??
                                                              0;

                                                          if (_selectedItems[index]) {
                                                            totalAmount += amount;

                                                            _selectedTinv7Items =
                                                                List.generate(membersDP.length, (i) => []);

                                                            final tinv7List = membersDP[index].tinv7 ?? [];

                                                            if (index < isCheckedBox.length &&
                                                                isCheckedBox[index].isNotEmpty) {
                                                              _selectedTinv7Items[index] = tinv7List.where((item) {
                                                                int innerIndex = tinv7List.indexOf(item);
                                                                return innerIndex < isCheckedBox[index].length &&
                                                                    isCheckedBox[index][innerIndex];
                                                              }).toList();
                                                            } else {
                                                              // log("isCheckedBox[$index] is not initialized or empty");
                                                            }
                                                          } else {
                                                            totalAmount -= amount;
                                                            if (_selectedTinv7Items.length > index) {
                                                              _selectedTinv7Items[index].clear();
                                                            }
                                                          }
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                                      decoration: BoxDecoration(
                                                        color: (!_selectedItems[index])
                                                            ? ProjectColors.blue
                                                            : Colors.deepOrange,
                                                        borderRadius: BorderRadius.circular(5),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            spreadRadius: 0.5,
                                                            blurRadius: 5,
                                                            color: Color.fromRGBO(0, 0, 0, 0.222),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            (!_selectedItems[index]) ? "Select" : "Unselect",
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                (membersDP[index].tinv7 != null &&
                                                        membersDP[index].tinv7!.isNotEmpty &&
                                                        _selectedItems[index])
                                                    ? IntrinsicHeight(
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            bool allSelected =
                                                                isCheckedBox[index].every((isChecked) => isChecked);

                                                            setState(() {
                                                              for (int innerIndex = 0;
                                                                  innerIndex < isCheckedBox[index].length;
                                                                  innerIndex++) {
                                                                isCheckedBox[index][innerIndex] = !allSelected;
                                                              }

                                                              List<DownPaymentEntity> dpList =
                                                                  stateInvoice.downPayments ?? [];
                                                              if (dpList.length > index) {
                                                                for (int innerIndex = 0;
                                                                    innerIndex < dpList[index].tinv7!.length;
                                                                    innerIndex++) {
                                                                  DownPaymentItemsEntity dpItem =
                                                                      dpList[index].tinv7![innerIndex];
                                                                  dpItem =
                                                                      dpItem.copyWith(isSelected: !allSelected ? 1 : 0);
                                                                  dpList[index].tinv7![innerIndex] = dpItem;
                                                                }
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                                            decoration: BoxDecoration(
                                                              color: ProjectColors.primary,
                                                              borderRadius: BorderRadius.circular(5),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  spreadRadius: 0.5,
                                                                  blurRadius: 5,
                                                                  color: Color.fromRGBO(0, 0, 0, 0.222),
                                                                ),
                                                              ],
                                                            ),
                                                            child: const Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  Icons.check_box_outlined,
                                                                  size: 18,
                                                                  color: Colors.white,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(width: 30),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (membersDP[index].tinv7 != null &&
                                        membersDP[index].tinv7!.isNotEmpty &&
                                        _selectedItems[index])
                                      Column(
                                        children: [
                                          const Divider(
                                            thickness: 0.5,
                                            color: ProjectColors.primary,
                                          ),
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: membersDP[index].tinv7!.length,
                                            itemBuilder: (context, innerIndex) {
                                              var tinvItem = membersDP[index].tinv7![innerIndex];
                                              return FutureBuilder<ItemMasterModel>(
                                                future: _getItem(tinvItem.toitmId ?? ""),
                                                builder: (context, snapshot) {
                                                  String itemName = "";
                                                  String itemBarcode = "";
                                                  String itemDocid = "";
                                                  double qtyAdditional = 0;
                                                  ItemMasterModel? item = snapshot.data;
                                                  if (item != null) {
                                                    itemName = item.itemName;
                                                    itemBarcode = item.itemCode;
                                                    itemDocid = item.docId;
                                                  }

                                                  List<ReceiptItemEntity> matchingReceiptItems =
                                                      stateInvoice.receiptItems.where((receiptItem) {
                                                    return receiptItem.itemEntity.itemName == itemName &&
                                                        receiptItem.itemEntity.itemCode == itemBarcode &&
                                                        receiptItem.itemEntity.toitmId == itemDocid;
                                                  }).toList();

                                                  if (matchingReceiptItems.isNotEmpty) {
                                                    qtyAdditional = matchingReceiptItems[0].quantity;
                                                  }

                                                  return CheckboxListTile(
                                                    title: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            itemName,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: ProjectColors.mediumBlack,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/images/barcode.svg",
                                                                height: 20,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                itemBarcode,
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: ProjectColors.mediumBlack,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    "Booked",
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      color: ProjectColors.mediumBlack,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    Helpers.cleanDecimal(tinvItem.quantity, 1),
                                                                    style: const TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: ProjectColors.primary,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    "Selected",
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      color: ProjectColors.mediumBlack,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    Helpers.cleanDecimal(
                                                                      (isCheckedBox[index][innerIndex])
                                                                          ? (tinvItem.quantity + qtyAdditional)
                                                                          : (tinvItem.qtySelected ?? 0 + qtyAdditional),
                                                                      1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    value: isCheckedBox[index][innerIndex],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isCheckedBox[index][innerIndex] = value ?? false;
                                                      });
                                                      List<DownPaymentEntity> dpList = stateInvoice.downPayments ?? [];
                                                      for (DownPaymentEntity dp in dpList) {
                                                        if (dp.isSelected == true &&
                                                            dp.tinv7 != null &&
                                                            dp.tinv7!.isNotEmpty) {
                                                          if (innerIndex < dp.tinv7!.length) {
                                                            DownPaymentItemsEntity dpItem = dp.tinv7![innerIndex];

                                                            dpItem = dpItem.copyWith(isSelected: value! ? 1 : 0);

                                                            dp.tinv7![innerIndex] = dpItem;
                                                          }
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            separatorBuilder: (BuildContext context, int index) => const Divider(
                                              thickness: 0.5,
                                              color: Color.fromARGB(100, 118, 118, 117),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10.0),
                          itemCount: membersDP.length,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }

  Future<bool> areAllItemsSelected() async {
    for (int i = 0; i < isCheckedBox.length; i++) {
      for (int innerIndex = 0; innerIndex < isCheckedBox[i].length; innerIndex++) {
        if (!isCheckedBox[i][innerIndex]) {
          return false;
        }
      }
    }
    return true;
  }

  Widget _warningCloseDPDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
        child: const Text(
          'Caution',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.fromLTRB(40, 20, 30, 10),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/caution.png",
            width: 70,
          ),
          const SizedBox(
            width: 30,
          ),
          SizedBox(
            width: 400,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "This will remove all items inputed and reset the down payment. Proceed?",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              overflow: TextOverflow.clip,
            ),
          )
        ],
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
                    context.pop(false);
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
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
              onPressed: () async {
                if (mounted) {
                  context.pop(true);
                }
              },
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Proceed",
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
    );
  }
}
