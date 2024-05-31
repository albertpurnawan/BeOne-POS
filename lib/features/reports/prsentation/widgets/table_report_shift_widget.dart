import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';

class TableReportShift extends StatefulWidget {
  final DateTime? fromDate;
  final DateTime? toDate;

  const TableReportShift({
    Key? key,
    this.fromDate,
    this.toDate,
  }) : super(key: key);

  @override
  State<TableReportShift> createState() => _TableReportShiftState();
}

class _TableReportShiftState extends State<TableReportShift> {
  final tableHead = ["No", "Date", "Shift", "Cashier", "Amount"];
  List<InvoiceHeaderModel>? fetched;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (widget.fromDate == null || widget.toDate == null) {
      return;
    } else {
      final fetchedInvoice = await GetIt.instance<AppDatabase>()
          .invoiceHeaderDao
          .readBetweenDate(
              widget.fromDate!,
              widget.toDate!
                  .add(const Duration(days: 1))
                  .subtract(const Duration(seconds: 1)));
      log("fetchedInvoice - $fetchedInvoice");
      setState(() {
        fetched = fetchedInvoice;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;

    if (fetched != null) {
      totalAmount = fetched!
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
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Table(
                    border: TableBorder.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    columnWidths: const {
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(80),
                      2: FlexColumnWidth(100),
                      3: FlexColumnWidth(100),
                      4: FlexColumnWidth(80),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: ProjectColors.primary,
                        ),
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
                      ...fetched!.map((shift) {
                        final index = fetched!.indexOf(shift) + 1;
                        return TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      index.toString(),
                                      style: const TextStyle(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      Helpers.formatDate(shift.transDateTime!),
                                      style: const TextStyle(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      shift.tcsr1Id!,
                                      style: const TextStyle(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      shift.tohemId!,
                                      style: const TextStyle(
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
                                      "Rp ${Helpers.parseMoney(shift.grandTotal)},00",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
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
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                              width: 2,
                              color: ProjectColors.primary,
                            ))),
                            child: TableCell(
                              child: Container(),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                              width: 2,
                              color: ProjectColors.primary,
                            ))),
                            child: TableCell(
                              child: Container(),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                              width: 2,
                              color: ProjectColors.primary,
                            ))),
                            child: TableCell(
                              child: Container(),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                              width: 2,
                              color: ProjectColors.primary,
                            ))),
                            child: TableCell(
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
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                              width: 2,
                              color: ProjectColors.primary,
                            ))),
                            child: TableCell(
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
