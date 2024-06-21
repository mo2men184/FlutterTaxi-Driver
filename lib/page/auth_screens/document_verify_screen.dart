import 'dart:developer';
import 'dart:io';

import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/document_upload_contoller.dart';
import 'package:rugbydriver/controller/documets.dart';
import 'package:rugbydriver/page/auth_screens/login_screen.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DocumentVerifyScreen extends StatelessWidget {
  final bool fromOtp;

  DocumentVerifyScreen({Key? key, required this.fromOtp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<DocumentController>(
      init: DocumentController(),
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
          body: WillPopScope(
            onWillPop: () async {
              if (fromOtp) {
                Get.offAll(() => LoginScreen());
                return true;
              } else {
                Get.back();
                return true;
              }
            },
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Responsive.height(2, context),
                        ),
                        Text(
                          'Add Verification Document'.tr,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: Responsive.height(2, context),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.rideList.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.rideList[index].title
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      ButtonThem.buildButton(
                                        context,
                                        title: 'upload'.tr,
                                        btnHeight: 32,
                                        btnWidthRatio: 0.25,
                                        btnColor: ConstantColors.blue,
                                        txtColor: Colors.white,
                                        onPress: () {
                                          buildBottomSheet(
                                              context,
                                              controller,
                                              index,
                                              controller.rideList[index].id
                                                  .toString());
                                        },
                                      ),
                                    ],
                                  ),
                                  controller.imageList.isNotEmpty
                                      ? controller.imageList[index].isNotEmpty
                                          ? Image.file(
                                              File(controller.imageList[index]),
                                              height: Responsive.height(
                                                  25, context),
                                              width:
                                                  Responsive.width(90, context),
                                              fit: BoxFit.cover,
                                            )
                                          : Container()
                                      : Container()
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: Responsive.height(1, context),
                        ),
                      ],
                    ),
                  ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            height: 80,
            width: Responsive.width(100, context),
            child: Center(
              child: ButtonThem.buildButton(
                context,
                title: 'next'.tr,
                btnHeight: 45,
                btnWidthRatio: 0.8,
                btnColor: ConstantColors.blue,
                txtColor: Colors.white,
                onPress: () {
                  log(controller.document.length.toString());
                  log(controller.rideList.length.toString());
                  if (controller.document.length ==
                      controller.rideList.length) {
                    // print("${controller.imageList.map((element) => element).toList()}");
                    // print("${controller.document.map((element) => element.toJson()).toList()}");

                    controller.uploadProfile().then((value) {
                      if (value != null) {
                        Get.offAll(LoginScreen());
                        buildAlertSendInformation(context);
                      }
                    });
                  } else {
                    ShowToastDialog.showToast('Please select All Documents'.tr);
                  }
                },
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  buildBottomSheet(BuildContext context, DocumentController controller,
      int index, String documentId) {
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
                                    source: ImageSource.camera,
                                    index: index,
                                    documentId: documentId),
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
                                    source: ImageSource.gallery,
                                    index: index,
                                    documentId: documentId),
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

  Future pickFile(DocumentController controller,
      {required ImageSource source,
      required int index,
      required String documentId}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        controller.imageList.removeAt(index);
        controller.imageList.insert(index, image.path);

        Documents document = Documents(
            documentId: documentId, attachmentIndex: index.toString());
        if (index < controller.document.length) {
          controller.document.removeAt(index);
          controller.document.insert(index, document);
        } else {
          controller.document.add(document);
        }
        Get.back();
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick".tr} : \n $e");
    } catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick".tr}: \n $e");
    }
  }

  buildAlertSendInformation(
    BuildContext context,
  ) {
    return Get.defaultDialog(
      radius: 6,
      title: "",
      titleStyle: const TextStyle(fontSize: 0.0),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/green_checked.png",
                height: 100,
                width: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "${"Your information send well. We will treat them and inform you after the treatment.".tr} ${"Your account will be active after validation of your information.".tr}",
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonThem.buildButton(context,
                title: "Close".tr,
                btnHeight: 40,
                btnWidthRatio: 0.6,
                btnColor: ConstantColors.primary,
                txtColor: Colors.white,
                onPress: () => Get.back()),
          ],
        ),
      ),
    );
  }
}
