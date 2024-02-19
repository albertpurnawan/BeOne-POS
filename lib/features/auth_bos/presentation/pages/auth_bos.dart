import 'package:flutter/material.dart';
import 'package:pos_fe/features/auth_bos/domain/usecases/auth_services.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  final AuthService _authService = AuthService();
  String _token = '';

  void _fetchToken() async {
    print("Fetching token...");
    final token = await _authService.fetchAuthToken(
        "interfacing@sesa.com", "BeOne\$\$123");
    if (token != null) {
      print("Token received: ${token.token}");
      setState(() {
        _token = token.token;
      });
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
              onPressed: _fetchToken,
              child: Text('Fetch Token'),
            ),
            SizedBox(height: 20),
            Text(
              _token,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
