// ignore_for_file: file_names, must_be_immutable

import 'dart:async';

import 'package:rugbydriver/controller/wallet_controller.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayStackScreen extends StatefulWidget {
  final WalletController walletController;
  final String initialURl;
  final String reference;
  final String amount;
  final String secretKey;
  final String callBackUrl;

  const PayStackScreen({
    Key? key,
    required this.initialURl,
    required this.reference,
    required this.amount,
    required this.secretKey,
    required this.walletController,
    required this.callBackUrl,
  }) : super(key: key);

  @override
  State<PayStackScreen> createState() => _PayStackScreenState();
}

class _PayStackScreenState extends State<PayStackScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    initController();
    super.initState();
  }

  initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigation) async {
            if (navigation.url ==
                '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}') {
              final isDone = await widget.walletController
                  .payStackVerifyTransaction(
                      secretKey: widget.secretKey,
                      reference: widget.reference,
                      amount: widget.amount);
              Get.back(result: isDone);
            }
            if (navigation.url ==
                '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}') {
              final isDone = await widget.walletController
                  .payStackVerifyTransaction(
                      secretKey: widget.secretKey,
                      reference: widget.reference,
                      amount: widget.amount);
              Get.back(result: isDone);
              //close webview
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialURl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: ConstantColors.primary,
            title: const Text("Payment"),
            centerTitle: false,
            leading: GestureDetector(
              onTap: () {
                _showMyDialog(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            )),

        body: WebViewWidget(controller: controller),
        // body: WebView(
        //   initialUrl: widget.initialURl,
        //   javascriptMode: JavascriptMode.unrestricted,
        //   gestureNavigationEnabled: true,
        //   userAgent:
        //       'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
        //   onWebViewCreated: (WebViewController webViewController) {
        //     _controller.future.then((value) => controllerGlobal = value);
        //     _controller.complete(webViewController);
        //   },
        //   navigationDelegate: (navigation) async {
        //     if (navigation.url ==
        //         '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}') {
        //       final isDone = await widget.walletController.payStackVerifyTransaction(
        //           secretKey: widget.secretKey, reference: widget.reference, amount: widget.amount);
        //       Get.back(result: isDone);
        //     }
        //     if (navigation.url ==
        //         '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}') {
        //       final isDone = await widget.walletController.payStackVerifyTransaction(
        //           secretKey: widget.secretKey, reference: widget.reference, amount: widget.amount);
        //       Get.back(result: isDone);
        //       //close webview
        //     }
        //     return NavigationDecision.navigate;
        //   },
        // ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Payment'),
          content: const SingleChildScrollView(
            child: Text('Are you want to cancel Payment?'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
