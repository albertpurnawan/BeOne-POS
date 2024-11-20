import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/usecases/archive_database_usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  bool endDateExceed = false;

  Future<void> selectDateFunction(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? selectedFromDate ??
              DateTime.now() //.subtract(const Duration(days: 30)
          : selectedToDate ??
              DateTime.now(), //.subtract(const Duration(days: 30))
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), //.subtract(const Duration(days: 1))
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: ProjectColors.lightBlack,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ProjectColors.lightBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          selectedFromDate = picked;
        } else {
          if (selectedFromDate != null && picked.isBefore(selectedFromDate!)) {
            selectedToDate = null;
            endDateExceed = true;
          } else {
            selectedToDate =
                picked.add(const Duration(hours: 23, minutes: 59, seconds: 59));
            endDateExceed = false;
          }
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
          title: const Text('Archive Database'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.98,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _selectDate(),
                    const SizedBox(height: 20),
                    (selectedFromDate != null && selectedToDate != null)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: _warningText())
                        : const SizedBox.shrink(),
                    const SizedBox(height: 20),
                    (selectedFromDate != null && selectedToDate != null)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: _actionButton(),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _selectDate() {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "From",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => selectDateFunction(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: ProjectColors.lightBlack),
                              const SizedBox(width: 10),
                              selectedFromDate != null
                                  ? Text(
                                      Helpers.dateEEddMMMyyy(selectedFromDate!),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  : _dateLabel(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "To",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => selectDateFunction(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: ProjectColors.lightBlack),
                              const SizedBox(width: 10),
                              selectedToDate != null
                                  ? Text(
                                      Helpers.dateEEddMMMyyy(selectedToDate!),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  : _dateLabel(),
                            ],
                          ),
                        ),
                      ),
                      endDateExceed
                          ? const Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                              child: Text(
                                "End date must be after start date.",
                                style: TextStyle(
                                  color: ProjectColors.primary,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateLabel() {
    return const Text(
      "Select Date",
      style: TextStyle(
          fontSize: 16, color: Colors.black, fontStyle: FontStyle.italic),
    );
  }

  Widget _actionButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.065,
      child: Row(
        children: [
          Expanded(
              child: TextButton(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: ProjectColors.primary),
                )),
                backgroundColor: WidgetStateColor.resolveWith(
                    (states) => ProjectColors.primary),
                overlayColor: WidgetStateColor.resolveWith(
                    (states) => Colors.white.withOpacity(.2))),
            onPressed: () async {
              await ArchiveDatabaseUseCase().call(
                  params: ArchiveDatabaseParams(
                      selectedFromDate!, selectedToDate!,
                      context: context));
            },
            child: const Center(
                child: Text(
              "Archive",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 234, 234, 234),
                fontWeight: FontWeight.bold,
              ),
            )),
          )),
        ],
      ),
    );
  }

  Widget _warningText() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        border: Border.all(
          color: Colors.yellow.shade700,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            color: Colors.yellow.shade700,
            size: 26.0,
          ),
          const SizedBox(width: 10.0),
          const Text(
            "Archiving the data will delete the archived data from local database. Proceed if you wish to continue",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
