import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
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

class CheckoutDialog extends StatelessWidget {
  const CheckoutDialog({super.key});

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
      content: const CheckoutDialogContent(),

      // contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 20, vertical: 5),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
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
              onPressed: () {},
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
                    height: 180,
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
                            height: 15,
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
                              color: ProjectColors.primary,
                              // color: Color.fromARGB(255, 31, 104, 36), // ijo
                              // color: Color.fromARGB(255, 40, 40, 40),
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
                                      onTap: () =>
                                          _value = mopsByType[0].tpmt3Id,
                                      onChanged: (value) => setState(() =>
                                          _cashAmount = Helpers
                                                  .revertMoneyToDecimalFormat(
                                                      value)
                                              .toInt()),
                                      inputFormatters: [MoneyInputFormatter()],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              signed: false, decimal: false),
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
