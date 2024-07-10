import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';

class TableReportItem extends StatefulWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? searchQuery;

  const TableReportItem({
    Key? key,
    this.fromDate,
    this.toDate,
    this.searchQuery,
  }) : super(key: key);

  @override
  State<TableReportItem> createState() => _TableReportItemState();
}

class _TableReportItemState extends State<TableReportItem> {
  final tableHead = ["No", "Item", "Description", "Quantity", "Amount"];
  List<dynamic>? fetched;
  List<InvoiceHeaderModel>? fetchedInvHeader;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(TableReportItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.fromDate != widget.fromDate ||
        oldWidget.toDate != widget.toDate) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (widget.fromDate == null || widget.toDate == null) {
      return;
    }

    final fetchedTinv1 =
        await GetIt.instance<AppDatabase>().invoiceDetailDao.readByItemBetweenDate(widget.fromDate!, widget.toDate!);
    log("fetchedTinv1 - $fetchedTinv1");
    // final fetchedToinv = await GetIt.instance<AppDatabase>()
    //     .invoiceHeaderDao
    //     .readBetweenDate(widget.fromDate!, widget.toDate!);
    // log("fetchedToinv - $fetchedToinv");

    // Apply Search Query
    if (fetchedTinv1 != null) {
      final filteredTinv1 = fetchedTinv1.where((invoice) {
        return invoice['itemcode'].toLowerCase().contains(widget.searchQuery!.toLowerCase()) ||
            invoice['itemname'].toLowerCase().contains(widget.searchQuery!.toLowerCase());
      }).toList();
      setState(() {
        fetched = filteredTinv1;
        // fetchedInvHeader = fetchedToinv;
        isLoading = false;
      });
    } else {
      setState(() {
        fetched = fetchedTinv1;
        // fetchedInvHeader = fetchedToinv;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;
    double taxAmount = 0.0;
    double totalDiscount = 0.0;
    double grandTotal = 0.0;

    if (fetched != null) {
      for (var item in fetched!) {
        double itemTotalAmount = item['totalamount'] * (100 / (100 + item['taxprctg'])) as double;
        double itemTaxAmount = item['taxamount'] * (100 / (100 + item['taxprctg'])) as double;
        double itemTotalDiscount = item['discamount'] as double;
        totalAmount += itemTotalAmount;
        taxAmount += itemTaxAmount;
        totalDiscount += itemTotalDiscount;
      }
      grandTotal = totalAmount + taxAmount;
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Report By Item",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Table(
                          border: TableBorder.all(color: Colors.transparent, width: 1),
                          columnWidths: const {
                            0: FixedColumnWidth(50),
                            1: FlexColumnWidth(80),
                            2: FlexColumnWidth(170),
                            3: FlexColumnWidth(50),
                            4: FlexColumnWidth(50),
                          },
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(color: ProjectColors.primary),
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
                                            fontWeight: FontWeight.w500,
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
                              final item = entry.value;
                              final isLastRow = index == fetched!.length - 1;
                              final itemCode = item['itemcode'];
                              final itemName = item['itemname'];
                              final quantity = item['totalquantity'];
                              final taxPercentage = item['taxprctg'];
                              final itemAmount = item['totalamount'] * (100 / (100 + taxPercentage));

                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: isLastRow
                                              ? const BorderSide(color: ProjectColors.primary, width: 2.0)
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
                                              ? const BorderSide(color: ProjectColors.primary, width: 2.0)
                                              : BorderSide.none,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            itemCode,
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
                                              ? const BorderSide(color: ProjectColors.primary, width: 2.0)
                                              : BorderSide.none,
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          itemName,
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: isLastRow
                                              ? const BorderSide(color: ProjectColors.primary, width: 2.0)
                                              : BorderSide.none,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            quantity.toString(),
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
                                              ? const BorderSide(color: ProjectColors.primary, width: 2.0)
                                              : BorderSide.none,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Rp ${Helpers.parseMoney(itemAmount.round())}.00",
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            // Total Amount Row
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
                                            fontWeight: FontWeight.w500,
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
                                          'Rp ${Helpers.parseMoney(totalAmount.round())}.00',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Total Tax
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
                                          'Total Tax:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
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
                                          'Rp ${Helpers.parseMoney(taxAmount.round())}.00',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Total Discount
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
                                            fontWeight: FontWeight.w500,
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
                                          'Rp ${Helpers.parseMoney(totalDiscount)}.00',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Grand Total
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
                                          'Rp ${Helpers.parseMoney(grandTotal)}.00',
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
                            // Total Data Row
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
