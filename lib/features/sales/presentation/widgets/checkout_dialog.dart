import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';
import 'package:pos_fe/features/sales/presentation/cubit/mop_selections_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';

final List<MopType> mopTypes = [
  MopType(name: "Tunai", payTypeCodes: ["1"]),
  MopType(name: "E-Wallet", payTypeCodes: ["5"]),
  MopType(name: "Debit", payTypeCodes: ["2"]),
  MopType(name: "Kredit", payTypeCodes: ["3"]),
  MopType(name: "Voucher", payTypeCodes: ["6"]),
  MopType(name: "Lainnya", payTypeCodes: ["4"])
];

class MopType {
  final String name;
  final List<String> payTypeCodes;

  MopType({required this.name, required this.payTypeCodes});
}

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({super.key});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  bool isCharged = false;

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
          'Checkout',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: isCharged
          ? const _CheckoutSuccessDialogContent()
          : const CheckoutDialogContent(),

      // contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 20, vertical: 5),
      actions: isCharged
          ? [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color: ProjectColors.primary))),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black.withOpacity(.2))),
                        onPressed: () {
                          // Navigator.of(context).pop();
                        },
                        child: const Center(
                            child: Text(
                          "Send Receipt",
                          style: TextStyle(color: ProjectColors.primary),
                        )),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color: ProjectColors.primary))),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black.withOpacity(.2))),
                        onPressed: () {
                          // Navigator.of(context).pop();
                        },
                        child: const Center(
                            child: Text(
                          "Print Receipt",
                          style: TextStyle(color: ProjectColors.primary),
                        )),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white.withOpacity(.2))),
                    onPressed: () {
                      isCharged = false;
                      Navigator.of(context).pop();
                      context.read<ReceiptCubit>().resetReceipt();
                    },
                    child: const Center(
                        child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ],
              )
            ]
          : <Widget>[
              Row(
                children: [
                  Expanded(
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
                      Navigator.of(context).pop();
                    },
                    child: const Center(
                        child: Text(
                      "Cancel",
                      style: TextStyle(color: ProjectColors.primary),
                    )),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white.withOpacity(.2))),
                    onPressed: () async {
                      await GetIt.instance<SaveReceiptUseCase>()
                          .call(params: context.read<ReceiptCubit>().state);
                      await GetIt.instance<InvoiceApi>().sendInvoice();
                      setState(() {
                        isCharged = true;
                      });
                    },
                    child: const Center(
                        child: Text(
                      "Charge",
                      style: TextStyle(color: Colors.white),
                    )),
                  )),
                ],
              ),
            ],
      actionsPadding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
    );
  }
}

class CheckoutDialogContent extends StatefulWidget {
  const CheckoutDialogContent({super.key});

  @override
  State<CheckoutDialogContent> createState() => _CheckoutDialogContentState();
}

class _CheckoutDialogContentState extends State<CheckoutDialogContent> {
  String _value = "";
  int _cashAmount = 0;

