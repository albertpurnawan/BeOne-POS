import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/presentation/cubit/employees_cubit.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class SelectEmployee extends StatefulWidget {
  const SelectEmployee({super.key});

  @override
  State<SelectEmployee> createState() => _SelectEmployeeState();
}

class _SelectEmployeeState extends State<SelectEmployee> {
  EmployeeEntity? radioValue;
  EmployeeEntity? selectedEmployee;
  final FocusNode _employeeInputFocusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();
  final TextEditingController _employeeTextController = TextEditingController();
  bool _showKeyboard = true;
  bool _shiftEnabled = false;

  @override
  void dispose() {
    _employeeInputFocusNode.dispose();
    _keyboardFocusNode.dispose();
    _employeeTextController.dispose();
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
              !_employeeInputFocusNode.hasPrimaryFocus) {
            _employeeInputFocusNode.unfocus();
            _employeeTextController.text += event.character!;
            _employeeInputFocusNode.requestFocus();
            return KeyEventResult.handled;
          } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown && _employeeInputFocusNode.hasPrimaryFocus) {
            _employeeInputFocusNode.nextFocus();
            return KeyEventResult.handled;
          } else if (event.physicalKey == PhysicalKeyboardKey.f12) {
            _employeeInputFocusNode.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();

            selectedEmployee = radioValue;
            Navigator.of(context).pop(selectedEmployee);
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
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Employee',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(360)),
                ),
                child: IconButton(
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
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _employeeTextController,
                      onSubmitted: (value) {
                        context.read<EmployeesCubit>().getEmployees(searchKeyword: value);
                        _employeeInputFocusNode.requestFocus();
                      },
                      autofocus: true,
                      focusNode: _employeeInputFocusNode,
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
                      keyboardType: TextInputType.none,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: BlocBuilder<EmployeesCubit, List<EmployeeEntity>>(
                      builder: (context, state) {
                        if (state.isEmpty) {
                          return const EmptyList(
                            imagePath: "assets/images/empty-search.svg",
                            sentence: "Tadaa.. There is nothing here!\nEnter any keyword to search.",
                          );
                        }
                        return ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: state.length,
                            itemBuilder: ((context, index) {
                              final EmployeeEntity employeeEntity = state[index];

                              return RadioListTile<EmployeeEntity>(
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
                                  title: Text(employeeEntity.empName),
                                  subtitle: Text(employeeEntity.phone),
                                  onChanged: (val) async {
                                    setState(() {
                                      radioValue = val;
                                    });
                                  });
                            }));
                      },
                    ),
                  ),
                  (_showKeyboard)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: KeyboardWidget(
                            controller: _employeeTextController,
                            isNumericMode: false,
                            customLayoutKeys: true,
                            onKeyPress: (key) async {
                              String text = _employeeTextController.text;
                              TextSelection currentSelection = _employeeTextController.selection;
                              int cursorPosition = currentSelection.start;

                              if (key.keyType == VirtualKeyboardKeyType.String) {
                                String inputText = (_shiftEnabled ? key.capsText : key.text) ?? '';
                                text = text.replaceRange(cursorPosition, cursorPosition, inputText);
                                cursorPosition += inputText.length;
                              } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                                switch (key.action) {
                                  case VirtualKeyboardKeyAction.Backspace:
                                    if (text.isNotEmpty) {
                                      text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
                                      cursorPosition -= 1;
                                    }
                                    break;
                                  case VirtualKeyboardKeyAction.Return:
                                    _employeeTextController.text = _employeeTextController.text.trimRight();
                                    context
                                        .read<EmployeesCubit>()
                                        .getEmployees(searchKeyword: _employeeTextController.text);
                                    _employeeInputFocusNode.requestFocus();
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
                              _employeeTextController.text = text;
                              _employeeTextController.selection = TextSelection.collapsed(offset: cursorPosition);

                              setState(() {});
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
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
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                  context.read<EmployeesCubit>().clearEmployees();
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
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                    onPressed: () async {
                      selectedEmployee = radioValue;
                      log("SelectedEmployee - $selectedEmployee");
                      Navigator.of(context).pop(selectedEmployee);
                      context.read<EmployeesCubit>().clearEmployees();
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
