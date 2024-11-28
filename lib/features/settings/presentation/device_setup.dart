import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/usecases/generate_device_number_usecase.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/login/presentation/pages/confirm_restore_db_dialog.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
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
  bool showKeyboard = true;

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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                color: showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                borderRadius: const BorderRadius.all(Radius.circular(360)),
              ),
              child: IconButton(
                icon: Icon(
                  showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_alt_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    showKeyboard = !showKeyboard;
                  });
                },
                tooltip: 'Toggle Keyboard',
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(100, 50, 100, 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SettingsForm(
                haveTopos: widget.toposExist,
                showKeyboard: showKeyboard,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsForm extends StatefulWidget {
  final bool haveTopos;
  final bool showKeyboard;
  const SettingsForm({Key? key, required this.haveTopos, required this.showKeyboard}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  SharedPreferences prefs = GetIt.instance<SharedPreferences>();

  final formKey = GlobalKey<FormState>();

  final TextEditingController gtentController = TextEditingController();
  final TextEditingController tostrController = TextEditingController();
  final TextEditingController tocsrController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode _gtentFocusNode = FocusNode();
  final FocusNode _tostrFocusNode = FocusNode();
  final FocusNode _tocsrFocusNode = FocusNode();
  final FocusNode _urlFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String currentFocusedField = '';

  String device = "";

  @override
  void initState() {
    super.initState();
    generateDeviceNumber();

    if (!widget.haveTopos) checkPermission().then((value) => _gtentFocusNode.requestFocus());

    _gtentFocusNode.addListener(() {
      if (_gtentFocusNode.hasFocus) {
        setState(() {
          currentFocusedField = 'gtent';
        });
      }
    });
    _tostrFocusNode.addListener(() {
      if (_tostrFocusNode.hasFocus) {
        setState(() {
          currentFocusedField = 'tostr';
        });
      }
    });
    _tocsrFocusNode.addListener(() {
      if (_tocsrFocusNode.hasFocus) {
        setState(() {
          currentFocusedField = 'tocsr';
        });
      }
    });
    _urlFocusNode.addListener(() {
      if (_urlFocusNode.hasFocus) {
        setState(() {
          currentFocusedField = 'url';
        });
      }
    });
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        setState(() {
          currentFocusedField = 'email';
        });
      }
    });
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          currentFocusedField = 'password';
        });
      }
    });
  }

  @override
  void dispose() {
    gtentController.dispose();
    tostrController.dispose();
    tocsrController.dispose();
    urlController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _gtentFocusNode.dispose();
    _tostrFocusNode.dispose();
    _tocsrFocusNode.dispose();
    _urlFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> generateDeviceNumber() async {
    final deviceId = await GetIt.instance<GenerateDeviceNumberUseCase>().call();
    setState(() {
      device = deviceId;
    });
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
    TextEditingController? activeController;
    switch (currentFocusedField) {
      case 'gtent':
        activeController = gtentController;
        break;
      case 'tostr':
        activeController = tostrController;
        break;
      case 'tocsr':
        activeController = tocsrController;
        break;
      case 'url':
        activeController = urlController;
        break;
      case 'email':
        activeController = emailController;
        break;
      default:
        activeController = passwordController;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
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
                    height: 55,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      controller: gtentController,
                      focusNode: _gtentFocusNode,
                      validator: (val) => val == null || val.isEmpty ? "TenantId is required" : null,
                      decoration: const InputDecoration(
                        labelText: "TenantId",
                        hintText: "Tenant Id",
                        prefixIcon: Icon(Icons.person_2_sharp),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.none,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Container(
                    height: 55,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      controller: tostrController,
                      focusNode: _tostrFocusNode,
                      validator: (val) => val == null || val.isEmpty ? "StoreId is required" : null,
                      decoration: const InputDecoration(
                        labelText: "StoreId",
                        hintText: "Store Id",
                        prefixIcon: Icon(Icons.store),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.none,
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
                    height: 55,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      controller: tocsrController,
                      focusNode: _tocsrFocusNode,
                      validator: (val) => val == null || val.isEmpty ? "CashierId is required" : null,
                      decoration: const InputDecoration(
                        labelText: "CashierId",
                        hintText: "Cashier Id",
                        prefixIcon: Icon(Icons.point_of_sale),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.none,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Container(
                    height: 55,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      controller: urlController,
                      focusNode: _urlFocusNode,
                      validator: (val) => val == null || val.isEmpty ? "BaseUrl is required" : null,
                      decoration: const InputDecoration(
                        labelText: "BaseUrl",
                        hintText: "Base Url",
                        prefixIcon: Icon(Icons.link_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.none,
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
                    height: 55,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      controller: emailController,
                      focusNode: _emailFocusNode,
                      validator: (val) => val == null || val.isEmpty ? "Interfacing Email is required" : null,
                      decoration: const InputDecoration(
                        labelText: "Interfacing Email",
                        hintText: "Interfacing Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.none,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Container(
                    height: 55,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      controller: passwordController,
                      focusNode: _passwordFocusNode,
                      validator: (val) => val == null || val.isEmpty ? "Interfacing Password is required" : null,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Interfacing Password",
                        hintText: "Interfacing Password",
                        prefixIcon: Icon(Icons.password_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            (widget.showKeyboard)
                ? KeyboardWidget(
                    controller: activeController,
                    isNumericMode: false,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 30),
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
      ),
    );
  }
}
