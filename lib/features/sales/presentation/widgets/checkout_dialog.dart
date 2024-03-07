import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';

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
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: EdgeInsets.all(0),
      content: CheckoutDialogContent(),

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
  int? _value = 1;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              color: Color.fromARGB(255, 238, 255, 239),
              // decoration: BoxDecoration(
              //   boxShadow: [
              //     const BoxShadow(
              //       color: Color.fromARGB(255, 233, 233, 233),
              //     ),
              //     const BoxShadow(
              //       color: Color.fromARGB(255, 242, 242, 242),
              //       spreadRadius: -8.0,
              //       blurRadius: 15.0,
              //     ),
              //   ],
              // ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: ProjectColors.primary,
                      ),
                      child: Text(
                        "Total Amount",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Rp 420.000,00",
                      style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 33, 33, 33)),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tunai",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // height: 60,
                      // width: 400,
                      child: TextField(
                        inputFormatters: [MoneyInputFormatter()],
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Cash Amount",
                            hintStyle: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 24),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.payments_outlined,
                              size: 24,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List<Widget>.generate(
                        8,
                        (int index) {
                          return ChoiceChip(
                            side: BorderSide(
                                color: ProjectColors.primary, width: 1),
                            padding: EdgeInsets.all(20),
                            label: Text('Rp $index.000'),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "E-Wallet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List<Widget>.generate(
                        8,
                        (int index) {
                          return ChoiceChip(
                            side: BorderSide(
                                color: ProjectColors.primary, width: 1),
                            padding: EdgeInsets.all(20),
                            label: Text(
                              "OVO",
                            ),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "EDC",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List<Widget>.generate(
                        8,
                        (int index) {
                          return ChoiceChip(
                            side: BorderSide(
                                color: ProjectColors.primary, width: 1),
                            padding: EdgeInsets.all(20),
                            label: Text(
                              'Mandiri',
                            ),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Voucher",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List<Widget>.generate(
                        8,
                        (int index) {
                          return ChoiceChip(
                            side: BorderSide(
                                color: ProjectColors.primary, width: 1),
                            padding: EdgeInsets.all(20),
                            label: Text(
                              'JanCB15',
                            ),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Lainnya",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List<Widget>.generate(
                        8,
                        (int index) {
                          return ChoiceChip(
                            side: BorderSide(
                                color: ProjectColors.primary, width: 1),
                            padding: EdgeInsets.all(20),
                            label: Text(
                              'Kasbon',
                            ),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
            SizedBox(
              height: 15,
            ),
          ],
        ),
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
