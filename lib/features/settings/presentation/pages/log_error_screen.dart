import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/models/log_error.dart';

class LogErrorScreen extends StatefulWidget {
  const LogErrorScreen({super.key});

  @override
  State<LogErrorScreen> createState() => _LogErrorScreenState();
}

class _LogErrorScreenState extends State<LogErrorScreen> {
  List<LogErrorModel> logErr = [];
  bool isLoading = true;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    fetchLogErrors();
  }

  Future<void> fetchLogErrors() async {
    try {
      logErr = await GetIt.instance<AppDatabase>().logErrorDao.readAll();
      logErr.sort((a, b) => b.createDate.compareTo(a.createDate));
    } catch (e) {
      log("Error fetching log errors: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> clearLogErrors() async {
    try {
      await GetIt.instance<AppDatabase>().logErrorDao.clearDb();
      setState(() {
        logErr = [];
      });
    } catch (e) {
      log("Error clearing log errors: $e");
    }
  }

  Future<void> _showFullDescriptionDialog(String description) async {
    try {
      await showDialog(
          context: context, barrierDismissible: false, builder: (context) => _buildFullDescriptionDialog(description));
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Error Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await clearLogErrors();
            },
            tooltip: 'Clear Logs',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Row(
                    // decoration: BoxDecoration(
                    //   color: ProjectColors.primary.withOpacity(0.1),
                    // ),
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Date',
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ProjectColors.mediumBlack),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Error Type',
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ProjectColors.mediumBlack),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Description',
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ProjectColors.mediumBlack),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: logErr.length,
                        itemBuilder: (context, index) {
                          final log = logErr[index];
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(Helpers.formatDate(log.createDate)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(log.processInfo),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: Text(Helpers.clipStringAndAddEllipsis(log.description, 200))),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () async => await _showFullDescriptionDialog(log.description),
                                            child: const Icon(
                                              Icons.remove_red_eye,
                                              color: ProjectColors.mediumBlack,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                              onTap: () async {
                                                await Clipboard.setData(ClipboardData(text: log.description));
                                                SnackBarHelper.presentSuccessSnackBar(
                                                    context, "Copied to clipboard", 3);
                                              },
                                              child: const Icon(Icons.copy, color: ProjectColors.mediumBlack)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: ProjectColors.lightBlack,
                                thickness: 0.2,
                              )
                            ],
                          );
                        }),
                  ),
                  // Table(
                  //   columnWidths: const {
                  //     0: FlexColumnWidth(2),
                  //     1: FlexColumnWidth(2),
                  //     2: FlexColumnWidth(6),
                  //   },
                  //   border: TableBorder.all(
                  //     color: ProjectColors.primary,
                  //     width: 1,
                  //   ),
                  //   children: [
                  //     TableRow(
                  //       decoration: BoxDecoration(
                  //         color: ProjectColors.primary.withOpacity(0.1),
                  //       ),
                  //       children: const [
                  //         Padding(
                  //           padding: EdgeInsets.all(8.0),
                  //           child: Text(
                  //             'Date',
                  //             style: TextStyle(fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.all(8.0),
                  //           child: Text(
                  //             'Error Type',
                  //             style: TextStyle(fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.all(8.0),
                  //           child: Text(
                  //             'Description',
                  //             style: TextStyle(fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     for (var log in logErr)
                  //       TableRow(
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Text(Helpers.formatDate(log.createDate)),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Text(log.processInfo),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Expanded(child: Text(Helpers.clipStringAndAddEllipsis(log.description, 200))),
                  //                 const SizedBox(
                  //                   width: 5,
                  //                 ),
                  //                 InkWell(
                  //                   onTap: () async => await _showFullDescriptionDialog(log.description),
                  //                   child: const Icon(
                  //                     Icons.remove_red_eye,
                  //                     color: ProjectColors.mediumBlack,
                  //                   ),
                  //                 ),
                  //                 const SizedBox(
                  //                   width: 10,
                  //                 ),
                  //                 InkWell(
                  //                     onTap: () async {
                  //                       await Clipboard.setData(ClipboardData(text: log.description));
                  //                       SnackBarHelper.presentSuccessSnackBar(context, "Copied to clipboard", 3);
                  //                     },
                  //                     child: const Icon(Icons.copy, color: ProjectColors.mediumBlack)),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //   ],
                  // ),
                ],
              ),
            ),
    );
  }

  Widget _buildFullDescriptionDialog(String description) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: FocusScope(
            autofocus: true,
            skipTraversal: true,
            node: _focusScopeNode,
            onKeyEvent: (node, event) {
              if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;
              if (event.physicalKey == PhysicalKeyboardKey.f12) {
                context.pop();
                return KeyEventResult.handled;
              } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
                context.pop();
                return KeyEventResult.handled;
              }

              return KeyEventResult.ignored;
            },
            child: AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Container(
                decoration: const BoxDecoration(
                  color: ProjectColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                ),
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Row(
                  children: [
                    const Text(
                      'Error Description',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: description));
                          SnackBarHelper.presentSuccessSnackBar(childContext, "Copied to clipboard", 3);
                        },
                        child: const Icon(Icons.copy, color: Colors.white)),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.white,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(color: ProjectColors.background, borderRadius: BorderRadius.circular(5)),
                            child: SelectableText(description)),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: ProjectColors.primary),
                          )),
                          backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                      onPressed: () => context.pop(),
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Done",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: "  (F12)",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    )),
                  ],
                ),
              ],
              actionsPadding: const EdgeInsets.all(10),
            ),
          ),
        );
      }),
    );
  }
}
