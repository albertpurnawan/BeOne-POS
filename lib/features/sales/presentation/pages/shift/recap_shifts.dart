import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';

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
      backgroundColor: Colors.white,
      body: ScrollWidget(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height / 2) - 350,
            ),
            const Text(
              'Shifts Recap',
              style: TextStyle(
                  color: ProjectColors.swatch,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const RecapsShiftList(),
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
  final List<dynamic> transactions = [
    {"id": 1, "name": "Name 1", "stats": "Stats 1"},
    {"id": 2, "name": "Name 2", "stats": "Stats 2"},
    {"id": 3, "name": "Name 3", "stats": "Stats 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (BuildContext context, int index) {
          final transaction = transactions[index];
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey, // Adjust the color of the border here
                  width: 1, // Adjust the width of the border here
                ),
              ),
            ),
            child: ListTile(
              title: Text("Transaction ID: ${transaction['id']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${transaction['name']}"),
                  Text("Stats: ${transaction['stats']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
