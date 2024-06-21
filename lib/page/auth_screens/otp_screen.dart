// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/phone_number_controller.dart';
import 'package:rugbydriver/model/user_model.dart';
import 'package:rugbydriver/page/auth_screens/vehicle_info_screen.dart';
import 'package:rugbydriver/page/dash_board.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../themes/constant_colors.dart';
import 'signup_screen.dart';

class OtpScreen extends StatelessWidget {
  String? phoneNumber;
  String? verificationId;

  OtpScreen({Key? key, required this.phoneNumber, required this.verificationId})
      : super(key: key);

  final controller = Get.put(PhoneNumberController());
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColors.background,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Enter OTP".tr,
                          style: const TextStyle(
                              letterSpacing: 0.60,
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                            width: 80,
                            child: Divider(
                              color: ConstantColors.yellow1,
                              thickness: 3,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Pinput(
                            controller: textEditingController,
                            defaultPinTheme: PinTheme(
                              height: 50,
                              width: 50,
                              textStyle: const TextStyle(
                                  letterSpacing: 0.60,
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              // margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                border: Border.all(
                                    color: ConstantColors.textFieldBoarderColor,
                                    width: 0.7),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            length: 6,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'done'.tr,
                              btnHeight: 50,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.black,
                              onPress: () async {
                                FocusScope.of(context).unfocus();
                                if (textEditingController.text.length == 6) {
                                  ShowToastDialog.showLoader("Verify OTP".tr);
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId:
                                              verificationId.toString(),
                                          smsCode: textEditingController.text);
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential)
                                        .then((value) async {
                                      Map<String, String> bodyParams = {
                                        'phone': phoneNumber.toString(),
                                        'user_cat': "driver",
                                      };
                                      await controller
                                          .phoneNumberIsExit(bodyParams)
                                          .then((value) async {
                                        if (value == true) {
                                          Map<String, String> bodyParams = {
                                            'phone': phoneNumber.toString(),
                                            'user_cat': "driver",
                                          };
                                          await controller
                                              .getDataByPhoneNumber(bodyParams)
                                              .then((value) {
                                            if (value != null) {
                                              if (value.success == "success") {
                                                ShowToastDialog.closeLoader();
                                                Preferences.setString(
                                                    Preferences.user,
                                                    jsonEncode(value));
                                                UserData? userData =
                                                    value.userData;
                                                Preferences.setInt(
                                                    Preferences.userId,
                                                    int.parse(userData!.id
                                                        .toString()));
                                                Preferences.setString(
                                                    Preferences.accesstoken,
                                                    value.userData!.accesstoken
                                                        .toString());
                                                API.header['accesstoken'] =
                                                    Preferences.getString(
                                                        Preferences
                                                            .accesstoken);

                                                if (userData.statutVehicule !=
                                                        "yes" ||
                                                    userData.statutVehicule!
                                                        .isEmpty) {
                                                  Get.to(() =>
                                                      VehicleInfoScreen());
                                                }
                                                // else if (userData.photoPath == null) {
                                                //   Get.to(AddProfilePhotoScreen(fromOtp: true));
                                                // }
                                                // else if (userData.photoLicencePath == null) {
                                                //   Get.to(() => DocumentVerifyScreen(
                                                //         fromOtp: true,
                                                //       ));
                                                // }
                                                // else if (userData.photoRoadWorthyPath == null) {
                                                //   Get.to(() => const AddRoadWorthyDocScreen(
                                                //         fromOtp: true,
                                                //       ));
                                                // } else if (userData.photoCarServiceBookPath == null) {
                                                //   Get.to(() => AddCarServiceBookScreen(
                                                //         fromOtp: true,
                                                //       ));
                                                // }
                                                else {
                                                  ShowToastDialog.closeLoader();
                                                  Preferences.setBoolean(
                                                      Preferences.isLogin,
                                                      true);
                                                  Get.offAll(() => DashBoard());

                                                  // if(userData.statut)
                                                  // Get.offAll(LoginScreen());
                                                }
                                              } else {
                                                ShowToastDialog.closeLoader();
                                                ShowToastDialog.showToast(
                                                    value.error);
                                              }
                                            } else {
                                              ShowToastDialog.closeLoader();
                                            }
                                          });
                                        } else if (value == false) {
                                          ShowToastDialog.closeLoader();
                                          Get.off(SignupScreen(
                                            phoneNumber: phoneNumber.toString(),
                                          ));
                                        }
                                      });
                                    });
                                  } on FirebaseException catch (e) {
                                    ShowToastDialog.closeLoader();
                                    if (e.code == 'invalid-verification-code') {
                                      ShowToastDialog.showToast(
                                          "Invalid OTP".tr);
                                    } else {
                                      ShowToastDialog.showToast(e.code);
                                    }
                                  }
                                } else {
                                  ShowToastDialog.showToast(
                                      "Please Enter OTP".tr);
                                }
                              },
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
