import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.primary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: ProjectColors.primary,
      body: Row(
        children: [
          Expanded(
              child: Image.asset(
            'assets/images/supermarket-illustration.png',
            height: double.infinity,
            fit: BoxFit.cover,
          )),
          Expanded(
              child: Container(
            color: Color.fromRGBO(128, 0, 0, 1),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.36,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Good Afternoon ",
                                ),
                                TextSpan(
                                    text: GetIt.instance<SharedPreferences>()
                                        .getString("username"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text: " ☀️",
                                )
                              ],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Have a Great Day!",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStatePropertyAll(2),
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () =>
                              context.pushNamed(RouteConstants.sales),
                          child: const Text(
                            "Sales",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () =>
                              context.pushNamed(RouteConstants.shifts),
                          child: const Text(
                            "Shifts",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () {},
                          child: const Text(
                            "Reports",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () {
                            context
                                .pushNamed(RouteConstants.settings)
                                .then((value) {
                              if (!Platform.isWindows) {
                                Future.delayed(Durations.short1, () {
                                  SystemChrome.setSystemUIOverlayStyle(
                                      const SystemUiOverlayStyle(
                                          statusBarColor:
                                              Color.fromARGB(255, 134, 1, 1),
                                          statusBarBrightness: Brightness.light,
                                          statusBarIconBrightness:
                                              Brightness.light));
                                });
                              }
                            });
                          },
                          child: const Text(
                            "Settings",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () {
                            context.goNamed(RouteConstants.welcome);
                            GetIt.instance<LogoutUseCase>().call();
                          },
                          child: const Text(
                            "Logout",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      // SizedBox.expand(),
                    ],
                  ),
                  Expanded(
                    // height: double.infinity,

                    // width: double.infinity,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          alignment: Alignment.centerRight,
                          height: 50,
                          width: 130,
                          padding: const EdgeInsets.fromLTRB(10, 16, 0, 15),
                          decoration: const BoxDecoration(
                            color: const Color.fromARGB(255, 85, 0, 0),
                            borderRadius: BorderRadius.only(
                              // topLeft: Radius.circular(5),
                              topLeft: Radius.circular(60),
                            ),
                          ),
                          child: SvgPicture.asset(
                            "assets/logo/white_only_pos.svg",
                            // alignment: Alignment.centerLeft,
                          )),
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
