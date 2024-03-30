import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';

class StartShiftScreen extends StatefulWidget {
  const StartShiftScreen({super.key});

  @override
  State<StartShiftScreen> createState() => _StartShiftScreenState();
}

class _StartShiftScreenState extends State<StartShiftScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.swatch,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollWidget(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height / 2) - 250,
              ),
              const Text(
                'Show Date Here',
                style: TextStyle(
                    color: ProjectColors.swatch,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const StartShiftForm(),
              const SizedBox(height: 20),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: CustomButton(
                  child: const Text("Start Shift"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartShiftScreen()),
                    );
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

class StartShiftForm extends StatefulWidget {
  const StartShiftForm({Key? key}) : super(key: key);

  @override
  State<StartShiftForm> createState() => _StartShiftFormState();
}

class _StartShiftFormState extends State<StartShiftForm> {
  late TextEditingController openValueController;

  @override
  void initState() {
    super.initState();

    openValueController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    openValueController.dispose();
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
              controller: openValueController,
              validator: (val) => val == null || val.isEmpty
                  ? "Opening Value is required"
                  : null,
              // label: "Openvalue",
              keyboardType: TextInputType.number,
              hint: "Enter Amount of Starting Cash",
              prefixIcon: const Icon(Icons.monetization_on_rounded),
            ),
          ),
          const SizedBox(height: 15),
        ]),
      ),
    );
  }
}

class StartShiftFormFields extends StatelessWidget {
  const StartShiftFormFields({
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
