import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class EDCDialog extends StatefulWidget {
  final double mopAmount;
  const EDCDialog({super.key, required this.mopAmount});

  @override
  State<EDCDialog> createState() => _EDCDialogState();
}

class _EDCDialogState extends State<EDCDialog> {
  String? radioValue;
  final TextEditingController bankIssuerController = TextEditingController();
  final TextEditingController subtypeController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController amounController = TextEditingController();
  bool isCredit = false;
  List<String> bankFound = [];
  List<String> bankDummy = [
    'Bank of America',
    'Chase Bank',
    'Wells Fargo',
    'Citi Bank',
    'HSBC',
    'Deutsche Bank'
  ];

  @override
  void dispose() {
    bankIssuerController.dispose();
    subtypeController.dispose();
    cardNumberController.dispose();
    cardHolderController.dispose();
    amounController.dispose();
    super.dispose();
  }

  void searchBankIssuer(String query) {
    final results = bankDummy
        .where((bank) => bank.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      bankFound = results;
    });

    if (results.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
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
                'Bank List',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(results[index]),
                    onTap: () {
                      bankIssuerController.text = results[index];
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "NO BANK FOUND",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ProjectColors.primary),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
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
          'EDC',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          color: Color.fromRGBO(0, 0, 0, 0.222),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(300, 0, 100, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: "Credit",
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value;
                                    isCredit = true;
                                  });
                                },
                              ),
                              const Text(
                                'Credit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ProjectColors.mediumBlack,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: "Debit",
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value;
                                    isCredit = false;
                                  });
                                },
                              ),
                              const Text(
                                'Debit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ProjectColors.mediumBlack,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 50,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Card Type",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              if (isCredit)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Payment Network",
                      hintStyle:
                          TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextFormField(
                  controller: bankIssuerController,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Bank Issuer",
                    hintStyle:
                        TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.search_outlined,
                      size: 18,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    bankIssuerController.text = "";
                    bankFound = [];
                    searchBankIssuer(value);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Subtype",
                      hintStyle:
                          TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.search_outlined,
                        size: 18,
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (isCredit)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Card Number",
                      hintStyle:
                          TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              if (isCredit)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Card Holder",
                      hintStyle:
                          TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Amount",
                    hintStyle:
                        TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

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
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    );
  }
}
