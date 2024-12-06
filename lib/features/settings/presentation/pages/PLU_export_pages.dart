import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class PLUExportScreen extends StatefulWidget {
  const PLUExportScreen({super.key});

  @override
  State<PLUExportScreen> createState() => _PLUExportScreenState();
}

class _PLUExportScreenState extends State<PLUExportScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String? searchedQuery;
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
  List<String> tableHeader = [
    "PLU",
    "Barcode",
    "Nama1",
    "Nama2",
    "Nama3",
    "Harga",
    "Expired",
    "type discount",
    "dis.date",
    "end.date",
    "limit1",
    "limit2",
  ];
  bool isLoading = false;

  bool _shiftEnabled = false;
  bool _showKeyboard = true;
  final FocusNode _keyboardFocusNode = FocusNode();
  bool currentNumericMode = false;

  @override
  void initState() {
    getDefaultKeyboardPOSParameter();
    super.initState();
    _loadData();
    readAllByScaleActive();
    searchedQuery = "";
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  Future<void> getDefaultKeyboardPOSParameter() async {
    try {
      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      setState(() {
        _showKeyboard = (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
      });
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentFailSnackBar(context, e.toString());
      }
    }
  }

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
        disDate.add('');
        endDate.add('');
        limit1.add('');
        limit2.add(null);
      } else {
        typeDiscount.add(2);
        final promoHeader =
            await GetIt.instance<AppDatabase>().promoHargaSpesialHeaderDao.readByToitmId(items[i].toitmId, null);
        if (promoHeader != null) {
          disDate.add('${promoHeader.startDate}');
          endDate.add('${promoHeader.endDate}');
          limit1.add('0');
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
          disDate.add('');
          endDate.add('');
          limit1.add('');
          limit2.add(null);
        }
      }
    }
    _initializeTableData();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> searchByKeyword(String keyword) async {
    setState(() {
      isLoading = true;
    });

    keyword = keyword.toLowerCase();

    List<int> matchedIndexes = [];
    for (int i = 0; i < itemName.length; i++) {
      if (itemName[i].toLowerCase().contains(keyword) || barcode[i].toLowerCase().contains(keyword)) {
        matchedIndexes.add(i);
      }
    }

    setState(() {
      tableData = matchedIndexes.map((index) {
        final name = itemName[index];
        final nama1 = name.length > 19 ? name.substring(0, 19) : name;
        final nama2 = name.length > 19 ? (name.length > 37 ? name.substring(19, 37) : name.substring(19)) : '';
        final nama3 = name.length > 37 ? name.substring(37) : '';
        return [
          barcode[index],
          barcode[index],
          nama1,
          nama2,
          nama3,
          Helpers.parseMoney(harga[index].round()),
          expired,
          typeDiscount[index].toString(),
          disDate[index] != '' ? Helpers.dateWithSlash(disDate[index]) : '',
          endDate[index] != '' ? Helpers.dateWithSlash(endDate[index]) : '',
          limit1[index],
          (limit2[index] != null) ? limit2[index]!.round().toString() : '',
        ];
      }).toList();

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
      _searchController.text = '';
    });
    tableData.clear();

    await readAllByScaleActive();
    setState(() {
      isLoading = false;
    });
    SnackBarHelper.presentSuccessSnackBar(context, "Success reload data", 3);
  }

  void _saveExportPath() {
    if (selectedFolderPath == null) {
      SnackBarHelper.presentErrorSnackBar(context, "Please select a folder first!");
    } else {
      SnackBarHelper.presentSuccessSnackBar(context, "Export path saved: $selectedFolderPath", 3);
    }
  }

  void _initializeTableData() {
    setState(() {
      tableData = List.generate(itemName.length, (index) {
        final name = itemName[index];
        final nama1 = name.length > 19 ? name.substring(0, 19) : name;
        final nama2 = name.length > 19 ? (name.length > 37 ? name.substring(19, 37) : name.substring(19)) : '';
        final nama3 = name.length > 37 ? name.substring(37) : '';

        final updatedNama1 = nama1.replaceAll('"', "'");
        final updatedNama2 = nama2.replaceAll('"', "'");
        final updatedNama3 = nama3.replaceAll('"', "'");
        return [
          barcode[index],
          barcode[index],
          updatedNama1,
          updatedNama2,
          updatedNama3,
          Helpers.parseMoney(harga[index].round()),
          expired,
          typeDiscount[index].toString(),
          disDate[index] != '' ? Helpers.dateWithSlash(disDate[index]) : '',
          endDate[index] != '' ? Helpers.dateWithSlash(endDate[index]) : '',
          limit1[index],
          (limit2[index] != null) ? limit2[index]!.round().toString() : '',
        ];
      });
    });
  }

  Future<void> _exportFile() async {
    if (selectedFolderPath == null) {
      SnackBarHelper.presentErrorSnackBar(context, "Please select a folder first!");
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
      ...tableData.map((data) => data.map((value) => value.replaceAll('"', '').replaceAll(',', '')).toList()).toList(),
    ];

    // List<DataRow> dataRows = tableData.map((row) {
    //   while (row.length < 12) {
    //     row.add('');
    //   }
    //   return DataRow(
    //     cells: row.map((e) => DataCell(Text(e.isEmpty ? "" : e))).toList(),
    //   );
    // }).toList();

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

      SnackBarHelper.presentSuccessSnackBar(context, "CSV file exported to $selectedFolderPath", 3);
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, "Failed to export CSV file!");
    }

    setState(() {
      exportProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.background,
      appBar: AppBar(
        title: const Text("PLU Export"),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                borderRadius: const BorderRadius.all(Radius.circular(360)),
              ),
              child: IconButton(
                icon: Icon(
                  _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showKeyboard = !_showKeyboard;
                  });
                },
                tooltip: 'Toggle Keyboard',
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            prefixIcon: const Icon(
                              Icons.upload_file_outlined,
                              color: Colors.grey,
                            ),
                            suffixIcon: const Icon(
                              Icons.more_horiz_outlined,
                              color: Colors.grey,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            fillColor: Colors.white,
                          ),
                          onTap: _navigateToFolder,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    color: ProjectColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 5,
                        color: Color.fromRGBO(0, 0, 0, 0.222),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProjectColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveExportPath,
                    child: const Text("Save"),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 15),
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
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "PLU List",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: SizedBox(
                      width: 450,
                      height: 40,
                      child: TextField(
                        focusNode: _searchFocusNode,
                        controller: _searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Search ...',
                          hintStyle: const TextStyle(
                            color: ProjectColors.mediumBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        style: const TextStyle(
                          color: ProjectColors.mediumBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                        ),
                        onChanged: (value) async {
                          setState(() {
                            searchedQuery = value;
                          });
                          await searchByKeyword(searchedQuery ?? "");
                        },
                        onEditingComplete: () async {
                          searchedQuery = _searchController.text;
                          await searchByKeyword(searchedQuery ?? "");
                          _searchFocusNode.unfocus();
                        },
                        keyboardType: TextInputType.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (isLoading)
                        ? SizedBox(
                            height: _showKeyboard ? 297 : 462,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : (tableData.isEmpty && !isLoading)
                            ? SizedBox(
                                height: _showKeyboard ? 297 : 462,
                                child: const Center(
                                  child: Text(
                                    "No data available",
                                    style: TextStyle(
                                        color: ProjectColors.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 222, 220, 220),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: SizedBox(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Header
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: ProjectColors.primary,
                                              ),
                                              child: Row(
                                                children: tableHeader.map((header) {
                                                  return Container(
                                                    width: 120,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      header,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),

                                            // Table data
                                            Container(
                                              color: const Color.fromARGB(255, 241, 241, 241),
                                              height: _showKeyboard ? 235 : 400,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: tableData.map((row) {
                                                    return Row(
                                                      children: row.map((cell) {
                                                        return Container(
                                                          width: 120,
                                                          height: 50,
                                                          decoration: const BoxDecoration(
                                                            border: Border.symmetric(
                                                              horizontal: BorderSide(
                                                                width: 0.5,
                                                                color: Color.fromARGB(255, 222, 220, 220),
                                                              ),
                                                            ),
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text(
                                                              cell.isEmpty ? '' : cell,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (_showKeyboard)
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 9),
                          child: KeyboardWidget(
                            controller: _searchController,
                            isNumericMode: currentNumericMode,
                            customLayoutKeys: true,
                            isShiftEnabled: _shiftEnabled,
                            onKeyPress: (key) async {
                              String text = _searchController.text;
                              TextSelection currentSelection = _searchController.selection;
                              int cursorPosition = currentSelection.start;

                              if (key.keyType == VirtualKeyboardKeyType.String) {
                                String inputText = (_shiftEnabled ? key.capsText : key.text) ?? '';
                                text = text.replaceRange(cursorPosition, cursorPosition, inputText);
                                cursorPosition += inputText.length;

                                setState(() {
                                  searchedQuery = text;
                                });
                                await searchByKeyword(searchedQuery ?? "");
                              } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                                switch (key.action) {
                                  case VirtualKeyboardKeyAction.Backspace:
                                    if (text.isNotEmpty && cursorPosition > 0) {
                                      text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
                                      cursorPosition -= 1;

                                      setState(() {
                                        searchedQuery = text;
                                      });
                                      await searchByKeyword(searchedQuery ?? "");
                                    }
                                    break;
                                  case VirtualKeyboardKeyAction.Return:
                                    setState(() {
                                      searchedQuery = text;
                                    });
                                    await searchByKeyword(searchedQuery ?? "");

                                    break;
                                  case VirtualKeyboardKeyAction.Space:
                                    text = text.replaceRange(cursorPosition, cursorPosition, ' ');
                                    cursorPosition += 1;
                                    setState(() {
                                      searchedQuery = text;
                                    });
                                    await searchByKeyword(searchedQuery ?? "");
                                    break;
                                  case VirtualKeyboardKeyAction.Shift:
                                    _shiftEnabled = !_shiftEnabled;
                                    break;
                                  default:
                                    break;
                                }
                              }
                              _searchController.text = text;
                              _searchController.selection = TextSelection.collapsed(offset: cursorPosition);

                              setState(() {});
                            },
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: ProjectColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            color: Color.fromRGBO(0, 0, 0, 0.222),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ProjectColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        ),
                        onPressed: _refreshData,
                        child: const Text("Reload PLUs"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: ProjectColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            color: Color.fromRGBO(0, 0, 0, 0.222),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ProjectColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        ),
                        onPressed: _exportFile,
                        child: const Text("Export PLUs"),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
