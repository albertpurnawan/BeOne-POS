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
  final tableHead = ["No", "Date", "Shift", "Cashier", "Amount"];
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
                    "Report By Shift",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Table(
                    border: TableBorder.all(color: Colors.transparent, width: 1),
                    columnWidths: const {
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(80),
                      2: FlexColumnWidth(100),
                      3: FlexColumnWidth(100),
                      4: FlexColumnWidth(80),
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
                                      transDate,
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
                                      "Rp ${Helpers.parseMoney(shift['grandtotal'])},00",
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
