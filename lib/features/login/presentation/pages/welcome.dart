import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/clickable_text.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/login/presentation/pages/login.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/sales.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/end_shift.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/recap_shifts.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/start_shift.dart';
import 'package:pos_fe/features/settings/presentation/pages/printer_settings.dart';
import 'package:pos_fe/features/settings/presentation/settings.dart';
import 'package:pos_fe/features/syncdata/presentation/test_fetch_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static Widget welcomingButtons(BuildContext context) {
    // final api = Api.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BeOneLogo(size: 150),
                  const SizedBox(height: 30),
                  Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: Text("Login"),
                      onTap: () async {
                        final prefs = GetIt.instance<SharedPreferences>();
                        bool isLoggedIn = prefs.getBool('logStatus') ?? false;
                        if (isLoggedIn == false) {
                          Helpers.navigate(context, LoginScreen());
                        } else {
                          Helpers.navigate(context, SalesPage());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                        onTap: () {},
                        child: Text("Register"),
                        style: CustomButtonStyle.bordered),
                  ),
                  const SizedBox(height: 15),
                  ClickableText(
                    "Forgot Password ● Help Center",
                    // onTap: () =>
                    //     Helpers.navigate(context, ForgotPasswordScreen()),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: Text("Sync BOS"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FetchScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: Text("Settings"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: Text("Shift Recap"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecapShifts()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: const Text("Start Shift"),
                      onTap: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final bool isOpen = prefs.getBool('isOpen') ?? false;

                        if (isOpen) {
                          if (!context.mounted) return;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                content: const Text(
                                  "Please end current shift first",
                                  style: TextStyle(color: Colors.red),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          if (!context.mounted) return;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.7, // 70% of screen width
                                  child: const StartShiftScreen(),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: CustomButton(
                          child: const Text("End Shift"),
                          onTap: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final bool isOpen =
                                prefs.getBool('isOpen') ?? false;

                            if (isOpen) {
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7, // 70% of screen width
                                      child: const EndShiftScreen(),
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    content: const Text(
                                      "Please start a new shift first",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          })),
                  SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: Text("Printer Settings"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrinterSettings()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const LanguageSwitchButton(color: ProjectColors.swatch),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
                "Copyright © 2020 Beone Optima Solusi\nAll right reserved",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: ProjectColors.lightBlack, fontSize: 12)),
          )
        ],
      ),
    );
  }

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class LanguageSwitchButton extends StatelessWidget {
  const LanguageSwitchButton({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    // final api = Api.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClickableText(
          "Bahasa Indonesia",
          textStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
          // onTap: () {
          //   api
          //     ..lang.changeLanguage("id")
          //     ..rootState.refresh();
          // },
        ),
        const SizedBox(width: 5),
        ClickableText(
          "English",
          textStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
          // onTap: () {
          //   api
          //     ..lang.changeLanguage("en")
          //     ..rootState.refresh();
          // },
        ),
      ],
    );
  }
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // bool isOpen = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkShiftStatus();
  // }

  // Future<void> _checkShiftStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     isOpen = prefs.getBool('isOpen') ?? false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.swatch,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));

    return Container(
      color: Colors.white,
      child: WelcomeScreen.welcomingButtons(context),
    );
  }
}
