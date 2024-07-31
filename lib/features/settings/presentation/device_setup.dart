import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/features/login/presentation/pages/confirm_restore_db_dialog.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/token_service.dart';
import 'package:pos_fe/features/settings/domain/usecases/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceSetupScreen extends StatefulWidget {
  final bool toposExist;
  const DeviceSetupScreen({Key? key, required this.toposExist}) : super(key: key);

  @override
  State<DeviceSetupScreen> createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends State<DeviceSetupScreen> {
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
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(100, 50, 100, 50),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'SETTINGS',
              //   style: TextStyle(
              //       color: ProjectColors.swatch,
              //       fontSize: 30,
              //       fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 30),
              SettingsForm(haveTopos: widget.toposExist)
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsForm extends StatefulWidget {
  final bool haveTopos;
  const SettingsForm({Key? key, required this.haveTopos}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  late TextEditingController gtentController,
      tostrController,
      tocsrController,
      urlController,
      emailController,
      passwordController,
      otpChannelController;
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
    otpChannelController = TextEditingController();

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

    if (!widget.haveTopos) checkPermission();
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
    otpChannelController.dispose();
  }

  Future<void> checkPermission() async {
    try {
      final permissionStatus = await Permission.manageExternalStorage.status;
      if (!permissionStatus.isGranted) {
        await PermissionHandler.requestStoragePermissions(context);
      }

      final updatedStatus = await Permission.manageExternalStorage.status;
      if (!updatedStatus.isGranted) {
        log("Permission still not granted. Cannot proceed with restore.");
        return;
      }
      await checkDatabase();
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, "Error on check permission");
    }
  }

  Future<void> checkDatabase() async {
    try {
      Directory backupFolder;
      if (Platform.isWindows) {
        final userProfile = Platform.environment['USERPROFILE'];
        if (userProfile == null) {
          throw Exception('Could not determine user profile directory');
        }
        final backupDir = p.join(userProfile, 'Documents', 'app', 'RubyPOS');
        backupFolder = Directory(backupDir);
        log("backupDir W - $backupDir");
        log("backupFolder W - $backupFolder");
      } else if (Platform.isAndroid) {
        const backupDir = "/storage/emulated/0";
        backupFolder = Directory('$backupDir/RubyPOS');
      } else if (Platform.isIOS) {
        final documentsDir = await getApplicationDocumentsDirectory();
        final backupDir = p.join(documentsDir.path, 'RubyPOS');
        backupFolder = Directory(backupDir);
      } else {
        throw UnsupportedError("Unsupported platform");
      }

      if (!backupFolder.existsSync()) return;

      final backupFiles = backupFolder.listSync().where((file) => file.path.endsWith('.zip')).toList()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      log("backup - $backupFiles");

      if (backupFiles.isEmpty) {
        return;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => const ConfirmRestoreDBDialog(),
        );
      }
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, "Error on check database");
    }
  }

  Future<String> encryptPassword(String rawPassword) async {
    final encryptPasswordUseCase = GetIt.instance<EncryptPasswordUseCase>();
    try {
      final encryptedPassword = await encryptPasswordUseCase.call(params: rawPassword);
      return encryptedPassword;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: CustomInput(
                    controller: gtentController,
                    validator: (val) => val == null || val.isEmpty ? "TenantId is required" : null,
                    label: "TenantId",
                    hint: "Tenant Id",
                    prefixIcon: const Icon(Icons.person_2_sharp),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: CustomInput(
                    controller: tostrController,
                    validator: (val) => val == null || val.isEmpty ? "StoreId is required" : null,
                    label: "StoreId",
                    hint: "Store Id",
                    prefixIcon: const Icon(Icons.store),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: CustomInput(
                    controller: tocsrController,
                    validator: (val) => val == null || val.isEmpty ? "CashierId is required" : null,
                    label: "CashierId",
                    hint: "Cashier Id",
                    prefixIcon: const Icon(Icons.point_of_sale),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: CustomInput(
                    controller: urlController,
                    validator: (val) => val == null || val.isEmpty ? "BaseUrl is required" : null,
                    label: "BaseUrl",
                    hint: "Base Url",
                    prefixIcon: const Icon(Icons.link_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: CustomInput(
                    controller: emailController,
                    validator: (val) => val == null || val.isEmpty ? "Manager Email is required" : null,
                    label: "Manager Email",
                    hint: "Manager Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: CustomInput(
                    controller: passwordController,
                    validator: (val) => val == null || val.isEmpty ? "Manager Password is required" : null,
                    obscureText: true,
                    label: "Manager Password",
                    hint: "Manager Password",
                    prefixIcon: const Icon(Icons.password_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: CustomInput(
                    controller: otpChannelController,
                    validator: (val) => val == null || val.isEmpty ? "OTP Channel is required" : null,
                    label: "OTP Channel",
                    hint: "OTP Channel",
                    prefixIcon: const Icon(Icons.vpn_key),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: const Text(""),
                ),
              ),
            ],
          ),
          const SizedBox(height: 150),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    child: const Text("Save"),
                    onTap: () async {
                      try {
                        await prefs.clear();
                        await GetIt.instance<AppDatabase>().posParameterDao.deleteTopos();

                        final hashedPassword = await encryptPassword(passwordController.text);

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
                          passwordAdmin: hashedPassword,
                          otpChannel: otpChannelController.text,
                          lastSync: '2000-01-01 00:00:00',
                        );

                        await GetIt.instance<AppDatabase>().posParameterDao.create(data: topos);

                        final token = await GetIt.instance<TokenApi>()
                            .getToken(urlController.text, emailController.text, passwordController.text);

                        final encryptPasswordUseCase = GetIt.instance<EncryptPasswordUseCase>();
                        final encryptToken = await encryptPasswordUseCase.call(params: token);
                        prefs.setString('adminToken', encryptToken);

                        Navigator.pop(context, true);
                      } catch (e, s) {
                        ErrorHandler.presentErrorSnackBar(context, "$e $s");
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
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
