import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_cash_register.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_user.dart';

class OpenShiftSuccessAlertDialog extends StatefulWidget {
  const OpenShiftSuccessAlertDialog({super.key, required this.openedShift});

  final CashierBalanceTransactionModel? openedShift;

  @override
  State<OpenShiftSuccessAlertDialog> createState() => _OpenShiftSuccessAlertDialogState();
}

class _OpenShiftSuccessAlertDialogState extends State<OpenShiftSuccessAlertDialog> {
  CashRegisterEntity? cashRegisterEntity;
  StoreMasterEntity? storeMasterEntity;
  UserEntity? userEntity;

  Future<void> populateData() async {
    try {
      final CashRegisterEntity? cashRegisterEntityRes =
          await GetIt.instance<GetCashRegisterUseCase>().call(params: widget.openedShift!.tocsrId!);
      if (cashRegisterEntityRes == null) throw "Cash Register not found";
      // log(cashRegisterEntityRes.toString());
      final StoreMasterEntity? storeMasterEntityRes =
          await GetIt.instance<GetStoreMasterUseCase>().call(params: cashRegisterEntityRes.tostrId);
      if (storeMasterEntityRes == null) throw "Store Master not found";
      final UserEntity? userEntityRes =
          await GetIt.instance<GetUserUseCase>().call(params: widget.openedShift!.tousrId);
      if (userEntityRes == null) throw "User not found";

      setState(() {
        cashRegisterEntity = cashRegisterEntityRes;
        storeMasterEntity = storeMasterEntityRes;
        userEntity = userEntityRes;
      });
    } catch (e) {
      ErrorHandler.presentErrorSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    populateData();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'Open Shift',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            fontFamily: 'Roboto',
            useMaterial3: true,
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              // width: MediaQuery.of(context).size.width * 0.7,
              width: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    width: double.infinity,
                    color: const Color.fromARGB(255, 134, 1, 1),
                    // color: Color.fromARGB(255, 11, 111, 56),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 30, vertical: 2),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(60),
                          //     // color: Color.fromARGB(255, 89, 0, 0),
                          //     boxShadow: const [
                          //       BoxShadow(
                          //         spreadRadius: 0.5,
                          //         blurRadius: 5,
                          //         color: Color.fromRGBO(0, 0, 0, 0.097),
                          //       ),
                          //     ],
                          //     // color: ProjectColors.primary,
                          //     // color: Color.fromARGB(255, 31, 104, 36), // ijo
                          //     // color: Color.fromARGB(255, 40, 40, 40),
                          //     color: const Color.fromARGB(255, 47, 143, 8),
                          //   ),
                          //   child: const Text(
                          //     "Shift Opening Success",
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w700,
                          //       color: Colors.white,
                          //       // color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle_outline,
                              //   color: const Color.fromARGB(255, 47, 143, 8),
                              //   size: 42,
                              // ),
                              SvgPicture.asset(
                                "assets/images/icon-success.svg",
                                height: 42,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Open Shift Success",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  // color: const Color.fromARGB(255, 33, 33, 33),
                                  color: Colors.white,
                                  // color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      width: double.infinity,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Detail",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Divider()
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      width: double.infinity,
                      child: Table(columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(4),
                      }, children: [
                        TableRow(
                          children: [
                            const Text(
                              "Store Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              storeMasterEntity?.storeName ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Cash Register",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              cashRegisterEntity?.description ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Cashier",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              userEntity?.username ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Opened At",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.formatDate((widget.openedShift!.openDate)),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Opening Balance",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(widget.openedShift?.openValue ?? 0),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ])),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          )),

      // contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 20, vertical: 5),
      actions: <Widget>[
        Column(
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //         child: TextButton(
            //       style: ButtonStyle(
            //           shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(5),
            //             // side: const BorderSide(color: ProjectColors.primary),
            //           )),
            //           backgroundColor: MaterialStateColor.resolveWith(
            //             (states) => const Color.fromARGB(255, 56, 56, 56),
            //           ),
            //           overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
            //       onPressed: null,
            //       child: const Center(
            //           child: Text(
            //         "Reopen Cash Drawer",
            //         style: TextStyle(color: Colors.white),
            //       )),
            //     )),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //         child: TextButton(
            //       style: ButtonStyle(
            //           shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(5),
            //               side: const BorderSide(color: ProjectColors.primary))),
            //           backgroundColor: MaterialStateColor.resolveWith(
            //             (states) => const Color.fromARGB(255, 234, 234, 234),
            //           ),
            //           overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
            //       onPressed: () {},
            //       child: const Center(
            //           child: Text(
            //         "Reprint",
            //         style: TextStyle(color: ProjectColors.primary),
            //       )),
            //     )),
            //   ],
            // ),
            // const SizedBox(
            //   height: 5,
            // ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
              onPressed: () => context.pop(true),
              child: const Center(
                  child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              )),
            ),
          ],
        )
      ],
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    );
  }
}
