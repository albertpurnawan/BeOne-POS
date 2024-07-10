import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/presentation/cubit/customers_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';

class SelectCustomerDialog extends StatefulWidget {
  const SelectCustomerDialog({super.key});

  @override
  State<SelectCustomerDialog> createState() => _SelectCustomerDialogState();
}

class _SelectCustomerDialogState extends State<SelectCustomerDialog> {
  late final FocusNode _customerInputFocusNode = FocusNode();
  late final TextEditingController _textEditingControllerCustomer = TextEditingController();
  CustomerEntity? radioValue;
  CustomerEntity? selectedCustomer;

  @override
  void dispose() {
    _customerInputFocusNode.dispose();
    _textEditingControllerCustomer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: FocusNode(
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          if (event.runtimeType == KeyUpEvent) {
            return KeyEventResult.handled;
          }

          if (event.character != null &&
              RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(event.character!) &&
              !_customerInputFocusNode.hasPrimaryFocus) {
            _customerInputFocusNode.unfocus();
            _textEditingControllerCustomer.text += event.character!;
            _customerInputFocusNode.requestFocus();
            return KeyEventResult.handled;
          } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown && _customerInputFocusNode.hasPrimaryFocus) {
            _customerInputFocusNode.nextFocus();
            return KeyEventResult.handled;
          } else if (event.physicalKey == PhysicalKeyboardKey.f12) {
            _customerInputFocusNode.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();

            selectedCustomer = radioValue;
            context.read<ReceiptCubit>().updateCustomer(selectedCustomer!, context);
            Navigator.of(context).pop();
            return KeyEventResult.handled;
          } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
            Navigator.of(context).pop();
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        },
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: const Text(
            'Select Customer',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: Theme(
          data: ThemeData(
            splashColor: const Color.fromARGB(40, 169, 0, 0),
            highlightColor: const Color.fromARGB(40, 169, 0, 0),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            fontFamily: 'Roboto',
            useMaterial3: true,
          ),
          child: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              width: 350,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      onSubmitted: (value) {
                        context.read<CustomersCubit>().getActiveCustomers(searchKeyword: value);
                        _customerInputFocusNode.requestFocus();
                      },
                      autofocus: true,
                      focusNode: _customerInputFocusNode,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          size: 16,
                        ),
                        hintText: "Enter customer's name",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        // isCollapsed: true,
                        // contentPadding:
                        //     EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Text(
                  //   "Name",
                  //   textAlign: TextAlign.left,
                  // ),
                  Expanded(
                    child: BlocBuilder<CustomersCubit, List<CustomerEntity>>(
                      builder: (context, state) {
                        if (state.isEmpty) {
                          return const Expanded(
                              child: EmptyList(
                            imagePath: "assets/images/empty-search.svg",
                            sentence: "Tadaa.. There is nothing here!\nEnter any keyword to search.",
                          ));
                        }
                        return ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: state.length,
                            itemBuilder: ((context, index) {
                              final CustomerEntity customerEntity = state[index];

                              return RadioListTile<CustomerEntity>(
                                  activeColor: ProjectColors.primary,
                                  hoverColor: ProjectColors.primary,
                                  // selected: index == radioValue,
                                  selectedTileColor: ProjectColors.primary,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  value: state[index],
                                  groupValue: radioValue,
                                  title: Text(customerEntity.custName),
                                  subtitle: Text(customerEntity.phone),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius:
                                  //         BorderRadius.circular(5)),
                                  onChanged: (val) async {
                                    setState(() {
                                      radioValue = val;
                                    });
                                  });
                            }));
                      },
                    ),
                  )
                ],
              ),
            );
          }),
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
                        borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
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
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                    onPressed: () async {
                      selectedCustomer = radioValue;
                      await context.read<ReceiptCubit>().updateCustomer(selectedCustomer!, context);
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Select",
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
                    )),
              )
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
}
