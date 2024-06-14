import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/otp_input_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInputDiscountDialog extends StatefulWidget {
  final double discountValue;
  const AuthInputDiscountDialog({Key? key, required this.discountValue})
      : super(key: key);

  @override
  State<AuthInputDiscountDialog> createState() =>
      _AuthInputDiscountDialogState();
}

class _AuthInputDiscountDialogState extends State<AuthInputDiscountDialog> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final prefs = GetIt.instance<SharedPreferences>();
  final _usernameFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  bool _obscureText = true;
  bool _isOTPClicked = false;
  bool _isSendingOTP = false;

  Future<String> checkPassword(String username, String password) async {
    String hashedPassword = md5.convert(utf8.encode(password)).toString();
    String check = "";

    final UserModel? user = await GetIt.instance<AppDatabase>()
        .userDao
        .readByUsername(username, null);

    if (user != null) {
      final tastr = await GetIt.instance<AppDatabase>()
          .authStoreDao
          .readByTousrId(user.docId, null);

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

  Future<void> onSubmit(
      BuildContext childContext, BuildContext parentContext) async {
    if (!formKey.currentState!.validate()) return;
    String passwordCorrect =
        await checkPassword(usernameController.text, passwordController.text);
    if (passwordCorrect == "Success") {
      childContext
          .read<ReceiptCubit>()
          .updateTotalAmountFromDiscount(widget.discountValue);
      Navigator.of(childContext).pop(); // Close the dialog
      Navigator.of(childContext).pop(); // Close the select method if needed
      Navigator.of(childContext).pop(); // Close the input discount if needed
      SnackBarHelper.presentSuccessSnackBar(parentContext,
          "Header discount applied: ${Helpers.parseMoney(widget.discountValue)}");
    } else {
      final message = passwordCorrect == "Wrong Password"
          ? "Invalid username or password"
          : "Unauthorized";
      SnackBarHelper.presentErrorSnackBar(childContext, message);
      if (Platform.isWindows) _usernameFocusNode.requestFocus();
    }
  }

  Future<void> sendOTP() async {
    await Future.delayed(const Duration(seconds: 3));
    log("OTP SENDED");
  }

  @override
  void dispose() {
    _keyboardListenerFocusNode.dispose();
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
              }

              return KeyEventResult.ignored;
            },
            child: AlertDialog(
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
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                child: const Text(
                  'Header Discount Authorization',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.all(0),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(childContext).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 40),
                    child: Form(
                      key: formKey,
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
                              onFieldSubmitted: (value) async =>
                                  await onSubmit(childContext, parentContext),
                              validator: (val) => val == null || val.isEmpty
                                  ? "Username is required"
                                  : null,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20),
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
                              validator: (val) => val == null || val.isEmpty
                                  ? "Password is required"
                                  : null,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                hintText: "Password",
                                hintStyle: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 20),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
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
                          Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Use OTP Instead',
                                      style: TextStyle(
                                        color: _isOTPClicked
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          setState(() {
                                            _isOTPClicked = true;
                                            _isSendingOTP = true;
                                          });

                                          await sendOTP();

                                          setState(() {
                                            _isOTPClicked = false;
                                            _isSendingOTP = false;
                                          });

                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                OTPInputDialog(),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              if (_isSendingOTP) ...[
                                const SizedBox(height: 15),
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ],
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: const BorderSide(
                                                  color:
                                                      ProjectColors.primary))),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white),
                                      overlayColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => ProjectColors.primary
                                                  .withOpacity(.2))),
                                  onPressed: () {
                                    Navigator.of(childContext).pop();
                                  },
                                  child: Center(
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Cancel",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: "  (Esc)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                        style: TextStyle(
                                            color: ProjectColors.primary),
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                )),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: const BorderSide(
                                                  color:
                                                      ProjectColors.primary))),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) =>
                                                  ProjectColors.primary),
                                      overlayColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white
                                                  .withOpacity(.2))),
                                  onPressed: () async => await onSubmit(
                                      childContext, parentContext),
                                  child: Center(
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Confirm",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: "  (Enter)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                )),
                              ],
                            ),
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
}
