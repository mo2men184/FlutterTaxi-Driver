import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/controller/bank_details_controller.dart';
import 'package:rugbydriver/page/add_bank_details/add_bank_account.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowBankDetails extends StatelessWidget {
  const ShowBankDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<BankDetailsController>(
      init: BankDetailsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: controller.isLoading.value
                ? Constant.loader()
                : controller.bankDetails.value.bankName == null &&
                        controller.bankDetails.value.branchName == null &&
                        controller.bankDetails.value.holderName == null &&
                        controller.bankDetails.value.accountNo == null &&
                        controller.bankDetails.value.otherInfo == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Image.asset(
                                'assets/images/add_bank_placeholder.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 100),
                            child: Text(
                              'You have not  added bank account \n please add bank account'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.50),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 40, left: 25, right: 25),
                            child: ButtonThem.buildButton(context,
                                btnHeight: 44,
                                title: "Add Bank".tr,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white, onPress: () {
                              Get.to(AddBankAccount(
                                isEdit: false,
                              ))!
                                  .then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    controller.getBankDetails();
                                  }
                                }
                              });
                            }),
                          )
                        ],
                      )
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/bank_name.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Text(
                                            'Bank Name'.tr,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.50),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, left: 38),
                                      child: Text(
                                        controller.bankDetails.value.bankName
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/branch_name.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Text(
                                            'Branch Name'.tr,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.50),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, left: 38),
                                      child: Text(
                                        controller.bankDetails.value.branchName
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/holder_name.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Text(
                                            'Holder Name'.tr,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.50),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, left: 38),
                                      child: Text(
                                        controller.bankDetails.value.holderName
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/account_number.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Text(
                                            'Account Number'.tr,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.50),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, left: 38),
                                      child: Text(
                                        controller.bankDetails.value.accountNo
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/account_number.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Text(
                                            'IFSC Code'.tr,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.50),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, left: 38),
                                      child: Text(
                                        controller.bankDetails.value.ifscCode
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/other_info.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Text(
                                            'Other Information'.tr,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.50),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, left: 38),
                                      child: Text(
                                        controller.bankDetails.value.otherInfo
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 25, right: 25),
                                child: ButtonThem.buildButton(context,
                                    btnHeight: 40,
                                    title: "Edit bank".tr,
                                    btnColor: ConstantColors.primary,
                                    txtColor: Colors.black, onPress: () {
                                  Get.to(AddBankAccount(
                                    isEdit: true,
                                  ))!
                                      .then((value) {
                                    if (value != null) {
                                      if (value == true) {
                                        controller.getBankDetails();
                                      }
                                    }
                                  });
                                }),
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
