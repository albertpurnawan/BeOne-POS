import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';

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
  final tableHead = ["Date", "Shift", "Invoice", "Cashier", "Amount", ""];
  List<dynamic>? fetched;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(TableReportShift oldWidget) {
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

    final fetchedInvoice =
        await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByUserBetweenDate(widget.fromDate!, widget.toDate!);

    // Apply Search Query
    if (fetchedInvoice != null) {
      final filteredInvoice = fetchedInvoice.where((invoice) {
        return invoice['docnum'].toLowerCase().contains(widget.searchQuery!.toLowerCase()) ||
            invoice['username'].toLowerCase().contains(widget.searchQuery!.toLowerCase()) ||
            invoice['invdocnum'].toLowerCase().contains(widget.searchQuery!.toLowerCase()) ||
            invoice['transdate'].toLowerCase().contains(widget.searchQuery!.toLowerCase());
      }).toList();
      setState(() {
        fetched = filteredInvoice;
        isLoading = false;
      });
    } else {
      setState(() {
        fetched = fetchedInvoice;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double grandTotal = 0.0;

    if (fetched != null) {
      grandTotal = fetched!.map((shift) => shift['grandtotal']).fold(0.0, (previous, current) => previous + current);
      // log("grandTotal - $grandTotal");
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Report By Invoice",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Table(
                    border: TableBorder.all(color: Colors.transparent, width: 1),
                    columnWidths: const {
                      0: FixedColumnWidth(200),
                      1: FlexColumnWidth(70),
                      2: FlexColumnWidth(70),
                      3: FlexColumnWidth(30),
                      4: FlexColumnWidth(50),
                      5: FlexColumnWidth(15),
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
                        final shiftName = shift['docnum'];
                        final userName = shift['username'];

                        final transDate = "${shift['transdate']} ${shift['transtime']}";
                        final dateTime = DateTime.parse(transDate);
                        final gmt = shift['timezone'];
                        final offsetHours = int.parse(gmt.substring(3));
                        final offsetSign = gmt[3];
                        final offset = Duration(hours: offsetSign == '+' ? offsetHours : -offsetHours);
                        final adjustedDateTime = dateTime.add(offset);
                        final formattedTransDate = Helpers.dateddMMMyyyyHHmmss(adjustedDateTime);

                        final docnum = shift['invdocnum'];

                        return TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                height: 55,
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
                                      formattedTransDate,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                height: 55,
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
                                      shiftName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                height: 55,
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
                                      docnum,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                height: 55,
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
                                      userName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                height: 55,
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
                                      "Rp ${Helpers.parseMoney(shift['grandtotal'])}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                  height: 55,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: isLastRow
                                          ? const BorderSide(color: ProjectColors.primary, width: 2.0)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.print_outlined, size: 20),
                                      onPressed: () {
                                        log("invoice - $docnum");
                                      },
                                    ),
                                  )),
                            ),
                          ],
                        );
                      }).toList(),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              height: 55,
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 55,
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 55,
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 55,
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
                              height: 55,
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp ${Helpers.parseMoney(grandTotal)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              height: 55,
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 55,
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 55,
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 55,
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
                              height: 55,
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
                          TableCell(
                            child: Container(),
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
