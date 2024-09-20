import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/down_payment_service.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_down_payment.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
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

  late ReceiptEntity stateInvoice;
  ReceiptItemEntity? currentReceiptItemEntity;
  ItemEntity? dp;

  String customerSelected = "Not Set";
  bool isReceive = true;
  bool isEdit = false;
  late double totalAmount;

  List<DownPaymentEntity> membersDP = [];

  @override
  void initState() {
    super.initState();
    stateInvoice = context.read<ReceiptCubit>().state;
    readInvoiceState();
    readCustomer();
    _amountFocusNode.requestFocus();
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
      SnackBarHelper.presentErrorSnackBar(context, "Item DP not found for this store");
    }
  }

  void readCustomer() async {
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
  }

  Future<List<DownPaymentEntity>> getMembersDownPayments() async {
    final List<DownPaymentEntity> downPayments =
        await GetIt.instance<DownPaymentApi>().fetchData(stateInvoice.customerEntity!.custCode);

    return downPayments;
  }

  void _setupControllers() {
    totalAmount = 0.0;
    log("membersDP - $membersDP");

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
      remarks: _remarksController.text,
      refpos2: null,
    );

    await receipt.addUpdateReceiptItems(params);
    await receipt.updateSalesTohemIdRemarksOnReceipt(stateInvoice.toinvTohemId ?? "", _remarksController.text);
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
    log("grandTotal - ${stateInvoice.grandTotal}");
    if (totalSelectedAmount > stateInvoice.grandTotal) {
      SnackBarHelper.presentErrorSnackBar(childContext, "DP can't be more than grand total");
      return;
    }

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
              if (event.runtimeType == KeyUpEvent) {
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
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
                              context.pop();
                              _addOrUpdateReceiveDownPayment();
                            }
                          : () async {
                              FocusScope.of(context).unfocus();
                              await _addOrUpdateDrawDownPayment(childContext);
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: [
              const SizedBox(height: 5),
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
                        const Icon(Icons.receipt_outlined, color: Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          (stateInvoice.docNum),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 30),
                  const Divider(height: 0),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Icon(
                              Icons.face_outlined,
                              color: Color.fromARGB(255, 66, 66, 66),
                            ),
                            SizedBox(width: 30),
                            Text(
                              "Customer",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
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
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(height: 0),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Icon(
                              Icons.payments_outlined,
                              color: Color.fromARGB(255, 66, 66, 66),
                            ),
                            SizedBox(width: 30),
                            Text(
                              "Amount",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          maxLines: 1,
                          maxLength: 21,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 66, 66, 66)),
                          inputFormatters: [MoneyInputFormatter()],
                          controller: _amountController,
                          focusNode: _amountFocusNode,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            counterText: "",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 0),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.note_alt_outlined,
                              color: Color.fromARGB(255, 66, 66, 66),
                            ),
                            SizedBox(width: 30),
                            Text(
                              "Remarks",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
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
                                fontWeight: FontWeight.w700,
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
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 0),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawDownPayment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double itemHeight = 80.0;
          double totalHeight = (membersDP.isEmpty) ? 50 : itemHeight * membersDP.length;
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
                        child: Text("No prior down payments found for this customer",
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
                          child: Row(
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextField(
                                          maxLines: 1,
                                          maxLength: 21,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: _selectedItems[index] ? Colors.white : Colors.black,
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
                                          onChanged: (value) {
                                            setState(() {
                                              double enteredAmount = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
                                              _isExceeding[index] = enteredAmount > membersDP[index].amount;
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
