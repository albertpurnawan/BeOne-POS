import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:pos_fe/features/home/presentation/pages/home.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/cashier_balance_transaction_details.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/open_shift.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecapShifts extends StatefulWidget {
  const RecapShifts({super.key});

  @override
  State<RecapShifts> createState() => _RecapShiftsState();
}

class _RecapShiftsState extends State<RecapShifts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.swatch,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text('Transactions List'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ScrollWidget(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height / 2) - 325,
            ),
            const Text(
              'Transactions List',
              style: TextStyle(
                  color: ProjectColors.swatch,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // insert
            const SizedBox(height: 30),
            const RecapsShiftList(),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Home'),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: CustomButton(
                child: const Text("Start Shift"),
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final bool isOpen = prefs.getBool('isOpen') ?? false;

                  if (isOpen) {
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          content: const Text(
                            "Please end current shift first",
                            style:
                                TextStyle(color: Color.fromRGBO(128, 0, 0, 1)),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          content: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: const OpenShiftScreen(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecapsShiftList extends StatefulWidget {
  const RecapsShiftList({Key? key}) : super(key: key);

  @override
  State<RecapsShiftList> createState() => _RecapsShiftListState();
}

class _RecapsShiftListState extends State<RecapsShiftList> {
  Future<List<CashierBalanceTransactionModel>>? _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = fetchTransactions();
  }

  Future<List<CashierBalanceTransactionModel>> fetchTransactions() async {
    final tcsr1 = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readAll();
    return tcsr1;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CashierBalanceTransactionModel>>(
      future: _transactionsFuture,
      builder: (BuildContext context,
          AsyncSnapshot<List<CashierBalanceTransactionModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Map<String, List<CashierBalanceTransactionModel>>
              transactionsByDate = {};
          for (var transaction in snapshot.data!) {
            final String dateFormatted =
                Helpers.dateEEddMMMyyy(transaction.openDate);

            if (!transactionsByDate.containsKey(dateFormatted)) {
              transactionsByDate[dateFormatted] = [];
            }
            transactionsByDate[dateFormatted]!.add(transaction);
          }

          final List<String> sortedDates = transactionsByDate.keys.toList();
          sortedDates.sort((a, b) => b.compareTo(a));

          return Container(
            color: Colors.white,
            height: 500,
            child: ListView.builder(
              itemCount: sortedDates.length,
              itemBuilder: (BuildContext context, int index) {
                final String date = sortedDates[index];
                final List<CashierBalanceTransactionModel> transactions =
                    transactionsByDate[date]!;
                return ExpansionTile(
                  title: Text(date),
                  children: transactions.map((transaction) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(transaction.docNum),
                          Text(transaction.calcValue.toString()),
                          Text(transaction.approvalStatus.toString()),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CashierBalanceTransactionDetails(
                              transaction: transaction,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          );
        }
      },
    );
  }
}
