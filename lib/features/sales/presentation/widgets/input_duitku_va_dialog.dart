import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/domain/entities/duitku_va_details.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';

class InputDuitkuVADialog extends StatefulWidget {
  const InputDuitkuVADialog({
    super.key,
    required this.mopSelectionEntity,
    required this.paymentMethods,
    required this.amount,
    required this.onVASelected,
  });

  final Function(
    MopSelectionEntity,
  ) onVASelected;
  final MopSelectionEntity mopSelectionEntity;
  final List<dynamic> paymentMethods;
  final int amount;

  @override
  State<InputDuitkuVADialog> createState() => _InputDuitkuVADialogState();
}

class _InputDuitkuVADialogState extends State<InputDuitkuVADialog> {
  String? selectedPaymentMethod;
  DuitkuVADetailsEntity? vaDuitku;
  final _textEditingControllerVAAmount = TextEditingController();
  // final _textEditingControllerRemarks = TextEditingController();
  bool isErr = false;
  String errMsg = "Invalid amount";
  MopSelectionEntity? mopVA;

  late FocusNode _focusNodeVADropdown;
  // FocusNode _focusNodeRemarks = FocusNode();
  late final _focusNodeVAAmount = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.f12) {
        if (isErr) return KeyEventResult.handled;
        if (selectedPaymentMethod == null) return KeyEventResult.handled;
        if (mopVA == null) return KeyEventResult.handled;

        final double mopAmount = Helpers.revertMoneyToDecimalFormat(_textEditingControllerVAAmount.text);

        if (_textEditingControllerVAAmount.text.isEmpty || mopAmount == 0) {
          setState(() {
            isErr = true;
            errMsg = "Invalid amount";
          });
          return KeyEventResult.handled;
        }

        if (mopAmount > widget.amount) {
          setState(() {
            isErr = true;
            errMsg = "Amount exceeds the total amount";
          });
          return KeyEventResult.handled;
        }

        mopVA = mopVA?.copyWith(
          cardName: vaDuitku!.paymentName,
          cardHolder: selectedPaymentMethod,
          edcDesc: vaDuitku!.paymentImage,
          amount: mopAmount,
          tpmt7Id: vaDuitku!.docId,
        );
        widget.onVASelected(mopVA!);

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
  initState() {
    super.initState();
    mopVA = widget.mopSelectionEntity;
    _focusNodeVADropdown = FocusNode();
    // _focusNodeRemarks = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodeVADropdown.requestFocus();
    });
  }

  @override
  void dispose() {
    _textEditingControllerVAAmount.dispose();
    // _textEditingControllerRemarks.dispose();
    _focusNodeVAAmount.dispose();
    _focusNodeVADropdown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Select Virtual Account',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: DropdownButtonFormField<String>(
                  hint: const Text("Choose a Virtual Account"),
                  value: selectedPaymentMethod,
                  focusNode: _focusNodeVADropdown,
                  isExpanded: true,
                  icon: null,
                  elevation: 18,
                  style: const TextStyle(
                    color: ProjectColors.mediumBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: "",
                    hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: ProjectColors.mediumBlack, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ProjectColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 24,
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a payment method';
                    }
                    return null;
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentMethod = newValue;

                      final selectedMethod =
                          widget.paymentMethods.firstWhere((method) => method.paymentMethod == newValue);

                      log("selectedMethod = $selectedMethod");

                      if (selectedMethod != null) {
                        vaDuitku = DuitkuVADetailsEntity(
                          docId: selectedMethod.docId ?? "",
                          paymentMethod: selectedPaymentMethod ?? "",
                          paymentName: selectedMethod.paymentName,
                          paymentImage: selectedMethod.paymentImage,
                          totalFee: selectedMethod.totalFee ?? 0,
                          statusActive: selectedMethod.statusActive ?? 0,
                        );
                      }
                    });
                  },
                  items: widget.paymentMethods.where(
                    (method) {
                      final paymentName = method.paymentName.trim();
                      return paymentName.contains(' VA ') || paymentName.endsWith(' VA') && method.statusActive == 1;
                    },
                  ).map((method) {
                    return DropdownMenuItem<String>(
                      value: method.paymentMethod,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(method.paymentName),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              method.paymentImage.endsWith(".SVG")
                                  ? SvgPicture.network(
                                      method.paymentImage,
                                      width: 30,
                                      height: 30,
                                    )
                                  : Image.network(
                                      method.paymentImage,
                                      width: 75,
                                      height: 50,
                                    ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextFormField(
                  focusNode: _focusNodeVAAmount,
                  controller: _textEditingControllerVAAmount,
                  autofocus: true,
                  inputFormatters: [MoneyInputFormatter()],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                  onChanged: (value) {
                    final double mopAmount = Helpers.revertMoneyToDecimalFormat(value);
                    if (mopAmount > widget.amount) {
                      setState(() {
                        isErr = true;
                        errMsg = "Invalid amount";
                      });
                    } else if (isErr) {
                      setState(() {
                        isErr = false;
                        errMsg = "Invalid amount";
                      });
                    }
                  },
                  onEditingComplete: () {
                    if (isErr) return;
                    if (selectedPaymentMethod == null) return;
                    if (mopVA == null) return;
                    final double mopAmount = Helpers.revertMoneyToDecimalFormat(_textEditingControllerVAAmount.text);
                    if (_textEditingControllerVAAmount.text.isEmpty || mopAmount == 0) return;
                    mopVA = mopVA?.copyWith(
                      cardName: vaDuitku!.paymentName,
                      cardHolder: selectedPaymentMethod,
                      edcDesc: vaDuitku!.paymentImage,
                      amount: mopAmount,
                      tpmt7Id: vaDuitku!.docId,
                    );
                    log("mopVA- $mopVA");
                    widget.onVASelected(mopVA!);
                    context.pop(mopAmount);
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintText: "Enter Amount (MAX: ${widget.amount})",
                      hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
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
                      prefixIcon: const Icon(
                        Icons.payments_outlined,
                        size: 24,
                      )),
                ),
              ),
              const SizedBox(height: 20),
              // SizedBox(
              //   height: 50,
              //   child: TextFormField(
              //     focusNode: _focusNodeRemarks,
              //     controller: _textEditingControllerRemarks,
              //     autofocus: true,
              //     keyboardType: TextInputType.text,
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(fontSize: 18),
              //     onChanged: (value) {},
              //     onEditingComplete: () {},
              //     decoration: InputDecoration(
              //         contentPadding: const EdgeInsets.all(10),
              //         hintText: "Remarks",
              //         hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              //         border: const OutlineInputBorder(),
              //         suffix: isErr
              //             ? Text(
              //                 errMsg,
              //                 style: const TextStyle(
              //                     fontSize: 14,
              //                     fontStyle: FontStyle.normal,
              //                     fontWeight: FontWeight.w700,
              //                     color: ProjectColors.swatch),
              //               )
              //             : null,
              //         prefixIcon: const Icon(
              //           Icons.note_alt_outlined,
              //           size: 24,
              //         )),
              //   ),
              // ),
            ],
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
                      borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
              onPressed: () {
                setState(() {
                  context.pop();
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
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
              onPressed: () {
                if (isErr) return;
                if (selectedPaymentMethod == null) return;
                if (mopVA == null) return;
                final double mopAmount = Helpers.revertMoneyToDecimalFormat(_textEditingControllerVAAmount.text);
                if (_textEditingControllerVAAmount.text.isEmpty || mopAmount == 0) return;
                mopVA = mopVA?.copyWith(
                  cardName: vaDuitku!.paymentName,
                  cardHolder: selectedPaymentMethod,
                  edcDesc: vaDuitku!.paymentImage,
                  amount: mopAmount,
                  tpmt7Id: vaDuitku!.docId,
                );
                widget.onVASelected(mopVA!);
                context.pop(mopAmount);
              },
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Set",
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
