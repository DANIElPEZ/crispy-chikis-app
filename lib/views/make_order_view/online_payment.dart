import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class PayWebView extends StatefulWidget {
  final int amountInCents;
  final String username;

  const PayWebView({required this.amountInCents, required this.username});

  @override
  State<PayWebView> createState() => _PayWebViewState();
}

class _PayWebViewState extends State<PayWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (message) {
          final data = jsonDecode(message.message);
          final bool success = data['paymentSuccess'] == true;

          if (success) {
            Navigator.pop(context, data['paymentSuccess'] == true);
          }
        },
      )
      ..loadRequest(
        Uri.parse(
          'https://crispy-chikis-payment.vercel.app/'
          '?amount=${widget.amountInCents}'
          '&username=${Uri.encodeComponent(widget.username)}',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false, child: WebViewWidget(controller: _controller));
  }
}
