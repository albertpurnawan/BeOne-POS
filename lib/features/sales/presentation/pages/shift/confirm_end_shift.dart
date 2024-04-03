import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmEndShift extends StatelessWidget {
  ConfirmEndShift({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final prefs = GetIt.instance<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Form(
            key: formKey,
            child: Column(
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
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