  List<MopSelectionEntity> mopSelectionModels = [];
  final _textEditingControllerCashAmount = TextEditingController();
  final _focusNodeCashAmount = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<MopSelectionsCubit>().getMopSelections();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerCashAmount.dispose();
    _focusNodeCashAmount.dispose();
  }

  List<MopSelectionEntity> getMopByPayTypeCode(String payTypeCode) {
    /**
     * 1 - Tunai
     * 2 - Debit
     * 3 - Kredit
     * 4 - Lainnya
     * 5 - E-Wallet
     * 6 - Voucher */
    final List<MopSelectionEntity> mopsByPayTypeCode = context
        .read<MopSelectionsCubit>()
        .state
        .where((element) => element.payTypeCode == payTypeCode)
        .toList();
    return mopsByPayTypeCode;
  }

  List<int> generateCashAmountSuggestions(int receiptTotalAmount) {
    List<int> cashAmountSuggestions = [];
    final List<int> multipliers = [10000, 50000, 100000];

    cashAmountSuggestions
        .add(receiptTotalAmount + 5000 - (receiptTotalAmount % 5000));

    for (final multiplier in multipliers) {
      if (cashAmountSuggestions.last % multiplier != 0) {
        cashAmountSuggestions.add(receiptTotalAmount +
            multiplier -
            (receiptTotalAmount % multiplier));
      }
    }

    // if (cashAmountSuggestions[0] % 10000 != 0) {
    //   cashAmountSuggestions
    //       .add(receiptTotalAmount + 10000 - (receiptTotalAmount % 10000));
    // }
    // if (cashAmountSuggestions[1] % 50000 != 0) {
    //   cashAmountSuggestions
    //       .add(receiptTotalAmount + 5000 - (receiptTotalAmount % 5000));
    // }
    // if (cashAmountSuggestions[2] % 100000 != 0) {
    //   cashAmountSuggestions
    //       .add(receiptTotalAmount + 5000 - (receiptTotalAmount % 5000));
    // }

    return cashAmountSuggestions;
  }

  List<MopSelectionEntity> getMopByPayTypeCodes(List<String> payTypeCodes) {
    List<MopSelectionEntity> mops = [];
    for (final payTypeCode in payTypeCodes) {
      final List<MopSelectionEntity> temp = context
          .read<MopSelectionsCubit>()
          .state
          .where((element) => element.payTypeCode == payTypeCode)
          .toList();
      mops.addAll(temp);
    }
    return mops;
  }

  void updateReceiptMop() {
    final MopSelectionEntity mopSelectionEntity = context
        .read<MopSelectionsCubit>()
        .state
        .where((element) => element.tpmt3Id == _value)
        .first;
    context.read<ReceiptCubit>().updateMopSelection(
        mopSelectionEntity: mopSelectionEntity,
        amountReceived: mopSelectionEntity.payTypeCode == "1"
            ? _cashAmount
            : context.read<ReceiptCubit>().state.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          fontFamily: 'Roboto',
          useMaterial3: true,
          chipTheme: const ChipThemeData(
              showCheckmark: true,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.transparent,
              selectedColor: ProjectColors.primary,
              labelStyle: TextStyle(color: ChipLabelColor(), fontSize: 18))),
      child: BlocBuilder<MopSelectionsCubit, List<MopSelectionEntity>>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    // height: 180,
                    // color: Color.fromARGB(255, 237, 237, 237), // almost white
                    // color: Color.fromARGB(255, 43, 144, 49), // ijo
                    // color: const Color.fromARGB(255, 186, 61, 61),
                    // color: Color.fromARGB(255, 184, 102, 102),
                    // color: Color.fromARGB(255, 121, 168, 124), // ijo muda
                    // color: Color.fromARGB(255, 126, 126, 126),
                    color: const Color.fromARGB(255, 134, 1, 1),
                    // color: ProjectColors.primary,

                    // decoration: BoxDecoration(
                    //   boxShadow: [
                    //     const BoxShadow(
                    //       color: Color.fromARGB(255, 101, 0, 0),
                    //     ),
                    //     const BoxShadow(
                    //       color: const Color.fromARGB(255, 134, 1, 1),
                    //       spreadRadius: -8.0,
                    //       blurRadius: 15.0,
                    //     ),
                    //   ],
                    // ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              // color: Color.fromARGB(255, 89, 0, 0),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, 0.097),
                                ),
                              ],
                              // color: ProjectColors.primary,
                              // color: Color.fromARGB(255, 31, 104, 36), // ijo
                              // color: Color.fromARGB(255, 40, 40, 40),
                              color: const Color.fromARGB(255, 47, 143, 8),
                            ),
                            child: const Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                // color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.totalPrice)}",
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                              // color: const Color.fromARGB(255, 33, 33, 33),
                              color: Colors.white,
                              // color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List<Widget>.generate(
                        mopTypes.length,
                        (int index) {
                          final mopType = mopTypes[index];
                          final List<MopSelectionEntity> mopsByType =
                              getMopByPayTypeCodes(mopType.payTypeCodes);

                          if (mopsByType.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          if (mopType.payTypeCodes[0] == "1") {
                            final List<int> cashAmountSuggestions =
                                generateCashAmountSuggestions(context
                                    .read<ReceiptCubit>()
                                    .state
                                    .totalPrice);

                            return SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mopType.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    // height: 60,
                                    // width: 400,
                                    child: TextField(
                                      focusNode: _focusNodeCashAmount,
                                      onTapOutside: (event) =>
                                          _focusNodeCashAmount.unfocus(),
                                      controller:
                                          _textEditingControllerCashAmount,
                                      onTap: () {
                                        _value = mopsByType[0].tpmt3Id;
                                        updateReceiptMop();
                                      },
                                      onChanged: (value) => setState(() {
                                        _cashAmount =
                                            Helpers.revertMoneyToDecimalFormat(
                                                    value)
                                                .toInt();
                                        updateReceiptMop();
                                      }),
                                      inputFormatters: [MoneyInputFormatter()],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 24),
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          hintText: "Cash Amount",
                                          hintStyle: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 24),
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.payments_outlined,
                                            size: 24,
                                          )),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: List<Widget>.generate(
                                      cashAmountSuggestions.length,
                                      (int index) {
                                        return ChoiceChip(
                                          side: const BorderSide(
                                              color: ProjectColors.primary,
                                              width: 1.5),
                                          padding: EdgeInsets.all(20),
                                          label: Text(Helpers.parseMoney(
                                              cashAmountSuggestions[index])),
                                          selected: _value ==
                                                  mopsByType[0].tpmt3Id &&
                                              _cashAmount ==
                                                  cashAmountSuggestions[index],
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _value = mopsByType[0].tpmt3Id;
                                              _cashAmount =
                                                  cashAmountSuggestions[index];
                                              _textEditingControllerCashAmount
                                                      .text =
                                                  Helpers.parseMoney(
                                                      cashAmountSuggestions[
                                                          index]);
                                              updateReceiptMop();
                                            });
                                          },
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            );
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mopType.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List<Widget>.generate(
                                    mopsByType.length,
                                    (int index) {
                                      final mop = mopsByType[index];
                                      return ChoiceChip(
                                        side: const BorderSide(
                                            color: ProjectColors.primary,
                                            width: 1.5),
                                        padding: EdgeInsets.all(20),
                                        label: Text(
                                          mop.mopAlias,
                                        ),
                                        selected: _value == mop.tpmt3Id,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _value =
                                                selected ? mop.tpmt3Id : "";
                                            _cashAmount = 0;
                                            _textEditingControllerCashAmount
                                                .text = "";
                                            updateReceiptMop();
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChipLabelColor extends Color implements MaterialStateColor {
  const ChipLabelColor() : super(_default);

  static const int _default = 0xFF000000;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.white; // Selected text color
    }
    return ProjectColors.primary; // normal text color
  }
}

class _CheckoutSuccessDialogContent extends StatefulWidget {
  const _CheckoutSuccessDialogContent({super.key});

  @override
  State<_CheckoutSuccessDialogContent> createState() =>
      __CheckoutSuccessDialogContentState();
}

class __CheckoutSuccessDialogContentState
    extends State<_CheckoutSuccessDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            fontFamily: 'Roboto',
            useMaterial3: true,
            chipTheme: const ChipThemeData(
                showCheckmark: true,
                checkmarkColor: Colors.white,
                backgroundColor: Colors.transparent,
                selectedColor: ProjectColors.primary,
                labelStyle: TextStyle(color: ChipLabelColor(), fontSize: 18))),
        child: SingleChildScrollView(
          child: SizedBox(
            // width: MediaQuery.of(context).size.width * 0.7,
            width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  width: double.infinity,
                  // height: 180,
                  // color: Color.fromARGB(255, 237, 237, 237), // almost white
                  // color: Color.fromARGB(255, 43, 144, 49), // ijo
                  // color: const Color.fromARGB(255, 186, 61, 61),
                  // color: Color.fromARGB(255, 184, 102, 102),
                  // color: Color.fromARGB(255, 121, 168, 124), // ijo muda
                  // color: Color.fromARGB(255, 126, 126, 126),
                  color: const Color.fromARGB(255, 134, 1, 1),
                  // color: ProjectColors.primary,

                  // decoration: BoxDecoration(
                  //   boxShadow: [
                  //     const BoxShadow(
                  //       color: Color.fromARGB(255, 101, 0, 0),
                  //     ),
                  //     const BoxShadow(
                  //       color: const Color.fromARGB(255, 134, 1, 1),
                  //       spreadRadius: -8.0,
                  //       blurRadius: 15.0,
                  //     ),
                  //   ],
                  // ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            // color: Color.fromARGB(255, 89, 0, 0),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 0.5,
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.097),
                              ),
                            ],
                            // color: ProjectColors.primary,
                            // color: Color.fromARGB(255, 31, 104, 36), // ijo
                            // color: Color.fromARGB(255, 40, 40, 40),
                            color: const Color.fromARGB(255, 47, 143, 8),
                          ),
                          child: const Text(
                            "Transaction Success",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              // color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(
                            //   Icons.check_circle_outline,
                            //   color: const Color.fromARGB(255, 47, 143, 8),
                            //   size: 42,
                            // ),
                            SvgPicture.asset(
                              "assets/images/icon-success.svg",
                              height: 42,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.totalPrice)}",
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                // color: const Color.fromARGB(255, 33, 33, 33),
                                color: Colors.white,
                                // color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 52,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat("EEE, dd MMM yyyy - hh:mm aaa")
                              .format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            // color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Divider()
                      ],
                    )),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    width: double.infinity,
                    child: Table(columnWidths: {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(4),
                    }, children: [
                      TableRow(
                        children: [
                          Text(
                            "Invoice Number",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            context.read<ReceiptCubit>().state.docNum,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            "Payment",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            context
                                .read<ReceiptCubit>()
                                .state
                                .mopSelection!
                                .mopAlias,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            "Total Bill",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.totalPrice)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            "Received",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.amountReceived!)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            "Change",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Rp ${Helpers.parseMoney(context.read<ReceiptCubit>().state.amountReceived! - context.read<ReceiptCubit>().state.totalPrice)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ])),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }
}
