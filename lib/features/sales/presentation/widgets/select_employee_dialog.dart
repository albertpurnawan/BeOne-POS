import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/presentation/cubit/employees_cubit.dart';

class SelectEmployee extends StatefulWidget {
  const SelectEmployee({super.key});

  @override
  State<SelectEmployee> createState() => _SelectEmployeeState();
}

class _SelectEmployeeState extends State<SelectEmployee> {
  EmployeeEntity? radioValue;
  EmployeeEntity? selectedEntity;
  final FocusNode _customerInputFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox.expand(
        child: OutlinedButton(
          onPressed: () async {
            // setState(() {
            //   isEditingNewReceiptItemCode = false;
            //   isEditingNewReceiptItemQty = false;
            //   isUpdatingReceiptItemQty = false;
            // });
            return showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  title: Container(
                    decoration: const BoxDecoration(
                      color: ProjectColors.primary,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5.0)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: const Text(
                      'Select Employee',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  contentPadding: EdgeInsets.all(0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextField(
                                onSubmitted: (value) {
                                  context
                                      .read<EmployeesCubit>()
                                      .getEmployees(searchKeyword: value);
                                  _customerInputFocusNode.requestFocus();
                                },
                                autofocus: true,
                                focusNode: _customerInputFocusNode,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                  hintText: "Enter employee's name",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: BlocBuilder<EmployeesCubit,
                                  List<EmployeeEntity>>(
                                builder: (context, state) {
                                  if (state.isEmpty) {
                                    return const Expanded(
                                        child: EmptyList(
                                      imagePath:
                                          "assets/images/empty-search.svg",
                                      sentence:
                                          "Tadaa.. There is nothing here!\nEnter any keyword to search.",
                                    ));
                                  }
                                  return ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: state.length,
                                      itemBuilder: ((context, index) {
                                        final EmployeeEntity employeeEntity =
                                            state[index];

                                        return RadioListTile<EmployeeEntity>(
                                            activeColor: ProjectColors.primary,
                                            hoverColor: ProjectColors.primary,
                                            selectedTileColor:
                                                ProjectColors.primary,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            value: state[index],
                                            groupValue: radioValue,
                                            title: Text(employeeEntity.empName),
                                            subtitle:
                                                Text(employeeEntity.phone),
                                            onChanged: (val) {
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
                  actions: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: ProjectColors.primary))),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.black.withOpacity(.2))),
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                              // Future.delayed(
                              //     const Duration(milliseconds: 200),
                              //     () => _newReceiptItemCodeFocusNode
                              //         .requestFocus());
                            });
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
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () async {
                            selectedEntity = radioValue;

                            Navigator.of(context).pop();
                          },
                          child: const Center(
                              child: Text(
                            "Select",
                            style: TextStyle(color: Colors.white),
                          )),
                        )),
                      ],
                    ),
                  ],
                  actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                );
              },
            ).then((value) => setState(() {
                  radioValue = null;
                  context.read<EmployeesCubit>().clearEmployees();
                }));
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(7),
            elevation: 5,
            shadowColor: Colors.black87,
            backgroundColor: ProjectColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: BorderSide.none,
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Select Employee",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}
