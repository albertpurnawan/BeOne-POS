import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';

class TableReportShift extends StatefulWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? searchQuery;

  const TableReportShift({
    Key? key,
    this.fromDate,
    this.toDate,
    this.searchQuery,
  }) : super(key: key);

  @override
  State<TableReportShift> createState() => _TableReportShiftState();
}

class _TableReportShiftState extends State<TableReportShift> {
  final tableHead = ["No", "Date", "Shift", "Cashier", "Amount"];
  List<InvoiceHeaderModel>? fetched;
  bool isLoading = true;
  List<CashierBalanceTransactionModel?> tcsr1Data = [];
  List<UserModel?> userData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (widget.fromDate == null || widget.toDate == null) {
      return;
    }

    final tcsr1IdConvert = await _convertDocNumToDocId(widget.searchQuery!);

    final fetchedInvoice = await GetIt.instance<AppDatabase>()
        .invoiceHeaderDao
        .readBetweenDate(
            widget.fromDate!, widget.toDate!, tcsr1IdConvert[0]!.docId);

    if (fetchedInvoice != null) {
      final List<Future<CashierBalanceTransactionModel?>> invFetched =
          fetchedInvoice.map((invoice) async {
        return await GetIt.instance<AppDatabase>()
            .cashierBalanceTransactionDao
            .readByDocId(invoice.tcsr1Id!, null);
      }).toList();

      tcsr1Data = await Future.wait(invFetched);

      final List<Future<UserModel?>> userFetched = tcsr1Data.map((shift) async {
        if (shift != null) {
          return await GetIt.instance<AppDatabase>()
              .userDao
              .readByDocId(shift.tousrId!, null);
        }
      }).toList();

      userData = await Future.wait(userFetched);

      setState(() {
        fetched = fetchedInvoice;
        isLoading = false;
      });
    }
  }

  Future<List<CashierBalanceTransactionModel?>> _convertDocNumToDocId(
      String docNum) async {
    final tcsr1Id = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readByDocNum(docNum, null);
    log("tcsr1Id convert - $tcsr1Id");
    return tcsr1Id;
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;
    double taxAmount = 0.0;
    double totalDiscount = 0.0;
    double grandTotal = 0.0;

    if (fetched != null) {
      totalAmount = fetched!
          .map((shift) => shift.subTotal)
          .fold(0.0, (previous, current) => previous + current);
      taxAmount = fetched!
          .map((shift) => shift.taxAmount)
          .fold(0.0, (previous, current) => previous + current);
      totalDiscount = fetched!
          .map((shift) => shift.discAmount)
          .fold(0.0, (previous, current) => previous + current);
      grandTotal = fetched!
          .map((shift) => shift.grandTotal)
          .fold(0.0, (previous, current) => previous + current);
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Report By Shift",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Table(
                    border:
                        TableBorder.all(color: Colors.transparent, width: 1),
                    columnWidths: const {
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(80),
                      2: FlexColumnWidth(100),
                      3: FlexColumnWidth(100),
                      4: FlexColumnWidth(80),
                    },
                    children: [
                      TableRow(
                        decoration:
                            const BoxDecoration(color: ProjectColors.primary),
                        children: tableHead.map((header) {
                          return TableCell(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    header,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      ...fetched!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final shift = entry.value;
                        final isLastRow = index == fetched!.length - 1;
                        final shiftName =
                            tcsr1Data.isNotEmpty && tcsr1Data[index] != null
                                ? tcsr1Data[index]!.docNum
                                : 'N/A';
                        final userName =
                            userData.isNotEmpty && userData[index] != null
                                ? userData[index]!.username
                                : 'N/A';

                        return TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isLastRow
                                        ? const BorderSide(
                                            color: ProjectColors.primary,
                                            width: 2.0)
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isLastRow
                                        ? const BorderSide(
                                            color: ProjectColors.primary,
                                            width: 2.0)
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      Helpers.formatDate(shift.transDateTime!),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isLastRow
                                        ? const BorderSide(
                                            color: ProjectColors.primary,
                                            width: 2.0)
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      shiftName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isLastRow
                                        ? const BorderSide(
                                            color: ProjectColors.primary,
                                            width: 2.0)
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isLastRow
                                        ? const BorderSide(
                                            color: ProjectColors.primary,
                                            width: 2.0)
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Rp ${Helpers.parseMoney(shift.subTotal)},00",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total Amount:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp ${Helpers.parseMoney(totalAmount)},00',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Tax Amount:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp ${Helpers.parseMoney(taxAmount)},00',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total Discount:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp ${Helpers.parseMoney(totalDiscount)},00',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Grand Total:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp ${Helpers.parseMoney(grandTotal)},00',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total Data:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${fetched?.length}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
