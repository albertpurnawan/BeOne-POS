import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/refresh_database_usecase.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/otp_service.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/widgets/otp_submit_reset_db_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetDBApprovalDialog extends StatefulWidget {
  const ResetDBApprovalDialog({super.key});

  @override
  State<ResetDBApprovalDialog> createState() => _ResetDBApprovalDialogState();
}

class _ResetDBApprovalDialogState extends State<ResetDBApprovalDialog> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final prefs = GetIt.instance<SharedPreferences>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  bool _isOTPClicked = false;
  bool _isSendingOTP = false;

  @override
  void initState() {
    super.initState();
  }

  Future<String> checkPassword(String username, String password) async {
    String hashedPassword = md5.convert(utf8.encode(password)).toString();
    String check = "";
    String category = "resetlocaldb";

    final UserModel? user = await GetIt.instance<AppDatabase>().userDao.readByUsername(username, null);

    if (user != null) {
      final tastr = await GetIt.instance<AppDatabase>().authStoreDao.readByTousrId(user.docId, category, null);

      if (tastr != null && tastr.tousrdocid == user.docId) {
        if (tastr.statusActive != 1) {
          check = "Unauthorized";
        } else if (user.password == hashedPassword) {
          check = "Success";
        } else {
          check = "Wrong Password";
        }
      } else {
        check = "Unauthorized";
      }
    } else {
      check = "Unauthorized";
    }
    return check;
  }

  Future<void> onSubmit(BuildContext childContext, BuildContext parentContext) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    String passwordCorrect = await checkPassword(usernameController.text, passwordController.text);
    if (passwordCorrect == "Success") {
      if (!context.mounted) return;
      await GetIt.instance<RefreshDatabaseUseCase>().call(params: RefreshDatabaseParams(context: childContext));
      // exit(0);
    } else {
      final message = passwordCorrect == "Wrong Password" ? "Invalid username or password" : "Unauthorized";
      SnackBarHelper.presentErrorSnackBar(childContext, message);
      if (Platform.isWindows) _usernameFocusNode.requestFocus();
    }
  }

  Future<void> handleOTP(BuildContext childContext) async {
    try {
      setState(() {
        _isOTPClicked = true;
        _isSendingOTP = true;
      });

      await createOTP().then((value) async {
        setState(() {
          _isOTPClicked = false;
          _isSendingOTP = false;
        });

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => OTPResetDBDialog(
            requester: value,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isOTPClicked = false;
        _isSendingOTP = false;
      });
      SnackBarHelper.presentFailSnackBar(childContext, e.toString());
    }
  }

  Future<String> createOTP() async {
    try {
      final POSParameterEntity? topos = await GetIt.instance<GetPosParameterUseCase>().call();
      if (topos == null) throw "Failed to retrieve POS Parameter";

      final StoreMasterEntity? store = await GetIt.instance<GetStoreMasterUseCase>().call(params: topos.tostrId);
      if (store == null) throw "Failed to retrieve Store Master";

      final cashierMachine = await GetIt.instance<AppDatabase>().cashRegisterDao.readByDocId(topos.tocsrId!, null);
      if (cashierMachine == null) throw "Failed to retrieve Cash Register";

      final String body = '''
    Approval For: Reset Database,
    Store Name: ${store.storeName},
    Cash Register Id: ${(cashierMachine.description == "") ? cashierMachine.idKassa! : cashierMachine.description},
''';

      final String subject = "OTP RUBY POS Reset Database - [${store.storeCode}]";

      final response = await GetIt.instance<OTPServiceAPi>().createSendOTP(context, null, subject, body);
      log("RESPONSE OTP - $response");
      return response['Requester'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Focus(
            onKeyEvent: (node, value) {
              if (value.runtimeType == KeyUpEvent) {
                return KeyEventResult.handled;
              }

              if (value.physicalKey == PhysicalKeyboardKey.enter) {
                onSubmit(childContext, parentContext);
                return KeyEventResult.handled;
              } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
                parentContext.pop();
              } else if (value.physicalKey == PhysicalKeyboardKey.f11) {
                handleOTP(childContext);
                return KeyEventResult.handled;
              }

              return KeyEventResult.ignored;
            },
            child: AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Container(
                decoration: const BoxDecoration(
                  color: ProjectColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                ),
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                child: const Text(
                  'Reset Database Confirmation',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.all(0),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(childContext).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(childContext).size.width * 0.5,
                            child: TextFormField(
                              focusNode: _usernameFocusNode,
                              controller: usernameController,
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (value) async => await onSubmit(childContext, parentContext),
                              validator: (val) => val == null || val.isEmpty ? "Username is required" : null,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Username",
                                  hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.person_4,
                                    size: 20,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: MediaQuery.of(childContext).size.width * 0.5,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (value) async {
                                await onSubmit(childContext, parentContext);
                              },
                              validator: (val) => val == null || val.isEmpty ? "Password is required" : null,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                hintText: "Password",
                                hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Use OTP Instead',
                                      style: TextStyle(
                                        color: _isOTPClicked ? Colors.grey : ProjectColors.lightBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          FocusScope.of(childContext).unfocus();
                                          await handleOTP(childContext);
                                        },
                                    ),
                                    TextSpan(
                                      text: " (F11)",
                                      style: TextStyle(
                                          color: _isOTPClicked ? Colors.grey : ProjectColors.lightBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              if (_isSendingOTP)
                                const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _warningtext(),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(color: ProjectColors.primary))),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                    overlayColor: MaterialStateColor.resolveWith(
                                        (states) => ProjectColors.primary.withOpacity(.2))),
                                onPressed: () {
                                  Navigator.of(childContext).pop();
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
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(color: ProjectColors.primary))),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                    overlayColor:
                                        MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                onPressed: () async => await onSubmit(childContext, parentContext),
                                child: Center(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Confirm",
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: "  (Enter)",
                                          style: TextStyle(fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _warningtext() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        border: Border.all(
          color: Colors.yellow.shade700,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            color: Colors.yellow.shade700,
            size: 42.0,
          ),
          const SizedBox(width: 10.0),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Refreshing the database might take some time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Please wait until the process is finished.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
