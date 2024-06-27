// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_cash_register.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_user.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_close_shift.dart';

class CloseShiftSuccessAlertDialog extends StatefulWidget {
  const CloseShiftSuccessAlertDialog({
    Key? key,
    required this.closedShift,
    required this.printCloseShiftUsecaseParams,
  }) : super(key: key);

  final CashierBalanceTransactionEntity closedShift;
  final PrintCloseShiftUsecaseParams printCloseShiftUsecaseParams;

  @override
  State<CloseShiftSuccessAlertDialog> createState() =>
      _CloseShiftSuccessAlertDialogState();
}

class _CloseShiftSuccessAlertDialogState
    extends State<CloseShiftSuccessAlertDialog> {
  CashRegisterEntity? cashRegisterEntity;
  StoreMasterEntity? storeMasterEntity;
  UserEntity? userEntity;

  Future<void> populateData() async {
    try {
      final CashRegisterEntity? cashRegisterEntityRes =
          await GetIt.instance<GetCashRegisterUseCase>()
              .call(params: widget.closedShift.tocsrId!);
      if (cashRegisterEntityRes == null) throw "Cash Register not found";
      log(cashRegisterEntityRes.toString());
      final StoreMasterEntity? storeMasterEntityRes =
          await GetIt.instance<GetStoreMasterUseCase>()
              .call(params: cashRegisterEntityRes.tostrId);
      if (storeMasterEntityRes == null) throw "Store Master not found";
      final UserEntity? userEntityRes = await GetIt.instance<GetUserUseCase>()
          .call(params: widget.closedShift.tousrId);
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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'Close Shift',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    width: double.infinity,
                    color: const Color.fromARGB(255, 134, 1, 1),
                    // color: Color.fromARGB(255, 219, 219, 219),

                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/icon-success.svg",
                                height: 42,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Close Shift Success",
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              storeMasterEntity?.storeName ?? "",
                              style: const TextStyle(
                                fontSize: 16,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              cashRegisterEntity?.description ?? "",
                              style: const TextStyle(
                                fontSize: 16,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              userEntity?.username ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Opened at",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.formatDate((widget.closedShift.openDate)),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Closed at",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.formatDate((widget.closedShift.openDate)),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Approved by",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.printCloseShiftUsecaseParams.approverName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const TableRow(children: [
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ]),
                        TableRow(
                          children: [
                            const Text(
                              "Opening Balance",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(widget.closedShift.openValue),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Total Cash Sales",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(widget
                                  .printCloseShiftUsecaseParams.totalCashSales),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Expected Cash",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(widget
                                  .printCloseShiftUsecaseParams.expectedCash),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                        const TableRow(children: [
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ]),
                        TableRow(
                          children: [
                            const Text(
                              "Total Non Cash Sales",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(widget
                                  .printCloseShiftUsecaseParams
                                  .totalNonCashSales),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Total Sales",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(widget
                                  .printCloseShiftUsecaseParams.totalSales),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const TableRow(children: [
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ]),
                        TableRow(
                          children: [
                            const Text(
                              "Total Actual Cash",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(widget
                                  .printCloseShiftUsecaseParams.cashReceived),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              "Difference",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: widget.printCloseShiftUsecaseParams
                                            .difference <
                                        0
                                    ? Colors.red
                                    : widget.printCloseShiftUsecaseParams
                                                .difference >
                                            0
                                        ? Colors.orange
                                        : Colors.green,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(widget
                                  .printCloseShiftUsecaseParams.difference),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: widget.printCloseShiftUsecaseParams
                                            .difference <
                                        0
                                    ? Colors.red
                                    : widget.printCloseShiftUsecaseParams
                                                .difference >
                                            0
                                        ? Colors.orange
                                        : Colors.green,
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
            Row(
              children: [
                Expanded(
                    child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        // side: const BorderSide(color: ProjectColors.primary),
                      )),
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 56, 56, 56),
                      ),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black.withOpacity(.2))),
                  onPressed: null,
                  child: const Center(
                      child: Text(
                    "Reopen Cash Drawer",
                    style: TextStyle(color: Colors.white),
                  )),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side:
                              const BorderSide(color: ProjectColors.primary))),
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 234, 234, 234),
                      ),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black.withOpacity(.2))),
                  onPressed: () {},
                  child: const Center(
                      child: Text(
                    "Reprint",
                    style: TextStyle(color: ProjectColors.primary),
                  )),
                )),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white.withOpacity(.2))),
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
