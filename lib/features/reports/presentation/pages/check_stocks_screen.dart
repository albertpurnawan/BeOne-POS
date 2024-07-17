import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/reports/data/data_source/remote/check_stock_service.dart';
import 'package:pos_fe/features/sales/data/models/check_stock.dart';
import 'package:pos_fe/features/sales/domain/entities/check_stock.dart';

class CheckStockScreen extends StatefulWidget {
  const CheckStockScreen({super.key});

  @override
  State<CheckStockScreen> createState() => _CheckStockScreenState();
}

class _CheckStockScreenState extends State<CheckStockScreen> {
  final TextEditingController _itemInputController = TextEditingController();

  List<dynamic>? itemsFound;
  Map<String, dynamic>? selectedItem;
  List<CheckStockEntity> stocksFetched = [
    CheckStockEntity(
      itemCode: "1234567890",
      itemName: " Test Item Name",
      storeCode: "Store-123",
      storeName: "Store123",
      qtyOnHand: 2,
      ordered: 4,
      commited: 1,
      available: 5,
    ),
  ];

  bool showTable = false;

  @override
  void dispose() {
    _itemInputController.dispose();
    super.dispose();
  }

  Future<List<dynamic>?> _searchItem(String query) async {
    final item = await GetIt.instance<AppDatabase>().itemMasterDao.readByKeyword(query);
    return item;
  }

  void _handleItemSelected(Map<String, dynamic> item) async {
    log("item - $item");
    // final stocks = await _checkStock(item['itemcode'], item['itemname']);
    // log("stocks - $stocks");
    setState(() {
      _itemInputController.text = "";
      itemsFound = null;
      selectedItem = item;
      showTable = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<List<CheckStockModel>> _checkStock(String itemCode, String itemName) async {
    final stockData = await GetIt.instance<CheckStockApi>().fetchData(itemCode, itemName);
    return stockData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Check Stocks'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.98,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _inputItemBox(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (itemsFound != null && itemsFound!.isNotEmpty)
                    Expanded(
                      child: _searchResult(onItemSelected: _handleItemSelected),
                    ),
                  const Divider(),
                  if (showTable)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _stocksTable(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputItemBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.66,
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Item SKU / Barcode",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _itemInputController,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        hintText: "Scan or Type an Item SKU/Barcode",
                        hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: ProjectColors.mediumBlack, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: ProjectColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onEditingComplete: () async {
                        final itemsSearched = await _searchItem(_itemInputController.text);
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          itemsFound = itemsSearched;
                          showTable = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 11, horizontal: 20)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          side: const BorderSide(color: ProjectColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        )),
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => ProjectColors.primary,
                        ),
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2)),
                      ),
                      onPressed: () async {
                        final itemsSearched = await _searchItem(_itemInputController.text);
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          itemsFound = itemsSearched;
                          showTable = false;
                        });
                      },
                      child: const Icon(
                        Icons.search_outlined,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchResult({required Function(Map<String, dynamic>) onItemSelected}) {
    return ListView.builder(
      itemCount: itemsFound!.length,
      itemBuilder: (context, index) {
        final item = itemsFound![index];
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Card(
            color: ProjectColors.background,
            shadowColor: ProjectColors.background,
            surfaceTintColor: Colors.transparent,
            child: ListTile(
              onTap: () {
                onItemSelected(item);
              },
              textColor: Colors.black,
              title: Text(
                item['itemname'] ?? 'Item Name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              subtitle: SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/inventory.svg",
                      height: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      item['itemcode'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SvgPicture.asset(
                      "assets/images/barcode.svg",
                      height: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      item['barcode'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.sell_outlined,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Rp ${Helpers.parseMoney(item['price'].toInt())}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stocksTable() {
    final price = selectedItem!['price'].toInt();
    final priceFormatted = Helpers.parseMoney(price);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                      child: Text(
                    "${(selectedItem != null) ? selectedItem!['itemname'] : ""}",
                    style: const TextStyle(color: ProjectColors.mediumBlack, fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inventory_2_outlined, color: Colors.black, size: 18.0),
                            Text(
                              " SKU: ${(selectedItem != null) ? selectedItem!['itemcode'] : ""}",
                              style: const TextStyle(
                                  color: ProjectColors.primary, fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/barcode.svg",
                              height: 20,
                            ),
                            Text(
                              " Barcode: ${(selectedItem != null) ? selectedItem!['barcode'] : ""}",
                              style: const TextStyle(
                                  color: ProjectColors.primary, fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.monetization_on_outlined, color: Colors.black, size: 18.0),
                            Text(
                              " Price: ${(selectedItem != null) ? priceFormatted : ""}",
                              style: const TextStyle(
                                  color: ProjectColors.primary, fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                spreadRadius: 0.5,
                blurRadius: 5,
                color: Color.fromRGBO(0, 0, 0, 0.222),
              ),
            ],
          ),
          child: Table(
            border: TableBorder.symmetric(
              outside: BorderSide.none,
              inside: BorderSide.none,
            ),
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: ProjectColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Store",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: ProjectColors.primary,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("On Hand",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: ProjectColors.primary,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Ordered",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: ProjectColors.primary,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Commited",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: ProjectColors.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Available",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              for (final stock in stocksFetched)
                TableRow(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 239, 238, 238),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        stock.storeCode,
                        style: TextStyle(color: ProjectColors.mediumBlack, fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        stock.qtyOnHand.toString(),
                        style: TextStyle(color: ProjectColors.mediumBlack, fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        stock.ordered.toString(),
                        style: TextStyle(color: ProjectColors.mediumBlack, fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        stock.commited.toString(),
                        style: TextStyle(color: ProjectColors.mediumBlack, fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        stock.available.toString(),
                        style: TextStyle(color: ProjectColors.mediumBlack, fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
