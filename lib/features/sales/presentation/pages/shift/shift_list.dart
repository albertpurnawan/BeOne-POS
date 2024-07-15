import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/home/presentation/widgets/confirm_queued_invoice_dialog.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/confirm_to_end_shift.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/open_shift.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/recap_shift.dart';
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
      backgroundColor: ProjectColors.background,
      appBar: AppBar(
        title: const Text('Shifts'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pushNamed(RouteConstants.home),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ActiveShift(),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 75),
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),
            AllShift(),
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
    final shift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readLastValue();
    setState(() {
      activeShift = shift;
    });
  }

  Future<bool> checkQueuedInvoice() async {
    final invoice = await GetIt.instance<AppDatabase>().queuedInvoiceHeaderDao.readAll();
    if (invoice.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasActiveShift = activeShift != null;

    if (!hasActiveShift) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        child: Container(
          decoration: BoxDecoration(
            color: null,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "NO ACTIVE SHIFT",
                  style: TextStyle(color: ProjectColors.mediumBlack, fontSize: 24, fontWeight: FontWeight.bold),
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

    String formattedOpenDate = Helpers.formatDateNoSeconds(activeShift!.openDate);
    final cashier = prefs.getString('username');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75.0),
      child: Container(
        decoration: BoxDecoration(
          color: null,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    formattedOpenDate,
                    style: const TextStyle(color: ProjectColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
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
                                  fontSize: 20, color: Color.fromARGB(255, 47, 143, 8), fontWeight: FontWeight.w700),
                            )
                          : const Text(
                              "CLOSED",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                      onTap: () async {
                        final checkInv = await checkQueuedInvoice();
                        if (checkInv == true) {
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const ConfirmQueuedInvoiceDialog(),
                          );
                        } else {
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ConfirmToEndShift(activeShift!),
                          );
                        }
                      },
                    )
                  : CustomButton(
                      color: const Color.fromARGB(255, 47, 143, 8),
                      child: const Text("OPEN SHIFT"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OpenShiftDialog()));
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
  CashierBalanceTransactionModel? activeShift;
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    fetchActiveShift();
  }

  Future<void> fetchActiveShift() async {
    final shifts = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readAll();
    final shift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readLastValue();

    setState(() {
      allShift = shifts;
      activeShift = shift;
    });
  }

  @override
  Widget build(BuildContext context) {
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

    DateTime parseDate(String date) {
      return DateFormat('EEEE, dd MMM yyyy').parse(date);
    }

    List<MapEntry<String, List<CashierBalanceTransactionModel>>> sortedEntries = groupedShifts.entries.toList()
      ..sort((a, b) => parseDate(b.key).compareTo(parseDate(a.key)));

    for (var entry in sortedEntries) {
      entry.value.sort((a, b) => b.openDate.compareTo(a.openDate));
    }

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight - 40,
            width: constraints.maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 75),
            decoration: BoxDecoration(
              color: null,
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  for (var entry in sortedEntries)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.start,
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        for (var shift in entry.value)
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              shift.docNum,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              NumberFormat.decimalPattern().format(shift.cashValue.toInt()),
                                              style: const TextStyle(fontSize: 18),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              shift.approvalStatus == 0 ? 'OPEN' : 'CLOSED',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: shift.approvalStatus == 0
                                                    ? const Color.fromARGB(255, 47, 143, 8)
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    shift.closedbyId!.isEmpty
                                        ? GestureDetector(
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => ConfirmToEndShift(activeShift!),
                                              );
                                            },
                                            child: const Icon(
                                              Icons.arrow_right_outlined,
                                              size: 40,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => RecapShiftScreen(
                                                  shiftId: shift.docId,
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
                                const Divider(
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
