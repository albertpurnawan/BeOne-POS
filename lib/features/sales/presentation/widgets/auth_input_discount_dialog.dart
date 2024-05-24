import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInputDiscountDialog extends StatefulWidget {
  final double discountValue;
  const AuthInputDiscountDialog({Key? key, required this.discountValue})
      : super(key: key);

  @override
  _AuthInputDiscountDialogState createState() =>
      _AuthInputDiscountDialogState();
}

class _AuthInputDiscountDialogState extends State<AuthInputDiscountDialog> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final prefs = GetIt.instance<SharedPreferences>();
  bool _obscureText = true;

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
        if (user.password == hashedPassword) {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
        child: const Text(
          'Confirm Discount',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: usernameController,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      validator: (val) => val == null || val.isEmpty
                          ? "Username is required"
                          : null,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Username",
                          hintStyle: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 20),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.person_4,
                            size: 20,
                          )),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      validator: (val) => val == null || val.isEmpty
                          ? "Password is required"
                          : null,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: ProjectColors.primary))),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      ProjectColors.primary.withOpacity(.2))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Center(
                              child: Text(
                            "Cancel",
                            style: TextStyle(color: ProjectColors.primary),
                          )),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: ProjectColors.primary))),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;
                            String passwordCorrect = await checkPassword(
                                usernameController.text,
                                passwordController.text);
                            String warning = '';
                            if (passwordCorrect == "Success") {
                              context
                                  .read<ReceiptCubit>()
                                  .updateTotalAmountFromDiscount(
                                      widget.discountValue);
                              context.pop();
                              context.pop();
                            } else if (passwordCorrect == "Wrong Password") {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Invalid Password'),
                                  content: Text(
                                      'Please enter the correct password.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Unauthorized'),
                                  content: Text('You\'re not authorized.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Center(
                              child: Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          )),
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
    );
  }
}
