import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/clickable_text.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/login/presentation/pages/login.dart';

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
                        onTap: () =>
                            Helpers.navigate(context, const LoginScreen())),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                        // onTap: () =>
                        //     Helpers.navigate(context, const RegisterScreen()),
                        child: Text("Register"),
                        style: CustomButtonStyle.bordered),
                  ),
                  const SizedBox(height: 15),
                  ClickableText(
                    "Forgot Password ● Help Center",
                    // onTap: () =>
                    //     Helpers.navigate(context, ForgotPasswordScreen()),
                  )
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
