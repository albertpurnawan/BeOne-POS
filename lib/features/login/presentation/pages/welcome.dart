import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/clickable_text.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/settings/presentation/settings.dart';
import 'package:pos_fe/features/syncdata/presentation/test_fetch_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
  bool haveTopos = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkShiftStatus();
  // }

  Future<void> checkTopos() async {
    final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
  }

  final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  Widget welcomingButtons(BuildContext context) {
    // final api = Api.of(context);
    bool isLoggedIn = prefs.getBool('logStatus') ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BeOneLogo(size: 90),
                  const SizedBox(height: 50),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: const Text("Login"),
                      onTap: () async {
                        if (isLoggedIn == false) {
                          context.pushNamed(RouteConstants.login);
                          // } else if (isLoggedIn && isOpen == false) {
                          //   Helpers.navigate(context, LoginScreen());
                          // if (!context.mounted) return;
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       shape: const RoundedRectangleBorder(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(10.0)),
                          //       ),
                          //       content: SizedBox(
                          //         width:
                          //             MediaQuery.of(context).size.width * 0.7,
                          //         child: const OpenShiftScreen(),
                          //       ),
                          //     );
                          //   },
                          // );
                        } else {
                          context.pushNamed(RouteConstants.home);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Container(
                  //   constraints: BoxConstraints(maxWidth: 400),
                  //   child: CustomButton(
                  //       onTap: () {
                  //         Helpers.navigate(context, HomeScreen());
                  //       },
                  //       child: Text("Register"),
                  //       style: CustomButtonStyle.bordered),
                  // ),
                  // const SizedBox(height: 15),
                  // ClickableText(
                  //   "Forgot Password ● Help Center",
                  //   // onTap: () =>
                  //   //     Helpers.navigate(context, ForgotPasswordScreen()),
                  // ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: const Text("Sync BOS"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FetchScreen()),
                        ).then((value) => Future.delayed(
                            const Duration(milliseconds: 200),
                            () => SystemChrome.setSystemUIOverlayStyle(
                                const SystemUiOverlayStyle(
                                    statusBarColor: ProjectColors.primary,
                                    statusBarBrightness: Brightness.light,
                                    statusBarIconBrightness:
                                        Brightness.light))));
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      child: const Text("Setup Device"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()),
                        ).then((value) => Future.delayed(
                            const Duration(milliseconds: 200),
                            () => SystemChrome.setSystemUIOverlayStyle(
                                const SystemUiOverlayStyle(
                                    statusBarColor: ProjectColors.primary,
                                    statusBarBrightness: Brightness.light,
                                    statusBarIconBrightness:
                                        Brightness.light))));
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Container(
                  //   constraints: const BoxConstraints(maxWidth: 400),
                  //   child: CustomButton(
                  //     child: const Text("ByPass DevPurpose"),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const HomeScreen()),
                  //       ).then((value) => Future.delayed(
                  //           const Duration(milliseconds: 200),
                  //           () => SystemChrome.setSystemUIOverlayStyle(
                  //               const SystemUiOverlayStyle(
                  //                   statusBarColor: ProjectColors.primary,
                  //                   statusBarBrightness: Brightness.light,
                  //                   statusBarIconBrightness:
                  //                       Brightness.light))));
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // const LanguageSwitchButton(color: ProjectColors.primary),
          // const SizedBox(height: 5),
          // const Padding(
          //   padding: EdgeInsets.only(bottom: 30),
          //   child: Text(
          //       "Copyright © 2020 Beone Optima Solusi\nAll right reserved",
          //       textAlign: TextAlign.center,
          //       style:
          //           TextStyle(color: ProjectColors.lightBlack, fontSize: 12)),
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.primary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 234, 234, 234),
        child: welcomingButtons(context),
      ),
    );
  }
}
