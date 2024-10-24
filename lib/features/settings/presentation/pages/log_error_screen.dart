import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/log_error.dart';

class LogErrorScreen extends StatefulWidget {
  const LogErrorScreen({super.key});

  @override
  State<LogErrorScreen> createState() => _LogErrorScreenState();
}

class _LogErrorScreenState extends State<LogErrorScreen> {
  List<LogErrorModel> logErr = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLogErrors();
  }

  Future<void> fetchLogErrors() async {
    try {
      logErr = await GetIt.instance<AppDatabase>().logErrorDao.readAll();
      logErr.sort((a, b) => b.createDate.compareTo(a.createDate));
    } catch (e) {
      log("Error fetching log errors: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> clearLogErrors() async {
    try {
      await GetIt.instance<AppDatabase>().logErrorDao.clearDb();
      setState(() {
        logErr = [];
      });
    } catch (e) {
      log("Error clearing log errors: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Error Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await clearLogErrors();
            },
            tooltip: 'Clear Logs',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(6),
                      },
                      border: TableBorder.all(
                        color: ProjectColors.primary,
                        width: 1,
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: ProjectColors.primary.withOpacity(0.1),
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Error Type',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Description',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        for (var log in logErr)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(Helpers.formatDate(log.createDate)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(log.processInfo),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(log.description),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
