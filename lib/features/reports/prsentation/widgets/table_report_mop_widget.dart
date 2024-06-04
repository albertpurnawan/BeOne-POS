import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
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
  List<MeansOfPaymentModel?> tpmt1Data = [];
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

      final List<Future<MeansOfPaymentModel?>> tpmt1Fetched =
          tpmt3Data.map((tpmt3) async {
        if (tpmt3 != null) {
          return await GetIt.instance<AppDatabase>()
              .meansOfPaymentDao
              .readByDocId(tpmt3.tpmt1Id!, null);
        }
      }).toList();

      tpmt1Data = await Future.wait(tpmt1Fetched);
      log("${toinvData.length} - $toinvData");
      setState(() {
        fetched = fetchedTinv2;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> aggregatedData = {};
    for (int i = 0; i < tpmt3Data.length; i++) {
      if (tpmt3Data[i] != null && toinvData[i] != null) {
        final mopId = tpmt1Data[i]?.docId ?? 'N/A';
        final mopDesc = tpmt1Data[i]?.description ?? 'N/A';
        final subTotal = fetched![i].amount;

        if (aggregatedData.containsKey(mopId)) {
          aggregatedData[mopId]!['amount'] += subTotal;
        } else {
          aggregatedData[mopId] = {'description': mopDesc, 'amount': subTotal};
        }
      }
    }
    double totalAmount = toinvData
        .map((data) => data!.totalPayment)
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

    final lastAggregatedIndex = aggregatedData.length - 1;
    final aggregatedKeys = aggregatedData.keys.toList();

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
                      ...aggregatedData.entries.map((entry) {
                        final index = aggregatedKeys.indexOf(entry.key);
                        final isLastRow = index == lastAggregatedIndex;
                        final mopId = entry.key;
                        final mopDesc = entry.value['description'] as String;
                        final amount = entry.value['amount'] as double;

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
                                      mopId,
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
                                      mopDesc,
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
                                      "Rp ${Helpers.parseMoney(amount)},00",
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
                                    '${toinvData.length}',
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
