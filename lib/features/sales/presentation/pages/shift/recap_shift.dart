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
import 'package:pos_fe/features/sales/data/models/money_denomination.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/recap_money_denom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecapShiftScreen extends StatefulWidget {
  final String shiftId;
  const RecapShiftScreen({
    Key? key,
    required this.shiftId,
  }) : super(key: key);

  @override
  State<RecapShiftScreen> createState() => _RecapShiftScreenState();
}

class _RecapShiftScreenState extends State<RecapShiftScreen> {
  late final String shiftId = widget.shiftId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text('Recap Shift'),
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
                  CloseShiftForm(
                    shiftId: shiftId,
                  ),
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
  const CloseShiftForm({
    Key? key,
    required this.shiftId,
  }) : super(key: key);

  @override
  State<CloseShiftForm> createState() => _CloseShiftFormState();
}

class _CloseShiftFormState extends State<CloseShiftForm> {
  late final String shiftId = widget.shiftId;
  CashierBalanceTransactionModel? tcsr1;
  MoneyDenominationModel? tcsr2;
  late List<InvoiceHeaderModel?> transactions = [];
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  String totalCash = '0';
  String totalNonCash = '0';
  String totalSales = '0';
  String calculatedTotalCash = '0';

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
    await fetchInvoices();
    await fetchShift();
  }

  Future<void> fetchShift() async {
    final shift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readByDocId(shiftId, null);
    setState(() {
      tcsr1 = shift;
    });
  }

  Future<void> fetchInvoices() async {
    final transaction = await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByShift(shiftId);
    setState(() {
      transactions = transaction;
    });
  }

  void updateTotalCash(Map<String, dynamic> total) {
    setState(() {
      calculatedTotalCash = totalCash;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tcsr1 == null) {
      return const Center(child: CircularProgressIndicator());
    }

    log("tcsr1 - $tcsr1");

    String formattedOpenDate = Helpers.formatDateNoSeconds(tcsr1!.openDate);
    String formattedOpenValue = NumberFormat.decimalPattern().format(tcsr1!.openValue.toInt());
    NumberFormat.decimalPattern().format(tcsr1!.cashValue.toInt());
    NumberFormat.decimalPattern().format(tcsr1!.calcValue.toInt());
    double cashFlow = 0.0;
    NumberFormat.decimalPattern().format(cashFlow.toInt());
    double expectedCash = tcsr1!.openValue + tcsr1!.cashValue + cashFlow;
    String formattedExpectedCash = NumberFormat.decimalPattern().format(expectedCash.toInt());

    final cashier = prefs.getString('username');

    totalCash = NumberFormat.decimalPattern().format(tcsr1!.cashValue.toInt());
    totalNonCash = NumberFormat.decimalPattern().format((tcsr1!.closeValue - tcsr1!.cashValue).toInt());
    totalSales = NumberFormat.decimalPattern().format(tcsr1!.closeValue.toInt());

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
        const SizedBox(
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
        const SizedBox(
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
        const Divider(
          height: 50,
          color: Colors.grey,
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
        const SizedBox(
          height: 10,
        ),
        RecapMoneyDialog(tcsr1Id: shiftId),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: CustomButton(
              child: const Text("OK"),
              onTap: () async {
                if (!context.mounted) return;
                Navigator.pop(context);
              }),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
