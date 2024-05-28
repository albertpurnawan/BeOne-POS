import 'package:flutter/material.dart';
import 'package:pos_fe/features/sales/presentation/widgets/webview_widgets.dart';

class WebViewApp extends StatefulWidget {
  final String url;
  const WebViewApp({super.key, required this.url});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRIS Payment'),
      ),
      body: WebViewStack(xurl: widget.url),
    );
  }
}
