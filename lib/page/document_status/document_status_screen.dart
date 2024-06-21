import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/document_status_contoller.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/themes/custom_alert_dialog.dart';
import 'package:rugbydriver/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DocumentStatusScreen extends StatelessWidget {
  DocumentStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<DocumentStatusController>(
      init: DocumentStatusController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          body: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: controller.documentList.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller
                                          .documentList[index].documentName
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  controller.documentList[index]
                                              .documentStatus ==
                                          "Disapprove"
                                      ? InkWell(
                                          onTap: () {
                                            showDialog(
                                              barrierColor: Colors.black26,
                                              context: context,
                                              builder: (context) {
                                                return CustomAlertDialog(
                                                  title:
                                                      "Reason : ${controller.documentList[index].comment!.isEmpty ? "Under Verification".tr : controller.documentList[index].comment.toString()}",
                                                  negativeButtonText: 'Ok'.tr,
                                                  positiveButtonText: 'Ok'.tr,
                                                  onPressPositive: () {
                                                    Get.back();
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child:
                                              const Icon(Icons.remove_red_eye))
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    controller
                                        .documentList[index].documentStatus
                                        .toString(),
                                    style: TextStyle(
                                        color: controller.documentList[index]
                                                        .documentStatus ==
                                                    "Disapprove" ||
                                                controller.documentList[index]
                                                        .documentStatus ==
                                                    "Pending"
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              controller
                                      .documentList[index].documentPath!.isEmpty
                                  ? Container()
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.network(
                                        controller
                                            .documentList[index].documentPath!,
                                        height: Responsive.height(25, context),
                                        width: Responsive.width(90, context),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
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
                                          controller.documentList[index].id
                                              .toString());
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  buildBottomSheet(BuildContext context, DocumentStatusController controller,
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

  Future pickFile(DocumentStatusController controller,
      {required ImageSource source,
      required int index,
      required String documentId}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;

      controller.updateDocument(documentId, image.path).then((value) {
        controller.isLoading.value = true;
        controller.getCarServiceBooks();
      });
      Get.back();
    } on PlatformException catch (e) {
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
