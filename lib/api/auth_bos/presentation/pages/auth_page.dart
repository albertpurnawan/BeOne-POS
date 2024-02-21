import 'package:flutter/material.dart';
import 'package:pos_fe/api/auth_api.dart';
import 'package:pos_fe/api/users/users_api.dart';
import 'package:pos_fe/core/constants/constants.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  final AuthApi _authApi = AuthApi();
  final UsersApi _userApi = UsersApi();
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
    print("Fetching users...");
    try {
      final userData = await _userApi.fetchUsersData();
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
              child: Text('Fetch Users'),
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
