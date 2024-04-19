import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashierBalanceTransactionDetails extends StatelessWidget {
  final CashierBalanceTransactionModel transaction;

  const CashierBalanceTransactionDetails({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final DateFormat formatter = DateFormat('EEEE, dd MMM yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(
              height: 20,
              color: Colors.amber,
              thickness: 10,
            ),
            _buildRow(
              leftText: "Cashier",
              rightText: transaction.tocsrId!,
            ),
            const SizedBox(height: 8),
            _buildRow(
              leftText: "Shift Start",
              rightText: Helpers.formatDate(transaction.openDate),
            ),
            const SizedBox(height: 8),
            _buildRow(
              leftText: "Shift End",
              rightText: Helpers.formatDate(transaction.closeDate!),
            ),
            const Divider(
              height: 20,
              color: Colors.amber,
              thickness: 10,
            ),
            _buildRow(
              leftText: "Cash Flow",
              rightText: "",
              isBold: true,
            ),
            const SizedBox(height: 8),
            _buildRow(
              leftText: "Initial Cash",
              rightText: transaction.openValue.toString(),
            ),
            const SizedBox(height: 8),
            _buildRow(
              leftText: "Closing Cash",
              rightText: transaction.closeValue.toString(),
            ),
            const SizedBox(height: 8),
            _buildRow(
              leftText: "Closing Non-Cash",
              rightText: transaction.calcValue.toString(),
            ),
            const SizedBox(height: 8),
            _buildRow(
              leftText: "Difference",
              rightText: (transaction.closeValue -
                      transaction.closeValue +
                      transaction.calcValue)
                  .toString(),
            ),
            const SizedBox(height: 8),
            _buildRow(
              leftText: "Total Cash",
              rightText: transaction.closeValue.toString(),
              isBold: true,
            ),
            const Divider(
              height: 20,
              color: Colors.amber,
              thickness: 10,
            ),
            const SizedBox(height: 15),
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: CustomButton(
                  child: const Text("End Shift"),
                  onTap: () async {
                    final SharedPreferences prefs =
                        GetIt.instance<SharedPreferences>();
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
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              // child: const EndShiftScreen(),
                            ),
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
                            content: const Text(
                              "Please start a new shift first",
                              style: TextStyle(color: Colors.red),
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
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required String leftText,
    required String rightText,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
            ),
          ),
          Text(
            rightText,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
