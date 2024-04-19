import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_row.dart';
import 'package:pos_fe/core/widgets/custom_row_input.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/confirm_end_shift.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndShiftScreen extends StatefulWidget {
  const EndShiftScreen({Key? key}) : super(key: key);

  @override
  State<EndShiftScreen> createState() => _EndShiftScreenState();
}

class _EndShiftScreenState extends State<EndShiftScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.swatch,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text('End Current Shift'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ScrollWidget(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height / 2) - 350,
            ),
            // const Text(
            //   'End Current Shift',
            //   style: TextStyle(
            //       color: ProjectColors.swatch,
            //       fontSize: 30,
            //       fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 30),
            const EndShiftForm(),
          ],
        ),
      ),
    );
  }
}

class EndShiftForm extends StatefulWidget {
  const EndShiftForm({Key? key}) : super(key: key);

  @override
  State<EndShiftForm> createState() => _EndShiftFormState();
}

class _EndShiftFormState extends State<EndShiftForm> {
  late TextEditingController actualCashController;
  late Future<CashierBalanceTransactionModel?> _openingFuture;
  late Future<List<InvoiceHeaderModel?>> _transactionsFuture;
  late CashierBalanceTransactionModel? opening;
  late List<InvoiceHeaderModel?> transactions;
  double differences = 0.0;
  final formKey = GlobalKey<FormState>();
  final prefs = GetIt.instance<SharedPreferences>();

  void _updateCashierBalanceTransaction(
      String docId, CashierBalanceTransactionModel value) async {
    await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .update(docId: docId, data: value);
  }

  @override
  void initState() {
    super.initState();
    actualCashController = TextEditingController();

    _openingFuture = _fetchOpeningData();
    _transactionsFuture = _fetchInvoices();
  }

  @override
  void dispose() {
    super.dispose();
    actualCashController.dispose();
  }

  Future<CashierBalanceTransactionModel?> _fetchOpeningData() async {
    opening = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readLastValue();
    return opening;
  }

  Future<List<InvoiceHeaderModel?>> _fetchInvoices() async {
    transactions =
        await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByShift();
    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    actualCashController.addListener(() {
      setState(() {
        final double cashFlow = _calculateCashFlow();
        final double actualCash =
            double.tryParse(actualCashController.text) ?? 0.0;
        differences = actualCash - cashFlow;
      });
    });

    // try {
    return FutureBuilder<CashierBalanceTransactionModel?>(
      future: _openingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          opening = snapshot.data!;
          return FutureBuilder<List<InvoiceHeaderModel?>>(
            future: _transactionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                transactions = snapshot.data!;
                return buildForm(context, formKey);
              }
            },
          );
        }
      },
    );
    // } catch (e, s) {
    //   debugPrintStack(stackTrace: s);
    //   return Placeholder();
    // }
  }

  Widget buildForm(BuildContext context, GlobalKey<FormState> formKey) {
    double cashFlow = _calculateCashFlow();
    final prefs = GetIt.instance<SharedPreferences>();
    final userLogged = prefs.getString('username');

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomRow(
              leftText: "Cashier",
              rightText: "${opening!.openedbyId} / $userLogged",
            ),
            CustomRow(
              leftText: "Shift Started",
              rightText: Helpers.formatDate(opening!.openDate),
            ),
            const SizedBox(height: 10),
            const CustomRow(
              leftText: "System Cashier",
              rightText: "",
            ),
            CustomRow(
              leftText: "   Start Cash",
              rightText: Helpers.parseMoney(opening!.openValue.toInt()),
            ),
            CustomRow(
              leftText: "   Cash Flow",
              rightText: Helpers.parseMoney(cashFlow.toInt()),
            ),
            const CustomRow(
              leftText: "   Cash Sales",
              rightText: "0.0",
            ),
            CustomRow(
              leftText: "   Expected Cash",
              rightText: Helpers.parseMoney(cashFlow.toInt()),
            ),
            const CustomRow(
              leftText: "   Non-Cash",
              rightText: "0.0",
            ),
            const SizedBox(height: 10),
            const CustomRow(
              leftText: "Actual Cash",
              rightText: "",
            ),
            CustomRowInput(
              controller: actualCashController,
              leftText: "   Actual Cash Earned",
              hint: "Enter Actual Cash Earned",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final isNumeric = double.tryParse(value);
                if (isNumeric == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            CustomRow(
              leftText: "   Differences",
              rightText: Helpers.parseMoney(differences.toInt()),
            ),
            const SizedBox(height: 30),
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: CustomButton(
                child: const Text("End Shift"),
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;

                  final double inputValue =
                      double.tryParse(actualCashController.text) ?? 0.0;

                  if (opening != null) {
                    final CashierBalanceTransactionModel shift =
                        CashierBalanceTransactionModel(
                      docId: opening!.docId,
                      createDate: opening!.createDate,
                      updateDate: opening!.updateDate,
                      tocsrId: opening!.tocsrId,
                      tousrId: opening!.tousrId,
                      docNum: opening!.docNum,
                      openDate: opening!.openDate,
                      openTime: opening!.openTime,
                      calcDate: opening!.calcDate,
                      calcTime: opening!.calcTime,
                      closeDate: DateTime.now(),
                      closeTime: DateTime.now(),
                      timezone: opening!.timezone,
                      openValue: opening!.openValue,
                      calcValue: 0,
                      cashValue: 0,
                      closeValue: inputValue,
                      openedbyId: "",
                      closedbyId: "",
                      approvalStatus: 1,
                    );

                    _updateCashierBalanceTransaction(opening!.docId, shift);

                    await prefs.setBool('isOpen', false);

                    await prefs.setString('tcsr1Id', "");

                    if (!context.mounted) return;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmEndShift();
                        });
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
                width: 400,
                child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side:
                              const BorderSide(color: ProjectColors.primary))),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black.withOpacity(.2))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: ProjectColors.primary,
                        fontWeight: FontWeight.w700),
                  )),
                )),
          ],
        ),
      ),
    );
  }

  double _calculateCashFlow() {
    double cashFlow = 0;
    for (var transaction in transactions) {
      cashFlow += transaction!.grandTotal;
    }
    return cashFlow;
  }
}
