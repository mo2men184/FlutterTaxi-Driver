import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/model/user_model.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CompletedController extends GetxController {
  var isLoading = true.obs;
  var rideList = <RideData>[].obs;

  @override
  void onInit() {
    getCompletedRide();
    getUsrData();
    super.onInit();
  }

  UserModel? userModel;

  getUsrData() {
    userModel = Constant.getUserData();
  }

  Future<dynamic> getCompletedRide() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.getCompletedRide}?id_driver=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isLoading.value = false;
        RideModel model = RideModel.fromJson(responseBody);
        rideList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        rideList.clear();
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

  // Future<dynamic> feelAsSafe(String id) async {
  //   try {
  //     ShowToastDialog.showLoader("Please wait");
  //     Map<String, dynamic> bodyParams = {
  //       'user_name': userModel!.userData!.nom,
  //       'user_cat': userModel!.userData!.userCat,
  //       'trip_id': id,
  //     };
  //     final response = await http.post(Uri.parse(API.feelSafeAtDestination), headers: API.header, body: jsonEncode(bodyParams));
  //     print(response.request);
  //     print(response.body);
  //     Map<String, dynamic> responseBody = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       ShowToastDialog.closeLoader();
  //       return responseBody;
  //     } else {
  //       ShowToastDialog.closeLoader();
  //       ShowToastDialog.showToast('Something want wrong. Please try again later');
  //       throw Exception('Failed to load album');
  //     }
  //   } on TimeoutException catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.message.toString());
  //   } on SocketException catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.message.toString());
  //   } on Error catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.toString());
  //   } catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.toString());
  //   }
  //   return null;
  // }

  Future<dynamic> conformPaymentByCache(String id) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      Map<String, dynamic> bodyParams = {
        'id_ride': id,
      };
      final response = await http.post(Uri.parse(API.conformPaymentByCash),
          headers: API.header, body: jsonEncode(bodyParams));
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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
}
