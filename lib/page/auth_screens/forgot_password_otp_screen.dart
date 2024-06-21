// ignore_for_file: must_be_immutable

import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/forgot_password_controller.dart';
import 'package:rugbydriver/page/auth_screens/login_screen.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/themes/text_field_them.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordOtpScreen extends StatelessWidget {
  String? email;

  ForgotPasswordOtpScreen({Key? key, required this.email}) : super(key: key);

  final controller = Get.put(ForgotPasswordController());
  static final _formKey = GlobalKey<FormState>();

  final textEditingController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conformPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: const EdgeInsets.only(
                              top: 30, right: 50, left: 50),
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
                            length: 4,
                          ),
                          // PinCodeTextField(
                          //   length: 4,
                          //   appContext: context,
                          //   keyboardType: TextInputType.phone,
                          //   textInputAction: TextInputAction.done,
                          //   pinTheme: PinTheme(
                          //       fieldHeight: 50,
                          //       fieldWidth: 50,
                          //       activeColor:
                          //           ConstantColors.textFieldBoarderColor,
                          //       selectedColor:
                          //           ConstantColors.textFieldBoarderColor,
                          //       inactiveColor:
                          //           ConstantColors.textFieldBoarderColor,
                          //       activeFillColor: Colors.white,
                          //       inactiveFillColor: Colors.white,
                          //       selectedFillColor: Colors.white,
                          //       shape: PinCodeFieldShape.box,
                          //       borderRadius: BorderRadius.circular(10),
                          //       borderWidth: 0.7),
                          //   enableActiveFill: true,
                          //   cursorColor: ConstantColors.primary,
                          //   controller: textEditingController,
                          //   onCompleted: (v) async {},
                          //   onChanged: (value) {},
                          // ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: TextFieldThem.boxBuildTextField(
                            hintText: 'password'.tr,
                            controller: _passwordController,
                            textInputType: TextInputType.text,
                            obscureText: false,
                            contentPadding: EdgeInsets.zero,
                            validators: (String? value) {
                              if (value!.length >= 6) {
                                return null;
                              } else {
                                return 'Password required at least 6 characters'
                                    .tr;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TextFieldThem.boxBuildTextField(
                            hintText: 'confirm_password'.tr,
                            controller: _conformPasswordController,
                            textInputType: TextInputType.text,
                            obscureText: false,
                            contentPadding: EdgeInsets.zero,
                            validators: (String? value) {
                              if (_passwordController.text.trim() !=
                                  value!.toString().trim()) {
                                return 'Confirm password is invalid'.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'done'.tr,
                              btnHeight: 50,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.white,
                              onPress: () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  Map<String, String> bodyParams = {
                                    'email': email.toString(),
                                    'otp': textEditingController.text.trim(),
                                    'new_password':
                                        _passwordController.text.trim(),
                                    'confirm_password':
                                        _passwordController.text.trim(),
                                    'user_cat': "driver",
                                  };
                                  controller
                                      .resetPassword(bodyParams)
                                      .then((value) {
                                    if (value != null) {
                                      if (value == true) {
                                        Get.offAll(LoginScreen(),
                                            duration: const Duration(
                                                milliseconds:
                                                    400), //duration of transitions, default 1 sec
                                            transition: Transition.rightToLeft);
                                        ShowToastDialog.showToast(
                                            "Password change successfully!".tr);
                                      } else {
                                        ShowToastDialog.showToast(
                                            "Please try again later".tr);
                                      }
                                    }
                                  });
                                }
                              },
                            )),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
