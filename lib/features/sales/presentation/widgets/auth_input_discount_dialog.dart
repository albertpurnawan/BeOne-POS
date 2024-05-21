import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/auth_store_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInputDiscountDialog extends StatelessWidget {
  final double discountValue;
  AuthInputDiscountDialog({super.key, required this.discountValue});

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final prefs = GetIt.instance<SharedPreferences>();

  Future<bool> checkPassword(String user, String password) async {
    final String username = user;
    String hashedPassword = md5.convert(utf8.encode(password)).toString();

    await GetIt.instance<AuthStoreApi>().authUser(username, hashedPassword);

    if (username != null) {
      final UserModel? user = await GetIt.instance<AppDatabase>()
          .userDao
          .readByUsername(username, null);

      if (user != null && user.password == hashedPassword) {
        return true;
      }
    }
    return false;
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
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
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
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: CustomInput(
                      obscureText: true,
                      hint: "Username",
                      controller: usernameController,
                      prefixIcon: const Icon(Icons.person_3),
                      validator: (val) => val == null || val.isEmpty
                          ? "Username is required"
                          : null,
                      type: CustomInputType.text,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: CustomInput(
                      obscureText: true,
                      hint: "Password",
                      controller: passwordController,
                      prefixIcon: const Icon(Icons.lock),
                      validator: (val) => val == null || val.isEmpty
                          ? "Password is required"
                          : null,
                      type: CustomInputType.password,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: CustomButton(
                      child: const Text("Confirm"),
                      onTap: () async {
                        if (!formKey.currentState!.validate()) return;
                        bool passwordCorrect = await checkPassword(
                            usernameController.text, passwordController.text);

                        if (passwordCorrect) {
                          // update discount here
                          context
                              .read<ReceiptCubit>()
                              .updateTotalAmountFromDiscount(discountValue);
                          context.goNamed(RouteConstants.sales);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Invalid Password'),
                              content:
                                  Text('Please enter the correct password.'),
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
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
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
                                (states) => Colors.black.withOpacity(.2))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: ProjectColors.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        )),
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
