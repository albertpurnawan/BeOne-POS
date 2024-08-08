import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/usecases/backup_database_usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/settings/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/settings/presentation/pages/default_printer_settings.dart';
import 'package:pos_fe/features/settings/presentation/pages/paper_size_settings.dart';
import 'package:pos_fe/features/settings/presentation/pages/test_fetch_page.dart';
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
    super.initState();
    getPosParameter();
  }

  void getPosParameter() async {
    _posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
    setState(() {});
  }

  @override
  void dispose() {
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
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Scrollbar(
              controller: _scrollController,
              thickness: 4,
              radius: const Radius.circular(30),
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const Row(
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
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () => {},
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.account_circle_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                                          GetIt.instance<SharedPreferences>().getString("username") ?? "Not Found",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromARGB(255, 66, 66, 66),
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
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () => {},
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.email_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                                          GetIt.instance<SharedPreferences>().getString("email") ?? "Not Found",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
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
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
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
                      const SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Database",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: Color.fromARGB(255, 66, 66, 66), fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const FetchScreen(
                                            outside: false,
                                          )));
                            },
                            child: const Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.sync,
                                          color: Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Sync Data",
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
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () async {
                              await BackupDatabaseUseCase().call(params: BackupDatabaseParams(context: context));
                            },
                            child: const Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.backup_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          "Backup Data",
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
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                          const Divider(
                            height: 0,
                          ),
                          // InkWell(
                          //   onTap: () async {
                          //     Navigator.push(context, MaterialPageRoute(builder: (context) => const ArchiveScreen()));
                          //   },
                          //   child: const Column(
                          //     children: [
                          //       SizedBox(
                          //         height: 20,
                          //       ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Row(
                          //             children: [
                          //               SizedBox(
                          //                 width: 5,
                          //               ),
                          //               Icon(
                          //                 Icons.archive_outlined,
                          //                 color: Color.fromARGB(255, 66, 66, 66),
                          //               ),
                          //               SizedBox(
                          //                 width: 30,
                          //               ),
                          //               Text(
                          //                 "Archive",
                          //                 style: TextStyle(fontSize: 16),
                          //               ),
                          //             ],
                          //           ),
                          //           Row(
                          //             children: [
                          //               SizedBox(
                          //                 width: 15,
                          //               ),
                          //               Icon(
                          //                 Icons.navigate_next,
                          //                 color: Color.fromARGB(255, 66, 66, 66),
                          //               ),
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
                          // const Divider(
                          //   height: 0,
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Config",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: Color.fromARGB(255, 66, 66, 66), fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.business_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                                          "${_posParameterEntity?.gtentId}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(Icons.navigate_next),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.store_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                                          _posParameterEntity?.tostrId ?? "Not Set",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(Icons.navigate_next),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.point_of_sale_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                                          _posParameterEntity?.tocsrId ?? "Not Set",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(Icons.navigate_next),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.link,
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                                          _posParameterEntity?.baseUrl ?? "Not Set",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 15,
                                        // ),
                                        // Icon(Icons.navigate_next),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Printer",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: Color.fromARGB(255, 66, 66, 66), fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () => Helpers.navigate(context, const DefaultPrinterSettings())
                                .then((value) => setState(() {})),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.print_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                                          GetIt.instance<SharedPreferences>().getStringList("defaultPrinter")?[0] ??
                                              "Not Set",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Icon(
                                          Icons.navigate_next,
                                          color: Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () =>
                                Helpers.navigate(context, const PaperSizeSettings()).then((value) => setState(() {})),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.receipt_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
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
                                          GetIt.instance<SharedPreferences>().getString("paperSize") ?? "Not Set",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(255, 66, 66, 66),
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Icon(
                                          Icons.navigate_next,
                                          color: Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 35,
                      // ),
                      // Column(
                      //   children: [
                      //     const Row(
                      //       children: [
                      //         Text(
                      //           "Cache",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w700, color: Color.fromARGB(255, 66, 66, 66), fontSize: 16),
                      //         ),
                      //       ],
                      //     ),
                      //     const SizedBox(
                      //       height: 15,
                      //     ),
                      //     const Divider(
                      //       height: 0,
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         GetIt.instance<SharedPreferences>().clear();
                      //         context.goNamed(RouteConstants.welcome);
                      //       },
                      //       child: const Column(
                      //         children: [
                      //           SizedBox(
                      //             height: 20,
                      //           ),
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Row(
                      //                 children: [
                      //                   SizedBox(
                      //                     width: 5,
                      //                   ),
                      //                   Icon(
                      //                     Icons.delete_outline,
                      //                     color: Color.fromARGB(255, 66, 66, 66),
                      //                   ),
                      //                   SizedBox(
                      //                     width: 30,
                      //                   ),
                      //                   Text(
                      //                     "Clear Cache",
                      //                     style: TextStyle(fontSize: 16),
                      //                   ),
                      //                 ],
                      //               ),
                      //               Row(
                      //                 children: [
                      //                   SizedBox(
                      //                     width: 15,
                      //                   ),
                      //                   Icon(
                      //                     Icons.navigate_next,
                      //                     color: Color.fromARGB(255, 66, 66, 66),
                      //                   ),
                      //                   SizedBox(
                      //                     width: 5,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: 20,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     const Divider(
                      //       height: 0,
                      //     ),
                      //   ],
                      // ),
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
