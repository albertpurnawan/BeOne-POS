import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                'SETTINGS',
                style: TextStyle(
                    color: ProjectColors.swatch,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const SettingsForm()
            ],
          )),
    );
  }
}

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  late TextEditingController gtentController,
      tostrController,
      tocsrController,
      urlController;
  String? oldGtentId, oldTostrId, oldTocsrId, oldUrl;

  @override
  void initState() {
    super.initState();

    gtentController = TextEditingController();
    tostrController = TextEditingController();
    tocsrController = TextEditingController();
    urlController = TextEditingController();

    oldGtentId = Constant.gtentId;
    oldTostrId = Constant.tostrId;
    oldTocsrId = Constant.tocsrId;
    oldUrl = Constant.baseUrl;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        oldGtentId = prefs.getString('gtentId') ?? oldGtentId;
        oldTostrId = prefs.getString('tostrId') ?? oldTostrId;
        oldTocsrId = prefs.getString('tocsrId') ?? oldTocsrId;
        oldUrl = prefs.getString('baseUrl') ?? oldUrl;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    gtentController.dispose();
    tostrController.dispose();
    tocsrController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
        key: formKey,
        child: Column(children: [
          Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: gtentController,
              validator: (val) =>
                  val == null || val.isEmpty ? "TenantId is required" : null,
              label: "TenantId",
              hint: "Tenant Id",
              prefixIcon: const Icon(Icons.person_2_sharp),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: tostrController,
              validator: (val) =>
                  val == null || val.isEmpty ? "StoreId is required" : null,
              label: "StoreId",
              hint: "Store Id",
              prefixIcon: const Icon(Icons.store),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: tocsrController,
              validator: (val) =>
                  val == null || val.isEmpty ? "CashierId is required" : null,
              label: "CashierId",
              hint: "Cashier Id",
              prefixIcon: const Icon(Icons.point_of_sale),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: urlController,
              validator: (val) =>
                  val == null || val.isEmpty ? "BaseUrl is required" : null,
              label: "BaseUrl",
              hint: "Base Url",
              prefixIcon: const Icon(Icons.link_outlined),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: CustomButton(
              child: const Text("Save"),
              onTap: () async {
                Constant.updateTopos(gtentController.text, tostrController.text,
                    tocsrController.text, urlController.text);

                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 15),
        ]),
      ),
    );
  }
}

class SettingsFormFields extends StatelessWidget {
  const SettingsFormFields({
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
