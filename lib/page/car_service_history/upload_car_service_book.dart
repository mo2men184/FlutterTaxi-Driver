import 'dart:io';

import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/car_service_history_controller.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/themes/responsive.dart';
import 'package:rugbydriver/themes/text_field_them.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AddCarServiceBookHistory extends StatelessWidget {
  const AddCarServiceBookHistory({Key? key}) : super(key: key);

  static final GlobalKey<FormState> _formKey = GlobalKey();
  static final TextEditingController kmDrivenController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<CarServiceHistoryController>(
      init: CarServiceHistoryController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Responsive.height(10, context),
                  ),
                  Text(
                    'Upload Car Service Book'.tr,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        fontSize: 22),
                  ),
                  const SizedBox(height: 15),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextFieldThem.boxBuildTextField(
                        hintText: 'ADD KM'.tr,
                        controller: kmDrivenController,
                        textInputType: TextInputType.phone,
                        maxLength: 10,
                        contentPadding: EdgeInsets.zero,
                        validators: (String? value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return 'required'.tr;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  controller.carServiceBook.isNotEmpty
                      ? Obx(
                          () => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 400,
                                width: 280,
                                child: SfPdfViewer.file(
                                  File(controller.carServiceBook.value),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
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
                title: 'Select A File'.tr,
                btnHeight: 45,
                btnWidthRatio: 0.8,
                btnColor: ConstantColors.blue,
                txtColor: Colors.white,
                onPress: () => pickDoc(controller),
              ),
            ),
          ),
          floatingActionButton: Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: FloatingActionButton(
              backgroundColor: ConstantColors.yellow,
              child: const Icon(
                Icons.navigate_next,
                size: 28,
                color: Colors.black,
              ),
              onPressed: () async {
                if (controller.carServiceBook.isNotEmpty &&
                    _formKey.currentState!.validate()) {
                  controller
                      .userCarServiceBook(kmDriven: kmDrivenController.text)
                      .then((value) {
                    if (value != null) {
                      if (value["success"] == "Success") {
                        controller.getCarServiceBooks();
                        Get.back();
                      } else {
                        ShowToastDialog.showToast(value['error']);
                      }
                    }
                  });
                } else {
                  if (controller.carServiceBook.isEmpty) {
                    ShowToastDialog.showToast("Please Choose Image".tr);
                  }
                }
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  pickDoc(
    CarServiceHistoryController controller,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
        allowMultiple: false,
      );
      if (result!.files.isEmpty) return;
      PlatformFile file = result.files.last;
      controller.carServiceBook.value = file.path!;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick".tr}: \n $e");
    }
  }
}
