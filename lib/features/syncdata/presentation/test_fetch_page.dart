import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/user_masters_dao.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/currency_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_barcode_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_by_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_category_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_barcode_masters_service.dart';
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
      final data = await GetIt.instance<UsersDao>().upsertDataFromAPI();
      setState(() {
        _dataCount = data.length;
      });
      print('Data synched');
    } catch (error) {
      print("Error synchronizing: $error");
    }
  }

  void _fetchData() async {
    print('Fetching data...');
    try {
      final data = await GetIt.instance<PriceByItemBarcodeApi>().fetchData();

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
          await GetIt.instance<PriceByItemBarcodeApi>().fetchSingleData(docid);
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
