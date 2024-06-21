import 'dart:developer';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/vehicle_info_controller.dart';
import 'package:rugbydriver/model/brand_model.dart';
import 'package:rugbydriver/model/model.dart';
import 'package:rugbydriver/page/auth_screens/add_profile_photo_screen.dart';
import 'package:rugbydriver/page/auth_screens/login_screen.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/themes/responsive.dart';
import 'package:rugbydriver/themes/text_field_them.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleInfoScreen extends StatelessWidget {
  VehicleInfoScreen({Key? key}) : super(key: key);

  static final GlobalKey<FormState> _formKey = GlobalKey();

  static final TextEditingController brandController = TextEditingController();
  static final TextEditingController modelController = TextEditingController();
  static final TextEditingController colorController = TextEditingController();
  static final TextEditingController carMakeController =
      TextEditingController();
  static final TextEditingController millageController =
      TextEditingController();
  static final TextEditingController kmDrivenController =
      TextEditingController();
  static final TextEditingController numberPlateController =
      TextEditingController();
  static final TextEditingController numberOfPassengersController =
      TextEditingController();

  final vehicleInfoController = Get.put(VehicleInfoController());

  @override
  Widget build(BuildContext context) {
    //vehicleInfoController.getVehicleCategory();

    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom == 0;

    return SafeArea(
      child: Scaffold(
        // extendBody: true,
        // resizeToAvoidBottomInset: true,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton:
        backgroundColor: ConstantColors.background,

        body: WillPopScope(
          onWillPop: () async {
            Get.offAll(() => LoginScreen());
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: InkWell(
                      onTap: () {
                        vehicleInfoController.getVehicleCategory();
                      },
                      child: Text(
                        'Enter your vehicle information'.tr,
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: Responsive.height(18, context),
                      child: ListView.builder(
                          itemCount:
                              vehicleInfoController.vehicleCategoryList.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Obx(
                              () => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    vehicleInfoController
                                            .selectedCategoryID.value =
                                        vehicleInfoController
                                            .vehicleCategoryList[index].id
                                            .toString();
                                  },
                                  child: Container(
                                    width: 120,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: vehicleInfoController
                                                    .selectedCategoryID.value ==
                                                vehicleInfoController
                                                    .vehicleCategoryList[index]
                                                    .id
                                                    .toString()
                                            ? ConstantColors.primary
                                            : Colors.black.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: vehicleInfoController
                                              .vehicleCategoryList[index].image
                                              .toString(),
                                          fit: BoxFit.fill,
                                          width: 100,
                                          height:
                                              Responsive.height(10, context),
                                          placeholder: (context, url) =>
                                              Constant.loader(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        Text(
                                          vehicleInfoController
                                              .vehicleCategoryList[index]
                                              .libelle
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              vehicleInfoController.getBrand().then((value) {
                                if (value!.isNotEmpty) {
                                  brandDialog(context, value);
                                } else {
                                  ShowToastDialog.showToast(
                                      "Please contact administrator".tr);
                                }
                              });
                            },
                            child: TextFieldThem.boxBuildTextField(
                              hintText: 'Brand'.tr,
                              controller: brandController,
                              textInputType: TextInputType.text,
                              maxLength: 20,
                              enabled: false,
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
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              if (vehicleInfoController
                                  .selectedCategoryID.value.isNotEmpty) {
                                if (brandController.text.isNotEmpty) {
                                  Map<String, String> bodyParams = {
                                    'brand': brandController.text,
                                    'vehicle_type': vehicleInfoController
                                        .selectedCategoryID.value,
                                  };
                                  vehicleInfoController
                                      .getModel(bodyParams)
                                      .then((value) {
                                    if (value != null && value.isNotEmpty) {
                                      modelDialog(context, value);
                                    } else {
                                      ShowToastDialog.showToast(
                                          "Car Model not Found.".tr);
                                    }
                                  });
                                } else {
                                  ShowToastDialog.showToast(
                                      "Please select brand".tr);
                                }
                              } else {
                                ShowToastDialog.showToast(
                                    'Please select Vehicle Type'.tr);
                              }
                            },
                            child: TextFieldThem.boxBuildTextField(
                              hintText: 'Model'.tr,
                              controller: modelController,
                              textInputType: TextInputType.text,
                              enabled: false,
                              maxLength: 20,
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
                          const SizedBox(
                            height: 8,
                          ),
                          TextFieldThem.boxBuildTextField(
                            hintText: 'Color'.tr,
                            controller: colorController,
                            textInputType: TextInputType.emailAddress,
                            maxLength: 20,
                            contentPadding: EdgeInsets.zero,
                            validators: (String? value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return 'required'.tr;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Select Year".tr),
                                    content: SizedBox(
                                      // Need to use container to add size constraint.
                                      width: 300,
                                      height: 300,
                                      child: YearPicker(
                                        firstDate: DateTime(
                                            DateTime.now().year - 30, 1),
                                        lastDate:
                                            DateTime(DateTime.now().year, 1),
                                        initialDate:
                                            DateTime(DateTime.now().year, 1),
                                        selectedDate:
                                            DateTime(DateTime.now().year, 1),
                                        onChanged: (DateTime dateTime) {
                                          // close the dialog when year is selected.
                                          carMakeController.text =
                                              dateTime.year.toString();
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextFieldThem.boxBuildTextField(
                                hintText: 'Car Registration year'.tr,
                                controller: carMakeController,
                                textInputType: TextInputType.number,
                                maxLength: 40,
                                enabled: false,
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
                          const SizedBox(
                            height: 8,
                          ),
                          TextFieldThem.boxBuildTextField(
                            hintText: 'Millage'.tr,
                            controller: millageController,
                            textInputType: TextInputType.number,
                            maxLength: 40,
                            contentPadding: EdgeInsets.zero,
                            validators: (String? value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return 'required'.tr;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFieldThem.boxBuildTextField(
                            hintText: 'KM Driven'.tr,
                            controller: kmDrivenController,
                            textInputType: TextInputType.number,
                            maxLength: 40,
                            contentPadding: EdgeInsets.zero,
                            validators: (String? value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return 'required'.tr;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFieldThem.boxBuildTextField(
                            hintText: 'Number Plate'.tr,
                            controller: numberPlateController,
                            textInputType: TextInputType.text,
                            maxLength: 40,
                            contentPadding: EdgeInsets.zero,
                            validators: (String? value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return 'required'.tr;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TextFieldThem.boxBuildTextField(
                              hintText: 'Number Of Passengers'.tr,
                              controller: numberOfPassengersController,
                              textInputType: TextInputType.text,
                              maxLength: 40,
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: keyboardIsOpen,
                    child: Center(
                      child: FloatingActionButton(
                        backgroundColor: ConstantColors.yellow,
                        child: const Icon(
                          Icons.navigate_next,
                          size: 28,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (vehicleInfoController
                                .selectedCategoryID.value.isNotEmpty) {
                              Map<String, String> bodyParams1 = {
                                "brand":
                                    vehicleInfoController.selectedBrandID.value,
                                "model":
                                    vehicleInfoController.selectedModelID.value,
                                "color": colorController.text,
                                "carregistration":
                                    numberPlateController.text.toUpperCase(),
                                "passenger": numberOfPassengersController.text,
                                "id_driver": vehicleInfoController
                                    .userModel!.userData!.id
                                    .toString(),
                                "id_categorie_vehicle": vehicleInfoController
                                    .selectedCategoryID.value,
                                "car_make": carMakeController.text,
                                "milage": millageController.text,
                                "km_driven": kmDrivenController.text,
                              };
                              log(bodyParams1.toString());
                              await vehicleInfoController
                                  .vehicleRegister(bodyParams1)
                                  .then((value) {
                                if (value != null) {
                                  if (value.success == "Success" ||
                                      value.success == "success") {
                                    Get.to(() => AddProfilePhotoScreen(
                                          fromOtp: false,
                                        ));
                                  } else {
                                    ShowToastDialog.showToast(value.error);
                                  }
                                }
                              });
                              //Get.to(AddProfilePhotoScreen());
                            } else {
                              ShowToastDialog.showToast(
                                  "Please select vehicle type".tr);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  brandDialog(BuildContext context, List<BrandData>? brandList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Brand list'),
            content: SizedBox(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: brandList!.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: brandList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: InkWell(
                              onTap: () {
                                brandController.text =
                                    brandList[index].name.toString();
                                vehicleInfoController.selectedBrandID.value =
                                    brandList[index].id.toString();
                                Get.back();
                              },
                              child: Text(brandList[index].name.toString())),
                        );
                      },
                    ),
            ),
          );
        });
  }

  modelDialog(BuildContext context, List<ModelData>? brandList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Model list'),
            content: SizedBox(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: brandList!.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: brandList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: InkWell(
                              onTap: () {
                                modelController.text =
                                    brandList[index].name.toString();
                                vehicleInfoController.selectedModelID.value =
                                    brandList[index].id.toString();

                                Get.back();
                              },
                              child: Text(brandList[index].name.toString())),
                        );
                      },
                    ),
            ),
          );
        });
  }
}
