// ignore_for_file: must_be_immutable

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/bank_details_controller.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBankAccount extends StatelessWidget {
  final bool isEdit;

  AddBankAccount({Key? key, required this.isEdit}) : super(key: key);

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var bankNameController = TextEditingController();
  var branchNameController = TextEditingController();
  var holderNameController = TextEditingController();
  var accountNumberController = TextEditingController();
  var otherInformationController = TextEditingController();
  var ifscCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<BankDetailsController>(
      init: BankDetailsController(),
      initState: (state) {
        bankNameController = TextEditingController(
            text: state.controller!.bankDetails.value.bankName);
        branchNameController = TextEditingController(
            text: state.controller!.bankDetails.value.branchName);
        holderNameController = TextEditingController(
            text: state.controller!.bankDetails.value.holderName);
        accountNumberController = TextEditingController(
            text: state.controller!.bankDetails.value.accountNo);
        otherInformationController = TextEditingController(
            text: state.controller!.bankDetails.value.otherInfo);
        ifscCodeController = TextEditingController(
            text: state.controller!.bankDetails.value.ifscCode);
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              title: Text(
                isEdit ? 'Edit bank'.tr : 'Add Bank'.tr,
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: ConstantColors.background),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: controller.isLoading.value
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank Name'.tr,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.50),
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: bankNameController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              'Branch Name'.tr,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.50),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: branchNameController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              'Holder Name'.tr,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.50),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: holderNameController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              'Account Number'.tr,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.50),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: accountNumberController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              'IFSC Code'.tr,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.50),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: ifscCodeController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              'Other information'.tr,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.50),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: otherInformationController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 45),
                              child: ButtonThem.buildButton(context,
                                  btnHeight: 44,
                                  title:
                                      isEdit ? "Edit bank".tr : "Add bank".tr,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.black, onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, String> bodyParams = {
                                    'driver_id':
                                        Preferences.getInt(Preferences.userId)
                                            .toString(),
                                    'bank_name': bankNameController.text,
                                    'branch_name': branchNameController.text,
                                    'holder_name': holderNameController.text,
                                    'account_no': accountNumberController.text,
                                    'information':
                                        otherInformationController.text,
                                    'ifsc_code': ifscCodeController.text
                                  };

                                  controller
                                      .setBankDetails(bodyParams)
                                      .then((value) {
                                    if (value != null) {
                                      Get.back(result: true);
                                    } else {
                                      ShowToastDialog.showToast(
                                          "Something want wrong.".tr);
                                    }
                                  });
                                }
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
