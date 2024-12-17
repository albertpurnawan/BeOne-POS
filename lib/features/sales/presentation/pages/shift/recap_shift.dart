import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
import 'package:pos_fe/features/sales/data/models/money_denomination.dart';
import 'package:pos_fe/features/sales/data/models/payment_type.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_close_shift.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_open_shift.dart';
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, vertical: 40),
        child: SizedBox(
          width: double.infinity,
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
  late List<InvoiceHeaderModel?> transactionsReturn = [];
  late List<dynamic> transactionsMOP = [];
  late List<PaymentTypeModel> transactionsTopmt = [];
  late List<MeansOfPaymentModel> transactionsTpmt1 = [];
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  String totalCash = '0';
  String totalNonCash = '0';
  String totalSales = '0';
  int calculatedTotalCash = 0;
  int difference = 0;
  String approver = '';
  bool isPrintingOpenShift = false;
  bool isPrintingCloseShift = false;

  final tableHeader = ["No", "Means of Payment", "Amount"];
  List<dynamic> tableData = [];

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
    await fetchMOPByInvoice();
  }

  Future<void> fetchShift() async {
    final shift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readByDocId(shiftId, null);
    await fetchApprover(shift!);
    setState(() {
      tcsr1 = shift;
    });
  }

  Future<void> fetchInvoices() async {
    final transaction = await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByShift(shiftId);

    for (var i = 0; i < transaction.length; i++) {
      final tinv1s =
          await GetIt.instance<AppDatabase>().invoiceDetailDao.readByToinvId(transaction[i].docId ?? "", null);
      if (tinv1s.isNotEmpty) {
        for (var j = 0; j < tinv1s.length; j++) {
          if (tinv1s[j].refpos3 != null && tinv1s[j].refpos3 != "") {
            setState(() {
              transactionsReturn.add(transaction[i]);
            });
          }
        }
      }
    }
    setState(() {
      transactions = transaction;
    });
  }

  Future<void> fetchApprover(CashierBalanceTransactionModel shift) async {
    final user = await GetIt.instance<AppDatabase>().userDao.readByDocId(shift.closedApproveById!, null);
    if (user == null) return;

    final approverName = user.tohemId != null
        ? (await GetIt.instance<AppDatabase>().employeeDao.readByDocId(user.tohemId!, null))?.empName
        : user.username;

    setState(() {
      approver = approverName!;
    });
  }

  void updateTotalCash(Map<String, int> total) {
    setState(() {
      calculatedTotalCash = total.values.fold(0, (sum, value) => sum + value);
    });
  }

  Future<void> fetchMOPByInvoice() async {
    for (var i = 0; i < transactions.length; i++) {
      final payMean =
          await GetIt.instance<AppDatabase>().payMeansDao.readByToinvShowTopmt(transactions[i]!.docId.toString());
      if (payMean != null && payMean.isNotEmpty) {
        for (var j = 0; j < payMean.length; j++) {
          transactionsMOP.add(payMean[j]);
        }
      }
    }
    for (var i = 0; i < transactionsMOP.length; i++) {
      final tpmt3 = await GetIt.instance<AppDatabase>().mopByStoreDao.readByDocId(transactionsMOP[i]["tpmt3Id"], null);
      if (tpmt3 == null) throw "Failed retrieve tpmt3";
      final tpmt1 = await GetIt.instance<AppDatabase>().meansOfPaymentDao.readByDocId(tpmt3.tpmt1Id ?? "", null);
      if (tpmt1 == null) throw "Failed retrieve tpmt1";
      final topmt = await GetIt.instance<AppDatabase>().paymentTypeDao.readByDocId(tpmt1.topmtId ?? "", null);
      if (topmt == null) throw "Failed retrieve topmt";
      transactionsTopmt.add(topmt);
      transactionsTpmt1.add(tpmt1);
    }

    setState(() {
      transactionsTopmt = transactionsTopmt
          .fold<Map<String, PaymentTypeModel>>({}, (map, transaction) {
            map[transaction.docId] = transaction;
            return map;
          })
          .values
          .toList()
        ..sort((a, b) => a.payTypeCode.compareTo(b.payTypeCode));

      transactionsTpmt1 = transactionsTpmt1
          .fold<Map<String, MeansOfPaymentModel>>({}, (map, transaction) {
            map[transaction.docId] = transaction;
            return map;
          })
          .values
          .toList();

      transactionsMOP = transactionsMOP
          .fold<Map<String, dynamic>>({}, (map, transaction) {
            String tpmt1Id = transaction['tpmt1Id'];

            if (map.containsKey(tpmt1Id)) {
              map[tpmt1Id]['amount'] += transaction['amount'];
              map[tpmt1Id]['docids'].add(transaction['docid']);
              map[tpmt1Id]['createdat'] = transaction['createdat'];
              map[tpmt1Id]['description'] = transaction['description'];
              map[tpmt1Id]['topmtId'] = transaction['topmtId'];
            } else {
              map[tpmt1Id] = {
                'tpmt1Id': tpmt1Id,
                'amount': transaction['amount'],
                'docids': [transaction['docid']],
                'createdat': transaction['createdat'],
                'description': transaction['description'],
                'paytypecode': transaction['paytypecode'],
                'topmtId': transaction['topmtId'],
              };
            }
            return map;
          })
          .values
          .toList()
        ..sort((a, b) => a['paytypecode'].compareTo(b['paytypecode']));

      tableData = transactionsMOP
          .asMap()
          .map((index, transaction) {
            return MapEntry(index, [
              (index + 1).toString(),
              transaction['description'] ?? '',
              Helpers.parseMoney(transaction['amount']),
            ]);
          })
          .values
          .toList();
    });
    log("transactionsTopmt - $transactionsTopmt");
    log("transactionsMOP - $transactionsMOP");
  }

  @override
  Widget build(BuildContext context) {
    if (tcsr1 == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String formattedOpenDate = Helpers.formatDateNoSeconds(tcsr1!.openDate);
    String formattedCloseDate = Helpers.formatDateNoSeconds(tcsr1!.closeDate);
    String formattedOpenValue = NumberFormat.decimalPattern().format(tcsr1!.openValue.toInt());
    NumberFormat.decimalPattern().format(tcsr1!.cashValue.toInt());
    NumberFormat.decimalPattern().format(tcsr1!.calcValue.toInt());
    double cashFlow = 0.0;
    NumberFormat.decimalPattern().format(cashFlow.toInt());
    double expectedCash = tcsr1!.openValue + tcsr1!.cashValue + cashFlow;
    String formattedExpectedCash = NumberFormat.decimalPattern().format(expectedCash.toInt());

    setState(() {
      difference = calculatedTotalCash - expectedCash.toInt();
    });

    final cashier = prefs.getString('username');

    totalCash = NumberFormat.decimalPattern().format(tcsr1!.cashValue.toInt());
    totalNonCash = NumberFormat.decimalPattern().format((tcsr1!.closeValue - tcsr1!.cashValue).toInt());
    totalSales = NumberFormat.decimalPattern().format(tcsr1!.closeValue.toInt());

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Shift",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                      overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                  onPressed: isPrintingOpenShift
                      ? null
                      : () async {
                          try {
                            setState(() {
                              isPrintingOpenShift = true;
                            });
                            await GetIt.instance<PrintOpenShiftUsecase>().call(params: tcsr1, printType: 2);
                            setState(() {
                              isPrintingOpenShift = false;
                            });
                          } catch (e) {
                            setState(() {
                              isPrintingOpenShift = false;
                            });
                            if (context.mounted) {
                              SnackBarHelper.presentErrorSnackBar(context, e.toString());
                            }
                          }
                        },
                  child: Center(
                    child: isPrintingOpenShift
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator.adaptive(
                                // backgroundColor: Colors.white,
                                ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.print_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Reprint\nOpen Shift",
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    // TextSpan(
                                    //   text: "  (F12)",
                                    //   style: TextStyle(fontWeight: FontWeight.w300),
                                    // ),
                                  ],
                                  style: TextStyle(height: 1, fontSize: 10),
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                      overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                  onPressed: isPrintingCloseShift
                      ? null
                      : () async {
                          try {
                            setState(() {
                              isPrintingCloseShift = true;
                            });
                            if (tcsr1 == null) throw "Shift not found";
                            if (tcsr1?.closedApproveById == null) throw "Shift has no approval";
                            final UserEntity? approverUser = await GetIt.instance<AppDatabase>()
                                .userDao
                                .readByDocId(tcsr1!.closedApproveById!, null);
                            if (approverUser == null) throw "Approver not found";

                            EmployeeEntity? approverEmployee;
                            if (approverUser.tohemId != null) {
                              approverEmployee =
                                  await GetIt.instance<EmployeeRepository>().getEmployee(approverUser.tohemId!);
                            }
                            await GetIt.instance<PrintCloseShiftUsecase>().call(
                              printType: 2,
                              params: PrintCloseShiftUsecaseParams(
                                cashierBalanceTransactionEntity: tcsr1!,
                                totalCashSales: Helpers.revertMoneyToDecimalFormat(totalCash),
                                expectedCash: expectedCash,
                                totalNonCashSales: Helpers.revertMoneyToDecimalFormat(totalNonCash),
                                totalSales: Helpers.revertMoneyToDecimalFormat(totalSales),
                                cashReceived: tcsr1!.calcValue,
                                difference: tcsr1!.calcValue - expectedCash,
                                approverName: approverEmployee?.empName ?? approverUser.username,
                                transactions: transactions.length,
                                transactionsReturn: transactionsReturn.length,
                                transactionsTopmt: transactionsTopmt,
                                transactionsMOP: transactionsMOP,
                              ),
                            );
                            setState(() {
                              isPrintingCloseShift = false;
                            });
                          } catch (e) {
                            setState(() {
                              isPrintingCloseShift = false;
                            });
                            if (context.mounted) {
                              SnackBarHelper.presentErrorSnackBar(context, e.toString());
                            }
                          }
                        },
                  child: Center(
                    child: isPrintingCloseShift
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator.adaptive(
                                // backgroundColor: Colors.white,
                                ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.print_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Reprint\nClose Shift",
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    // TextSpan(
                                    //   text: "  (F12)",
                                    //   style: TextStyle(fontWeight: FontWeight.w300),
                                    // ),
                                  ],
                                  style: TextStyle(height: 1, fontSize: 10),
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(height: 10),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Closed At",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                formattedCloseDate,
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
                "Approved By",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                approver,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const Divider(
          height: 30,
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
                formattedExpectedCash,
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
        const SizedBox(height: 10),
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
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Invoice Count (All)",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                transactions.length.toString(),
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
                "Invoice Count (Return)",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                transactionsReturn.length.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const Divider(
          height: 30,
          color: Colors.grey,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "MOP Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (transactionsTopmt.isEmpty && transactionsMOP.isEmpty)
                ? const Expanded(
                    child: Center(
                      child: EmptyList(
                        imagePath: "assets/images/empty-search.svg",
                        sentence: "No transactions happened on this shift",
                        height: 200,
                      ),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(transactionsTopmt.length, (index) {
                          List<List<dynamic>> tableData = [];

                          final filteredTransactions = transactionsMOP.where((transaction) {
                            return transaction['topmtId'] == transactionsTopmt[index].docId;
                          }).toList();

                          if (filteredTransactions.isNotEmpty) {
                            double totalAmount = filteredTransactions.fold(0, (sum, transaction) {
                              return sum + (transaction['amount'] ?? 0);
                            });

                            tableData = filteredTransactions
                                .asMap()
                                .map((i, transaction) {
                                  return MapEntry(i, [
                                    (i + 1).toString(),
                                    transaction['description'] ?? '',
                                    Helpers.parseMoney(transaction['amount']),
                                  ]);
                                })
                                .values
                                .toList();

                            tableData.add([
                              '',
                              'Total',
                              Helpers.parseMoney(totalAmount),
                            ]);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transactionsTopmt[index].description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 222, 220, 220),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Table Header
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: ProjectColors.primary,
                                              ),
                                              child: Row(
                                                children: tableHeader.map((header) {
                                                  return Container(
                                                    width: 275,
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      header,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            // Table Data
                                            Column(
                                              children: tableData.map((row) {
                                                bool isLastRow = row == tableData.last;
                                                return Row(
                                                  children: row.map<Widget>((cell) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        border: const Border.symmetric(
                                                          horizontal: BorderSide(
                                                            width: 0.5,
                                                            color: Color.fromARGB(255, 222, 220, 220),
                                                          ),
                                                        ),
                                                        color: isLastRow
                                                            ? const Color.fromARGB(255, 220, 220, 220)
                                                            : const Color.fromARGB(255, 240, 240, 240),
                                                      ),
                                                      width: 275,
                                                      height: 40,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        cell.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight: isLastRow ? FontWeight.bold : FontWeight.w500,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
          ],
        ),
        const Divider(
          height: 30,
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        // const SizedBox(height: 10),
        RecapMoneyDialog(
          tcsr1Id: shiftId,
          setTotal: updateTotalCash,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Total Actual Cash",
                style: TextStyle(
                  fontSize: 16,
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
                Helpers.parseMoney(calculatedTotalCash),
                style: const TextStyle(
                  fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Helpers.revertMoneyToDecimalFormat(difference.toString()) < 0
                        ? Colors.red
                        : Helpers.revertMoneyToDecimalFormat(difference.toString()) > 0
                            ? Colors.orange
                            : Colors.green,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Helpers.revertMoneyToDecimalFormat(difference.toString()) < 0
                      ? Icons.warning_amber_rounded
                      : Helpers.revertMoneyToDecimalFormat(difference.toString()) > 0
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outlined,
                  color: Helpers.revertMoneyToDecimalFormat(difference.toString()) < 0
                      ? Colors.red
                      : Helpers.revertMoneyToDecimalFormat(difference.toString()) > 0
                          ? Colors.orange
                          : Colors.green,
                  size: 16,
                ),
              ],
            ),
            const Expanded(
              child: Text(""),
            ),
            Text(
              Helpers.parseMoney(difference),
              style: TextStyle(
                height: 1,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Helpers.revertMoneyToDecimalFormat(difference.toString()) < 0
                    ? Colors.red
                    : Helpers.revertMoneyToDecimalFormat(difference.toString()) > 0
                        ? Colors.orange
                        : Colors.green,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: CustomButton(
              child: const Text("OK"),
              onTap: () async {
                if (!context.mounted) return;
                Navigator.pop(context);
              }),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
