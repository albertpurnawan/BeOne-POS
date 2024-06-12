import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/presentation/cubit/employees_cubit.dart';

class SelectEmployee extends StatefulWidget {
  const SelectEmployee({super.key});

  @override
  State<SelectEmployee> createState() => _SelectEmployeeState();
}

class _SelectEmployeeState extends State<SelectEmployee> {
  EmployeeEntity? radioValue;
  final FocusNode _customerInputFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Employee'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                hintText: "Enter customer's name",
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<EmployeesCubit, List<EmployeeEntity>>(
              builder: (context, state) {
                if (state.isEmpty) {
                  return const Center(
                    child:
                        Text("No customers found. Enter a keyword to search."),
                  );
                }
                return ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    final EmployeeEntity customerEntity = state[index];
                    return RadioListTile<EmployeeEntity>(
                      activeColor: ProjectColors.primary,
                      hoverColor: ProjectColors.primary,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: customerEntity,
                      groupValue: radioValue,
                      title: Text(customerEntity.empName),
                      subtitle: Text(customerEntity.phone),
                      onChanged: (val) {
                        setState(() {
                          radioValue = val;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      if (radioValue != null) {
                        // Do something with the selected customer
                        Navigator.of(context).pop(radioValue);
                      }
                    },
                    child: const Text("Select"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
