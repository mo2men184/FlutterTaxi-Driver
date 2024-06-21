import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/model/user_model.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  Future<UserModel?> signUp(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.userSignUP),
          headers: API.authheader, body: jsonEncode(bodyParams));

      debugPrint(response.toString());
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        if (responseBody['success'] == "Failed") {
          ShowToastDialog.showToast(responseBody['error']);
        } else {
          Preferences.setString(Preferences.accesstoken,
              responseBody['data']['accesstoken'].toString());
          API.header['accesstoken'] =
              Preferences.getString(Preferences.accesstoken);

          return UserModel.fromJson(responseBody);
        }
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
      log(e.toString());
    }
    ShowToastDialog.closeLoader();
    return null;
  }
}
