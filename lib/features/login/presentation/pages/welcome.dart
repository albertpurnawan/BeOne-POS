import 'dart:developer';

import 'package:auto_updater/auto_updater.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/clickable_text.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/home/domain/usecases/get_app_version.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/settings/presentation/device_setup.dart';
import 'package:pos_fe/features/settings/presentation/pages/test_fetch_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:window_manager/window_manager.dart';

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

class _WelcomeScreenState extends State<WelcomeScreen> with UpdaterListener {
  bool isLoggedIn = false;
  final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  bool haveTopos = false;
  String appVersion = "";
  String buildNumber = "";
  bool secondDisplay = true;
  final String _feedURL =
      'https://raw.githubusercontent.com/albertpurnawan/BeOne-POS/refs/heads/feat/auto_updater/dist/appcast.xml?token=GHSAT0AAAAAAC4WUTV4TMKA4QBSYOBUZTUQZ3XVTPQ';
  // final String _feedURL = 'http://localhost:55056/appcast.xml';
  bool _isFeedURLSetted = false;
  bool isUpdateAvailable = false;

  @override
  void initState() {
    super.initState();
    autoUpdater.addListener(this);
    checkAppVersion();
    checkTopos();
    checkPermission();
    prefs.reload().then((value) {
      setState(() {
        isLoggedIn = prefs.getBool('logStatus') ?? false;
      });
    });
    _handleClickSetFeedURL().then((value) => {_handleClickCheckForUpdatesWithoutUI()});
    if (isUpdateAvailable) {
      Future.microtask(() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Update Available"),
                content: const Text("Please update your app"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Update"),
                  ),
                ],
              )));
    }
  }

  @override
  void dispose() {
    autoUpdater.removeListener(this);
    super.dispose();
  }

  Future<void> checkTopos() async {
    final topos = await GetIt.instance<GetPosParameterUseCase>().call();
    setState(() {
      (topos != null) ? haveTopos = true : haveTopos = false;
    });
    log("TOPOS CHECKED - $haveTopos");
  }

  Future<void> checkPermission() async {
    try {
      final permissionStatus = await Permission.manageExternalStorage.status;
      if (!permissionStatus.isGranted) {
        await PermissionHandler.requestStoragePermissions(context);
      }
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, "Error on check permission");
    }
  }

  Future<void> checkAppVersion() async {
    final appVersionUseCase = await GetIt.instance<GetAppVersionUseCase>().call();
    setState(() {
      appVersion = appVersionUseCase.version;
      buildNumber = appVersionUseCase.buildNumber;
    });
  }

  // Future<void> checkPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final keys = prefs.getKeys();

  //   final prefsMap = <String, dynamic>{};
  //   for (String key in keys) {
  //     prefsMap[key] = prefs.get(key);
  //   }

  //   log("prefsMap - $prefsMap");
  // }

  Future<void> _handleClickSetFeedURL() async {
    await autoUpdater.setFeedURL(_feedURL);
    _isFeedURLSetted = true;
  }

  Future<void> _handleClickCheckForUpdates() async {
    if (!_isFeedURLSetted) {
      BotToast.showText(text: 'Please call setFeedURL method first.');
      return;
    }
    await autoUpdater.checkForUpdates();
  }

  Future<void> _handleClickCheckForUpdatesWithoutUI() async {
    await autoUpdater.checkForUpdates(inBackground: true);
  }

  Future<void> _handleClickSetScheduledCheckInterval() async {
    await autoUpdater.setScheduledCheckInterval(3600);
  }

  @override
  void onUpdaterError(UpdaterError? error) {
    if (kDebugMode) {
      print('onUpdaterError: $error');
    }
  }

  @override
  void onUpdaterCheckingForUpdate(Appcast? appcast) {
    if (kDebugMode) {
      setState(() {
        isUpdateAvailable = true;
      });
      print('onUpdaterCheckingForUpdate: ${appcast?.toJson()}');
    }
  }

  @override
  void onUpdaterUpdateAvailable(AppcastItem? item) {
    if (kDebugMode) {
      print('onUpdaterUpdateAvailable: ${item?.toJson()}');
    }
  }

  @override
  void onUpdaterUpdateNotAvailable(UpdaterError? error) {
    if (kDebugMode) {
      print('onUpdaterUpdateNotAvailable: $error');
    }
  }

  @override
  void onUpdaterUpdateDownloaded(AppcastItem? item) {
    if (kDebugMode) {
      print('onUpdaterUpdateDownloaded: ${item?.toJson()}');
    }
  }

  @override
  void onUpdaterBeforeQuitForUpdate(AppcastItem? item) {
    if (kDebugMode) {
      print('onUpdaterBeforeQuitForUpdate: ${item?.toJson()}');
    }
    windowManager.setPreventClose(false);
  }

  Widget welcomingButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BeOneLogo(size: 300),
                  const SizedBox(height: 30),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CustomButton(
                      onTap: haveTopos
                          ? () async {
                              isLoggedIn = prefs.getBool('logStatus') ?? false;
                              if (isLoggedIn) {
                                context.pushNamed(RouteConstants.home);
                              } else {
                                context.pushNamed(RouteConstants.login);
                              }
                            }
                          : () {
                              SnackBarHelper.presentErrorSnackBar(context, "Please Setup the Device First");
                            },
                      child: const Text("Login"),
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
                      onTap: haveTopos
                          ? () async {
                              await checkTopos();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FetchScreen(
                                          outside: true,
                                        )),
                              ).then((value) => Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () => SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                                      statusBarColor: ProjectColors.primary,
                                      statusBarBrightness: Brightness.light,
                                      statusBarIconBrightness: Brightness.light))));
                            }
                          : () {
                              SnackBarHelper.presentErrorSnackBar(context, "Please Setup the Device First");
                            },
                      child: const Text("Sync Data"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: haveTopos
                        ? null
                        : CustomButton(
                            child: const Text("Setup Device"),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeviceSetupScreen(
                                    toposExist: haveTopos,
                                  ),
                                ),
                              );
                              if (result == true) {
                                await checkTopos();
                              }
                              await Future.delayed(
                                const Duration(milliseconds: 200),
                                () => SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                    statusBarColor: ProjectColors.primary,
                                    statusBarBrightness: Brightness.light,
                                    statusBarIconBrightness: Brightness.light,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Version  ",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(appVersion, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  // Container(
                  //   constraints: const BoxConstraints(maxWidth: 400),
                  //   child: CustomButton(
                  //     child: const Text("Check Prefs"),
                  //     onTap: () async {
                  //       await checkPrefs();
                  //     },
                  //   ),
                  // ),
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
          //       "Copyright 2020 Beone Optima Solusi\nAll right reserved",
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
