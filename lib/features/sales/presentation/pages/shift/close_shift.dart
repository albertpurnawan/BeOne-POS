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
import 'package:pos_fe/features/sales/data/models/money_denomination.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/calculate_cash.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/cashier_balance_transactions_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
                    username: widget.username!,
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
  String calculatedTotalCash = '0';
  Map<String, dynamic>? denomination;

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
    final transaction = await GetIt.instance<AppDatabase>()
        .invoiceHeaderDao
        .readByShift(activeShift!.docId);
    setState(() {
      transactions = transaction;
    });
  }

  void updateTotalCash(Map<String, dynamic> total) {
    setState(() {
      calculatedTotalCash = totalCash;
      denomination = total;
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
            cashValue: salesAmount,
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
            totalNonCash = NumberFormat.decimalPattern().format(nonCash);
            totalSales = NumberFormat.decimalPattern().format(salesAmount);
            totalCash =
                NumberFormat.decimalPattern().format(salesAmount - nonCash);
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
    double cashFlow = 0.0;
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
                    calcValue:
                        Helpers.revertMoneyToDecimalFormat(calculatedTotalCash),
                    cashValue: activeShift!.cashValue,
                    closeValue: Helpers.revertMoneyToDecimalFormat(totalSales),
                    openedbyId: activeShift!.openedbyId,
                    closedbyId: userId!.docId,
                    approvalStatus: 1,
                  );

                  List<MoneyDenominationModel> createDenominationList(
                      Map<String, dynamic> denomination) {
                    final list = <MoneyDenominationModel>[];
                    denomination.forEach((key, value) {
                      if (value.isNotEmpty) {
                        final nominal = int.parse(key.replaceAll('k', '000'));
                        final count = int.parse(value);
                        list.add(MoneyDenominationModel(
                          docId: Uuid().v4(),
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

                  final denominationList =
                      createDenominationList(denomination!);
                  await GetIt.instance<AppDatabase>()
                      .moneyDenominationDao
                      .bulkCreate(data: denominationList);

                  await prefs.setBool('isOpen', false);
                  await prefs.setString('tcsr1Id', "");
                  await GetIt.instance<AppDatabase>()
                      .cashierBalanceTransactionDao
                      .update(docId: shiftId, data: shift);
                  await GetIt.instance<CashierBalanceTransactionApi>()
                      .sendTransactions(shift);
                  GetIt.instance<LogoutUseCase>().call();
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
