import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_close_shift.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/calculate_cash.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/cashier_balance_transactions_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloseShiftScreen extends StatefulWidget {
  final String shiftId;
  final String? username;
  const CloseShiftScreen({Key? key, required this.shiftId, this.username})
      : super(key: key);

  @override
  State<CloseShiftScreen> createState() =>
      _CloseShiftScreenState(shiftId: shiftId);
}

class _CloseShiftScreenState extends State<CloseShiftScreen> {
  final String shiftId;
  _CloseShiftScreenState({required this.shiftId});
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
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(134, 234, 234, 234),
              const Color.fromARGB(43, 234, 234, 234),
              Colors.transparent,
              Colors.transparent,
              const Color.fromARGB(43, 234, 234, 234),
              Color.fromARGB(134, 234, 234, 234),
            ],
            stops: [
              0.0,
              0.04,
              0.07,
              0.93,
              0.96,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        // padding: EdgeInsets.symmetric(vertical: 20),
        // width: double.infinity,
        child: SingleChildScrollView(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2,
              vertical: 40),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                CloseShiftForm(
                  shiftId: shiftId,
                  username: widget.username!,
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
  const CloseShiftForm({Key? key, required this.shiftId, this.username})
      : super(key: key);

  @override
  State<CloseShiftForm> createState() => _CloseShiftFormState(shiftId: shiftId);
}

class _CloseShiftFormState extends State<CloseShiftForm> {
  final String shiftId;
  CashierBalanceTransactionModel? activeShift;
  late List<InvoiceHeaderModel?> transactions = [];
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  String totalCash = '0';
  String totalNonCash = '0';
  String totalSales = '0';
  String expectedCash = "0";
  String calculatedTotalCash = '0';

  _CloseShiftFormState({required this.shiftId});

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
    prefs = await SharedPreferences.getInstance();
    await fetchActiveShift();
    await fetchInvoices();
    updateActiveShift();
  }

  Future<void> fetchActiveShift() async {
    final shift = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readByDocId(shiftId, null);
    setState(() {
      activeShift = shift;
    });
  }

  Future<void> fetchInvoices() async {
    final transaction =
        await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByShift();
    setState(() {
      transactions = transaction;
    });
  }

  void updateTotalCash(String total) {
    setState(() {
      calculatedTotalCash = totalCash;
    });
  }

  void updateActiveShift() async {
    if (activeShift != null && transactions.isNotEmpty) {
      double nonCash = 0.0;
      double salesAmount = 0.0;
      final DateTime now = DateTime.now();
      final start = activeShift!.openDate
          .subtract(Duration(hours: DateTime.now().timeZoneOffset.inHours));
      final end = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
        999,
      );
      final fetched = await GetIt.instance<AppDatabase>()
          .payMeansDao
          .readByTpmt3BetweenDate(start, end);

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
            cashValue: salesAmount,
            closeValue: activeShift!.closeValue,
            openedbyId: activeShift!.openedbyId,
            closedbyId: activeShift!.closedbyId,
            approvalStatus: activeShift!.approvalStatus,
          );

          await GetIt.instance<AppDatabase>()
              .cashierBalanceTransactionDao
              .update(docId: shiftId, data: data);
          log("nonCash - $nonCash");
          log("cash - ${salesAmount - nonCash}");
          log("totalSales - ${salesAmount}");
          setState(() {
            activeShift = data;
            totalNonCash = NumberFormat.decimalPattern().format(nonCash);
            totalSales = NumberFormat.decimalPattern().format(salesAmount);
            totalCash =
                NumberFormat.decimalPattern().format(salesAmount - nonCash);
            expectedCash = NumberFormat.decimalPattern()
                .format(data.openValue + (salesAmount - nonCash));
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activeShift == null) {
      return Center(child: CircularProgressIndicator());
    }

    String formattedOpenDate =
        Helpers.formatDateNoSeconds(activeShift!.openDate);
    String formattedOpenValue =
        NumberFormat.decimalPattern().format(activeShift!.openValue.toInt());

    final cashier = prefs.getString('username');

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Cashier",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                cashier!,
                style: const TextStyle(
                  fontSize: 20,
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
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                formattedOpenDate,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        SizedBox(
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
                  fontSize: 24,
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
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                formattedOpenValue,
                style: const TextStyle(
                  fontSize: 20,
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
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalCash,
                style: const TextStyle(
                  fontSize: 20,
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
                  fontSize: 20,
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
                  fontSize: 20,
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
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalNonCash,
                style: const TextStyle(
                  fontSize: 20,
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
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalSales,
                style: const TextStyle(
                  fontSize: 20,
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
                "Cash Received",
                style: TextStyle(
                  fontSize: 24,
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
        CalculateCash(updateTotalCash),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: CustomButton(
              child: const Text("End Shift"),
              onTap: () async {
                if (activeShift != null) {
                  final userId = await GetIt.instance<AppDatabase>()
                      .userDao
                      .readByUsername(widget.username!, null);
                  final CashierBalanceTransactionModel shift =
                      CashierBalanceTransactionModel(
                    docId: activeShift!.docId,
                    createDate: activeShift!.createDate,
                    updateDate: activeShift!.updateDate,
                    tocsrId: activeShift!.tocsrId,
                    tousrId: activeShift!.tousrId,
                    docNum: activeShift!.docNum,
                    openDate: activeShift!.openDate,
                    openTime: activeShift!.openTime,
                    calcDate: activeShift!.calcDate,
                    calcTime: activeShift!.calcTime,
                    closeDate: DateTime.now(),
                    closeTime: DateTime.now(),
                    timezone: activeShift!.timezone,
                    openValue: activeShift!.openValue,
                    calcValue: activeShift!.calcValue,
                    cashValue: activeShift!.cashValue,
                    closeValue:
                        Helpers.revertMoneyToDecimalFormat(calculatedTotalCash),
                    openedbyId: activeShift!.openedbyId,
                    closedbyId: userId!.docId,
                    approvalStatus: 1,
                  );

                  await prefs.setBool('isOpen', false);
                  await prefs.setString('tcsr1Id', "");
                  await GetIt.instance<AppDatabase>()
                      .cashierBalanceTransactionDao
                      .update(docId: shiftId, data: shift);
                  // await GetIt.instance<CashierBalanceTransactionApi>()
                  //     .sendTransactions(shift);
                  final CashierBalanceTransactionEntity?
                      cashierBalanceTransactionEntity =
                      await GetIt.instance<AppDatabase>()
                          .cashierBalanceTransactionDao
                          .readByDocId(shift.docId, null);
                  await GetIt.instance<PrintCloseShiftUsecase>().call(
                      params: PrintCloseShiftUsecaseParams(
                          cashierBalanceTransactionEntity:
                              cashierBalanceTransactionEntity!,
                          totalCashSales:
                              Helpers.revertMoneyToDecimalFormat(totalCash),
                          expectedCash:
                              Helpers.revertMoneyToDecimalFormat(expectedCash),
                          totalNonCashSales:
                              Helpers.revertMoneyToDecimalFormat(totalNonCash),
                          totalSales:
                              Helpers.revertMoneyToDecimalFormat(totalSales),
                          cashReceived: Helpers.revertMoneyToDecimalFormat(
                              calculatedTotalCash),
                          difference: Helpers.revertMoneyToDecimalFormat(
                                  calculatedTotalCash) -
                              Helpers.revertMoneyToDecimalFormat(totalCash)));
                  await GetIt.instance<LogoutUseCase>().call();
                  if (!context.mounted) return;
                  context.goNamed(RouteConstants.welcome);
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
