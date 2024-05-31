import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';

class FiltereReportScreen extends StatefulWidget {
  const FiltereReportScreen({super.key});

  @override
  State<FiltereReportScreen> createState() => _FiltereReportScreenState();
}

class _FiltereReportScreenState extends State<FiltereReportScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 10 / 0.5,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "From",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Text(
                            ":",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            "Fri, 31-01-2024 00:00:00",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Cashier",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Text(
                            ":",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            "Rp example,00",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "To",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Text(
                            ":",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            "Fri, 31-01-2024 12:00:00",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Shift",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Text(
                            ":",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            "S0001-20240531-001",
                            style: TextStyle(
                                color: ProjectColors.mediumBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                color: ProjectColors.primary,
                thickness: 5.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: ProjectColors.primary,
                    width: 2.0,
                  ),
                ),
                child: const Text(
                  "Content",
                  style: TextStyle(color: ProjectColors.mediumBlack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
