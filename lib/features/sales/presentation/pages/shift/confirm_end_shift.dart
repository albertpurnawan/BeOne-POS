import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/shift_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmEndShift extends StatelessWidget {
  ConfirmEndShift({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final prefs = GetIt.instance<SharedPreferences>();

  void checkPassword(String password) async {
    final String? username = prefs.getString('username');

    if (username != null) {
      final List<UserModel> users =
          await GetIt.instance<AppDatabase>().userDao.readAll();

      //  final UserModel? currentUser = users.firstWhereOrNull((user) => user.username == username);
    }
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
                      hint: "Password",
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

                        await prefs.setBool('isOpen', false);
                        await prefs.setString('tcsr1Id', "");

                        if (!context.mounted) return;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShiftsList()));
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
