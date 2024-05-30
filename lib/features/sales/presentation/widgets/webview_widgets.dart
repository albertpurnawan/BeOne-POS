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
          await controller.runJavaScript('''
            (function() {
              var height = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);
              window.scrollTo(0, (height - window.innerHeight) / 2);
            })();
          ''');
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
