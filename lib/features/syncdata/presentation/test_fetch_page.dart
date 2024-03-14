import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/user_masters_dao.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/country_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/credit_card_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/currency_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/employee_services.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_masters_servive.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/payment_type_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/province_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/zipcode_service.dart';
import 'package:pos_fe/features/syncdata/domain/usecases/fetch_bos_token.dart';
import 'package:pos_fe/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // await GetIt.instance<AppDatabase>().emptyDb();
      // print("DB Opened");

      // final currencies = await GetIt.instance<CurrencyApi>().fetchData();
      // await GetIt.instance<AppDatabase>().currencyDao.bulkCreate(currencies);
      // final countries = await GetIt.instance<CountryApi>().fetchData();
      // await GetIt.instance<AppDatabase>().countryDao.bulkCreate(countries);
      // final provinces = await GetIt.instance<ProvinceApi>().fetchData();
      // await GetIt.instance<AppDatabase>().provinceDao.bulkCreate(provinces);
      // final zipcodes = await GetIt.instance<ZipcodeApi>().fetchData();
      // await GetIt.instance<AppDatabase>().zipcodeDao.bulkCreate(zipcodes);
      // final employees = await GetIt.instance<EmployeeApi>().fetchData();
      // await GetIt.instance<AppDatabase>().employeeDao.bulkCreate(employees);
      // final taxes = await GetIt.instance<TaxMasterApi>().fetchData();
      // await GetIt.instance<AppDatabase>().taxMasterDao.bulkCreate(taxes);
      // final paymentTypes = await GetIt.instance<PaymentTypeApi>().fetchData();
      // await GetIt.instance<AppDatabase>()
      //     .paymentTypeDao
      //     .bulkCreate(paymentTypes);
      // final mops = await GetIt.instance<MOPApi>().fetchData();
      // await GetIt.instance<AppDatabase>().meansOfPaymentDao.bulkCreate(mops);
      final ccs = await GetIt.instance<CreditCardApi>().fetchData();
      await GetIt.instance<AppDatabase>().creditCardDao.bulkCreate(ccs);

      // var fetched = currencies.length +
      //     countries.length +
      //     provinces.length +
      //     zipcodes.length +
      //     employees.length;

      setState(() {
        _dataCount = ccs.length;
      });
      print('Data synched');
    } catch (error) {
      print("Error synchronizing: $error");
    }
  }

  void _fetchData() async {
    print('Fetching data...');
    try {
      final data = await GetIt.instance<ProvinceApi>().fetchData();

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
      final datum = await GetIt.instance<UoMApi>().fetchSingleData(docid);
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
            Text(
              'Data Count: $_dataCount',
              style: TextStyle(fontSize: 18),
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
