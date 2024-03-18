import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/assign_price_member_per_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/authorization_service.dart';
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
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_picture_service.dart';
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

  void _syncData() async {
    print("Synching data...");
    try {
      setState(() {
        _syncProgress = 0.0;
      });

      final currencies = await GetIt.instance<CurrencyApi>().fetchData();
      await GetIt.instance<AppDatabase>().currencyDao.bulkCreate(currencies);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final countries = await GetIt.instance<CountryApi>().fetchData();
      await GetIt.instance<AppDatabase>().countryDao.bulkCreate(countries);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final provinces = await GetIt.instance<ProvinceApi>().fetchData();
      await GetIt.instance<AppDatabase>().provinceDao.bulkCreate(provinces);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final zipcodes = await GetIt.instance<ZipcodeApi>().fetchData();
      await GetIt.instance<AppDatabase>().zipcodeDao.bulkCreate(zipcodes);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final employees = await GetIt.instance<EmployeeApi>().fetchData();
      await GetIt.instance<AppDatabase>().employeeDao.bulkCreate(employees);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final taxes = await GetIt.instance<TaxMasterApi>().fetchData();
      await GetIt.instance<AppDatabase>().taxMasterDao.bulkCreate(taxes);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final payTypes = await GetIt.instance<PaymentTypeApi>().fetchData();
      await GetIt.instance<AppDatabase>().paymentTypeDao.bulkCreate(payTypes);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final mops = await GetIt.instance<MOPApi>().fetchData();
      await GetIt.instance<AppDatabase>().meansOfPaymentDao.bulkCreate(mops);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final ccs = await GetIt.instance<CreditCardApi>().fetchData();
      await GetIt.instance<AppDatabase>().creditCardDao.bulkCreate(ccs);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final pricelists = await GetIt.instance<PricelistApi>().fetchData();
      await GetIt.instance<AppDatabase>().pricelistDao.bulkCreate(pricelists);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final stores = await GetIt.instance<StoreMasterApi>().fetchData();
      await GetIt.instance<AppDatabase>().storeMasterDao.bulkCreate(stores);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final mopStores = await GetIt.instance<MOPByStoreApi>().fetchData();
      await GetIt.instance<AppDatabase>().mopByStoreDao.bulkCreate(mopStores);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final cashiers = await GetIt.instance<CashRegisterApi>().fetchData();
      await GetIt.instance<AppDatabase>().cashRegisterDao.bulkCreate(cashiers);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final uoms = await GetIt.instance<UoMApi>().fetchData();
      await GetIt.instance<AppDatabase>().uomDao.bulkCreate(uoms);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final roles = await GetIt.instance<UserRoleApi>().fetchData();
      await GetIt.instance<AppDatabase>().userRoleDao.bulkCreate(roles);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final users = await GetIt.instance<UserApi>().fetchData();
      await GetIt.instance<AppDatabase>().userDao.bulkCreate(users);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final pricelistPeriod =
          await GetIt.instance<PricelistPeriodApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .pricelistPeriodDao
          .bulkCreate(pricelistPeriod);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final itemCat = await GetIt.instance<ItemCategoryApi>().fetchData();
      await GetIt.instance<AppDatabase>().itemCategoryDao.bulkCreate(itemCat);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final items = await GetIt.instance<ItemMasterApi>().fetchData();
      await GetIt.instance<AppDatabase>().itemMasterDao.bulkCreate(items);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final itemsStores = await GetIt.instance<ItemByStoreApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .itemByStoreDao
          .bulkCreate(itemsStores);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final itemBarcodes = await GetIt.instance<ItemBarcodeApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .itemBarcodeDao
          .bulkCreate(itemBarcodes);
      setState(() {
        _syncProgress += 1 / totalTable;
      });
      // // ---
      final itemRemarks = await GetIt.instance<ItemRemarksApi>().fetchData();
      await GetIt.instance<AppDatabase>().itemRemarkDao.bulkCreate(itemRemarks);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final venGroups = await GetIt.instance<VendorGroupApi>().fetchData();
      await GetIt.instance<AppDatabase>().vendorGroupDao.bulkCreate(venGroups);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final vendor = await GetIt.instance<VendorApi>().fetchData();
      await GetIt.instance<AppDatabase>().vendorDao.bulkCreate(vendor);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final prefVendor = await GetIt.instance<PreferredVendorApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .preferredVendorDao
          .bulkCreate(prefVendor);
      setState(() {
        _syncProgress += 1 / totalTable;
      });
      // // ---

      final cusGroup = await GetIt.instance<CustomerGroupApi>().fetchData();
      await GetIt.instance<AppDatabase>().customerGroupDao.bulkCreate(cusGroup);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final cusCst = await GetIt.instance<CustomerApi>().fetchData();
      await GetIt.instance<AppDatabase>().customerCstDao.bulkCreate(cusCst);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final priceByItem = await GetIt.instance<PriceByItemApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .priceByItemDao
          .bulkCreate(priceByItem);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final apmps = await GetIt.instance<APMPSApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .assignPriceMemberPerStoreDao
          .bulkCreate(apmps);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

      final priceItemBarcode =
          await GetIt.instance<PriceByItemBarcodeApi>().fetchData();
      await GetIt.instance<AppDatabase>()
          .priceByItemBarcodeDao
          .bulkCreate(priceItemBarcode);
      setState(() {
        _syncProgress += 1 / totalTable;
      });

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
    } catch (error) {
      print("Error synchronizing: $error");
    }
  }

  void _fetchData() async {
    print('Fetching data...');
    try {
      final data = await GetIt.instance<CurrencyApi>().fetchData();

      setState(() {
        _dataFetched = data.length;
        _dataExample = data[0].docId;
        _errorMessage = '';
      });
      print(data);
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
        _singleData = datum.docId;
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
                _syncData();
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
