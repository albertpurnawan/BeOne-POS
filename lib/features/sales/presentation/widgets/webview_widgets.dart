import 'dart:async'; // Import for Future.delayed

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  final String xurl;
  const WebViewStack({Key? key, required this.xurl}) : super(key: key);

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
          print('Page started loading: $url'); // Add logging
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) async {
          setState(() {
            loadingPercentage = 100;
          });
          print('Page finished loading: $url'); // Add logging

          // Inject JavaScript to check for payment success indication
          final success = await controller.runJavaScriptReturningResult('''
            (function() {
              // Example: check if certain text is present on the page
              return document.body.innerText.includes('Pembayaran Berhasil');
            })();
          ''');

          if (success == true) {
            print('Payment success detected'); // Add logging
            // Delay for 5 seconds before navigating to the success screen
            Future.delayed(Duration(seconds: 5), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SuccessScreen()),
              );
            });
          }
        },
      ))
      ..loadRequest(
        Uri.parse(widget.xurl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 500,
            height: 700,
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ),
        if (loadingPercentage < 100)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
          ),
      ],
    );
  }
}

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
      ),
      body: Center(
        child: Text(
          'Payment was successful!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
