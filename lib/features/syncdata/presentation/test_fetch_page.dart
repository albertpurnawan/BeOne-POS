import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/syncdata/domain/usecases/fetch_bos_token.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:pos_fe/core/constants/constants.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  Database? _database;
  final AuthApi _authApi = AuthApi();
  String _token = '';
  List<dynamic> _userData = [];
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

  void _fetchUsers() async {
    print("Fetching data...");
    try {
      final userData =
          await GetIt.instance<AppDatabase>().usersDao.insertUsersFromApi();
      setState(() {
        _userData = userData;
        _usersCount = userData.length;
      });
    } catch (error) {
      print("Error fetching users: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FetchToken'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // _fetchToken();
                _fetchUsers();
              },
              child: Text('Fetch'),
            ),
            // SizedBox(height: 20),
            // Text(
            //   'Token: $_token',
            //   style: TextStyle(fontSize: 18),
            // ),
            SizedBox(height: 20),
            Text(
              'User Count: $_usersCount',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
