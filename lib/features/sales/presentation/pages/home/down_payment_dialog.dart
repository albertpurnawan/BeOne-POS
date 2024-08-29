import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
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

  late final ReceiptEntity stateInvoice;
  String customerSelected = "Not Set";
  bool isReceive = true;

  @override
  void initState() {
    super.initState();
    stateInvoice = context.read<ReceiptCubit>().state;
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
    super.dispose();
  }

  void readCustomer() async {
    String customer = stateInvoice.customerEntity!.custName;

    setState(() {
      customerSelected = customer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ReceiptEntity stateInvoice = context.read<ReceiptCubit>().state;
    return Focus(
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
                animationDuration: 300,
                activeBgColors: const [
                  [ProjectColors.green],
                  [ProjectColors.green]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
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
              child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: isReceive ? _buildReceiveDownPayment() : _buildDrawDownPayment()),
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
                        borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
                onPressed: null,
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
    );
  }

  Widget _buildReceiveDownPayment() {
    return SizedBox(
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
                      ("${stateInvoice.docNum}/DP"),
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
                          customerSelected.toString(),
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
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 0),

              // Padding(
              //   padding: const EdgeInsets.fromLTRB(54, 10, 10, 10),
              //   child: Container(
              //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              //     child: TextField(
              //       maxLines: 3,
              //       maxLength: 300,
              //       controller: _remarksController,
              //       focusNode: _remarksFocusNode,
              //       decoration: const InputDecoration(
              //         contentPadding: EdgeInsets.all(10),
              //         border: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: ProjectColors.lightBlack,
              //             width: 1.0,
              //           ),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: ProjectColors.lightBlack,
              //             width: 1.0,
              //           ),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: ProjectColors.primary,
              //             width: 2.0,
              //           ),
              //         ),
              //         counterText: "",
              //       ),
              //     ),
              //   ),
              // ),
              // // const SizedBox(height: 30),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDrawDownPayment() {
    return Column();
  }
}
