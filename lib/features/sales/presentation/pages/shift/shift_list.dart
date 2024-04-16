import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/close_shift.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftsList extends StatefulWidget {
  const ShiftsList({Key? key}) : super(key: key);

  @override
  State<ShiftsList> createState() => _ShiftsListState();
}

class _ShiftsListState extends State<ShiftsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.primary,
      appBar: AppBar(
        title: const Text('Shifts'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ActiveShift(),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 222, 222),
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 4,
              width: 875,
            ),
            const SizedBox(height: 10),
            const AllShift(),
          ],
        ),
      ),
    );
  }
}

class ActiveShift extends StatefulWidget {
  const ActiveShift({Key? key}) : super(key: key);

  @override
  State<ActiveShift> createState() => _ActiveShiftState();
}

class _ActiveShiftState extends State<ActiveShift> {
  CashierBalanceTransactionModel? activeShift;
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    fetchActiveShift();
  }

  Future<void> fetchActiveShift() async {
    final shift = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readLastValue();
    setState(() {
      activeShift = shift;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedOpenDate =
        Helpers.formatDateNoSeconds(activeShift!.openDate);
    final cashier = prefs.getString('username');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 200.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 222, 222),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    formattedOpenDate,
                    style: const TextStyle(
                        color: ProjectColors.swatch,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        cashier!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 50),
                      activeShift!.approvalStatus == 0
                          ? const Text(
                              "OPEN",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 47, 143, 8)),
                            )
                          : const Text(
                              "CLOSED",
                              style: TextStyle(fontSize: 20),
                            ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
              CustomButton(
                color: ProjectColors.swatch,
                child: const Text("CLOSE SHIFT"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EndShiftScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AllShift extends StatefulWidget {
  const AllShift({Key? key}) : super(key: key);

  @override
  State<AllShift> createState() => _AllShiftState();
}

class _AllShiftState extends State<AllShift> {
  List<CashierBalanceTransactionModel>? allShift;
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    fetchActiveShift();
  }

  Future<void> fetchActiveShift() async {
    final shifts = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readAll();
    setState(() {
      allShift = shifts;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Group shifts by date
    Map<String, List<CashierBalanceTransactionModel>> groupedShifts = {};
    if (allShift != null) {
      for (var shift in allShift!) {
        final formattedDate = Helpers.dateEEddMMMyyy(shift.openDate);
        String date = formattedDate;
        if (!groupedShifts.containsKey(date)) {
          groupedShifts[date] = [];
        }
        groupedShifts[date]!.add(shift);
      }
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight - 40,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 222, 222),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var entry in groupedShifts.entries)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${entry.key}', // Display date
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Display shifts for this date
                            for (var shift in entry.value)
                              Text(
                                'Shift ID: ${shift.docNum}', // Display shift ID or any relevant information
                              ),
                            SizedBox(height: 20),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
