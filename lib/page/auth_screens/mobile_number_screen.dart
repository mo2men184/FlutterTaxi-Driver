// ignore_for_file: must_be_immutable

import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/phone_number_controller.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MobileNumberScreen extends StatelessWidget {
  bool? isLogin;

  MobileNumberScreen({Key? key, required this.isLogin}) : super(key: key);

  final controller = Get.put(PhoneNumberController());

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isLogin == true
                              ? "Login Phone".tr
                              : "Signup Phone".tr,
                          style: const TextStyle(
                              letterSpacing: 0.60,
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                            width: 80,
                            child: Divider(
                              color: ConstantColors.primary,
                              thickness: 3,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: ConstantColors.textFieldBoarderColor,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.only(left: 10),
                            child: IntlPhoneField(
                              onChanged: (phone) {
                                controller.phoneNumber.value =
                                    phone.completeNumber;
                              },
                              invalidNumberMessage: "number invalid",
                              showDropdownIcon: false,
                              disableLengthCheck: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                hintText: 'Phone Number'.tr,
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'Continue'.tr,
                              btnHeight: 50,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.white,
                              onPress: () async {
                                if (controller.phoneNumber.value.isNotEmpty) {
                                  ShowToastDialog.showLoader("Code sending".tr);
                                  controller
                                      .sendCode(controller.phoneNumber.value);
                                }
                              },
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ButtonThem.buildBorderButton(
                              context,
                              title: 'Login With Email'.tr,
                              btnHeight: 50,
                              btnBorderColor: ConstantColors.primary,
                              btnColor: Colors.white,
                              txtColor: ConstantColors.primary,
                              onPress: () {
                                FocusScope.of(context).unfocus();
                                Get.back();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
