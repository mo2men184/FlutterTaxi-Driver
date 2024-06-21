import 'dart:convert';
import 'dart:developer';

import 'package:rugbydriver/model/payment_setting_model.dart';
import 'package:http/http.dart' as http;

class PayStackURLGen {
  static Future payStackURLGen(
      {required String amount,
      required String secretKey,
      required String currency}) async {
    const url = "https://api.paystack.co/transaction/initialize";
    final response = await http.post(Uri.parse(url), body: {
      "email": "email@deom.com",
      "amount": amount,
      "currency": currency,
    }, headers: {
      "Authorization": "Bearer $secretKey",
    });
    final data = jsonDecode(response.body);
    if (!data["status"]) {
      return null;
    }
    return PayFast.fromJson(data);
  }

  static Future<bool> verifyTransaction({
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

  static Future<String> getPayHTML(
      {required String amount,
      required PayFast payFastSettingData,
      String itemName = "wallet Topup"}) async {
    String newUrl =
        'https://${payFastSettingData.isSandboxEnabled == "true" ? "sandbox" : "www"}.payfast.co.za/eng/process';
    Map body = {
      'merchant_id': payFastSettingData.merchantId,
      'merchant_key': payFastSettingData.merchantKey,
      'amount': amount,
      'item_name': itemName,
      'return_url': payFastSettingData.returnUrl,
      'cancel_url': payFastSettingData.cancelUrl,
      'notify_url': payFastSettingData.notifyUrl,
      'name_first': "firstName",
      'name_last': "lastName",
      'email_address': "email@deom.com",
    };

    final response = await http.post(
      Uri.parse(newUrl),
      body: body,
    );

    log(response.body);
    return response.body;
  }
}
