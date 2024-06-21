import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/model/brand_model.dart';
import 'package:rugbydriver/model/get_vehicle_getegory.dart';
import 'package:rugbydriver/model/model.dart';
import 'package:rugbydriver/model/user_model.dart';
import 'package:rugbydriver/model/vehicle_register_model.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VehicleInfoController extends GetxController {
  UserModel? userModel;

  @override
  void onInit() {
    getUserdata();
    getVehicleCategory();
    super.onInit();
  }

  getUserdata() async {
    userModel = Constant.getUserData();
  }

  RxString selectedCategoryID = "".obs;
  RxString selectedBrandID = "".obs;
  RxString selectedModelID = "".obs;

  List<VehicleData> vehicleCategoryList = [];

  Future<VehicleRegisterModel?> vehicleRegister(
      Map<String, String> bodyParams) async {
    try {
      // ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.vehicleRegister),
          headers: API.header, body: jsonEncode(bodyParams));
      log(response.toString());

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return VehicleRegisterModel.fromJson(responseBody);
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

  Future<VehicleData?> getVehicleCategory() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
        Uri.parse(API.vehicleCategory),
        headers: API.header,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        final VehicleCategoryModel getVehicleCategory =
            VehicleCategoryModel.fromJson(responseBody);

        vehicleCategoryList = getVehicleCategory.vehicleData!;

        update();
        ShowToastDialog.closeLoader();

        return VehicleData.fromJson(responseBody);
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

  Future<List<BrandData>?> getBrand() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response =
          await http.get(Uri.parse(API.brand), headers: API.header);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        BrandModel model = BrandModel.fromJson(responseBody);
        return model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
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

  Future<List<ModelData>?> getModel(bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.model),
          headers: API.header, body: jsonEncode(bodyParams));
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        Model model = Model.fromJson(responseBody);
        return model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.showToast(responseBody['error']);
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
