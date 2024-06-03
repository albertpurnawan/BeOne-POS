import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/reports/prsentation/widgets/table_report_item_widget.dart';
import 'package:pos_fe/features/reports/prsentation/widgets/table_report_mop_widget.dart';
import 'package:pos_fe/features/reports/prsentation/widgets/table_report_shift_widget.dart';

class FiltereReportScreen extends StatefulWidget {
  const FiltereReportScreen({super.key});

  @override
  State<FiltereReportScreen> createState() => _FiltereReportScreenState();
}

class _FiltereReportScreenState extends State<FiltereReportScreen> {
  final List<String> filterOptions = ["Invoice", "MOP", "Item"];
  String? selectedFilter;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedFromDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    selectedToDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
  }

  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? selectedFromDate ?? DateTime.now()
          : selectedToDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          selectedFromDate = picked;
        } else {
          selectedToDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Reports'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.13,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Text(
                                    "From",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 30,
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => selectDate(context, true),
                                  child: SizedBox(
                                    width: 300,
                                    height: 30,
                                    child: Text(
                                      selectedFromDate == null
                                          ? Helpers.dateToString(
                                              DateTime.now().toLocal())
                                          : '${selectedFromDate!.toLocal()}'
                                              .split(' ')[0],
                                      style: TextStyle(
                                        color: ProjectColors.mediumBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20), // Add spacing between rows
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Text(
                                    "To",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 30,
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => selectDate(context, false),
                                  child: SizedBox(
                                    width: 300,
                                    height: 30,
                                    child: Text(
                                      selectedToDate == null
                                          ? Helpers.dateToString(
                                              DateTime.now().toLocal())
                                          : '${selectedToDate!.toLocal()}'
                                              .split(' ')[0],
                                      style: TextStyle(
                                        color: ProjectColors.mediumBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20), // Add space between columns
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Text(
                                    "Report By",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 30,
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 30,
                                  child: DropdownButton<String>(
                                    value: selectedFilter,
                                    isExpanded: true,
                                    icon: null,
                                    elevation: 18,
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    underline: SizedBox(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedFilter = newValue!;
                                      });
                                    },
                                    items: filterOptions
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(
                                  width: 420,
                                  height: 30,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 8),
                                      border: OutlineInputBorder(),
                                      hintText: 'Search...',
                                      hintStyle: TextStyle(
                                        color: ProjectColors.mediumBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    onChanged: (value) {
                                      // Add search logic here
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Container(
                  width: double.infinity,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: ProjectColors.primary,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: selectedFilter == "Invoice"
                      ? TableReportShift(
                          fromDate: selectedFromDate,
                          toDate: selectedToDate,
                        )
                      : selectedFilter == "MOP"
                          ? const TableReportMop()
                          : selectedFilter == "Item"
                              ? const TableReportItem()
                              : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
