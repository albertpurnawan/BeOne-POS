import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/money_denomination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecapMoneyDialog extends StatefulWidget {
  final String tcsr1Id;
  final Function(Map<String, int>) setTotal;

  const RecapMoneyDialog({super.key, required this.tcsr1Id, required this.setTotal});

  @override
  State<RecapMoneyDialog> createState() => _RecapMoneyDialogState();
}

class _RecapMoneyDialogState extends State<RecapMoneyDialog> {
  List<MoneyDenominationModel?>? tcsr2;
  final int maxLength = 10;
  final prefs = GetIt.instance<SharedPreferences>();
  int qty100k = 0;
  int qty50k = 0;
  int qty20k = 0;
  int qty10k = 0;
  int qty5k = 0;
  int qty2k = 0;
  int qty1k = 0;
  int qty500 = 0;
  int qty200 = 0;
  int qty100 = 0;
  int qty50 = 0;
  int total100k = 0;
  int total50k = 0;
  int total20k = 0;
  int total10k = 0;
  int total5k = 0;
  int total2k = 0;
  int total1k = 0;
  int total500 = 0;
  int total200 = 0;
  int total100 = 0;
  int total50 = 0;
  int calculatedTotalCash = 0;

  @override
  void initState() {
    getMoneyDenominations(widget.tcsr1Id);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getMoneyDenominations(String shiftId) async {
    try {
      final moneys = await GetIt.instance<AppDatabase>().moneyDenominationDao.readByTcsr1Id(shiftId, null);
      setState(() {
        tcsr2 = moneys;
        qty100k = getDenominationCount(100000);
        qty50k = getDenominationCount(50000);
        qty20k = getDenominationCount(20000);
        qty10k = getDenominationCount(10000);
        qty5k = getDenominationCount(5000);
        qty2k = getDenominationCount(2000);
        qty1k = getDenominationCount(1000);
        qty500 = getDenominationCount(500);
        qty200 = getDenominationCount(200);
        qty100 = getDenominationCount(100);
        qty50 = getDenominationCount(50);
        total100k = qty100k * 100000;
        total50k = qty50k * 50000;
        total20k = qty20k * 20000;
        total10k = qty10k * 10000;
        total5k = qty5k * 5000;
        total2k = qty2k * 2000;
        total1k = qty1k * 1000;
        total500 = qty500 * 500;
        total200 = qty200 * 200;
        total100 = qty100 * 100;
        total50 = qty50 * 50;

        calculateTotalCash();
      });
    } catch (e) {
      rethrow;
    }
  }

  int getDenominationCount(int nominal) {
    final denomination = tcsr2?.firstWhere(
      (denomination) => denomination?.nominal == nominal,
      orElse: () => MoneyDenominationModel(
        docId: '',
        createDate: DateTime.now(),
        updateDate: DateTime.now(),
        nominal: nominal,
        count: 0,
        tcsr1Id: '',
      ),
    );
    return denomination?.count ?? 0;
  }

  void calculateTotalCash() {
    setState(() {
      calculatedTotalCash = total100k +
          total50k +
          total20k +
          total10k +
          total5k +
          total2k +
          total1k +
          total500 +
          total200 +
          total100 +
          total50;

      widget.setTotal({'totalCash': calculatedTotalCash});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 100,000",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty100k",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total100k),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 50,000",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty50k",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total50k),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 20,000",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty20k",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total20k),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 10,000",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty10k",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total10k),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 5,000",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty5k",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total5k),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 2,000",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty2k",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total2k),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 1,000",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty1k",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total1k),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 500",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty500",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total500),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 200",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty200",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total200),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 100",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty100",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total100),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 50",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  "$qty50",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                NumberFormat.decimalPattern().format(total50),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
