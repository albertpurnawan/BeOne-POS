import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/close_shift.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/open_shift.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pushNamed(RouteConstants.home),
        ),
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
                borderRadius: BorderRadius.circular(5),
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
    final bool hasActiveShift = activeShift != null;

    if (!hasActiveShift) {
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
                const Text(
                  "NO ACTIVE SHIFT",
                  style: TextStyle(
                      color: ProjectColors.mediumBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                CustomButton(
                  color: const Color.fromARGB(255, 47, 143, 8),
                  child: const Text("OPEN SHIFT"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OpenShiftDialog(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    String formattedOpenDate =
        Helpers.formatDateNoSeconds(activeShift!.openDate);
    final cashier = prefs.getString('username');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 200.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 222, 222),
          borderRadius: BorderRadius.circular(5),
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
                        color: ProjectColors.primary,
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
                                  color: Color.fromARGB(255, 47, 143, 8),
                                  fontWeight: FontWeight.w700),
                            )
                          : const Text(
                              "CLOSED",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
              activeShift!.approvalStatus == 0
                  ? CustomButton(
                      color: ProjectColors.primary,
                      child: const Text("CLOSE SHIFT"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CloseShiftScreen(shiftId: activeShift!.docId),
                          ),
                        );
                      },
                    )
                  : CustomButton(
                      color: const Color.fromARGB(255, 47, 143, 8),
                      child: const Text("OPEN SHIFT"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OpenShiftDialog()));
                      },
                    ),
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

    // Sort the entries by date in descending order
    List<MapEntry<String, List<CashierBalanceTransactionModel>>> sortedEntries =
        groupedShifts.entries.toList()..sort((a, b) => b.key.compareTo(a.key));

    // Sort shifts within each group by date in descending order
    for (var entry in sortedEntries) {
      entry.value.sort((a, b) => b.openDate.compareTo(a.openDate));
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
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var entry in sortedEntries)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key, // Display date
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            for (var shift in entry.value)
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          shift.docNum,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            NumberFormat.decimalPattern()
                                                .format(
                                                    shift.closeValue.toInt()),
                                            style:
                                                const TextStyle(fontSize: 18),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        if (shift.approvalStatus == 0)
                                          const SizedBox(
                                            width: 100,
                                            child: Text(
                                              'OPEN',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 47, 143, 8),
                                              ),
                                            ),
                                          )
                                        else
                                          const SizedBox(
                                            width: 100,
                                            child: Text(
                                              'CLOSED',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CloseShiftScreen(
                                                  shiftId: shift.docId),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.arrow_right_outlined,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
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
