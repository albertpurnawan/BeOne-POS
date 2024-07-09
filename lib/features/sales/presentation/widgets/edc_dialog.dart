import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/data/models/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';
import 'package:pos_fe/features/sales/domain/entities/edc_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/presentation/widgets/checkout_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_card_type.dart';
import 'package:uuid/uuid.dart';

class EDCDialog extends StatefulWidget {
  const EDCDialog({
    Key? key,
    required this.mopSelectionEntity,
    required this.onEDCSelected,
    this.max = double.infinity,
  }) : super(key: key);

  final Function(
    EDCSelectionEntity,
  ) onEDCSelected;
  final MopSelectionEntity mopSelectionEntity;
  final double max;

  @override
  State<EDCDialog> createState() => _EDCDialogState();
}

class _EDCDialogState extends State<EDCDialog> {
  EDCSelectionEntity? edcSelected;
  final TextEditingController _cardNumber1Controller = TextEditingController();
  final TextEditingController _cardNumber2Controller = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool isCredit = false;
  List<MopSelectionModel> mopList = [];
  String? mopSelected;
  String cardName = "Select Card Here...";
  CreditCardEntity? cardSelected;
  String? campaignSelected = "Select Campaign Here...";
  bool isErr = false;
  String errMsg = "Invalid amount";

  late final _focusNodeAmount = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.f12) {
        final double mopAmount =
            Helpers.revertMoneyToDecimalFormat(_amountController.text);
        if (mopAmount > widget.max) {
          setState(() {
            isErr = true;
            errMsg = "Invalid amount";
          });

          return KeyEventResult.handled;
        }
        context.pop(mopAmount);
        return KeyEventResult.handled;
      } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    },
  );

  @override
  void initState() {
    fetchMOP();
    super.initState();
  }

  @override
  void dispose() {
    _cardNumber1Controller.dispose();
    _cardNumber2Controller.dispose();
    _cardHolderController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> fetchMOP() async {
    final edc = widget.mopSelectionEntity.edcDesc;
    final tpmt1List = await GetIt.instance<AppDatabase>()
        .meansOfPaymentDao
        .readByPaytypeCode("2", edc!);

    setState(() {
      mopList.addAll(tpmt1List);
    });
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
          labelStyle: TextStyle(
            color: ChipLabelColor(),
            fontSize: 18,
          ),
        ),
      ),
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
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: const Text(
            'Select MOP',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Means Of Payment",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: mopList
                            .map((MopSelectionModel mop) => ChoiceChip(
                                  side: const BorderSide(
                                      color: ProjectColors.primary, width: 1.5),
                                  padding: const EdgeInsets.all(15),
                                  label: Text(mop.mopAlias),
                                  selected: mopSelected == mop.edcDesc,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      mopSelected =
                                          selected ? mop.description : null;
                                      log("mopSelected - $mopSelected");
                                      log("mopEntity - ${widget.mopSelectionEntity}");
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 50,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Card Type",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => showDialog<CreditCardEntity>(
                                context: context,
                                builder: (BuildContext context) =>
                                    const SelectCardType(),
                              ).then((selectedCard) {
                                if (selectedCard != null) {
                                  setState(() {
                                    cardSelected = selectedCard;
                                    cardName = selectedCard.description;
                                  });
                                  log("selectedCard - $selectedCard");
                                }
                              }),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(10.0),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cardName.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: ProjectColors.mediumBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_right_outlined),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 50,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Card Number",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: _cardNumber1Controller,
                                    style: const TextStyle(fontSize: 18),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: "____",
                                      hintStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Center(
                                    child: Text(
                                      " **** **** ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: _cardNumber2Controller,
                                    style: const TextStyle(fontSize: 18),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: "____",
                                      hintStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ], // Limit input to 4 digits
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 50,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Card Holder",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              controller: _cardHolderController,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: "Card Holder",
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 18),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 50,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Campaign",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {}
                              // showDialog<CreditCardEntity>(
                              //   context: context,
                              //   builder: (BuildContext context) =>
                              //       const SelectCardType(),
                              // ).then((selectedCard) {
                              //   if (selectedCard != null) {
                              //     setState(() {
                              //       cardName = selectedCard.description;
                              //       tpmt2IdSelected = selectedCard.docId;
                              //     });
                              //     log("selectedCard - $selectedCard");
                              //   }
                              // })
                              ,
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(10.0),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    campaignSelected.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: ProjectColors.mediumBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_right_outlined),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 50,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Amount",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            child: TextFormField(
                              focusNode: _focusNodeAmount,
                              textAlign: TextAlign.left,
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [MoneyInputFormatter()],
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                hintText: "Enter Amount",
                                hintStyle: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 18),
                                border: const OutlineInputBorder(),
                                suffix: isErr
                                    ? Text(
                                        errMsg,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: ProjectColors.swatch),
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                final double mopAmount =
                                    Helpers.revertMoneyToDecimalFormat(value);
                                if (mopAmount > widget.max) {
                                  setState(() {
                                    isErr = true;
                                    errMsg = "Invalid amount";
                                  });
                                } else if (isErr) {
                                  setState(() {
                                    isErr = false;
                                    // errMsg = "Invalid amount";
                                  });
                                }
                              },
                              // onEditingComplete: () {
                              //   final double mopAmount =
                              //       Helpers.revertMoneyToDecimalFormat(
                              //           _amountController.text);
                              //   if (mopAmount > widget.max) return;
                              //   context.pop(mopAmount);
                              // },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                  child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black.withOpacity(.2))),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
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
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => ProjectColors.primary),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white.withOpacity(.2))),
                onPressed: () {
                  final edc = EDCSelectionEntity(
                    docId: const Uuid().v4(),
                    creditCard: cardSelected!,
                    tpmt1Id: "",
                    cardNoPrefix: _cardNumber1Controller.text,
                    cardNoSuffix: _cardNumber2Controller.text,
                    campaign: "",
                    amount: Helpers.revertMoneyToDecimalFormatDouble(
                        _amountController.text),
                  );
                  widget.onEDCSelected(edc);
                  context.pop();
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
        actionsPadding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
      ),
    );
  }
}
