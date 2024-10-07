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
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_down_payment.dart';
import 'package:pos_fe/features/sales/presentation/cubit/items_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/quantity_draw_dp_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/item_search_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_employee_dialog.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  bool isLoading = false;
  double totalAmount = 0;

  List<DownPaymentEntity> membersDP = [];
  List<ItemEntity> itemsDP = [];
  List<double> qtyDP = [];

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
    } else {
      _amountController.text = "";
      if (mounted) {
        SnackBarHelper.presentErrorSnackBar(context, "Item DP not found for this store");
      }
    }
  }

  void readCustomer() async {
    setState(() {
      isLoading = true;
    });
    try {
      String customer = stateInvoice.customerEntity!.custName;

      setState(() {
        customerSelected = customer;
      });
      membersDP = await getMembersDownPayments();
      if (membersDP.isNotEmpty) {
        _setupControllers();
      } else {
        _setupControllers();
      }
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _resetDPItems(BuildContext childContext) async {
    SnackBarHelper.presentSuccessSnackBar(childContext, "All items removed", 2);
    setState(() {
      itemsDP = [];
      qtyDP = [];
      grandTotalReceiveDP = 0;
      salesSelected = "Not Set*";
      _remarksController.text = "";
      _amountController.text = "";
    });
  }

  Future<List<DownPaymentEntity>> getMembersDownPayments() async {
    final List<DownPaymentEntity> downPayments =
        await GetIt.instance<DownPaymentApi>().fetchData(stateInvoice.customerEntity!.custCode);

    return downPayments;
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
      int selectedIndex =
          stateInvoice.downPayments?.indexWhere((dp) => dp.toinvDocId == membersDP[index].refpos2) ?? -1;
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

    final amount = Helpers.revertMoneyToDecimalFormat(_amountController.text);
    final params = AddUpdateReceiptItemsParams(
      barcode: null,
      itemEntity: dp,
      quantity: 1,
      context: context,
      onOpenPriceInputted: () {},
      setOpenPrice: amount,
      remarks: null,
      refpos2: null,
    );

    await receipt.addUpdateReceiptItems(params);
    await receipt.updateSalesTohemIdRemarksOnReceipt(tohemIdSelected ?? "", _remarksController.text);
  }

  Future<void> _addOrUpdateDrawDownPayment(BuildContext childContext) async {
    final receipt = context.read<ReceiptCubit>();

    List<DownPaymentEntity> selectedDownPayments = [];
    double totalSelectedAmount = 0;
    double previousSelectedAmount = stateInvoice.downPayments?.fold(0.0, (sum, dp) => sum! + dp.amount) ?? 0.0;

    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i]) {
        double amount = double.tryParse(_drawAmountControllers[i].text.replaceAll(',', '')) ?? 0.0;
        selectedDownPayments.add(DownPaymentEntity(toinvDocId: membersDP[i].refpos2, amount: amount));
        totalSelectedAmount += amount;
      }
    }
    // if (totalSelectedAmount > stateInvoice.grandTotal) {
    //   SnackBarHelper.presentErrorSnackBar(childContext, "DP can't be more than grand total");
    //   return;
    // }

    double grandTotalDifference = previousSelectedAmount - totalSelectedAmount;
    receipt.addOrUpdateDownPayments(downPaymentEntities: selectedDownPayments, amountDifference: grandTotalDifference);
    context.pop();
  }

  Future<void> _resetDownPayment() async {
    final receipt = context.read<ReceiptCubit>();
    setState(() {
      _selectedItems = List.generate(membersDP.length, (_) => false);
      totalAmount = 0;
      for (int index = 0; index < _drawAmountControllers.length; index++) {
        _drawAmountControllers[index].text = Helpers.parseMoney(membersDP[index].amount);
      }
    });

    await receipt.addOrUpdateDownPayments(downPaymentEntities: [], amountDifference: 0);
    stateInvoice = receipt.state.copyWith();
  }

  Future<bool> _checkDrawDownPayment() async {
    final receiptEntity = context.read<ReceiptCubit>().state;
    bool dpAllocated = receiptEntity.downPayments != null && receiptEntity.downPayments!.isNotEmpty;

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
                FocusScope.of(context).unfocus();
                final receiptItems = context.read<ReceiptCubit>().state.receiptItems;
                if (receiptItems.any((item) => item.itemEntity.itemCode != "99") &&
                    receiptItems.any((item) => item.itemEntity.itemCode != "08700000002")) {
                  SnackBarHelper.presentErrorSnackBar(
                      childContext, "Down payment has to be excluded from other transactions");
                  return KeyEventResult.handled;
                }
                if (receiveZero) return KeyEventResult.handled;
                context.pop();
                _addOrUpdateReceiveDownPayment();
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
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
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
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Scrollbar(
                    controller: _scrollController,
                    thickness: 4,
                    radius: const Radius.circular(30),
                    thumbVisibility: true,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : isReceive
                            ? _buildReceiveDownPayment()
                            : _buildDrawDownPayment(),
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
                        log("itemsDP - $itemsDP - $isReceive");
                        if (itemsDP.isNotEmpty && isReceive) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _warningCloseDPDialog();
                              });
                        } else {
                          Navigator.of(context).pop();
                        }
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
                              _addOrUpdateReceiveDownPayment();
                              log("${context.read<ReceiptCubit>().state}");
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

                              if (childContext.mounted) {
                                await _addOrUpdateDrawDownPayment(childContext);
                              }
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
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReceiveDownPayment() {
    return Builder(builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
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
                        onLongPress: () async {
                          await _resetDPItems(context);
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
                          if (mounted) {
                            context.read<ItemsCubit>().clearItems();
                            FocusScope.of(context).unfocus();
                          }
                          final ItemEntity? itemEntitySearch = await showDialog<ItemEntity>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const ItemSearchDialog());

                          if (itemEntitySearch != null) {
                            final double quantity = double.parse(await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const QuantityDrawDPDialog(
                                      quantity: 0,
                                    )));

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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
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
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                    (itemsDP.isEmpty)
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 20),
                                            child: EmptyList(
                                              imagePath: "assets/images/empty-item.svg",
                                              sentence:
                                                  "Tadaa.. There is nothing here!\nPress icon + to start adding item.",
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
                                                        // decoration: BoxDecoration(
                                                        //   borderRadius: BorderRadius.circular(5),
                                                        //   color: Colors.white,
                                                        //   boxShadow: const [
                                                        //     BoxShadow(
                                                        //       spreadRadius: 0.5,
                                                        //       blurRadius: 5,
                                                        //       color: Color.fromRGBO(197, 197, 197, 1),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        height: 70,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/images/inventory.svg",
                                                                          height: 18,
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text(
                                                                          itemsDP[index].itemCode,
                                                                          style: const TextStyle(
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Color.fromARGB(255, 66, 66, 66),
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
                                                                          itemsDP[index].barcode,
                                                                          style: const TextStyle(
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Color.fromARGB(255, 66, 66, 66),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      itemsDP[index].itemName,
                                                                      style: const TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Color.fromARGB(255, 66, 66, 66),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  Helpers.parseMoney(itemsDP[index].price),
                                                                  textAlign: TextAlign.center,
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Color.fromARGB(255, 66, 66, 66),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  Helpers.cleanDecimal(qtyDP[index], 1),
                                                                  textAlign: TextAlign.center,
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Color.fromARGB(255, 66, 66, 66),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    Helpers.parseMoney(
                                                                        qtyDP[index] * itemsDP[index].price),
                                                                    textAlign: TextAlign.end,
                                                                    style: const TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Color.fromARGB(255, 66, 66, 66),
                                                                    ),
                                                                  )),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      IntrinsicHeight(
                                                                        child: GestureDetector(
                                                                          onTap: () async {
                                                                            log("Edit button pressed");
                                                                            final double quantity = double.parse(
                                                                                await showDialog(
                                                                                    context: context,
                                                                                    barrierDismissible: false,
                                                                                    builder: (context) =>
                                                                                        QuantityDrawDPDialog(
                                                                                          quantity: qtyDP[index],
                                                                                        )));
                                                                            setState(() {
                                                                              grandTotalReceiveDP -=
                                                                                  itemsDP[index].price * qtyDP[index];
                                                                              qtyDP[index] = quantity;
                                                                              grandTotalReceiveDP +=
                                                                                  itemsDP[index].price * qtyDP[index];
                                                                            });
                                                                            await _recalculateDownPayment(
                                                                                grandTotalReceiveDP);
                                                                          },
                                                                          child: Container(
                                                                            alignment: Alignment.center,
                                                                            padding:
                                                                                const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                                                            decoration: BoxDecoration(
                                                                              color: ProjectColors.blue,
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
                                                                            log("Remove button pressed - ${itemsDP[index].itemName}");
                                                                            setState(() {
                                                                              grandTotalReceiveDP -=
                                                                                  (itemsDP[index].price * qtyDP[index]);
                                                                              itemsDP.remove(itemsDP[index]);
                                                                              qtyDP.remove(qtyDP[index]);
                                                                            });
                                                                            await _recalculateDownPayment(
                                                                                grandTotalReceiveDP);
                                                                            if (context.mounted) {
                                                                              SnackBarHelper.presentSuccessSnackBar(
                                                                                  context,
                                                                                  "Item ${itemsDP[index].itemName} removed",
                                                                                  2);
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            alignment: Alignment.center,
                                                                            padding:
                                                                                const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.deepOrange,
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
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (BuildContext context, int index) =>
                                                    const SizedBox(height: 5),
                                                itemCount: itemsDP.length),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 15, 155, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            child: Text(
                                              "GRAND TOTAL",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(255, 66, 66, 66),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 270),
                                          Text(
                                            Helpers.cleanDecimal(
                                                (qtyDP.isEmpty) ? 0 : qtyDP.reduce((a, b) => a + b), 1),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 2, 10, 0),
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
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: Text(
                                              "DP Amount*",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(255, 66, 66, 66),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 500),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 7.8, 0),
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
                                                  contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                  border: InputBorder.none,
                                                  enabledBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black, width: 1),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(color: ProjectColors.primary, width: 2),
                                                  ),
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
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Remarks*",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(255, 66, 66, 66),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: SingleChildScrollView(
                                              child: Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                                child: TextField(
                                                  maxLines: null,
                                                  maxLength: 300,
                                                  controller: _remarksController,
                                                  focusNode: _remarksFocusNode,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
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
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
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
                    text: "Items inputed will be removed upon canceling the process. Proceed?",
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
              onPressed: () {
                context.pop(true);
                context.pop(true);
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

  Widget _buildDrawDownPayment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double itemHeight = 80.0;
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
                        GestureDetector(
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
                        onTap: () {
                          if (!_isExceeding[index] && !_isZero[index]) {
                            setState(() {
                              _selectedItems[index] = !_selectedItems[index];

                              double amount =
                                  double.tryParse(_drawAmountControllers[index].text.replaceAll(',', '')) ?? 0;

                              if (_selectedItems[index]) {
                                totalAmount += amount;
                              } else {
                                totalAmount -= amount;
                              }
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedItems[index] ? ProjectColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ProjectColors.primary,
                              width: 2.0,
                            ),
                          ),
                          height: itemHeight,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${membersDP[index].refpos2}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedItems[index] ? Colors.white : ProjectColors.primary,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Available",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _selectedItems[index] ? Colors.white : ProjectColors.mediumBlack,
                                        ),
                                      ),
                                      Text(
                                        Helpers.parseMoney(membersDP[index].amount),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedItems[index] ? Colors.white : ProjectColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: _selectedItems[index],
                                child: Column(
                                  children: List.generate(
                                    (membersDP[index].tinv7?.length ?? 0),
                                    (childIndex) => Container(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      child: Text(membersDP[index].tinv7![childIndex].toString()), // Render each item
                                    ),
                                  ),
                                ),
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
}
