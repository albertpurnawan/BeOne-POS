import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PLUExportScreen extends StatefulWidget {
  const PLUExportScreen({super.key});

  @override
  State<PLUExportScreen> createState() => _PLUExportScreenState();
}

class _PLUExportScreenState extends State<PLUExportScreen> {
  String? selectedFolderPath;
  double exportProgress = 0.0;
  List<String> itemName = [];
  List<String> barcode = [];
  List<double> harga = [];
  String expired = "1";
  List<int> typeDiscount = [];
  List<String> disDate = [];
  List<String> endDate = [];
  List<String> limit1 = [];
  List<double?> limit2 = [];
  List<List<String>> tableData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    // getPosParameter();
    readAllByScaleActive();
  }

  // void getPosParameter() async {
  //   _posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
  //   setState(() {});
  // }

  Future<void> readAllByScaleActive() async {
    setState(() {
      isLoading = true;
    });
    final items = await GetIt.instance<AppDatabase>().itemsDao.readAllByScaleActive(scaleActive: 1);

    if (items.isEmpty) throw "Failed retrieve Store";
    double hargaTax = 0;
    for (var i = 0; i < items.length; i++) {
      itemName.add(items[i].itemName);
      barcode.add(items[i].barcode);

      if (items[i].includeTax == 1) {
        hargaTax = items[i].price;
        harga.add(hargaTax);
      } else {
        hargaTax = items[i].price + (items[i].price * items[i].taxRate / 100);
        harga.add(hargaTax);
      }

      final promo = await GetIt.instance<AppDatabase>().promosDao.readByToitmAndPromoType(items[i].toitmId, 202, null);
      if (promo == null) {
        typeDiscount.add(0);
        disDate.add("");
        endDate.add("");
        limit1.add("");
        limit2.add(null);
      } else {
        typeDiscount.add(2);
        final promoHeader =
            await GetIt.instance<AppDatabase>().promoHargaSpesialHeaderDao.readByToitmId(items[i].toitmId, null);
        if (promoHeader != null) {
          disDate.add("${promoHeader.startDate}");
          endDate.add("${promoHeader.endDate}");
          limit1.add("0");
          final promoHarga =
              await GetIt.instance<AppDatabase>().promoHargaSpesialBuyDao.readByToitmLastDate(items[i].toitmId, null);
          double limitPrice = 0;
          if (items[i].includeTax == 1) {
            limitPrice = items[i].price - promoHarga.first.price;
            limit2.add(limitPrice);
          } else {
            limitPrice = (items[i].price + (items[i].price * items[i].taxRate / 100)) -
                (promoHarga.first.price + (promoHarga.first.price * items[i].taxRate / 100));

            limit2.add(limitPrice);
          }
        } else {
          disDate.add("");
          endDate.add("");
          limit1.add("");
          limit2.add(null);
        }
      }
    }
    _initializeTableData();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedFolderPath = prefs.getString('folderPath');
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (selectedFolderPath != null) {
      await prefs.setString('folderPath', selectedFolderPath!);
    }
  }

  Future<void> _navigateToFolder() async {
    String? folderPath = await FilePicker.platform.getDirectoryPath();
    if (folderPath != null) {
      setState(() {
        selectedFolderPath = folderPath;
      });
      await _saveData();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    tableData.clear();

    await readAllByScaleActive();
    setState(() {
      isLoading = false;
    });
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

  void _initializeTableData() {
    setState(() {
      tableData = List.generate(itemName.length, (index) {
        return [
          barcode[index],
          barcode[index],
          itemName[index],
          '',
          '',
          Helpers.parseMoney(harga[index].round()),
          expired,
          typeDiscount[index].toString(),
          disDate[index] != '' ? Helpers.dateWithSlash(disDate[index]) : '',
          endDate[index] != '' ? Helpers.dateWithSlash(endDate[index]) : '',
          limit1[index],
          (limit2[index] != null) ? limit2[index]!.round().toString() : "",
        ];
      });
    });
  }

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
        'Harga',
        'Expired',
        'type discount',
        'dis.date',
        'end.date',
        'limit1',
        'limit2',
      ],
      ...tableData,
    ];

    List<DataRow> dataRows = tableData.map((row) {
      while (row.length < 12) {
        row.add('');
      }
      return DataRow(
        cells: row.map((e) => DataCell(Text(e.isEmpty ? "" : e))).toList(),
      );
    }).toList();

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
          mainAxisSize: MainAxisSize.min,
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
                  child: SizedBox(
                    height: 40,
                    child: Stack(
                      children: [
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(text: selectedFolderPath),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            // isCollapsed: true,
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
                          // top: 5,
                          child: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: _navigateToFolder,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProjectColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: _saveExportPath,
                    child: const Text("Save"),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
            if (exportProgress > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: exportProgress,
                  backgroundColor: Colors.grey[200],
                  color: ProjectColors.primary,
                ),
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
                mainAxisSize: MainAxisSize.min,
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
                  if (isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (tableData.isEmpty && !isLoading)
                    const Expanded(child: Center(child: Text("No data available please wait")))
                  else
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(ProjectColors.primary),
                                  columns: const [
                                    DataColumn(
                                        label: Text(
                                      "PLU",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Barcode",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Nama1",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Nama2",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Nama3",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Harga",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Expired",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "type discount",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "dis.date",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "end.date",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "limit1",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "limit2",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                  ],
                                  rows: tableData.map((row) {
                                    for (int i = 0; i < row.length; i++) {
                                      if (row[i].isEmpty) {
                                        row[i] = '';
                                      }
                                    }
                                    return DataRow(
                                      cells: row.map((e) {
                                        return DataCell(Container(
                                          width: 120,
                                          child: Text(e.isEmpty ? "" : e),
                                        ));
                                      }).toList(),
                                    );
                                  }).toList(),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 20),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: ProjectColors.primary,
                //     foregroundColor: Colors.white,
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                //   ),
                //   onPressed: () {
                //     // Action for Tombol 1
                //   },
                //   child: const Text("Tombol 1"),
                // ),
                // const SizedBox(width: 20),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: ProjectColors.primary,
                //     foregroundColor: Colors.white,
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                //   ),
                //   onPressed: () {
                //     // Action for Tombol 2
                //   },
                //   child: const Text("Tombol 2"),
                // ),
                // const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _refreshData,
                  child: const Text("Reload PLUs"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _exportFile,
                  child: const Text("Export PLUs"),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
