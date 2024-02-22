import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/syncdata/data/models/user_master_model.dart';
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
  int _usersCount = 0;

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

  void _fetchData() async {
    print("Synching data...");
    try {
      final data =
          await GetIt.instance<AppDatabase>().usersDao.insertUsersFromApi();
      setState(() {
        _usersCount = data.length;
      });
    } catch (error) {
      print("Error fetching users: $error");
    }
  }

  void _fetchSingleData(String docid) async {
    print("Fetching single data...");
    try {
      final data = await GetIt.instance<AppDatabase>()
          .usersApi
          .fetchSingleUserData(docid);
      print(data);
      if (data[0] == null) {
        setState(() {
          _singleData = 'Data not found';
        });
      } else {
        setState(() {
          _singleData = data[0]['docid'];
        });
      }
    } catch (error) {
      print("Error fetching users: $error");
    }
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
            ElevatedButton(
              onPressed: () {
                _fetchToken();
                _fetchData();
              },
              child: Text('Sync'),
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
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Text(
              'Data Fetched: ${_singleData}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Data Count: $_usersCount',
              style: TextStyle(fontSize: 18),
            ),
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
