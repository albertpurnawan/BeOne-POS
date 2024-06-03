import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';

class TableReportItem extends StatefulWidget {
  const TableReportItem({super.key});

  @override
  State<TableReportItem> createState() => _TableReportItemState();
}

class _TableReportItemState extends State<TableReportItem> {
  final tableHead = ["No", "Item", "Description", "Quantity", "Amount"];
  List<Map<String, dynamic>> shiftsWithUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final fetchedShifts = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readAll();
    List<Map<String, dynamic>> fetchedShiftsWithUsers = [];

    for (var shift in fetchedShifts) {
      final user = await GetIt.instance<AppDatabase>()
          .userDao
          .readByDocId(shift.tousrId!, null);
      if (user != null) {
        fetchedShiftsWithUsers.add({
          'shift': shift,
          'user': user,
        });
      }
    }

    setState(() {
      shiftsWithUsers = fetchedShiftsWithUsers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Report By Item",
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
                      color: ProjectColors.primary,
                      width: 1,
                    ),
                    columnWidths: const {
                      0: FixedColumnWidth(40),
                      1: FlexColumnWidth(100),
                      2: FlexColumnWidth(100),
                      3: FlexColumnWidth(100),
                      4: FlexColumnWidth(100),
                    },
                    children: [
                      TableRow(
                        children: tableHead.map((header) {
                          return TableCell(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                              child: Text(
                                header,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: ProjectColors.primary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      ...shiftsWithUsers.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final shift = entry.value['shift']
                            as CashierBalanceTransactionModel;
                        final user = entry.value['user'] as UserModel;
                        return TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  index.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Helpers.formatDate(shift.openDate),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  shift.docNum,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Helpers.parseMoney(shift.closeValue),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
