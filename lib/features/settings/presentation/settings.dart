import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/features/sales/data/models/netzme_data.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.primary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Setup'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color.fromARGB(255, 234, 234, 234),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Text(
                //   'SETTINGS',
                //   style: TextStyle(
                //       color: ProjectColors.swatch,
                //       fontSize: 30,
                //       fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 30),
                const SettingsForm()
              ],
            ),
          ),
        ),
      ),
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
      urlController,
      emailController,
      passwordController;
  String? oldGtentId, oldTostrId, oldTocsrId, oldUrl;
  SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  String dflDate = "2000-01-01 00:00:00";

  @override
  void initState() {
    super.initState();

    gtentController = TextEditingController();
    tostrController = TextEditingController();
    tocsrController = TextEditingController();
    urlController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    oldGtentId = Constant.gtentId;
    oldTostrId = Constant.tostrId;
    oldTocsrId = Constant.tocsrId;
    oldUrl = Constant.url;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        oldGtentId = prefs.getString('gtentId') ?? oldGtentId;
        oldTostrId = prefs.getString('tostrId') ?? oldTostrId;
        oldTocsrId = prefs.getString('tocsrId') ?? oldTocsrId;
        oldUrl = prefs.getString('url') ?? oldUrl;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    gtentController.dispose();
    tostrController.dispose();
    tocsrController.dispose();
    urlController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
            constraints: const BoxConstraints(maxWidth: 400),
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
            constraints: const BoxConstraints(maxWidth: 400),
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
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: urlController,
              validator: (val) =>
                  val == null || val.isEmpty ? "BaseUrl is required" : null,
              label: "BaseUrl",
              hint: "Base Url",
              prefixIcon: const Icon(Icons.link_outlined),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: emailController,
              validator: (val) => val == null || val.isEmpty
                  ? "Manager Email is required"
                  : null,
              label: "Manager Email",
              hint: "Manager Email",
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: passwordController,
              validator: (val) => val == null || val.isEmpty
                  ? "Manager Password is required"
                  : null,
              obscureText: true,
              label: "Manager Password",
              hint: "Manager Password",
              prefixIcon: const Icon(Icons.password_outlined),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomButton(
              child: const Text("Save"),
              onTap: () async {
                try {
                  await prefs.clear();

                  final hashedPass =
                      md5.convert(utf8.encode("BeOne\$\$123")).toString();

                  final topos = POSParameterModel(
                    docId: const Uuid().v4(),
                    createDate: DateTime.now(),
                    updateDate: DateTime.now(),
                    gtentId: gtentController.text,
                    tostrId: tostrController.text,
                    storeName: "",
                    tocsrId: tocsrController.text,
                    baseUrl: urlController.text,
                    usernameAdmin: emailController.text,
                    passwordAdmin: hashedPass,
                    lastSync: '2000-01-01 00:00:00',
                  );

                  await GetIt.instance<AppDatabase>()
                      .posParameterDao
                      .create(data: topos);

                  log("TOPOS CREATED");

                  Constant.updateTopos(
                    gtentController.text,
                    tostrController.text,
                    tocsrController.text,
                    urlController.text,
                    emailController.text,
                    hashedPass,
                    dflDate,
                  );

                  final token = await GetIt.instance<TokenApi>().getToken(
                      urlController.text,
                      emailController.text,
                      passwordController.text);

                  prefs.setString('adminToken', token.toString());

                  final tntzm = [
                    NetzmeModel(
                        docId: const Uuid().v4(),
                        url: "https://tokoapisnap-stg.netzme.com",
                        clientKey: "pt_bak",
                        clientSecret: "61272364208846ee9366dc204f81fce6",
                        privateKey:
                            "MIIBOgIBAAJBAMjxtB9QVz9KLCe5DAqJoLlz7e9ZhS5EE5YhC0E1F7+a14GLpm7mqcSN0alAmOK5DQZW4JufhzFmDpwB3a4+vskCAwEAAQJAfDYkcILaG64+0yMo1U6zwk9uEdkVYT8FmHS+n0Uxc+cqgs9UGb8uFoZmswGhs5HpfxpgEOckucwqi4SrgqXWMQIhAM4DOyj8SVCbvieRjOruhLjuh6S9wQmingB7A9+b58bVAiEA+bOjL0CothyHnfNgaY2IBT9TIO0FefTE1IfcukbH+iUCIHeyTOdNXlOlieB3owbFOvwwK0O+tLAieecRkniTnyFZAiA5uQsqKzpVDvdSziYlgHBHNkJTRDeV3714nAeskBw+eQIhAKkIuZjqXadPACYDNUXrfm5GGWZ2BKUjujJIZXjaRLnA",
                        custIdMerchant: "M_b7uJH43W")
                  ];
                  final netz =
                      await GetIt.instance<AppDatabase>().netzmeDao.readAll();
                  if (netz.isEmpty) {
                    await GetIt.instance<AppDatabase>()
                        .netzmeDao
                        .bulkCreate(data: tntzm);
                  } else {
                    await GetIt.instance<AppDatabase>()
                        .netzmeDao
                        .update(docId: netz[0].docId, data: netz[0]);
                  }

                  Navigator.pop(context);
                } catch (e, s) {
                  ErrorHandler.presentErrorSnackBar(context, "$e $s");
                }
              },
            ),
          ),
          const SizedBox(height: 15),
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
      // validator: validator,
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
