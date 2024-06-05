import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/calculate_cash.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/confirm_end_shift.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloseShiftScreen extends StatefulWidget {
  final String shiftId;
  const CloseShiftScreen({Key? key, required this.shiftId}) : super(key: key);

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
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  CloseShiftForm(shiftId: shiftId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CloseShiftForm extends StatefulWidget {
  final String shiftId;
  const CloseShiftForm({Key? key, required this.shiftId}) : super(key: key);

  @override
  State<CloseShiftForm> createState() => _CloseShiftFormState(shiftId: shiftId);
}

class _CloseShiftFormState extends State<CloseShiftForm> {
  final String shiftId;
  CashierBalanceTransactionModel? activeShift;
  late List<InvoiceHeaderModel?> transactions = [];
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  String totalCash = '0';

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
      totalCash = total;
    });
  }

  void updateActiveShift() async {
    if (activeShift != null && transactions.isNotEmpty) {
      double totalCashValue = 0;
      double totalNonCash = 0.0;
      final DateTime now = DateTime.now();
      final fetched = await GetIt.instance<AppDatabase>()
          .payMeansDao
          .readByTpmt3BetweenDate(
              DateTime(
                  activeShift!.openDate.year, now.month, now.day, 0, 0, 0, 0),
              DateTime(now.year, now.month, now.day, 23, 59, 59, 999));
      log("$fetched");
      // for(final mop in fetched!) {
      //   if(mop['tpmt3Id'] != )
      // }

      for (final trx in transactions) {
        if (trx != null) {
          totalCashValue += trx.grandTotal;
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
            cashValue: totalCashValue,
            closeValue: activeShift!.closeValue,
            openedbyId: activeShift!.openedbyId,
            closedbyId: activeShift!.closedbyId,
            approvalStatus: activeShift!.approvalStatus,
          );

          await GetIt.instance<AppDatabase>()
              .cashierBalanceTransactionDao
              .update(docId: shiftId, data: data);
          setState(() {
            activeShift = data;
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
    String formattedCashValue =
        NumberFormat.decimalPattern().format(activeShift!.cashValue.toInt());
    String formattedCalcValue =
        NumberFormat.decimalPattern().format(activeShift!.calcValue.toInt());
    double cashFlow = 0.0;
    String formattedCashFlow =
        NumberFormat.decimalPattern().format(cashFlow.toInt());
    double expectedCash =
        activeShift!.openValue + activeShift!.cashValue + cashFlow;
    String formattedExpectedCash =
        NumberFormat.decimalPattern().format(expectedCash.toInt());

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
        const Divider(
          height: 50,
          color: Colors.grey,
        ),
        Row(
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
        SizedBox(
          height: 10,
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
                formattedCashValue,
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
                formattedExpectedCash,
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
        SizedBox(
          height: 20,
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
                formattedCalcValue,
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
                formattedCashFlow,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const Divider(
          height: 50,
          color: Colors.grey,
        ),
        Row(
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
        SizedBox(
          height: 10,
        ),
        CalculateCash(updateTotalCash),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 200),
          child: CustomButton(
              child: const Text("End Shift"),
              onTap: () {
                if (activeShift != null) {
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
                    closeDate: activeShift!.closeDate,
                    closeTime: activeShift!.closeTime,
                    timezone: activeShift!.timezone,
                    openValue: activeShift!.openValue,
                    calcValue: activeShift!.calcValue,
                    cashValue: activeShift!.cashValue,
                    closeValue: activeShift!.closeValue,
                    openedbyId: activeShift!.openedbyId,
                    closedbyId: activeShift!.closedbyId,
                    approvalStatus: activeShift!.approvalStatus,
                  );

                  if (!context.mounted) return;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmEndShift(shift, totalCash);
                      });
                }
              }),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
