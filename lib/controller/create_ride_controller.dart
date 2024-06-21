// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/dash_board_controller.dart';
import 'package:rugbydriver/model/customer_model.dart';
import 'package:rugbydriver/model/driver_model.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/model/tax_model.dart';
import 'package:rugbydriver/model/trancation_model.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

import '../model/get_vehicle_data_model.dart';

class CreateRideController extends GetxController {
  final controllerDashBoard = Get.put(DashBoardController());
  RxBool createUser = false.obs;
  RxDouble distance = 0.0.obs;
  RxString duration = "".obs;
  VehicleData? vehicleData;
  RxString paymentMethodId = "".obs;
  CustomerData? selectedUser;
  List<CustomerData> userList = [];

  List<AddStopModel> multiStopList = [];
  List<AddStopModel> multiStopListNew = [];
  RxDouble taxAmount = 0.0.obs;

  @override
  void onInit() {
    getVehicleDataAPI();
    getPaymentSettingData();
    getUserDataAPI();

    super.onInit();
  }

  Future<dynamic> getPaymentSettingData() async {
    try {
      final response =
          await http.get(Uri.parse(API.paymentSetting), headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        paymentMethodId.value =
            responseBody['Cash']['id_payment_method'].toString();
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getVehicleDataAPI() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.getVehicleData}${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        vehicleData = VehicleData.fromJson(responseBody['data']);
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album'.tr);
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getUserDataAPI() async {
    try {
      final response =
          await http.get(Uri.parse(API.getCustomer), headers: API.header);

      dynamic responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        responseBody.forEach((value) {
          userList.add(CustomerData.fromJson(value));
        });
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album'.tr);
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<PlacesDetailsResponse?> placeSelectAPI(BuildContext context) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Constant.kGoogleApiKey ?? '',
      mode: Mode.overlay,
      onError: (response) {
        log("-->${response.status}");
      },
      language: "en",
      types: [],
      strictbounds: false,
      components: [],
    );

    return displayPrediction(p!);
  }

  Future<PlacesDetailsResponse?> displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces? places = GoogleMapsPlaces(
        apiKey: Constant.kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse? detail =
          await places.getDetailsByPlaceId(p.placeId.toString());

      return detail;
    }
    return null;
  }

  Future<dynamic> getDurationDistance(
      LatLng departureLatLong, LatLng destinationLatLong) async {
    ShowToastDialog.showLoader("Please wait".tr);
    double originLat, originLong, destLat, destLong;
    originLat = departureLatLong.latitude;
    originLong = departureLatLong.longitude;
    destLat = destinationLatLong.latitude;
    destLong = destinationLatLong.longitude;

    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    http.Response restaurantToCustomerTime = await http.get(Uri.parse(
        '$url?units=metric&origins=$originLat,'
        '$originLong&destinations=$destLat,$destLong&key=${Constant.kGoogleApiKey}'));

    var decodedResponse = jsonDecode(restaurantToCustomerTime.body);

    if (decodedResponse['status'] == 'OK' &&
        decodedResponse['rows'].first['elements'].first['status'] == 'OK') {
      ShowToastDialog.closeLoader();
      return decodedResponse;
      //   estimatedTime = decodedResponse['rows'].first['elements'].first['distance']['value'] / 1000.00;
      //   if (selctedOrderTypeValue == "Delivery") {
      //     setState(() => deliveryCharges = (estimatedTime! * double.parse(deliveryCost)).toString());
      //   }
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> bookRide(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.bookRides),
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

  addStops() async {
    ShowToastDialog.showLoader("Please wait".tr);
    multiStopList.add(AddStopModel(
        editingController: TextEditingController(),
        latitude: "",
        longitude: ""));
    multiStopListNew = List<AddStopModel>.generate(
      multiStopList.length,
      (int index) => AddStopModel(
          editingController: multiStopList[index].editingController,
          latitude: multiStopList[index].latitude,
          longitude: multiStopList[index].longitude),
    );
    ShowToastDialog.closeLoader();
    update();
  }

  removeStops(int index) {
    ShowToastDialog.showLoader("Please wait".tr);
    multiStopList.removeAt(index);
    multiStopListNew = List<AddStopModel>.generate(
      multiStopList.length,
      (int index) => AddStopModel(
          editingController: multiStopList[index].editingController,
          latitude: multiStopList[index].latitude,
          longitude: multiStopList[index].longitude),
    );
    ShowToastDialog.closeLoader();
    update();
  }

  double calculateTax({TaxModel? taxModel, double? tripPrice}) {
    double tax = 0.0;
    if (taxModel != null && taxModel.statut == 'yes') {
      if (taxModel.type.toString() == "Fixed") {
        tax = double.parse(taxModel.value.toString());
      } else {
        tax = (tripPrice! * double.parse(taxModel.value!.toString())) / 100;
      }
    }
    return tax;
  }

  Future<bool> checkBalance() async {
    ShowToastDialog.showLoader("Please wait");
    final response = await http.get(
        Uri.parse(
            "${API.walletHistory}?id_diver=${Preferences.getInt(Preferences.userId)}"),
        headers: API.header);

    Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode == 200 && responseBody['success'] == "success") {
      TruncationModel model = TruncationModel.fromJson(responseBody);

      if (double.parse(model.totalEarnings!.toString()) >=
          double.parse(Constant.minimumWalletBalance!)) {
        return true;
      } else {
        ShowToastDialog.closeLoader();
        return false;
      }
    } else if (response.statusCode == 200 &&
        responseBody['success'] == "Failed") {
      if (double.parse('0'.toString()) >=
          double.parse(Constant.minimumWalletBalance!)) {
        return true;
      } else {
        ShowToastDialog.closeLoader();
        return false;
      }
    } else {
      ShowToastDialog.closeLoader();
    }
    return false;
  }

  Future<DriverData?> getDriverDetails() async {
    ShowToastDialog.showLoader("Please wait");
    try {
      final response =
          await http.get(Uri.parse(API.driverDetails), headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        DriverModel driverData = DriverModel.fromJson(responseBody);
        for (var i = 0; i < driverData.data!.length; i++) {
          if (driverData.data![i].id.toString() ==
              Preferences.getInt(Preferences.userId).toString()) {
            return driverData.data![i];
          }
        }
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
}

class AddStopModel {
  String latitude = "";
  String longitude = "";
  TextEditingController editingController = TextEditingController();

  AddStopModel({
    required this.editingController,
    required this.latitude,
    required this.longitude,
  });
}
