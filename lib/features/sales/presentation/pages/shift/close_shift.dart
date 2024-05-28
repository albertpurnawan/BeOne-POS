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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Close Current Shift",
                  style: TextStyle(
                      color: ProjectColors.swatch,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              CloseShiftForm(shiftId: shiftId),
            ],
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
  late List<InvoiceHeaderModel?> transactions;
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  String totalCash = '0';

  _CloseShiftFormState({required this.shiftId});

  @override
  void initState() {
    super.initState();
    fetchData();
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
            calcDate: activeShift!.calcDate,
            calcTime: activeShift!.calcTime,
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
    if (activeShift == null || transactions.isEmpty) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    "Shift Started",
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
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    "Total Cash Flow",
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    "Total Non Cash",
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    "Expected Cash",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Text(
                    formattedExpectedCash,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Calculate Cash",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: CalculateCash(updateTotalCash),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomButton(
                child: const Text("End Shift"),
                onTap: () async {
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
        ],
      ),
    );
  }
}
