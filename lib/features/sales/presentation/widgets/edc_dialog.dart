import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_card_type.dart';

class EDCDialog extends StatefulWidget {
  const EDCDialog({
    Key? key,
    required this.mopSelectionEntity,
    this.max = double.infinity,
  }) : super(key: key);

  final MopSelectionEntity mopSelectionEntity;
  final double max;

  @override
  State<EDCDialog> createState() => _EDCDialogState();
}

class _EDCDialogState extends State<EDCDialog> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController amounController = TextEditingController();
  bool isCredit = false;
  List<String> mopDescriptionList = [];
  List<dynamic> mopList = [];
  String? cardSelected;
  String? tpmt2IdSelected;

  @override
  void initState() {
    fetchMOP();
    super.initState();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    amounController.dispose();
    super.dispose();
  }

  Future<void> fetchMOP() async {
    final tpmt1List = await GetIt.instance<AppDatabase>()
        .meansOfPaymentDao
        .readByPaytypeCode("2");

    List<String> descriptionList = [];
    if (tpmt1List != null) {
      for (var mop in tpmt1List) {
        String description = mop['description'];
        descriptionList.add(description);
      }
    }

    setState(() {
      mopDescriptionList.addAll(descriptionList);
      mopList.addAll(tpmt1List!);
    });
  }

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
          'Select MOP',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
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
                      children: mopDescriptionList
                          .map((String cardType) => ChoiceChip(
                                side: const BorderSide(
                                    color: ProjectColors.primary, width: 1.5),
                                label: Text(cardType),
                                padding: const EdgeInsets.all(15),
                                selected: false,
                                onSelected: (bool selected) {},
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
                                  cardSelected = selectedCard.description;
                                  tpmt2IdSelected = selectedCard.docId;
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
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Select Card Here...",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: ProjectColors.mediumBlack,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.arrow_right_outlined),
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
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Card Number",
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
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Campaign",
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
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Amount",
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
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.black.withOpacity(.2))),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  // Future.delayed(const Duration(milliseconds: 200),
                  //     () => _newReceiptItemCodeFocusNode.requestFocus());
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
                //onPressed
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
    );
  }
}
