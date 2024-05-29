import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/settings/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/settings/presentation/pages/default_printer_settings.dart';
import 'package:pos_fe/features/settings/presentation/pages/paper_size_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  POSParameterEntity? _posParameterEntity;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosParameter();
  }

  void getPosParameter() async {
    _posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isWindows) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: ProjectColors.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light));
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Scrollbar(
              controller: _scrollController,
              thickness: 4,
              radius: Radius.circular(30),
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 30),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Account",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 66, 66, 66),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () => {},
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.account_circle_outlined,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Username",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          GetIt.instance<SharedPreferences>()
                                                  .getString("username") ??
                                              "Not Found",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Color.fromARGB(255, 66, 66, 66),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(
                                        //   Icons.navigate_next,
                                        //   color:
                                        //       Color.fromARGB(255, 66, 66, 66),
                                        // ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () => {},
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.email_outlined,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "E-mail",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          GetIt.instance<SharedPreferences>()
                                                  .getString("email") ??
                                              "Not Found",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(
                                        //   Icons.navigate_next,
                                        //   color:
                                        //       Color.fromARGB(255, 66, 66, 66),
                                        // ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          // InkWell(
                          //   onTap: () => {},
                          //   child: Column(
                          //     children: [
                          //       SizedBox(
                          //         height: 20,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Row(
                          //             children: [
                          //               SizedBox(
                          //                 width: 5,
                          //               ),
                          //               Icon(Icons
                          //                   .admin_panel_settings_outlined),
                          //               SizedBox(
                          //                 width: 30,
                          //               ),
                          //               Text(
                          //                 "Role",
                          //                 style: TextStyle(fontSize: 16),
                          //               ),
                          //             ],
                          //           ),
                          //           Row(
                          //             children: [
                          //               Text(
                          //                 "Staff",
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.w700,
                          //                     color: Color.fromARGB(
                          //                         255, 66, 66, 66),
                          //                     fontSize: 16),
                          //               ),
                          //               // SizedBox(
                          //               //   width: 15,
                          //               // ),
                          //               // Icon(
                          //               //   Icons.navigate_next,
                          //               //   color:
                          //               //       Color.fromARGB(255, 66, 66, 66),
                          //               // ),
                          //               SizedBox(
                          //                 width: 5,
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: 20,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Divider(
                          //   height: 0,
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Config",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 66, 66, 66),
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.business_outlined,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Tenant",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${_posParameterEntity?.gtentId}" ??
                                              "Not Set",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(Icons.navigate_next),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.store_outlined,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Store",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _posParameterEntity?.tostrId ??
                                              "Not Set",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(Icons.navigate_next),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.point_of_sale_outlined,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Cash Register",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _posParameterEntity?.tocsrId ??
                                              "Not Set",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(Icons.navigate_next),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.link,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Base URL",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _posParameterEntity?.baseUrl ??
                                              "Not Set",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(Icons.navigate_next),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Printer",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 66, 66, 66),
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () => Helpers.navigate(
                                    context, const DefaultPrinterSettings())
                                .then((value) => setState(() {})),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.print_outlined,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Default Printer",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          GetIt.instance<SharedPreferences>()
                                                  .getStringList(
                                                      "defaultPrinter")?[0] ??
                                              "Not Set",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () => Helpers.navigate(
                                    context, const PaperSizeSettings())
                                .then((value) => setState(() {})),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.receipt_outlined,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Paper Size",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          GetIt.instance<SharedPreferences>()
                                                  .getString("paperSize") ??
                                              "Not Set",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Cache",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 66, 66, 66),
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {
                              GetIt.instance<SharedPreferences>().clear();
                              context.goNamed(RouteConstants.welcome);
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.delete_outline,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Clear Cache",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
