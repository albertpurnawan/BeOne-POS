import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/mop_by_store.dart';
import 'package:pos_fe/features/sales/data/models/pay_means.dart';

class TableReportMop extends StatefulWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? searchQuery;

  const TableReportMop({
    Key? key,
    this.fromDate,
    this.toDate,
    this.searchQuery,
  }) : super(key: key);

  @override
  State<TableReportMop> createState() => _TableReportMopState();
}

class _TableReportMopState extends State<TableReportMop> {
  final tableHead = ["No", "MOP", "Description", "Amount"];
  bool isLoading = true;
  List<PayMeansModel>? fetched;
  List<MOPByStoreModel?> tpmt3Data = [];
  List<InvoiceHeaderModel?> toinvData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (widget.fromDate == null || widget.toDate == null) {
      return;
    }

    final fetchedTinv2 = await GetIt.instance<AppDatabase>()
        .payMeansDao
        .readBetweenDate(widget.fromDate!, widget.toDate!);

    if (fetchedTinv2 != null) {
      final List<Future<MOPByStoreModel?>> mopFetched =
          fetchedTinv2.map((mop) async {
        log("$mop");
        return await GetIt.instance<AppDatabase>()
            .mopByStoreDao
            .readByDocId(mop.tpmt3Id!, null);
      }).toList();

      tpmt3Data = await Future.wait(mopFetched);

      final List<Future<InvoiceHeaderModel?>> invFetched =
          fetchedTinv2.map((data) async {
        return await GetIt.instance<AppDatabase>()
            .invoiceHeaderDao
            .readByDocId(data.toinvId!, null);
      }).toList();

      toinvData = await Future.wait(invFetched);

      // log("fetchedTinv2 - $fetchedTinv2");
      // log("toinvData - $toinvData");
      log("tpmt3Data - $tpmt3Data");
      setState(() {
        fetched = fetchedTinv2;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = toinvData
        .map((data) => data!.subTotal)
        .fold(0.0, (previous, current) => previous + current);
    double taxAmount = toinvData
        .map((data) => data!.taxAmount)
        .fold(0.0, (previous, current) => previous + current);
    double totalDiscount = toinvData
        .map((data) => data!.discAmount)
        .fold(0.0, (previous, current) => previous + current);
    double grandTotal = toinvData
        .map((data) => data!.grandTotal)
        .fold(0.0, (previous, current) => previous + current);
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Report By Means of Payment",
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
                      ...tpmt3Data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        final isLastRow = index == tpmt3Data.length - 1;
                        final mopName = data?.docId ?? 'N/A';
                        // final description = data?.description ?? 'N/A';

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
                                      mopName,
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
                                      "description",
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
                                      "Rp ${Helpers.parseMoney(12)},00",
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
                                    'Rp ${Helpers.parseMoney(12)},00',
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
                                    'Rp ${Helpers.parseMoney(12)},00',
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
                                    'Rp ${Helpers.parseMoney(12)},00',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
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
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Grand Total:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
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
                                    'Rp ${Helpers.parseMoney(12)},00',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
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
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total Data:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
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
                                    '${fetched!.length}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
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
