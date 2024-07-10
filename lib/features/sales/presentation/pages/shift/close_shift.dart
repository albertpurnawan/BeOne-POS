import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/navigation_helper.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/money_denomination.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_close_shift.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/calculate_cash.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/close_shift_success_alert_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirmation_dialog.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/cashier_balance_transactions_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CloseShiftScreen extends StatelessWidget {
  final String shiftId;
  final String? username;
  const CloseShiftScreen({Key? key, required this.shiftId, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text('Close Shift'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(134, 234, 234, 234),
              Color.fromARGB(43, 234, 234, 234),
              Colors.transparent,
              Colors.transparent,
              Color.fromARGB(43, 234, 234, 234),
              Color.fromARGB(134, 234, 234, 234),
            ],
            stops: [0.0, 0.04, 0.07, 0.93, 0.96, 1.0], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        // padding: EdgeInsets.symmetric(vertical: 20),
        // width: double.infinity,
        child: SingleChildScrollView(
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, vertical: 40),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                CloseShiftForm(
                  shiftId: shiftId,
                  username: username!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CloseShiftForm extends StatefulWidget {
  final String shiftId;
  final String? username;
  const CloseShiftForm({Key? key, required this.shiftId, this.username}) : super(key: key);

  @override
  State<CloseShiftForm> createState() => _CloseShiftFormState();
}

class _CloseShiftFormState extends State<CloseShiftForm> {
  late final String shiftId = widget.shiftId;
  CashierBalanceTransactionModel? activeShift;
  late List<InvoiceHeaderModel?> transactions = [];
  final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  String totalCash = '0';
  String totalNonCash = '0';
  String totalSales = '0';
  String expectedCash = "0";
  String calculatedTotalCash = '0';
  String difference = "0";
  Map<String, dynamic>? denomination;
  UserEntity? closeShiftApproverUser;
  EmployeeEntity? closeShiftApproverEmployee;
  UserEntity? openShiftApproverUser;
  EmployeeEntity? openShiftApproverEmployee;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    await fetchActiveShift();
    await fetchInvoices();
    await updateActiveShift();
    await fetchOpenShiftApprover();
    await fetchCloseShiftApprover();
  }

  Future<void> fetchCloseShiftApprover() async {
    try {
      final UserEntity? user = await GetIt.instance<AppDatabase>().userDao.readByUsername(widget.username!, null);

      if (user == null) throw "User not found";
      setState(() {
        closeShiftApproverUser = user;
      });

      if (user.tohemId == null) throw "Employee ID not found in user";
      final EmployeeEntity? employee = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(user.tohemId!, null);

      if (employee == null) throw "Employee not found";
      setState(() {
        closeShiftApproverEmployee = employee;
      });

      return;
    } catch (e) {
      log("$e when fetch close shift approver");
    }
  }

  Future<void> fetchOpenShiftApprover() async {
    try {
      if (activeShift == null) throw "Active shift not found";
      final UserEntity? user = await GetIt.instance<AppDatabase>().userDao.readByDocId(activeShift!.openedbyId!, null);

      if (user == null) throw "User not found";
      setState(() {
        openShiftApproverUser = user;
      });

      if (user.tohemId == null) throw "Employee ID not found in user";
      final EmployeeEntity? employee = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(user.tohemId!, null);

      if (employee == null) throw "Employee not found";
      setState(() {
        openShiftApproverEmployee = employee;
      });

      return;
    } catch (e) {
      log("$e when fetch open shift approver");
    }
  }

  Future<void> fetchActiveShift() async {
    final shift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readByDocId(shiftId, null);
    setState(() {
      activeShift = shift;
      expectedCash = Helpers.parseMoney(shift?.openValue ?? 0);
      difference = Helpers.parseMoney(
          Helpers.revertMoneyToDecimalFormat(calculatedTotalCash) - Helpers.revertMoneyToDecimalFormat(expectedCash));
    });
  }

  Future<void> fetchInvoices() async {
    final transaction = await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByShift(activeShift!.docId);
    setState(() {
      transactions = transaction;
    });
  }

  void updateTotalCash(Map<String, String> total) {
    setState(() {
      int totalCash = 0;
      for (String key in total.keys) {
        totalCash += (Helpers.revertMoneyToDecimalFormat(total[key] == "" ? "0" : total[key]!) *
                int.parse(key.replaceAll('k', "000")))
            .round();
      }
      calculatedTotalCash = Helpers.parseMoney(totalCash);
      denomination = total;
      difference = Helpers.parseMoney(
          Helpers.revertMoneyToDecimalFormat(calculatedTotalCash) - Helpers.revertMoneyToDecimalFormat(expectedCash));
    });
  }

  Future<void> updateActiveShift() async {
    if (activeShift != null && transactions.isNotEmpty) {
      double nonCash = 0.0;
      double salesAmount = 0.0;
      final DateTime now = DateTime.now();
      final start = activeShift!.openDate.subtract(Duration(hours: DateTime.now().timeZoneOffset.inHours));
      final end = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
        999,
      );
      log("$start - $end");
      final fetched = await GetIt.instance<AppDatabase>().payMeansDao.readByTpmt3BetweenDate(start, end);
      log("$fetched");
      for (final mop in fetched!) {
        if ((mop['description'] != 'TUNAI')) {
          nonCash += mop['totalamount'];
        }
      }

      for (final trx in transactions) {
        if (trx != null) {
          salesAmount += trx.grandTotal;
          CashierBalanceTransactionModel data = CashierBalanceTransactionModel(
            docId: activeShift!.docId,
            createDate: activeShift!.createDate,
            updateDate: activeShift!.updateDate,
            tocsrId: activeShift!.tocsrId,
            tousrId: activeShift!.tousrId,
            docNum: activeShift!.docNum,
            openDate: activeShift!.openDate,
            openTime: activeShift!.openTime,
            calcDate: DateTime.now(),
            calcTime: DateTime.now(),
            closeDate: activeShift!.closeDate,
            closeTime: activeShift!.closeTime,
            timezone: activeShift!.timezone,
            openValue: activeShift!.openValue,
            calcValue: activeShift!.calcValue,
            cashValue: salesAmount - nonCash,
            closeValue: activeShift!.closeValue,
            openedbyId: activeShift!.openedbyId,
            closedbyId: activeShift!.closedbyId,
            approvalStatus: activeShift!.approvalStatus,
            refpos: activeShift!.docId,
            syncToBos: activeShift!.syncToBos,
          );

          // await GetIt.instance<AppDatabase>()
          //     .cashierBalanceTransactionDao
          //     .update(docId: shiftId, data: data);

          setState(() {
            activeShift = data;
            totalNonCash = NumberFormat.decimalPattern().format(nonCash);
            totalSales = NumberFormat.decimalPattern().format(salesAmount);
            totalCash = NumberFormat.decimalPattern().format(salesAmount - nonCash);
            expectedCash = NumberFormat.decimalPattern().format(data.openValue + (salesAmount - nonCash));
            difference = Helpers.parseMoney(Helpers.revertMoneyToDecimalFormat(calculatedTotalCash) -
                Helpers.revertMoneyToDecimalFormat(expectedCash));
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activeShift == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String formattedOpenDate = Helpers.formatDateNoSeconds(activeShift!.openDate);
    String formattedOpenValue = NumberFormat.decimalPattern().format(activeShift!.openValue.toInt());

    final cashier = prefs.getString('username');

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "Shift",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Cashier",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                cashier!,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Opened at",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                formattedOpenDate,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Close Shift Approver",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                closeShiftApproverEmployee?.empName ?? closeShiftApproverUser?.username ?? "null",
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "Sales",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Opening Balance",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                formattedOpenValue,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Total Cash Sales",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalCash,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Expected Cash",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ProjectColors.mediumBlack,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                expectedCash,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ProjectColors.mediumBlack,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Total Non Cash Sales",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalNonCash,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Total Sales",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalSales,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "Actual Cash",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
        ),
        CalculateCash(setTotal: updateTotalCash),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Total Actual Cash",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const Expanded(
              child: Text(""),
            ),
            SizedBox(
              width: 300,
              child: Text(
                calculatedTotalCash,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Difference",
                  style: TextStyle(
                    height: 1,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Helpers.revertMoneyToDecimalFormat(difference) < 0
                        ? Colors.red
                        : Helpers.revertMoneyToDecimalFormat(difference) > 0
                            ? Colors.orange
                            : Colors.green,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Helpers.revertMoneyToDecimalFormat(difference) < 0
                      ? Icons.warning_amber_rounded
                      : Helpers.revertMoneyToDecimalFormat(difference) > 0
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outlined,
                  color: Helpers.revertMoneyToDecimalFormat(difference) < 0
                      ? Colors.red
                      : Helpers.revertMoneyToDecimalFormat(difference) > 0
                          ? Colors.orange
                          : Colors.green,
                ),
              ],
            ),
            const Expanded(
              child: Text(""),
            ),
            Text(
              difference,
              style: TextStyle(
                height: 1,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Helpers.revertMoneyToDecimalFormat(difference) < 0
                    ? Colors.red
                    : Helpers.revertMoneyToDecimalFormat(difference) > 0
                        ? Colors.orange
                        : Colors.green,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        const Divider(
          height: 50,
          color: Colors.grey,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: CustomButton(
              child: const Text("End Shift"),
              onTap: () async {
                try {
                  if (activeShift == null) throw "Current shift not found";
                  final userId = await GetIt.instance<AppDatabase>().userDao.readByUsername(widget.username!, null);
                  final CashierBalanceTransactionModel shift = CashierBalanceTransactionModel(
                    docId: activeShift!.docId,
                    createDate: activeShift!.createDate,
                    updateDate: activeShift!.updateDate,
                    tocsrId: activeShift!.tocsrId,
                    tousrId: activeShift!.tousrId,
                    docNum: activeShift!.docNum,
                    openDate: activeShift!.openDate,
                    openTime: activeShift!.openTime,
                    calcDate: DateTime.now(),
                    calcTime: DateTime.now(),
                    closeDate: DateTime.now(),
                    closeTime: DateTime.now(),
                    timezone: activeShift!.timezone,
                    openValue: activeShift!.openValue,
                    calcValue: Helpers.revertMoneyToDecimalFormat(calculatedTotalCash),
                    cashValue: activeShift!.cashValue,
                    closeValue: Helpers.revertMoneyToDecimalFormat(totalSales),
                    openedbyId: activeShift!.openedbyId,
                    closedbyId: userId!.docId,
                    approvalStatus: 1,
                    refpos: activeShift!.docId,
                    syncToBos: activeShift!.syncToBos,
                  );

                  List<MoneyDenominationModel> createDenominationList(Map<String, dynamic> denomination) {
                    final list = <MoneyDenominationModel>[];
                    denomination.forEach((key, value) {
                      if (value.isNotEmpty) {
                        final nominal = int.parse(key.replaceAll('k', '000'));
                        final count = int.parse(value);
                        list.add(MoneyDenominationModel(
                          docId: const Uuid().v4(),
                          createDate: DateTime.now(),
                          updateDate: DateTime.now(),
                          nominal: nominal,
                          count: count,
                          tcsr1Id: activeShift!.docId,
                        ));
                      }
                    });
                    return list;
                  }

                  final denominationList = createDenominationList(denomination!);

                  final bool? isProceed = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        final double numDifference = Helpers.revertMoneyToDecimalFormat(difference);
                        final String absDifference = Helpers.parseMoney(numDifference.abs());
                        return ConfirmationDialog(
                            primaryMsg: "Are you sure to close current shift?",
                            secondaryMsg: numDifference != 0
                                ? "There is a $absDifference ${numDifference > 0 ? "surplus" : "deficit"} between expected cash and actual cash."
                                : "Great! Actual cash has matched the expected cash.");
                      });

                  if (isProceed != true) return;

                  await GetIt.instance<AppDatabase>().moneyDenominationDao.bulkCreate(data: denominationList);

                  await prefs.setBool('isOpen', false);
                  await prefs.setString('tcsr1Id', "");
                  await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.update(docId: shiftId, data: shift);
                  await GetIt.instance<CashierBalanceTransactionApi>().sendTransactions(shift);
                  final CashierBalanceTransactionEntity? cashierBalanceTransactionEntity =
                      await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readByDocId(shift.docId, null);
                  if (cashierBalanceTransactionEntity == null) {
                    throw "Close shift failed, current shift not found";
                  }
                  final PrintCloseShiftUsecaseParams printCloseShiftUsecaseParams = PrintCloseShiftUsecaseParams(
                      cashierBalanceTransactionEntity: cashierBalanceTransactionEntity,
                      totalCashSales: Helpers.revertMoneyToDecimalFormat(totalCash),
                      expectedCash: Helpers.revertMoneyToDecimalFormat(expectedCash),
                      totalNonCashSales: Helpers.revertMoneyToDecimalFormat(totalNonCash),
                      totalSales: Helpers.revertMoneyToDecimalFormat(totalSales),
                      cashReceived: Helpers.revertMoneyToDecimalFormat(calculatedTotalCash),
                      difference: Helpers.revertMoneyToDecimalFormat(calculatedTotalCash) -
                          Helpers.revertMoneyToDecimalFormat(expectedCash),
                      approverName: closeShiftApproverEmployee?.empName ?? closeShiftApproverUser?.username ?? "");
                  await GetIt.instance<PrintCloseShiftUsecase>().call(params: printCloseShiftUsecaseParams);
                  await GetIt.instance<LogoutUseCase>().call();
                  if (!context.mounted) return;
                  context.goNamed(RouteConstants.welcome);
                  await Future.delayed(Durations.medium1);
                  await showDialog(
                      context: NavigationHelper.context!,
                      builder: (context) => CloseShiftSuccessAlertDialog(
                            closedShift: cashierBalanceTransactionEntity,
                            printCloseShiftUsecaseParams: printCloseShiftUsecaseParams,
                          ));
                } catch (e) {
                  SnackBarHelper.presentFailSnackBar(context, e.toString());
                }
              }),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
