import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/assign_price_member_per_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/cash_register_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/country_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/credit_card_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/currency_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/customer_group_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/customer_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/employee_services.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/invoice_header_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_barcode_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_by_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_category_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_remarks_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_by_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_masters_servive.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/payment_type_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/preferred_vendor_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_barcode_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pricelist_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pricelist_period_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/province_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/store_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_role_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/vendor_group_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/vendor_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/zipcode_service.dart';
import 'package:pos_fe/features/syncdata/domain/usecases/fetch_bos_token.dart';
import 'package:uuid/uuid.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  final TextEditingController _docIdController = TextEditingController();
  final AuthApi _authApi = AuthApi();

  String _token = '';
  String _singleData = '';
  int _dataCount = 0;
  int _dataFetched = 0;
  String _dataExample = '';
  int _statusCode = 0;
  String _errorMessage = '';
  double _syncProgress = 0.0;
  int totalTable = 30;
  int fetched = 0;

  void _fetchToken() async {
    print("Fetching token...");
    final token =
        await _authApi.fetchAuthToken("interfacing@sesa.com", "BeOne\$\$123");
    if (token != null) {
      print("Token received: ${token.token}");
      setState(() {
        _token = token.token;
      });
    }
  }

  void _manualSyncData() async {
    print("Synching data...");
    try {
      setState(() {
        _syncProgress = 0.0;
      });

      final currencies = await GetIt.instance<CurrencyApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .currencyDao
          .bulkCreate(data: currencies);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final countries = await GetIt.instance<CountryApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .countryDao
          .bulkCreate(data: countries);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final provinces = await GetIt.instance<ProvinceApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .provinceDao
          .bulkCreate(data: provinces);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final zipcodes = await GetIt.instance<ZipcodeApi>().fetchData();
      await GetIt.instance<AppDatabase>().zipcodeDao.bulkCreate(data: zipcodes);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final employees = await GetIt.instance<EmployeeApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .employeeDao
          .bulkCreate(data: employees);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final taxes = await GetIt.instance<TaxMasterApi>().fetchData();
      await GetIt.instance<AppDatabase>().taxMasterDao.bulkCreate(data: taxes);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final payTypes = await GetIt.instance<PaymentTypeApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .paymentTypeDao
          .bulkCreate(data: payTypes);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final mops = await GetIt.instance<MOPApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .meansOfPaymentDao
          .bulkCreate(data: mops);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final ccs = await GetIt.instance<CreditCardApi>().fetchData();
      await GetIt.instance<AppDatabase>().creditCardDao.bulkCreate(data: ccs);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final pricelists = await GetIt.instance<PricelistApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .pricelistDao
          .bulkCreate(data: pricelists);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final stores = await GetIt.instance<StoreMasterApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .storeMasterDao
          .bulkCreate(data: stores);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final mopStores = await GetIt.instance<MOPByStoreApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .mopByStoreDao
          .bulkCreate(data: mopStores);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final cashiers = await GetIt.instance<CashRegisterApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .cashRegisterDao
          .bulkCreate(data: cashiers);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final uoms = await GetIt.instance<UoMApi>().fetchData();
      await GetIt.instance<AppDatabase>().uomDao.bulkCreate(data: uoms);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final roles = await GetIt.instance<UserRoleApi>().fetchData();
      await GetIt.instance<AppDatabase>().userRoleDao.bulkCreate(data: roles);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final users = await GetIt.instance<UserApi>().fetchData();
      await GetIt.instance<AppDatabase>().userDao.bulkCreate(data: users);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final pricelistPeriod =
          await GetIt.instance<PricelistPeriodApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .pricelistPeriodDao
          .bulkCreate(data: pricelistPeriod);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final itemCat = await GetIt.instance<ItemCategoryApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .itemCategoryDao
          .bulkCreate(data: itemCat);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final items = await GetIt.instance<ItemMasterApi>().fetchData();
      await GetIt.instance<AppDatabase>().itemMasterDao.bulkCreate(data: items);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final itemsStores = await GetIt.instance<ItemByStoreApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .itemByStoreDao
          .bulkCreate(data: itemsStores);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final itemBarcodes = await GetIt.instance<ItemBarcodeApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .itemBarcodeDao
          .bulkCreate(data: itemBarcodes);
      setState(() {
        _syncProgress += 1 / totalTable;
      });
      // // ---
      final itemRemarks = await GetIt.instance<ItemRemarksApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .itemRemarkDao
          .bulkCreate(data: itemRemarks);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final venGroups = await GetIt.instance<VendorGroupApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .vendorGroupDao
          .bulkCreate(data: venGroups);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final vendor = await GetIt.instance<VendorApi>().fetchData();
      await GetIt.instance<AppDatabase>().vendorDao.bulkCreate(data: vendor);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final prefVendor = await GetIt.instance<PreferredVendorApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .preferredVendorDao
          .bulkCreate(data: prefVendor);
      setState(() {
        _syncProgress += 1 / totalTable;
      });
      // // ---

      final cusGroup = await GetIt.instance<CustomerGroupApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .customerGroupDao
          .bulkCreate(data: cusGroup);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final cusCst = await GetIt.instance<CustomerApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .customerCstDao
          .bulkCreate(data: cusCst);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final priceByItem = await GetIt.instance<PriceByItemApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .priceByItemDao
          .bulkCreate(data: priceByItem);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final apmps = await GetIt.instance<APMPSApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .assignPriceMemberPerStoreDao
          .bulkCreate(data: apmps);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final priceItemBarcode =
          await GetIt.instance<PriceByItemBarcodeApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .priceByItemBarcodeDao
          .bulkCreate(data: priceItemBarcode);
      setState(() {
        _syncProgress += 1 / totalTable;
      });
      // log("$priceItemBarcode\n");

      // final topos =
      //     await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final posParameter = [
        {
          "docid": const Uuid().v4(),
          "createdate": DateTime.now().toString(),
          "updatedate": DateTime.now().toString(),
          "gtentId": const Uuid().v4(),
          "tostrId": stores[0].docId,
          "storename": stores[0].storeName,
          "tcurrId": stores[0].tcurrId,
          "currcode": currencies[0].curCode,
          "toplnId": stores[0].toplnId,
          "tocsrId": cashiers[0].docId,
          "tovatId": stores[0].tovatId,
          "baseUrl": "someUrl",
          "user": "user",
          "password": "password",
        }
      ];

      await GetIt.instance<AppDatabase>().posParameterDao.bulkCreate(
          data: posParameter.map((e) => POSParameterModel.fromMap(e)).toList());

      // final auths = await GetIt.instance<AuthorizationApi>().fetchData();
      // await GetIt.instance<AppDatabase>().authorizationDao.bulkCreate(auths);
      // final itemPics = await GetIt.instance<ItemPictureApi>().fetchData();
      // await GetIt.instance<AppDatabase>().itemPictureDao.bulkCreate(itemPics);

      fetched = currencies.length +
          countries.length +
          provinces.length +
          zipcodes.length +
          employees.length +
          taxes.length +
          payTypes.length +
          mops.length +
          ccs.length +
          pricelists.length +
          stores.length +
          mopStores.length +
          cashiers.length +
          uoms.length +
          roles.length +
          users.length +
          pricelistPeriod.length +
          itemCat.length +
          items.length +
          itemsStores.length +
          itemBarcodes.length +
          itemRemarks.length +
          venGroups.length +
          vendor.length +
          prefVendor.length +
          cusGroup.length +
          cusCst.length +
          priceByItem.length +
          apmps.length +
          priceItemBarcode.length;

      setState(() {
        _dataCount = fetched;
        _syncProgress = 1.0;
      });
      print('Data synched');
    } catch (error, stack) {
      print("Error synchronizing: $error");
      debugPrintStack(stackTrace: stack);
    }
  }

  void _fetchData() async {
    print('Fetching data...');
    try {
      final data = await GetIt.instance<InvoiceApi>().sendInvoice();

      setState(() {
        // _dataFetched = data.length;
        // _dataExample = data[0].docId;
        _errorMessage = '';
      });
      // print(data);
      print("Data Fetched");
    } catch (error) {
      print('Error: $error');
      handleError(error);
      setState(() {
        _statusCode = handleError(error)['statusCode'];
        _errorMessage = handleError(error)['message'];
        _clearErrorMessageAfterDelay();
      });
    }
  }

  void _fetchSingleData(String docid) async {
    print("Fetching single data...");
    try {
      final datum =
          await GetIt.instance<InvoiceHeaderApi>().fetchSingleData(docid);
      print(datum);
      setState(() {
        _singleData = datum.docnum;
      });
      print("Data Fetched");
    } catch (error) {
      handleError(error);
      setState(() {
        _statusCode = handleError(error)['statusCode'];
        _errorMessage = handleError(error)['message'];
        _clearErrorMessageAfterDelay();
      });
    }
  }

  void _clearErrorMessageAfterDelay() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _statusCode = 0;
        _errorMessage = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // _fetchToken();
                _manualSyncData();
              },
              child: Text('SYNC'),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 40,
                    child: LinearProgressIndicator(
                      value: _syncProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _syncProgress == 1.0
                          ? "Data Synced: $fetched"
                          : "${(_syncProgress * 100).round().toString()}%",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchData();
              },
              child: Text('FETCH'),
            ),
            SizedBox(height: 20),
            Text(
              'Data Fetched: [$_dataFetched] $_dataExample',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _docIdController,
              decoration: InputDecoration(
                labelText: 'Enter Document ID',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchSingleData(_docIdController.text);
              },
              child: Text('SEARCH'),
            ),
            SizedBox(height: 20),
            Text(
              'Data Found: ${_singleData}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (_statusCode != 0) Text(_statusCode.toString()),
            if (_errorMessage.isNotEmpty) Text(_errorMessage),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _docIdController.dispose();
    super.dispose();
  }
}
