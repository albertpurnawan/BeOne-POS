import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/campaign.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';
import 'package:pos_fe/features/sales/domain/entities/edc_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/presentation/widgets/checkout_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_campaign_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_card_type.dart';

class EDCDialog extends StatefulWidget {
  const EDCDialog({
    Key? key,
    required this.mopSelectionEntity,
    required this.onEDCSelected,
    this.max = double.infinity,
    required this.isMultiMOPs,
  }) : super(key: key);

  final Function(
    MopSelectionEntity,
  ) onEDCSelected;
  final MopSelectionEntity mopSelectionEntity;
  final double max;
  final bool isMultiMOPs;

  @override
  State<EDCDialog> createState() => _EDCDialogState();
}

class _EDCDialogState extends State<EDCDialog> {
  final TextEditingController _cardNumber1Controller = TextEditingController();
  final TextEditingController _cardNumber2Controller = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _refNumberController = TextEditingController();
  bool isCredit = false;
  List<MopSelectionEntity> mopList = [];
  List<MopSelectionEntity> mopsSelected = [];
  List<EDCSelectionEntity> edcsSelected = [];
  MopSelectionEntity? mopSelected;
  String cardName = "Select Card Here...";
  CreditCardEntity? cardSelected;
  CampaignEntity? campaignSelected;
  String campaignName = "Select Campaign Here...";
  bool isErr = false;
  bool savePressed = false;
  double? currentAmount;
  String errMsg = "Invalid amount";

