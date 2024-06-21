// ignore_for_file: avoid_print, library_prefixes

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/payStackURLModel.dart';
import 'package:rugbydriver/model/bank_details_model.dart';
import 'package:rugbydriver/model/payment_method_model.dart';
import 'package:rugbydriver/model/payment_setting_model.dart';
import 'package:rugbydriver/model/razorpay_gen_userid_model.dart';
import 'package:rugbydriver/model/trancation_model.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripePrefix;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WalletController extends GetxController {
  RxString ref = "".obs;

  RxString totalEarn = "0".obs;
  RxDouble dailyEarn = 0.0.obs;
  RxDouble weeklyEarn = 0.0.obs;
  RxString? selectedRadioTile;
  var paymentSettingModel = PaymentSettingModel().obs;

  RxBool stripe = false.obs;
  RxBool razorPay = false.obs;
  RxBool payTm = false.obs;
  RxBool paypal = false.obs;
  RxBool payStack = false.obs;
  RxBool flutterWave = false.obs;
  RxBool mercadoPago = false.obs;
  RxBool payFast = false.obs;
  var isLoading = true.obs;
  var paymentMethodList = <PaymentMethodData>[].obs;

  @override
  Future<void> onInit() async {
    getTrancation();
    setFlutterwaveRef();
    getPaymentMethod();
    selectedRadioTile = "".obs;
    paymentSettingModel.value = Constant.getPaymentSetting();

    stripePrefix.Stripe.publishableKey =
        paymentSettingModel.value.strip!.clientpublishableKey!;
    stripePrefix.Stripe.merchantIdentifier = "RugbyRides";
    // await stripePrefix.Stripe.instance.applySettings();

    super.onInit();
  }

  setFlutterwaveRef() {
    Random numRef = Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      ref.value = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      ref.value = "IOSRef$year$refNumber";
    }
  }

  Future<dynamic> getPaymentMethod() async {
    try {
      isLoading.value = true;
      final response =
          await http.get(Uri.parse(API.getPaymentMethod), headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        PaymentMethodModel model = PaymentMethodModel.fromJson(responseBody);
        await stripePrefix.Stripe.instance.applySettings();
        paymentMethodList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "failed") {
        paymentMethodList.clear();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        paymentMethodList.clear();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  var bankDetails = BankData();

  Future<dynamic> getBankDetails() async {
    ShowToastDialog.showLoader("Please wait");
    try {
      final response = await http.get(
          Uri.parse(
              "${API.bankDetails}?driver_id=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        BankDetailsModel model = BankDetailsModel.fromJson(responseBody);
        bankDetails = model.data!;
        return bankDetails;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error'].toString());
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  var transactionList = <TansactionData>[].obs;

  Future<dynamic> getTrancation() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.walletHistory}?id_diver=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;

        TruncationModel model = TruncationModel.fromJson(responseBody);
        transactionList.value = model.data!;
        totalEarn.value = model.totalEarnings!.toString();
        update();
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        transactionList.clear();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<bool?> setWithdrawals(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.withdrawalsRequest),
          headers: API.header, body: jsonEncode(bodyParams));
      print(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return true;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
        return null;
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> setAmount(String amount) async {
    print('00000000AMOUNT : $amount');
    try {
      ShowToastDialog.showLoader("Please wait");
      Map<String, dynamic> bodyParams = {
        'id_user': Preferences.getInt(Preferences.userId),
        'cat_user': "driver",
        'amount': amount,
        'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
        'paymethod': selectedRadioTile!.value,
      };
      final response = await http.post(Uri.parse(API.amount),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "failed") {
        ShowToastDialog.closeLoader();
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  ///Stripe
  createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "${Preferences.getInt(Preferences.userId)} Wallet Topup",
        "shipping[name]":
            "${Preferences.getInt(Preferences.userId)} ${Preferences.getInt(Preferences.userId)}",
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      var stripeSecret = paymentSettingModel.value.strip!.secretKey;

      await stripePrefix.Stripe.instance.applySettings();
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      print("=====$e");
    }
  }

  ///razorPay
  Future<CreateRazorPayOrderModel?> createOrderRazorPay(
      {required int amount, bool isTopup = false}) async {
    final String orderId =
        "${Preferences.getInt(Preferences.userId)}_${DateTime.now().microsecondsSinceEpoch}";

    const url = "${API.baseUrl}payments/razorpay/createorder";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'apikey': API.apiKey,
          'accesstoken': Preferences.getString(Preferences.accesstoken),
        },
        body: {
          "amount": (amount * 100).toString(),
          "receipt_id": orderId,
          "currency": "INR",
          "razorpaykey": paymentSettingModel.value.razorpay!.key,
          "razorPaySecret": paymentSettingModel.value.razorpay!.secretKey,
          "isSandBoxEnabled":
              paymentSettingModel.value.razorpay!.isSandboxEnabled,
        },
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['id'] != null) {
        isLoading.value = false;
        return CreateRazorPayOrderModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['id'] == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;

    //
    //
    // final response = await http.post(
    //   Uri.parse(url),
    //   body: {
    //     "amount": (amount * 100).toString(),
    //     "receipt_id": orderId,
    //     "currency": "INR",
    //     "razorpaykey": "rzp_test_0iHc1FA4UBP0H3",
    //     "razorPaySecret": "Y79h9H1l4qLTKvgXFDei9pA5",
    //     "isSandBoxEnabled": true,
    //   },
    // );
    //
    //
    // if (response.statusCode == 500) {
    //   return null;
    // } else {
    //   final data = jsonDecode(response.body);
    //
    //
    //   return CreateRazorPayOrderModel.fromJson(data);
    // }
    //
  }

  ///paytm
  Future verifyCheckSum(
      {required String checkSum,
      required double amount,
      required orderId}) async {
    String getChecksum = "${API.baseUrl}payments/validatechecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        body: {
          "mid": paymentSettingModel.value.paytm!.merchantId,
          "order_id": orderId,
          "key_secret": paymentSettingModel.value.paytm!.merchantKey,
          "checksum_value": checkSum,
        });
    final data = jsonDecode(response.body);

    return data['status'];
  }

  ///payStack
  Future<dynamic> payStackURLGen(
      {required String amount, required secretKey}) async {
    const url = "https://api.paystack.co/transaction/initialize";

    try {
      final response = await http.post(Uri.parse(url), body: {
        "email": "demo@email.com",
        "amount": (double.parse(amount) * 100).toString(),
        "currency": "NGN",
      }, headers: {
        "Authorization": "Bearer $secretKey",
      });

      final responseBody = json.decode(response.body);
      log(responseBody);

      if (response.statusCode == 200 && responseBody['status'] == true) {
        isLoading.value = false;
        return PayStackUrlModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['status'] == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }

    final response = await http.post(Uri.parse(url), body: {
      "email": "demo@email.com",
      "amount": (double.parse(amount) * 100).toString(),
      "currency": "NGN",
    }, headers: {
      "Authorization": "Bearer $secretKey",
    });

    final data = jsonDecode(response.body);

    if (!data["status"]) {
      return null;
    }
    return PayStackUrlModel.fromJson(data);
  }

  Future<bool> payStackVerifyTransaction({
    required String reference,
    required String secretKey,
    required String amount,
  }) async {
    final url = "https://api.paystack.co/transaction/verify/$reference";
    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $secretKey",
    });

    final data = jsonDecode(response.body);
    if (data["status"] == true) {
      if (data["message"] == "Verification successful") {}
    }

    return data["status"];

    //PayPalClientSettleModel.fromJson(data);
  }
}
