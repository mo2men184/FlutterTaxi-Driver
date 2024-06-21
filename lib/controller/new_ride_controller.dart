import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/model/trancation_model.dart';
import 'package:rugbydriver/model/user_model.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class NewRideController extends GetxController {
  var isLoading = true.obs;
  var rideList = <RideData>[].obs;

  Timer? timer;
  RxString totalEarn = "0".obs;

  @override
  void onInit() {
    getNewRide();
    getUsrData();
    timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      getNewRide();
    });
    super.onInit();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  UserModel? userModel;

  getUsrData() async {
    userModel = Constant.getUserData();

    final response = await http.get(
        Uri.parse(
            "${API.walletHistory}?id_diver=${Preferences.getInt(Preferences.userId)}"),
        headers: API.header);

    Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode == 200 && responseBody['success'] == "success") {
      TruncationModel model = TruncationModel.fromJson(responseBody);

      totalEarn.value = model.totalEarnings!.toString();
    } else if (response.statusCode == 200 &&
        responseBody['success'] == "Failed") {
    } else {}
  }

  Future<dynamic> getNewRide() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.driverAllRides}?id_driver=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      LocationData currentLocation;
      Location location = Location();
      StreamSubscription<LocationData> locationSubscription =
          location.onLocationChanged.listen((event) {});

      PermissionStatus permissionStatus = await location.hasPermission();

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        RideModel model = RideModel.fromJson(responseBody);
        rideList.value = model.data!;
        // if (rideList[0].statut.toString() != "on ride") {
        //   if (permissionStatus == PermissionStatus.granted) {
        //     location.enableBackgroundMode(enable: true);
        //     location.changeSettings(
        //         accuracy: LocationAccuracy.high,
        //         distanceFilter:
        //             double.parse(Constant.driverLocationUpdateUnit.toString()),
        //         interval: 2000);
        //     locationSubscription = location.onLocationChanged.listen((locationData) {
        //       currentLocation = locationData;
        //
        //       Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).set({
        //         'driver_latitude': currentLocation.latitude,
        //         'driver_longitude': currentLocation.longitude,
        //         'rotation': currentLocation.heading,
        //       });
        //     });
        //   } else {
        //     location.requestPermission().then((permissionStatus) {
        //       if (permissionStatus == PermissionStatus.granted) {
        //         location.enableBackgroundMode(enable: true);
        //         location.changeSettings(
        //             accuracy: LocationAccuracy.high,
        //             distanceFilter: double.parse(
        //                 Constant.driverLocationUpdateUnit.toString()),
        //             interval: 2000);
        //         locationSubscription = location.onLocationChanged.listen((locationData) {
        //           currentLocation = locationData;
        //
        //           Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).set({
        //             'driver_latitude': currentLocation.latitude,
        //             'driver_longitude': currentLocation.longitude,
        //             'rotation': currentLocation.heading,
        //           });
        //         });
        //       }
        //     });
        //   }
        // }
        // else {
        //   await Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).get().then((value) {
        //     DocumentSnapshot v = value;
        //     if (v.exists) {
        //       Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).delete();
        //       locationSubscription.cancel();
        //       locationSubscription.pause();
        //     }
        //   });
        // }
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        rideList.clear();

        // if (permissionStatus == PermissionStatus.granted) {
        //   location.enableBackgroundMode(enable: true);
        //   location.changeSettings(
        //       accuracy: LocationAccuracy.high,
        //       distanceFilter:
        //           double.parse(Constant.driverLocationUpdateUnit.toString()),
        //       interval: 2000);
        //   // locationSubscription =
        //   location.onLocationChanged.listen((locationData) {
        //     currentLocation = locationData;
        //
        //     Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).set({
        //       'driver_latitude': currentLocation.latitude,
        //       'driver_longitude': currentLocation.longitude,
        //       'rotation': currentLocation.heading,
        //     });
        //   });
        // } else {
        //   location.requestPermission().then((permissionStatus) {
        //     if (permissionStatus == PermissionStatus.granted) {
        //       location.enableBackgroundMode(enable: true);
        //         location.changeSettings(
        //           accuracy: LocationAccuracy.high,
        //           distanceFilter: double.parse(
        //               Constant.driverLocationUpdateUnit.toString()),
        //           interval: 2000);
        //       // locationSubscription =
        //       location.onLocationChanged.listen((locationData) {
        //         currentLocation = locationData;
        //
        //         Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).set({
        //           'driver_latitude': currentLocation.latitude,
        //           'driver_longitude': currentLocation.longitude,
        //           'rotation': currentLocation.heading,
        //         });
        //       });
        //     }
        //   });
        // }

        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast('Unauthorized');
        // throw Exception('Failed to load album');
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

  TextEditingController otpController = TextEditingController();

  Future<dynamic> feelNotSafe(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.feelSafeAtDestination),
          headers: API.header, body: jsonEncode(bodyParams));
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

  Future<dynamic> confirmedRide(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.conformRide),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> canceledRide(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.rejectRide),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> setOnRideRequest(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.onRideRequest),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> setCompletedRequest(
      Map<String, String> bodyParams, RideData data) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.setCompleteRequest),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        if (data.rideType!.toString() == "driver") {
          await cashPaymentRequest(data);
        }
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> verifyOTP(
      {required String userId, required String rideId}) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
          Uri.parse(
              "${API.rideOtpVerify}?id_user_app=$userId&otp=${otpController.text.toString()}&ride_id=$rideId"),
          headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        await http.get(
            Uri.parse(
                "${API.reGenerateOtp}?id_user_app=$userId&ride_id=$rideId"),
            headers: API.header);

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

  Future<dynamic> cashPaymentRequest(RideData data) async {
    List taxList = [];

    Constant.taxList.forEach((v) {
      taxList.add(v.toJson());
    });
    Map<String, dynamic> bodyParams = {
      'id_ride': data.id.toString(),
      'id_driver': data.idConducteur.toString(),
      'id_user_app': data.idUserApp.toString(),
      'amount': data.montant.toString(),
      'paymethod': "Cash",
      'discount': data.discount.toString(),
      'tip': data.tipAmount.toString(),
      'tax': taxList,
      'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
      'commission': Preferences.getString(Preferences.admincommission),
      'payment_status': "success",
    };
    try {
      // ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.payRequestCash),
          headers: API.header, body: jsonEncode(bodyParams));

      log('--------${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseBody['success'].toString().toLowerCase() ==
              "Success".toString().toLowerCase()) {
        ShowToastDialog.showToast("Successfully completed");

        Get.back();
        // ShowToastDialog.closeLoader();

        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        // ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        // ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      // ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      // ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      // ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    // ShowToastDialog.closeLoader();
    return null;
  }
}
