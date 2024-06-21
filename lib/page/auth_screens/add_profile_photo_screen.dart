import 'dart:convert';
import 'dart:io';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/add_photo_controller.dart';
import 'package:rugbydriver/model/user_model.dart';
import 'package:rugbydriver/page/auth_screens/document_verify_screen.dart';
import 'package:rugbydriver/page/auth_screens/login_screen.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/themes/responsive.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePhotoScreen extends StatelessWidget {
  final bool fromOtp;

  AddProfilePhotoScreen({Key? key, required this.fromOtp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AddPhotoController>(
      init: AddPhotoController(),
      dispose: (controller) {
        controller.dispose();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ConstantColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (fromOtp) {
                    Get.offAll(() => LoginScreen());
                  } else {
                    Get.back();
                  }
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
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Responsive.height(5, context),
                ),
                Text(
                  'select_profile_photo'.tr,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      fontSize: 22),
                ),
                const SizedBox(height: 15),
                Text(
                  'profile_message'.tr,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      height: 2,
                      letterSpacing: 1),
                ),
                SizedBox(
                  height: Responsive.height(5, context),
                ),
                controller.image.isNotEmpty
                    ? Center(
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipOval(
                                child: Image.file(
                              File(controller.image.value),
                              height: 190,
                              width: 190,
                              fit: BoxFit.cover,
                            )),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 80,
            width: Responsive.width(100, context),
            color: Colors.white,
            child: Center(
              child: ButtonThem.buildButton(
                context,
                title: 'please_select'.tr,
                btnHeight: 45,
                btnWidthRatio: 0.8,
                btnColor: ConstantColors.blue,
                txtColor: Colors.white,
                onPress: () => buildBottomSheet(context, controller),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ConstantColors.yellow,
            child: const Icon(
              Icons.navigate_next,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              if (controller.image.isNotEmpty) {
                controller.uploadProfile().then((value) async {
                  if (value != null) {
                    if (value["success"] == "Success") {
                      UserModel userModel = Constant.getUserData();
                      userModel.userData!.photoPath =
                          value['data']['photo_path'];
                      Preferences.setString(
                          Preferences.user, json.encode(userModel.toJson()));
                      Get.to(DocumentVerifyScreen(
                        fromOtp: false,
                      ));
                    } else {
                      ShowToastDialog.showToast(value['error']);
                    }
                  }
                });
              } else {
                ShowToastDialog.showToast("Please Choose Image".tr);
              }
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  buildBottomSheet(BuildContext context, AddPhotoController controller) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: Responsive.height(22, context),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'please_select'.tr,
                      style: TextStyle(
                        color: const Color(0XFF333333).withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller,
                                    source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text('camera'.tr),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller,
                                    source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text('gallery'.tr),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile(AddPhotoController controller,
      {required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      controller.image.value = image.path;
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick".tr}: \n $e");
    }
  }
}
