import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class PLUExportScreen extends StatefulWidget {
  const PLUExportScreen({super.key});

  @override
  State<PLUExportScreen> createState() => _PLUExportScreenState();
}

class _PLUExportScreenState extends State<PLUExportScreen> {
  String? selectedFolderPath;
  double exportProgress = 0.0;

  Future<void> _navigateToFolder() async {
    String? folderPath = await FilePicker.platform.getDirectoryPath();
    if (folderPath != null) {
      setState(() {
        selectedFolderPath = folderPath;
      });
    }
  }

  void _saveExportPath() {
    if (selectedFolderPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a folder first!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Export path saved: $selectedFolderPath")),
      );
    }
  }

  List<List<String>> tableData = [
    [
      '130',
      '130',
      'Item Name Line 1',
      'Item Name Line 2',
      'Item Name Line 3',
      'Item Name Line 4',
      'Item Name Line 5',
      'Item Name Line 6',
      'Item Name Line 7'
    ],
    [
      '131',
      '131',
      'Item Name Line 1',
      'Item Name Line 2',
      'Item Name Line 3',
      'Item Name Line 4',
      'Item Name Line 5',
      'Item Name Line 6',
      'Item Name Line 7'
    ],
    // Add more rows here
  ];

  Future<void> _exportFile() async {
    if (selectedFolderPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a folder first!")),
      );
      return;
    }

    setState(() {
      exportProgress = 0.0;
    });

    List<List<String>> rows = [
      [
        'PLU',
        'Barcode',
        'Nama1',
        'Nama2',
        'Nama3',
        'Nama4',
        'Nama5',
        'Nama6',
        'Nama7'
      ],
      // Add the data rows
      ...tableData,
    ];

    String csvData = const ListToCsvConverter().convert(rows);

    try {
      String dateFormatted = DateFormat('yyMMdd_HHmmss').format(DateTime.now());

      final file = File('$selectedFolderPath/timbangan_$dateFormatted.csv');

      for (int i = 0; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 30), () {
          setState(() {
            exportProgress = i / 100;
          });
        });
      }

      await file.writeAsString(csvData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV file exported to $selectedFolderPath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to export CSV file!")),
      );
    }

    setState(() {
      exportProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text("PLU Export"),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                const Text(
                  "Export Path",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Stack(
                    children: [
                      TextField(
                        readOnly: true,
                        controller:
                            TextEditingController(text: selectedFolderPath),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: const Color.fromARGB(255, 234, 234, 234),
                          filled: true,
                        ),
                        onTap: _navigateToFolder,
                      ),
                      Positioned(
                        right: 2,
                        top: 5,
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: _navigateToFolder,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProjectColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveExportPath,
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (exportProgress > 0)
              LinearProgressIndicator(
                value: exportProgress,
                backgroundColor: Colors.grey[200],
                color: ProjectColors.primary,
              ),
            if (exportProgress > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Exporting: ${(exportProgress * 100).toInt()}%",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 20),
                    child: Text(
                      "PLU List",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SizedBox(
                        height: 400,
                        width: 1200,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("PLU")),
                                DataColumn(label: Text("Barcode")),
                                DataColumn(label: Text("Nama1")),
                                DataColumn(label: Text("Nama2")),
                                DataColumn(label: Text("Nama3")),
                                DataColumn(label: Text("Nama4")),
                                DataColumn(label: Text("Nama5")),
                                DataColumn(label: Text("Nama6")),
                                DataColumn(label: Text("Nama7")),
                              ],
                              rows: List<DataRow>.generate(
                                20,
                                (index) => const DataRow(
                                  cells: [
                                    DataCell(Text("130")),
                                    DataCell(Text("130")),
                                    DataCell(Text("Item Name Line 1")),
                                    DataCell(Text("Item Name Line 2")),
                                    DataCell(Text("Item Name Line 3")),
                                    DataCell(Text("Item Name Line 4")),
                                    DataCell(Text("Item Name Line 5")),
                                    DataCell(Text("Item Name Line 6")),
                                    DataCell(Text("Item Name Line 7")),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  ),
                  onPressed: () {
                    // Action for Tombol 1
                  },
                  child: const Text("Tombol 1"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  ),
                  onPressed: () {
                    // Action for Tombol 2
                  },
                  child: const Text("Tombol 2"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  ),
                  onPressed: () {
                    // Action for Tombol 3
                  },
                  child: const Text("Tombol 3"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  ),
                  onPressed: _exportFile,
                  child: const Text("Send PLUs"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
