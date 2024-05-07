import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmEndShift extends StatelessWidget {
  final CashierBalanceTransactionModel shift;
  final String totalCash;

  ConfirmEndShift(this.shift, this.totalCash, {Key? key})
      : super(
          key: key,
        );

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final prefs = GetIt.instance<SharedPreferences>();

  Future<bool> checkPassword(String password) async {
    final String? username = prefs.getString('username');
    double totalCashDouble =
        double.tryParse(totalCash.replaceAll(',', '')) ?? 0.0;
    String hashedPassword = md5.convert(utf8.encode(password)).toString();

    if (username != null) {
      final UserModel? user = await GetIt.instance<AppDatabase>()
          .userDao
          .readByUsername(username, null);

      if (user != null && user.password == hashedPassword) {
        CashierBalanceTransactionModel closeShift =
            CashierBalanceTransactionModel(
          docId: shift.docId,
          createDate: shift.createDate,
          updateDate: DateTime.now(),
          tocsrId: shift.tocsrId,
          tousrId: shift.tousrId,
          docNum: shift.docNum,
          openDate: shift.openDate,
          openTime: shift.openTime,
          calcDate: shift.calcDate,
          calcTime: shift.calcTime,
          closeDate: DateTime.now(),
          closeTime: DateTime.now(),
          timezone: shift.timezone,
          openValue: shift.openValue,
          calcValue: shift.calcValue,
          cashValue: shift.cashValue,
          closeValue: totalCashDouble,
          openedbyId: shift.openedbyId,
          closedbyId: user.docId,
          approvalStatus: 1,
        );

        _updateCashierBalanceTransaction(shift.docId, closeShift);

        return true;
      }
    }
    return false;
  }

  void _updateCashierBalanceTransaction(
      String docId, CashierBalanceTransactionModel value) async {
    await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .update(docId: docId, data: value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'End Shift Confirmation',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      contentPadding: EdgeInsets.all(0),
      content: Center(
        child: Container(
            color: Color.fromARGB(255, 234, 234, 234),
            width: MediaQuery.of(context).size.width * 0.5,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: CustomInput(
                      label: "Password",
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
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: CustomButton(
                      child: const Text("End Shift"),
                      onTap: () async {
                        if (!formKey.currentState!.validate()) return;
                        bool passwordCorrect =
                            await checkPassword(passwordController.text);

                        if (passwordCorrect) {
                          await prefs.setBool('isOpen', false);
                          await prefs.setString('tcsr1Id', "");

                          GetIt.instance<LogoutUseCase>().call();

                          if (!context.mounted) return;
                          context.goNamed(RouteConstants.welcome);
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
                        )),
                      )),
                ],
              ),
            )),
      ),
    );
  }
}
