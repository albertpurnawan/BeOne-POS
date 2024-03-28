import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/clickable_text.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/login/presentation/pages/login.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/sales.dart';
import 'package:pos_fe/features/settings/presentation/pages/default_printer_settings.dart';
import 'package:pos_fe/features/settings/presentation/pages/printer_settings.dart';
import 'package:pos_fe/features/settings/presentation/settings.dart';
import 'package:pos_fe/features/syncdata/presentation/test_fetch_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/thermal_printer.dart';

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
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        bool isLoggedIn = prefs.getBool('logStatus') ?? false;
                        print("WELCOME $isLoggedIn");
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
                  SizedBox(height: 10),
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
  @override
  void initState() {
    super.initState();
  }

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
