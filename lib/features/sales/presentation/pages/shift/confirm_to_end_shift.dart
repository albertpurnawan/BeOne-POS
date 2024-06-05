import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/close_shift.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmToEndShift extends StatelessWidget {
  final CashierBalanceTransactionModel shift;

  ConfirmToEndShift(this.shift, {Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final prefs = GetIt.instance<SharedPreferences>();

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
    final obscureTextNotifier = ValueNotifier<bool>(true);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
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
            'End Shift Confirmation',
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
                      child: ValueListenableBuilder<bool>(
                        valueListenable: obscureTextNotifier,
                        builder: (context, obscureText, child) {
                          return TextFormField(
                            controller: passwordController,
                            obscureText: obscureText,
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
                                  obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                ),
                                onPressed: () {
                                  obscureTextNotifier.value =
                                      !obscureTextNotifier.value;
                                },
                              ),
                            ),
                          );
                        },
                      ),
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
                              if (passwordCorrect == "Success") {
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CloseShiftScreen(shiftId: shift.docId),
                                  ),
                                );
                              } else {
                                final message =
                                    passwordCorrect == "Wrong Password"
                                        ? "Invalid Password"
                                        : "Unauthorized";
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: ProjectColors.primary,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.error,
                                          color: ProjectColors.mediumBlack,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          message,
                                          style: TextStyle(
                                            color: ProjectColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            color: ProjectColors.mediumBlack,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
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
      ),
    );
  }
}
