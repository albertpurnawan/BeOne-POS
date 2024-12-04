import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/campaign.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';
import 'package:pos_fe/features/sales/domain/entities/edc_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/presentation/widgets/checkout_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_campaign_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_card_type.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class EDCDialog extends StatefulWidget {
  const EDCDialog({
    Key? key,
    required this.mopSelectionEntity,
    required this.onEDCSelected,
    required this.onEDCRemoved,
    required this.values,
    this.max = double.infinity,
    required this.isMultiMOPs,
  }) : super(key: key);

  final Function(
    MopSelectionEntity,
  ) onEDCSelected;
  final Function(
    MopSelectionEntity,
  ) onEDCRemoved;
  final MopSelectionEntity mopSelectionEntity;
  final List<MopSelectionEntity> values;
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
  final FocusNode _cardNumber1FocusNode = FocusNode();
  final FocusNode _cardNumber2FocusNode = FocusNode();
  final FocusNode _cardHolderFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _refNumberFocusNode = FocusNode();
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
  String edcMachine = "";

  bool _shiftEnabled = false;
  bool _showKeyboard = true;
  final FocusNode _keyboardFocusNode = FocusNode();
  bool _currentNumericMode = false;
  TextEditingController _activeController = TextEditingController();

  // late final _focusNodeAmount = FocusNode(
  //   onKeyEvent: (node, event) {
  //     if (event.runtimeType == KeyUpEvent) {
  //       return KeyEventResult.handled;
  //     }

  //     if (event.physicalKey == PhysicalKeyboardKey.f12) {
  //       final double mopAmount = Helpers.revertMoneyToDecimalFormat(_amountController.text);
  //       if (mopAmount > widget.max) {
  //         setState(() {
  //           isErr = true;
  //           errMsg = "Invalid amount";
  //         });

  //         return KeyEventResult.handled;
  //       }
  //       context.pop(mopAmount);
  //       return KeyEventResult.handled;
  //     } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
  //       Navigator.of(context).pop();
  //       return KeyEventResult.handled;
  //     }

  //     return KeyEventResult.ignored;
  //   },
  // );

  @override
  void initState() {
    super.initState();
    fetchMOP();
    currentAmount = widget.max;
    mopsSelected.addAll(widget.values);
    edcMachine = widget.mopSelectionEntity.edcDesc ?? "";

    _cardNumber1FocusNode.addListener(() {
      if (_cardNumber1FocusNode.hasFocus) {
        setState(() {
          _activeController = _cardNumber1Controller;
          _currentNumericMode = true;
        });
      }
    });
    _cardNumber2FocusNode.addListener(() {
      if (_cardNumber2FocusNode.hasFocus) {
        setState(() {
          _activeController = _cardNumber2Controller;
          _currentNumericMode = true;
        });
      }
    });
    _cardHolderFocusNode.addListener(() {
      if (_cardHolderFocusNode.hasFocus) {
        setState(() {
          _activeController = _cardHolderController;
          _currentNumericMode = false;
        });
      }
    });
    _refNumberFocusNode.addListener(() {
      if (_refNumberFocusNode.hasFocus) {
        setState(() {
          _activeController = _refNumberController;
          _currentNumericMode = false;
        });
      }
    });
    _amountFocusNode.addListener(() {
      if (_amountFocusNode.hasFocus) {
        setState(() {
          _activeController = _amountController;
          _currentNumericMode = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _cardNumber1Controller.dispose();
    _cardNumber2Controller.dispose();
    _cardHolderController.dispose();
    _amountController.dispose();
    _refNumberController.dispose();
    _cardNumber1FocusNode.dispose();
    _cardNumber2FocusNode.dispose();
    _cardHolderFocusNode.dispose();
    _amountFocusNode.dispose();
    _refNumberFocusNode.dispose();
    _keyboardFocusNode.dispose();
    _activeController.dispose();
    super.dispose();
  }

  Future<void> fetchMOP() async {
    final payType = widget.mopSelectionEntity.payTypeCode;
    final edc = widget.mopSelectionEntity.tpmt4Id;
    final tpmt1List = await GetIt.instance<AppDatabase>().meansOfPaymentDao.readByPaytypeCode(payType ?? "", edc ?? "");

    setState(() {
      mopList.addAll(tpmt1List);
    });
  }

  // Future<void> removeMOP() async {}

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
                padding: const EdgeInsets.fromLTRB(25, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      edcMachine,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                        borderRadius: const BorderRadius.all(Radius.circular(360)),
                      ),
                      child: IconButton(
                        // key: _iconButtonKey,
                        focusColor: const Color.fromARGB(255, 110, 0, 0),
                        focusNode: _keyboardFocusNode,
                        icon: Icon(
                          _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _showKeyboard = !_showKeyboard;
                          });
                        },
                        tooltip: 'Toggle Keyboard',
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                width: MediaQuery.of(parentContext).size.width * 0.7,
                height: MediaQuery.of(parentContext).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        const SizedBox(
                          height: 5,
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 5,
                          children: mopsSelected.asMap().entries.map((entry) {
                            int index = entry.key;
                            MopSelectionEntity mop = entry.value;
                            return Container(
                              padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 5,
                                    color: Color.fromRGBO(0, 0, 0, 0.222),
                                  ),
                                ],
                                color: const Color.fromARGB(255, 11, 57, 84),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    mop.mopAlias,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    (mop.cardName != null) ? " - ${mop.cardName}" : "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    Helpers.parseMoney(mop.amount!),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        mopsSelected.removeAt(index);
                                        currentAmount = currentAmount! + mop.amount!;
                                      });
                                      widget.onEDCRemoved(mop);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 15,
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
                              height: 5,
                            ),
                            Column(
                              children: [
                                Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: mopList
                                      .map((MopSelectionEntity mop) => ChoiceChip(
                                            side: const BorderSide(color: ProjectColors.primary, width: 1),
                                            padding: const EdgeInsets.all(12),
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
                                  height: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Card Type",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      OutlinedButton(
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
                                              borderRadius: BorderRadius.circular(5.0),
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
                                            const Icon(Icons.arrow_right_outlined),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Card Number",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                              child: TextFormField(
                                                focusNode: _cardNumber1FocusNode,
                                                controller: _cardNumber1Controller,
                                                textAlign: TextAlign.center,
                                                keyboardType: TextInputType.none,
                                                style: const TextStyle(fontSize: 18),
                                                decoration: const InputDecoration(
                                                  contentPadding: EdgeInsets.all(2),
                                                  hintText: "____",
                                                  hintStyle: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 18,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                                ),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(4),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: Center(
                                              child: Text(
                                                " - xxxx - xxxx - ",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                              child: TextFormField(
                                                focusNode: _cardNumber2FocusNode,
                                                controller: _cardNumber2Controller,
                                                textAlign: TextAlign.center,
                                                keyboardType: TextInputType.none,
                                                style: const TextStyle(fontSize: 18),
                                                decoration: const InputDecoration(
                                                  contentPadding: EdgeInsets.all(2),
                                                  hintText: "____",
                                                  hintStyle: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 18,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                                ),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(4),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Card Holder",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                              child: TextFormField(
                                                focusNode: _cardHolderFocusNode,
                                                controller: _cardHolderController,
                                                textAlign: TextAlign.left,
                                                keyboardType: TextInputType.none,
                                                style: const TextStyle(fontSize: 18),
                                                decoration: const InputDecoration(
                                                  contentPadding: EdgeInsets.all(10),
                                                  hintText: "Card Holder",
                                                  hintStyle: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 18,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Campaign",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      OutlinedButton(
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
                                              borderRadius: BorderRadius.circular(5),
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
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Reference Number",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                              child: TextFormField(
                                                focusNode: _refNumberFocusNode,
                                                controller: _refNumberController,
                                                textAlign: TextAlign.left,
                                                keyboardType: TextInputType.none,
                                                style: const TextStyle(fontSize: 18),
                                                decoration: const InputDecoration(
                                                  contentPadding: EdgeInsets.all(10),
                                                  hintText: "Reference Number",
                                                  hintStyle: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 18,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Amount",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                              child: TextFormField(
                                                focusNode: _amountFocusNode,
                                                controller: _amountController,
                                                textAlign: TextAlign.left,
                                                keyboardType: TextInputType.none,
                                                inputFormatters: [MoneyInputFormatter()],
                                                style: const TextStyle(fontSize: 18),
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.all(10),
                                                  hintText: Helpers.parseMoney(currentAmount!),
                                                  hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                                                  border: const OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        (_showKeyboard)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: KeyboardWidget(
                                  controller: _activeController,
                                  isNumericMode: _currentNumericMode,
                                  customLayoutKeys: true,
                                  onKeyPress: (key) async {
                                    String text = _activeController.text;
                                    TextSelection currentSelection = _activeController.selection;
                                    int cursorPosition = currentSelection.start;

                                    if (key.keyType == VirtualKeyboardKeyType.String) {
                                      String inputText = (_shiftEnabled ? key.capsText : key.text) ?? '';
                                      text = text.replaceRange(cursorPosition, cursorPosition, inputText);
                                      cursorPosition += inputText.length;
                                    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                                      switch (key.action) {
                                        case VirtualKeyboardKeyAction.Backspace:
                                          if (text.isNotEmpty && cursorPosition > 0) {
                                            text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
                                            cursorPosition -= 1;
                                          }
                                          break;
                                        case VirtualKeyboardKeyAction.Return:
                                          _activeController.text = _activeController.text.trimRight();

                                          break;
                                        case VirtualKeyboardKeyAction.Space:
                                          text = text.replaceRange(cursorPosition, cursorPosition, ' ');
                                          cursorPosition += 1;

                                          break;
                                        case VirtualKeyboardKeyAction.Shift:
                                          _shiftEnabled = !_shiftEnabled;
                                          break;
                                        default:
                                          break;
                                      }
                                    }
                                    if (_activeController == _amountController) {
                                      TextEditingValue formattedValue = MoneyInputFormatter().formatEditUpdate(
                                        TextEditingValue(
                                          text: text,
                                          selection: TextSelection.collapsed(offset: text.length),
                                        ),
                                        TextEditingValue(
                                          text: text,
                                          selection: TextSelection.collapsed(offset: text.length),
                                        ),
                                      );
                                      _activeController.text = formattedValue.text;
                                      _activeController.selection = formattedValue.selection;
                                      setState(() {});
                                    } else {
                                      _activeController.text = text;
                                      _activeController.selection = TextSelection.collapsed(offset: cursorPosition);
                                      setState(() {});
                                    }
                                  },
                                ),
                              )
                            : const SizedBox.shrink(),
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
                              // TextSpan(
                              //   text: "  (Esc)",
                              //   style: TextStyle(fontWeight: FontWeight.w300),
                              // ),
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
                          tpmt6Id: campaignSelected?.docId,
                        );
                        mopsSelected.add(mopEDC);
                        FocusScope.of(context).unfocus();

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
                                ? SnackBarHelper.presentSuccessSnackBar(childContext, "Success Add Card", 3)
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
                              // TextSpan(
                              //   text: "  (F12)",
                              //   style: TextStyle(fontWeight: FontWeight.w300),
                              // ),
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
