import 'package:flutter/material.dart';
import 'package:pos_fe/features/sales/presentation/widgets/webview_widgets.dart';

class WebViewApp extends StatefulWidget {
  final String url;
  final ValueChanged<bool> onPaymentSuccess;
  const WebViewApp(
      {Key? key, required this.url, required this.onPaymentSuccess})
      : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 500,
        height: 700,
        child: WebViewStack(
          xurl: widget.url,
          onPaymentSuccess: widget.onPaymentSuccess,
        ),
      ),
    );
  }
}
