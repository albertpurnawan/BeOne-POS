import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';

class MOPAdjustmentScreen extends StatefulWidget {
  const MOPAdjustmentScreen({super.key});

  @override
  State<MOPAdjustmentScreen> createState() => _MOPAdjustmentScreenState();
}

class _MOPAdjustmentScreenState extends State<MOPAdjustmentScreen> {
  List<String> mop1Options = [];
  List<String> mop2Options = [];
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  String? selectedMOP1;
  String? selectedMOP2;
  String? mop1;
  String? mop2;
  TextEditingController mop1Controller = TextEditingController();
  TextEditingController mop2Controller = TextEditingController();

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
  void initState() {
    super.initState();
    getMops();
  }

  Future<void> getMops() async {
    final mops =
        await GetIt.instance<AppDatabase>().meansOfPaymentDao.readAll();
    for (final mop in mops) {
      final desc = mop.description;
      mop1Options.add(desc);
      mop2Options.add(desc);
    }

    setState(() {});
  }

  @override
  void dispose() {
    mop1Controller.dispose();
    mop2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: const Text('MOP Adjustment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Text(
                  "DocId",
                  style: TextStyle(
                    color: ProjectColors.mediumBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: Text(
                              "Date",
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
                              width: 200,
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
                    ),
                    SizedBox(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: Text(
                              "Cashier",
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
                            width: 200,
                            height: 30,
                            child: Text(
                              "CashierName",
                              style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: Text(
                              "Shift",
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
                            width: 100,
                            height: 30,
                            child: Text(
                              "ShiftId",
                              style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "MOP 1",
                            style: TextStyle(
                              color: ProjectColors.mediumBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: DropdownButton<String>(
                              value: selectedMOP1,
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
                                  selectedMOP1 = newValue!;
                                });
                              },
                              items: mop1Options.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            width: 420,
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: mop1Controller,
                                inputFormatters: [MoneyInputFormatter()],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8),
                                  border: OutlineInputBorder(),
                                  hintText: '0',
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
                                  mop1 = mop1Controller.text;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "MOP 2",
                            style: TextStyle(
                              color: ProjectColors.mediumBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: DropdownButton<String>(
                              value: selectedMOP2,
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
                                  selectedMOP2 = newValue!;
                                });
                              },
                              items: mop1Options.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            width: 420,
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: mop2Controller,
                                inputFormatters: [MoneyInputFormatter()],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8),
                                  border: OutlineInputBorder(),
                                  hintText: '0',
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
                                  mop2 = mop2Controller.text;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
