import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _inAppWebViewController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool isPop) async {
        if (_inAppWebViewController != null) {
          bool canGoBack = await _inAppWebViewController.canGoBack();
          if (canGoBack) {
            _inAppWebViewController.goBack();
            return;
          }
        }
        exit(0); // Exit only if no back history
      },
      child: Scaffold(
        appBar: MediaQuery.of(context).orientation == Orientation.landscape
            ? null
            : AppBar(
          backgroundColor: Colors.white,
          title: const Text("Youtube Lite"),
          actions: [
            IconButton(
                onPressed: () async {
                  if (_inAppWebViewController != null &&
                      await _inAppWebViewController.canGoBack()) {
                    _inAppWebViewController.goBack();
                  }
                },
                icon: const Icon(Icons.arrow_back))
          ],
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse("https://www.youtube.com/watch?v=ua54JU7k1Us")),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      supportZoom: false,
                      useShouldOverrideUrlLoading: true)),
              onWebViewCreated: (controller) {
                _inAppWebViewController = controller; // FIXED
              },
              onLoadStop: (controller, url) {
                setState(() {
                  progress = 1.0;
                });
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  this.progress = progress / 100; // FIXED
                });
              },
            ),
            if (progress < 1.0)
              LinearProgressIndicator(
                value: progress,
                color: Colors.green,
                backgroundColor: Colors.black12,
              ),
          ],
        ),
      ),
    );
  }
}

