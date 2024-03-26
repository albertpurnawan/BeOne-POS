import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/core/widgets/custom_row.dart';
import 'package:pos_fe/core/widgets/custom_row_input.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';

class EndShiftScreen extends StatefulWidget {
  const EndShiftScreen({super.key});

  @override
  State<EndShiftScreen> createState() => _EndShiftScreenState();
}

class _EndShiftScreenState extends State<EndShiftScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.swatch,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollWidget(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height / 2) - 300,
              ),
              const Text(
                'End Currrent Shift',
                style: TextStyle(
                    color: ProjectColors.swatch,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const CustomRow(
                leftText: "Cashier",
                rightText: "Cashier1   ",
              ),
              const CustomRow(
                leftText: "Shift Started",
                rightText: "SomeDate at SomeTime   ",
              ),
              const SizedBox(height: 10),
              const CustomRow(
                leftText: "System Cashier",
                rightText: "",
              ),
              const CustomRow(
                leftText: "   Start Cash",
                rightText: "Start Cash1   ",
              ),
              const CustomRow(
                leftText: "   Cash Flow",
                rightText: "Cash Flow1   ",
              ),
              const CustomRow(
                leftText: "   Cash Sales",
                rightText: "0   ",
              ),
              const CustomRow(
                leftText: "   Expected Cash",
                rightText: "All Cash   ",
              ),
              const CustomRow(
                leftText: "   Non-Cash",
                rightText: "Total NonCash   ",
              ),
              const SizedBox(height: 10),
              const CustomRow(
                leftText: "Actual Cash",
                rightText: "",
              ),
              const CustomRowInput(
                leftText: "   Actual Cash Earned",
                rightText: "Enter Actual Cash Earned",
              ),
              // const EndShiftForm(),
              const SizedBox(height: 30),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: CustomButton(
                  child: const Text("End Shift"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the borderRadius value as needed
                      ),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          )),
    );
  }
}

class EndShiftForm extends StatefulWidget {
  const EndShiftForm({Key? key}) : super(key: key);

  @override
  State<EndShiftForm> createState() => _EndShiftFormState();
}

class _EndShiftFormState extends State<EndShiftForm> {
  late TextEditingController actualCashController;

  @override
  void initState() {
    super.initState();
    actualCashController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    actualCashController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
        key: formKey,
        child: Column(children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: actualCashController,
              validator: (val) =>
                  val == null || val.isEmpty ? "Actual Cash is required" : null,
              keyboardType: TextInputType.number,
              hint: "Enter Actual Cash Earned",
              prefixIcon: const Icon(Icons.monetization_on_rounded),
            ),
          ),
          const SizedBox(height: 15),
        ]),
      ),
    );
  }
}

class ActualCashFormFields extends StatelessWidget {
  const ActualCashFormFields({
    Key? key,
    this.validator,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    required this.label,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  final String? Function(String? val)? validator;
  final Widget? prefix, prefixIcon, suffix, suffixIcon;
  final String label;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(Object context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(bottom: 10),
          prefixIcon: prefixIcon,
          prefix: prefix,
          suffixIcon: suffixIcon,
          suffix: suffix,
          labelText: label),
    );
  }
}
