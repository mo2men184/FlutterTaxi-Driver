import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/model/ride_details_model.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/model/tax_model.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  RxDouble subTotalAmount = 0.0.obs;
  RxDouble tipAmount = 0.0.obs;
  RxDouble taxAmount = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble adminCommission = 0.0.obs;

  var data = RideData().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      data.value = argumentData["rideData"];

      subTotalAmount.value = double.parse(data.value.montant!);
      tipAmount.value =
          data.value.tipAmount != "null" && data.value.tipAmount!.isNotEmpty
              ? double.parse(data.value.tipAmount.toString())
              : 0.0;
      // taxAmount.value = double.parse(data.value.tax!);
      discountAmount.value = data.value.discount != "null"
          ? double.parse(data.value.discount!)
          : 0.0;
      for (var i = 0; i < data.value.taxModel!.length; i++) {
        if (data.value.taxModel![i].statut == 'yes') {
          if (data.value.taxModel![i].type == "Fixed") {
            taxAmount.value +=
                double.parse(data.value.taxModel![i].value.toString());
          } else {
            taxAmount.value += ((subTotalAmount.value - discountAmount.value) *
                    double.parse(data.value.taxModel![i].value!.toString())) /
                100;
          }
        }
      }
    }
    if (data.value.statutPaiement == "yes") {
      getRideDetailsData(data.value.id.toString());
      adminCommission.value =
          double.parse(data.value.adminCommission.toString());
    } else {
      adminCommission.value =
          (Preferences.getString(Preferences.admincommissiontype).toString() ==
                  'Percentage')
              ? ((subTotalAmount.value - discountAmount.value) *
                      double.parse(
                          Preferences.getString(Preferences.admincommission)
                              .toString())) /
                  100
              : double.parse(Preferences.getString(Preferences.admincommission)
                  .toString());
    }

    update();
  }

  Future<dynamic> getRideDetailsData(String id) async {
    try {
      final response = await http.get(
          Uri.parse("${API.rideDetails}?ride_id=$id"),
          headers: API.header);
      log(response.body);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        RideDetailsModel rideDetailsModel =
            RideDetailsModel.fromJson(responseBody);

        subTotalAmount.value =
            double.parse(rideDetailsModel.rideDetailsdata!.montant.toString());
        tipAmount.value = double.parse(
            rideDetailsModel.rideDetailsdata!.tipAmount.toString());
        discountAmount.value =
            double.parse(rideDetailsModel.rideDetailsdata!.discount.toString());
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

  double calculateTax({TaxModel? taxModel}) {
    double tax = 0.0;
    if (taxModel != null && taxModel.statut == 'yes') {
      if (taxModel.type.toString() == "Fixed") {
        tax = double.parse(taxModel.value.toString());
      } else {
        tax = ((subTotalAmount.value - discountAmount.value) *
                double.parse(taxModel.value!.toString())) /
            100;
      }
    }
    return tax;
  }

  double getTotalAmount() {
    // if (Constant.taxType == "Percentage") {
    //   taxAmount.value =
    //       Constant.taxValue != null && Constant.taxValue.toString() != "0"
    //           ? (subTotalAmount.value - discountAmount.value) *
    //               double.parse(Constant.taxValue.toString()) /
    //               100
    //           : 0.0;
    // } else {
    //   taxAmount.value = Constant.taxValue.toString() != "0"
    //       ? double.parse(Constant.taxValue.toString())
    //       : 0.0;
    // }
    // if (paymentSettingModel.value.tax!.taxType == "percentage") {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? (subTotalAmount.value - discountAmount.value) *
    //           double.parse(
    //               paymentSettingModel.value.tax!.taxAmount.toString()) /
    //           100
    //       : 0.0;
    // } else {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? double.parse(paymentSettingModel.value.tax!.taxAmount.toString())
    //       : 0.0;
    // }

    return (subTotalAmount.value - discountAmount.value) +
        tipAmount.value +
        taxAmount.value;
  }
}