  late final _focusNodeAmount = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.f12) {
        final double mopAmount = Helpers.revertMoneyToDecimalFormat(_amountController.text);
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
    currentAmount = widget.max;
    super.initState();
  }

  @override
  void dispose() {
    _cardNumber1Controller.dispose();
    _cardNumber2Controller.dispose();
    _cardHolderController.dispose();
    _amountController.dispose();
    _refNumberController.dispose();
    super.dispose();
  }

  Future<void> fetchMOP() async {
    final edc = widget.mopSelectionEntity.edcDesc;
    final tpmt1List = await GetIt.instance<AppDatabase>().meansOfPaymentDao.readByPaytypeCode("2", edc!);

    setState(() {
      mopList.addAll(tpmt1List);
    });
  }

  @override
  Widget build(BuildContext parentContext) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Theme(
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
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Container(
                decoration: const BoxDecoration(
                  color: ProjectColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                ),
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: const Text(
                  'Select MOP',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                width: MediaQuery.of(parentContext).size.width * 0.7,
                height: MediaQuery.of(parentContext).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CARD LIST START
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Card Processed",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 1,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "MOP",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                "Card Type",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Amount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        ...mopsSelected.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          MopSelectionEntity mop = entry.value;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      index.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      mop.mopAlias,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      mop.cardName ?? "Select Card Here...",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      mop.amount.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                        const Divider(
                          color: Colors.black,
                          height: 1,
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        // -- CARD LIST END
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Means Of Payment",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (mopSelected == null && savePressed)
                              const Text(
                                "Please select the Mean of Payment",
                                style: TextStyle(color: Colors.red),
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
                                      .map((MopSelectionEntity mop) => ChoiceChip(
                                            side: const BorderSide(color: ProjectColors.primary, width: 1.5),
                                            padding: const EdgeInsets.all(15),
                                            label: Text(mop.mopAlias),
                                            selected: mopSelected == mop,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                mopSelected = selected ? mop : null;
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
                                      width: MediaQuery.of(parentContext).size.width * 0.2,
                                      height: 50,
                                      child: const Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Card Type",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(parentContext).size.width * 0.4,
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () => showDialog<CreditCardEntity>(
                                          context: parentContext,
                                          builder: (BuildContext parentContext) => const SelectCardType(),
                                        ).then((selectedCard) {
                                          if (selectedCard != null) {
                                            setState(() {
                                              cardSelected = selectedCard;
                                              cardName = selectedCard.description;
                                            });
                                          }
                                        }),
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(10.0),
                                          ),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cardName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: ProjectColors.mediumBlack,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            // if (cardSelected == null && savePressed)
                                            //   const Text(
                                            //     "Please select a card type",
                                            //     style: TextStyle(color: Colors.red),
                                            //   ),
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
                                      width: MediaQuery.of(parentContext).size.width * 0.2,
                                      height: 50,
                                      child: const Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Card Number",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(parentContext).size.width * 0.4,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(parentContext).size.width * 0.1,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _cardNumber1Controller,
                                              style: const TextStyle(fontSize: 18),
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.all(8),
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
                                            width: MediaQuery.of(parentContext).size.width * 0.2,
                                            child: const Center(
                                              child: Text(
                                                " - xxxx - xxxx - ",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(parentContext).size.width * 0.1,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _cardNumber2Controller,
                                              style: const TextStyle(fontSize: 18),
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.all(8),
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
                                      width: MediaQuery.of(parentContext).size.width * 0.2,
                                      height: 50,
                                      child: const Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Card Holder",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(parentContext).size.width * 0.4,
                                      height: 50,
                                      child: TextFormField(
                                        textAlign: TextAlign.left,
                                        controller: _cardHolderController,
                                        style: const TextStyle(fontSize: 18),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          hintText: "Card Holder",
                                          hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
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
                                      width: MediaQuery.of(parentContext).size.width * 0.2,
                                      height: 50,
                                      child: const Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Campaign",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(parentContext).size.width * 0.4,
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () => showDialog<CampaignEntity>(
                                          context: parentContext,
                                          builder: (BuildContext parentContext) => const SelectCampaign(),
                                        ).then((selectedCampaign) {
                                          if (selectedCampaign != null) {
                                            setState(() {
                                              campaignSelected = selectedCampaign;
                                              campaignName = selectedCampaign.description;
                                            });
                                          }
                                        }),
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(10.0),
                                          ),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              campaignName,
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
                                      width: MediaQuery.of(parentContext).size.width * 0.2,
                                      height: 50,
                                      child: const Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Reference Number",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(parentContext).size.width * 0.4,
                                      height: 50,
                                      child: TextFormField(
                                        textAlign: TextAlign.left,
                                        controller: _refNumberController,
                                        style: const TextStyle(fontSize: 18),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          hintText: "Reference Number",
                                          hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
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
                                      width: MediaQuery.of(parentContext).size.width * 0.2,
                                      height: 50,
                                      child: const Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Amount",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(parentContext).size.width * 0.4,
                                      height: 50,
                                      child: TextFormField(
                                        focusNode: _focusNodeAmount,
                                        controller: _amountController,
                                        textAlign: TextAlign.left,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [MoneyInputFormatter()],
                                        style: const TextStyle(fontSize: 18),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(10),
                                          hintText: "$currentAmount",
                                          hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                                          border: const OutlineInputBorder(),
                                          suffix: isErr
                                              ? Text(
                                                  errMsg,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontStyle: FontStyle.normal,
                                                      fontWeight: FontWeight.w700,
                                                      color: ProjectColors.swatch),
                                                )
                                              : null,
                                        ),
                                        enabled: widget.isMultiMOPs,
                                        onChanged: (value) {
                                          final double mopAmount = Helpers.revertMoneyToDecimalFormat(value);
                                          if (mopAmount > widget.max) {
                                            setState(() {
                                              isErr = true;
                                              errMsg = "Invalid amount";
                                            });
                                          } else if (isErr) {
                                            setState(() {
                                              isErr = false;
                                            });
                                          }
                                        },
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
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
                      onPressed: () {
                        Navigator.of(parentContext).pop();
                      },
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Back",
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
                          shape:
                              MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                      onPressed: () {
                        setState(() {
                          savePressed = true;
                        });
                        if (mopSelected == null) {
                          SnackBarHelper.presentFailSnackBar(childContext, "Please select a means of payment");
                          return;
                        }

                        // if (cardSelected == null) {
                        //   SnackBarHelper.presentFailSnackBar(childContext, "Please select a card type");
                        //   return;
                        // }

                        final edcAmount = widget.isMultiMOPs
                            ? (_amountController.text.isEmpty)
                                ? currentAmount
                                : Helpers.revertMoneyToDecimalFormatDouble(_amountController.text)
                            : currentAmount;

                        if (edcAmount! > currentAmount! || edcAmount == 0) {
                          SnackBarHelper.presentFailSnackBar(
                              childContext, "Please Input Correct Amount (Max Amount: ${currentAmount!.toInt()})");
                          return;
                        }
                        final mopEDC = mopSelected!.copyWith(
                          amount: edcAmount,
                          tpmt2Id: cardSelected?.docId,
                          cardName: cardSelected?.description,
                          cardNo: (_cardNumber1Controller.text.isEmpty || _cardNumber2Controller.text.isEmpty)
                              ? ""
                              : "${_cardNumber1Controller.text}-xxxx-xxxx-${_cardNumber2Controller.text}",
                          cardHolder: _cardHolderController.text,
                          rrn: _refNumberController.text,
                        );
                        mopsSelected.add(mopEDC);

                        setState(() {
                          currentAmount = currentAmount! - edcAmount;
                          mopSelected = null;
                          cardSelected = null;
                          cardName = "Select Card Here...";
                          _cardNumber1Controller.text = "";
                          _cardNumber2Controller.text = "";
                          _cardHolderController.text = "";
                          campaignSelected = null;
                          campaignName = "Select Campaign Here...";
                          _refNumberController.text = "";
                          _amountController.text = "";
                          savePressed = false;
                        });
                        widget.onEDCSelected(mopEDC);
                        (widget.isMultiMOPs)
                            ? (currentAmount! > 0)
                                ? SnackBarHelper.presentSuccessSnackBar(childContext, "Success Add Card")
                                : Navigator.of(childContext).pop()
                            : Navigator.of(childContext).pop();
                      },
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Add Card",
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
          ),
        );
      }),
    );
  }
}
