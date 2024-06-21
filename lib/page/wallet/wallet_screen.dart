// ignore_for_file: must_be_immutable, library_prefixes

import 'dart:convert';
import 'dart:developer';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/dash_board_controller.dart';
import 'package:rugbydriver/controller/payStackURLModel.dart';
import 'package:rugbydriver/controller/wallet_controller.dart';
import 'package:rugbydriver/model/get_payment_txt_token_model.dart';
import 'package:rugbydriver/model/payment_setting_model.dart';
import 'package:rugbydriver/model/razorpay_gen_userid_model.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/model/stripe_failed_model.dart';
import 'package:rugbydriver/model/trancation_model.dart';
import 'package:rugbydriver/page/completed/trip_history_screen.dart';
import 'package:rugbydriver/page/wallet/mercadopago_screen.dart';
import 'package:rugbydriver/page/wallet/payStackScreen.dart';
import 'package:rugbydriver/page/wallet/payfast_screen.dart';
import 'package:rugbydriver/page/wallet/paystack_url_generator.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal_native/flutter_paypal_native.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe1;
import 'withdrawals_screen.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatelessWidget {
  WalletScreen({Key? key}) : super(key: key);

  final Razorpay razorPayController = Razorpay();

  static final GlobalKey<FormState> _walletFormKey = GlobalKey<FormState>();
  final controllerDashBoard = Get.put(DashBoardController());
  final walletController = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return GetX<WalletController>(
        init: WalletController(),
        initState: (state) {
          initPayPal();
          walletController.getTrancation();
        },
        builder: (walletController) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => walletController.getTrancation(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.asset('assets/images/earning_bg.png'),
                        Positioned(
                          left: 5,
                          right: 5,
                          top: 0,
                          bottom: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Earnings'.tr,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      Constant().amountShow(
                                          amount: walletController.totalEarn
                                              .toString()),
                                      style: const TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    addToWalletAmount(
                                        context, walletController);
                                  },
                                  child: Container(
                                    height: 40,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "TOPUP WALLET".tr,
                                        style: TextStyle(
                                            color: ConstantColors.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: walletController.isLoading.value
                            ? Constant.loader()
                            : walletController.transactionList.isEmpty
                                ? Constant.emptyView("No transaction found".tr)
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        walletController.transactionList.length,
                                    itemBuilder: (context, index) {
                                      return showRideTransaction(
                                          walletController
                                              .transactionList[index]);
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonThem.buildButton(
                      context,
                      title: 'Withdraw'.tr,
                      btnHeight: 45,
                      btnWidthRatio: 0.8,
                      btnColor: ConstantColors.primary,
                      txtColor: Colors.black,
                      onPress: () async {
                        walletController.getBankDetails().then((value) {
                          if (value == null) {
                            ShowToastDialog.showToast(
                                'Please Update bank Details'.tr);
                          } else {
                            buildShowBottomSheet(context, walletController);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: ButtonThem.buildBorderButton(
                    context,
                    title: 'History'.tr.toUpperCase(),
                    btnHeight: 45,
                    btnWidthRatio: 0.8,
                    btnColor: Colors.white,
                    txtColor: Colors.black.withOpacity(0.60),
                    btnBorderColor: Colors.black.withOpacity(0.20),
                    onPress: () async {
                      Get.to(const WithdrawalsScreen());
                    },
                  ))
                ],
              ),
            ),
          );
        });
  }

  showRideTransaction(TansactionData data) {
    return InkWell(
      onTap: () {
        if (data.departName!.isNotEmpty) {
          Get.to(const TripHistoryScreen(), arguments: {
            "rideData": RideData.fromJson(data.toJson()),
          });
        } else {}
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.creer.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        data.amount!.toString().contains('-')
                            ? "(-${Constant().amountShow(amount: data.amount!.split("-").last.toString())})"
                            : data.amount!.isNotEmpty
                                ? Constant().amountShow(
                                    amount:
                                        "${double.parse(data.amount!.toString()) + double.parse(data.adminCommission!.isNotEmpty ? data.adminCommission!.toString() : "0.0")}")
                                : "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: data.amount!.toString().contains('-')
                                ? Colors.red
                                : ConstantColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: data.departName!.isNotEmpty
                    ? Row(
                        children: [
                          Image.asset(
                            "assets/icons/ic_pic_drop_location.png",
                            height: 65,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextScroll(data.departName.toString(),
                                      mode: TextScrollMode.bouncing,
                                      pauseBetween: const Duration(seconds: 2)),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  TextScroll(data.destinationName.toString(),
                                      mode: TextScrollMode.bouncing,
                                      pauseBetween: const Duration(seconds: 2))
                                  // Text(data.destinationName.toString(),maxLines: 1,),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            data.amount!.toString().contains('-')
                                ? "Admin Commission".tr
                                : data.payment.toString(),
                            style: TextStyle(
                                color: ConstantColors.yellow,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${"Wallet Topup Via".tr} ${data.libelle}",
                          style: TextStyle(
                              color: ConstantColors.yellow,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final amountController = TextEditingController();
  final noteController = TextEditingController();

  buildShowBottomSheet(BuildContext context, WalletController controller) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Withdraw".tr,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: ConstantColors.primary.withOpacity(0.40),
                                width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.bankDetails.bankName
                                              .toString(),
                                          style: TextStyle(
                                              color: ConstantColors.primary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            controller.bankDetails.accountNo
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.80),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/icons/bank_name.png',
                                    height: 40,
                                    width: 40,
                                    color: ConstantColors.primary
                                        .withOpacity(0.40),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 22),
                                child: Text(
                                  controller.bankDetails.holderName.toString(),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.40),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.bankDetails.otherInfo
                                            .toString(),
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.60),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      controller.bankDetails.branchName
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.60),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Amount to Withdraw".tr,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.50),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          prefix: Text(Constant.currency.toString()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Add Note".tr,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.50),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: noteController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: ButtonThem.buildButton(
                            context,
                            title: 'Withdraw'.tr,
                            btnHeight: 45,
                            btnWidthRatio: 0.9,
                            btnColor: ConstantColors.primary,
                            txtColor: Colors.white,
                            onPress: () async {
                              if (controller.bankDetails.bankName.toString() !=
                                  'null') {
                                if (amountController.text.isNotEmpty) {
                                  if (double.parse(Constant
                                          .minimumWithdrawalAmount
                                          .toString()) >
                                      double.parse(amountController.text)) {
                                    ShowToastDialog.showToast(
                                        '${'Withdraw amount must be greater or equal to'.tr}${Constant().amountShow(amount: Constant.minimumWithdrawalAmount.toString())}');
                                  } else {
                                    Map<String, dynamic> bodyParams = {
                                      'driver_id': Preferences.getInt(
                                          Preferences.userId),
                                      'amount': amountController.text,
                                      'note': noteController.text,
                                    };
                                    controller
                                        .setWithdrawals(bodyParams)
                                        .then((value) {
                                      if (value != null && value) {
                                        ShowToastDialog.showToast(
                                            'Amount Withdrawals request successfully'
                                                .tr);
                                      }
                                    });
                                    Get.back();
                                  }
                                } else {
                                  ShowToastDialog.showToast(
                                      'Please enter amount'.tr);
                                }
                              } else {
                                ShowToastDialog.showToast(
                                    'Please add bank details'.tr);
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  addToWalletAmount(BuildContext context, WalletController walletController) {
    return showModalBottomSheet(
        elevation: 5,
        useRootNavigator: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        backgroundColor: ConstantColors.background,
        builder: (context) {
          return GetX<WalletController>(
              init: WalletController(),
              initState: (controller) {
                razorPayController.on(
                    Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                razorPayController.on(
                    Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWaller);
                razorPayController.on(
                    Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
              },
              builder: (controller) {
                return SizedBox(
                  height: Get.height / 1.2,
                  child: SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Topup Wallet".tr,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Text("Add Topup Amount".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey)),
                              ),
                            ],
                          ),
                          Form(
                            key: _walletFormKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              child: TextFormField(
                                validator: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "required".tr;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: amountController,
                                maxLength: 13,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  counterText: "",
                                  hintText: "enter_amount".tr,
                                  contentPadding:
                                      const EdgeInsets.only(top: 20, left: 10),
                                  prefix: Text(Constant.currency.toString()),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Select Payment Option".tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Visibility(
                            visible: walletController.paymentSettingModel.value
                                        .strip!.isEnabled ==
                                    "true"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation:
                                    walletController.stripe.value ? 0 : 2,
                                child: RadioListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: walletController.stripe.value
                                              ? ConstantColors.primary
                                              : Colors.transparent)),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: "Stripe",
                                  groupValue:
                                      walletController.selectedRadioTile!.value,
                                  onChanged: (String? value) {
                                    walletController.stripe = true.obs;
                                    walletController.razorPay = false.obs;
                                    walletController.payTm = false.obs;
                                    walletController.paypal = false.obs;
                                    walletController.payStack = false.obs;
                                    walletController.flutterWave = false.obs;
                                    walletController.mercadoPago = false.obs;
                                    walletController.payFast = false.obs;
                                    walletController.selectedRadioTile!.value =
                                        value!;
                                  },
                                  selected: walletController.stripe.value,
                                  //selectedRadioTile == "strip" ? true : false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 10),
                                            child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Image.asset(
                                                  "assets/images/stripe.png",
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text("Stripe".tr),
                                    ],
                                  ),
                                  //toggleable: true,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: walletController.paymentSettingModel.value
                                        .payStack!.isEnabled ==
                                    "true"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation:
                                    walletController.payStack.value ? 0 : 2,
                                child: RadioListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: walletController.payStack.value
                                              ? ConstantColors.primary
                                              : Colors.transparent)),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: "PayStack",
                                  groupValue:
                                      walletController.selectedRadioTile!.value,
                                  onChanged: (String? value) {
                                    walletController.stripe = false.obs;
                                    walletController.razorPay = false.obs;
                                    walletController.payTm = false.obs;
                                    walletController.paypal = false.obs;
                                    walletController.payStack = true.obs;
                                    walletController.flutterWave = false.obs;
                                    walletController.mercadoPago = false.obs;
                                    walletController.payFast = false.obs;
                                    walletController.selectedRadioTile!.value =
                                        value!;
                                  },
                                  selected: walletController.payStack.value,
                                  //selectedRadioTile == "strip" ? true : false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 10),
                                            child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Image.asset(
                                                  "assets/images/paystack.png",
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text("PayStack".tr),
                                    ],
                                  ),
                                  //toggleable: true,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: walletController.paymentSettingModel.value
                                        .flutterWave!.isEnabled ==
                                    "true"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation:
                                    walletController.flutterWave.value ? 0 : 2,
                                child: RadioListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color:
                                              walletController.flutterWave.value
                                                  ? ConstantColors.primary
                                                  : Colors.transparent)),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: "FlutterWave",
                                  groupValue:
                                      walletController.selectedRadioTile!.value,
                                  onChanged: (String? value) {
                                    walletController.stripe = false.obs;
                                    walletController.razorPay = false.obs;
                                    walletController.payTm = false.obs;
                                    walletController.paypal = false.obs;
                                    walletController.payStack = false.obs;
                                    walletController.flutterWave = true.obs;
                                    walletController.mercadoPago = false.obs;
                                    walletController.payFast = false.obs;
                                    walletController.selectedRadioTile!.value =
                                        value!;
                                  },
                                  selected: walletController.flutterWave.value,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 10),
                                            child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Image.asset(
                                                  "assets/images/flutterwave.png",
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text("FlutterWave"),
                                    ],
                                  ),
                                  //toggleable: true,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: walletController.paymentSettingModel.value
                                        .razorpay!.isEnabled ==
                                    "true"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation:
                                    walletController.razorPay.value ? 0 : 2,
                                child: RadioListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: walletController.razorPay.value
                                              ? ConstantColors.primary
                                              : Colors.transparent)),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: "RazorPay",
                                  groupValue:
                                      walletController.selectedRadioTile!.value,
                                  onChanged: (String? value) {
                                    walletController.stripe = false.obs;
                                    walletController.razorPay = true.obs;
                                    walletController.payTm = false.obs;
                                    walletController.paypal = false.obs;
                                    walletController.payStack = false.obs;
                                    walletController.flutterWave = false.obs;
                                    walletController.mercadoPago = false.obs;
                                    walletController.payFast = false.obs;
                                    walletController.selectedRadioTile!.value =
                                        value!;
                                  },
                                  selected: walletController.razorPay.value,
                                  //selectedRadioTile == "strip" ? true : false,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3.0, horizontal: 10),
                                            child: SizedBox(
                                                width: 80,
                                                height: 35,
                                                child: Image.asset(
                                                    "assets/images/razorpay_@3x.png")),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text("RazorPay"),
                                    ],
                                  ),
                                  //toggleable: true,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: walletController.paymentSettingModel.value
                                        .payFast!.isEnabled ==
                                    "true"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation:
                                    walletController.payFast.value ? 0 : 2,
                                child: RadioListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: walletController.payFast.value
                                              ? ConstantColors.primary
                                              : Colors.transparent)),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: "PayFast",
                                  groupValue:
                                      walletController.selectedRadioTile!.value,
                                  onChanged: (String? value) {
                                    walletController.stripe = false.obs;
                                    walletController.razorPay = false.obs;
                                    walletController.payTm = false.obs;
                                    walletController.paypal = false.obs;
                                    walletController.payStack = false.obs;
                                    walletController.flutterWave = false.obs;
                                    walletController.mercadoPago = false.obs;
                                    walletController.payFast = true.obs;
                                    walletController.selectedRadioTile!.value =
                                        value!;
                                  },
                                  selected: walletController.payFast.value,
                                  //selectedRadioTile == "strip" ? true : false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 10),
                                            child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Image.asset(
                                                  "assets/images/payfast.png",
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text("Pay Fast"),
                                    ],
                                  ),
                                  //toggleable: true,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: walletController.paymentSettingModel.value
                                        .paytm!.isEnabled ==
                                    "true"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: walletController.payTm.value ? 0 : 2,
                                child: RadioListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: walletController.payTm.value
                                              ? ConstantColors.primary
                                              : Colors.transparent)),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: "PayTm",
                                  groupValue:
                                      walletController.selectedRadioTile!.value,
                                  onChanged: (String? value) {
                                    walletController.stripe = false.obs;
                                    walletController.razorPay = false.obs;
                                    walletController.payTm = true.obs;
                                    walletController.paypal = false.obs;
                                    walletController.payStack = false.obs;
                                    walletController.flutterWave = false.obs;
                                    walletController.mercadoPago = false.obs;
                                    walletController.payFast = false.obs;
                                    walletController.selectedRadioTile!.value =
                                        value!;
                                  },
                                  selected: walletController.payTm.value,
                                  //selectedRadioTile == "strip" ? true : false,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3.0, horizontal: 10),
                                            child: SizedBox(
                                                width: 80,
                                                height: 35,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3.0),
                                                  child: Image.asset(
                                                    "assets/images/paytm_@3x.png",
                                                  ),
                                                )),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text("Paytm".tr),
                                    ],
                                  ),
                                  //toggleable: true,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: walletController.paymentSettingModel.value
                                        .mercadopago!.isEnabled ==
                                    "true"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation:
                                    walletController.mercadoPago.value ? 0 : 2,
                                child: RadioListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color:
                                              walletController.mercadoPago.value
                                                  ? ConstantColors.primary
                                                  : Colors.transparent)),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: "MercadoPago",
                                  groupValue:
                                      walletController.selectedRadioTile!.value,
                                  onChanged: (String? value) {
                                    walletController.stripe = false.obs;
                                    walletController.razorPay = false.obs;
                                    walletController.payTm = false.obs;
                                    walletController.paypal = false.obs;
                                    walletController.payStack = false.obs;
                                    walletController.flutterWave = false.obs;
                                    walletController.mercadoPago = true.obs;
                                    walletController.payFast = false.obs;
                                    walletController.selectedRadioTile!.value =
                                        value!;
                                  },
                                  selected: walletController.mercadoPago.value,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 10),
                                            child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Image.asset(
                                                  "assets/images/mercadopago.png",
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text("Mercado Pago".tr),
                                    ],
                                  ),
                                  //toggleable: true,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: walletController.paymentSettingModel.value
                                        .payPal!.isEnabled ==
                                    "true"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation:
                                    walletController.paypal.value ? 0 : 2,
                                child: RadioListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: walletController.paypal.value
                                              ? ConstantColors.primary
                                              : Colors.transparent)),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: "PayPal",
                                  groupValue:
                                      walletController.selectedRadioTile!.value,
                                  onChanged: (String? value) {
                                    walletController.stripe = false.obs;
                                    walletController.razorPay = false.obs;
                                    walletController.payTm = false.obs;
                                    walletController.paypal = true.obs;
                                    walletController.payStack = false.obs;
                                    walletController.flutterWave = false.obs;
                                    walletController.mercadoPago = false.obs;
                                    walletController.payFast = false.obs;
                                    walletController.selectedRadioTile!.value =
                                        value!;
                                  },
                                  selected: walletController.paypal.value,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3.0, horizontal: 10),
                                            child: SizedBox(
                                                width: 80,
                                                height: 35,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3.0),
                                                  child: Image.asset(
                                                      "assets/images/paypal_@3x.png"),
                                                )),
                                          )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text("PayPal".tr),
                                    ],
                                  ),
                                  //toggleable: true,
                                ),
                              ),
                            ),
                          ),

                          // controller.isLoading.value
                          //     ? Constant.loader()
                          //     : controller.paymentMethodList.isEmpty
                          //         ? Constant.emptyView(context, "Payment method not found please contact administrator", false)
                          //         : ListView.builder(
                          //             itemCount: controller.paymentMethodList.length,
                          //             shrinkWrap: true,
                          //             itemBuilder: (context, index) {
                          //               return Obx(
                          //                 () => controller.paymentMethodList[index].libelle != "Cash" &&
                          //                         controller.paymentMethodList[index].libelle != "My Wallet"
                          //                     ? Visibility(
                          //                         visible: controller.paymentMethodList[index].statut == "yes",
                          //                         child: Padding(
                          //                           padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 15),
                          //                           child: Card(
                          //                               shape: RoundedRectangleBorder(
                          //                                 borderRadius: BorderRadius.circular(8),
                          //                               ),
                          //                               elevation: controller.selectedRadioTile!.value ==
                          //                                       controller.paymentMethodList[index].libelle.toString()
                          //                                   ? 0
                          //                                   : 2,
                          //                               child: RadioListTile(
                          //                                 shape: RoundedRectangleBorder(
                          //                                     borderRadius: BorderRadius.circular(8),
                          //                                     side: BorderSide(
                          //                                         color: controller.selectedRadioTile!.value ==
                          //                                                 controller.paymentMethodList[index].libelle.toString()
                          //                                             ? ConstantColors.primary
                          //                                             : Colors.transparent)),
                          //                                 controlAffinity: ListTileControlAffinity.trailing,
                          //                                 value: controller.paymentMethodList[index].libelle.toString(),
                          //                                 groupValue: controller.selectedRadioTile!.value,
                          //                                 onChanged: (newValue) {
                          //                                   controller.selectedRadioTile!.value = newValue.toString();
                          //                                 },
                          //                                 title: Row(
                          //                                   children: [
                          //                                     Padding(
                          //                                       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          //                                       child: Container(
                          //                                         decoration: BoxDecoration(
                          //                                           color: Colors.grey.withOpacity(0.10),
                          //                                           borderRadius: BorderRadius.circular(8),
                          //                                         ),
                          //                                         child: Padding(
                          //                                           padding:
                          //                                               const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                          //                                           child: SizedBox(
                          //                                             width: 80,
                          //                                             height: 35,
                          //                                             child: Padding(
                          //                                               padding: const EdgeInsets.symmetric(vertical: 6.0),
                          //                                               child: CachedNetworkImage(
                          //                                                 imageUrl: controller.paymentMethodList[index].image!,
                          //                                                 placeholder: (context, url) => Constant.loader(),
                          //                                                 errorWidget: (context, url, error) =>
                          //                                                     const Icon(Icons.error),
                          //                                               ),
                          //                                             ),
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                     Padding(
                          //                                       padding: const EdgeInsets.only(left: 10),
                          //                                       child: Text(
                          //                                         controller.paymentMethodList[index].libelle.toString(),
                          //                                         style: const TextStyle(color: Colors.black),
                          //                                       ),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                               )),
                          //                         ),
                          //                       )
                          //                     : Container(),
                          //               );
                          //             }),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 15),
                            child: GestureDetector(
                              onTap: () async {
                                if (_walletFormKey.currentState!.validate()) {
                                  Get.back();
                                  showLoadingAlert(context);
                                  if (walletController
                                          .selectedRadioTile!.value ==
                                      "Stripe") {
                                    stripeMakePayment(
                                        amount: amountController.text);
                                  } else if (walletController
                                          .selectedRadioTile!.value ==
                                      "RazorPay") {
                                    startRazorpayPayment();
                                  } else if (walletController
                                          .selectedRadioTile!.value ==
                                      "PayTm") {
                                    getPaytmCheckSum(context,
                                        amount: double.parse(
                                            amountController.text));
                                  } else if (walletController
                                          .selectedRadioTile!.value ==
                                      "PayPal") {
                                    print(
                                        "====AMOUNT : ${amountController.text}");
                                    paypalPaymentSheet(amountController.text);
                                    // _paypalPayment();
                                  } else if (walletController
                                          .selectedRadioTile!.value ==
                                      "PayStack") {
                                    payStackPayment(context);
                                  } else if (walletController
                                          .selectedRadioTile!.value ==
                                      "FlutterWave") {
                                    flutterWaveInitiatePayment(context);
                                  } else if (walletController
                                          .selectedRadioTile!.value ==
                                      "PayFast") {
                                    payFastPayment(context);
                                  } else if (walletController
                                          .selectedRadioTile!.value ==
                                      "MercadoPago") {
                                    mercadoPagoMakePayment(context);
                                  } else {
                                    Get.back();
                                    ShowToastDialog.showToast(
                                        "Please select payment method".tr);
                                  }
                                }
                              },
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: ConstantColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                    child: Text(
                                  "CONTINUE".tr.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  void _handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    showSnackBarAlert(
      message: "${"Payment Processing Via".tr} \n${response.walletName!}",
      color: Colors.blue.shade400,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.back();
    walletController.setAmount(amountController.text).then((value) {
      if (value != null) {
        showSnackBarAlert(
          message: "Payment Successful!!".tr,
          color: Colors.green.shade400,
        );
        _refreshAPI();
      }
    });
  }

  showSnackBarAlert({required String message, Color color = Colors.green}) {
    return Get.showSnackbar(GetSnackBar(
      isDismissible: true,
      message: message,
      backgroundColor: color,
      duration: const Duration(seconds: 8),
    ));
  }

  Future<void> _refreshAPI() async {
    walletController.getTrancation();
    amountController.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    showSnackBarAlert(
      message:
          "${"Payment Failed!!".tr}${jsonDecode(response.message!)['error']['description']}",
      color: Colors.red.shade400,
    );
  }

  showLoadingAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CircularProgressIndicator(),
              Text('Please wait!!'.tr),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Please wait!! while completing Transaction'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///payFast

  payFastPayment(context) {
    PayFast? payfast = walletController.paymentSettingModel.value.payFast;
    PayStackURLGen.getPayHTML(
            payFastSettingData: payfast!,
            amount: double.parse(amountController.text.toString())
                .round()
                .toString())
        .then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(
        htmlData: value!,
        payFastSettingData: payfast,
      ));
      if (isDone) {
        Get.back();
        walletController.setAmount(amountController.text).then((value) {
          if (value != null) {
            showSnackBarAlert(
              message: "Payment Successful!!".tr,
              color: Colors.green.shade400,
            );
            _refreshAPI();
          }
        });
      } else {
        Get.back();
        showSnackBarAlert(
          message: "Payment UnSuccessful!!".tr,
          color: Colors.red,
        );
      }
    });
  }

  /// Stripe Payment Gateway
  Map<String, dynamic>? paymentIntentData;

  Future<void> stripeMakePayment({required String amount}) async {
    try {
      paymentIntentData =
          await walletController.createStripeIntent(amount: amount);

      if (paymentIntentData != null &&
          paymentIntentData!.containsKey("error")) {
        Get.back();
        showSnackBarAlert(
          message: "Something went wrong, please contact admin.".tr,
          color: Colors.red.shade400,
        );
      } else {
        await stripe1.Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: stripe1.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              allowsDelayedPaymentMethods: false,
              googlePay: stripe1.PaymentSheetGooglePay(
                merchantCountryCode: 'US',
                testEnv: walletController.paymentSettingModel.value.strip!
                            .isSandboxEnabled ==
                        'true'
                    ? true
                    : false,
                currencyCode: "USD",
              ),
              style: ThemeMode.system,
              appearance: stripe1.PaymentSheetAppearance(
                colors: stripe1.PaymentSheetAppearanceColors(
                  primary: ConstantColors.primary,
                ),
              ),
              merchantDisplayName: 'RugbyRides',
            ))
            .then((value) {});

        displayStripePaymentSheet();
      }
    } catch (e, s) {
      Get.back();

      showSnackBarAlert(
        message: 'exception:$e \n$s',
        color: Colors.red,
      );
    }
  }

  displayStripePaymentSheet() async {
    try {
      await stripe1.Stripe.instance.presentPaymentSheet().then((value) {
        Get.back();
        walletController.setAmount(amountController.text).then((value) {
          if (value != null) {
            _refreshAPI();
          }
        });
        paymentIntentData = null;
      });
    } on stripe1.StripeException catch (e) {
      Get.back();
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      showSnackBarAlert(
        message: lom.error.message,
        color: Colors.green,
      );
    } catch (e) {
      Get.back();
      showSnackBarAlert(
        message: e.toString(),
        color: Colors.green,
      );
    }
  }

  /// RazorPay Payment Gateway
  startRazorpayPayment() {
    try {
      walletController
          .createOrderRazorPay(
              amount: double.parse(amountController.text).round())
          .then((value) {
        if (value != null) {
          CreateRazorPayOrderModel result = value;
          openCheckout(
            amount: amountController.text,
            orderId: result.id,
          );
        } else {
          Get.back();
          showSnackBarAlert(
            message: "Something went wrong, please contact admin.".tr,
            color: Colors.red.shade400,
          );
        }
      });
    } catch (e) {
      Get.back();
      showSnackBarAlert(
        message: e.toString(),
        color: Colors.red.shade400,
      );
    }
  }

  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': walletController.paymentSettingModel.value.razorpay!.key,
      'amount': amount * 100,
      'name': 'RugbyRides',
      'order_id': orderId,
      "currency": "GBP",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': "8888888888", 'email': "info@rugbyrides.co.uk"},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPayController.open(options);
    } catch (e) {
      log('RazorPay Error : $e');
    }
  }

  /// Paytm Payment Gateway
  bool isStaging = true;
  bool enableAssist = true;
  String result = "";

  getPaytmCheckSum(
    context, {
    required double amount,
  }) async {
    String orderId = DateTime.now().microsecondsSinceEpoch.toString();
    String getChecksum = "${API.baseUrl}payments/getpaytmchecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {
          'apikey': API.apiKey,
          'accesstoken': Preferences.getString(Preferences.accesstoken),
        },
        body: {
          "mid": walletController.paymentSettingModel.value.paytm!.merchantId,
          "order_id": orderId,
          "key_secret":
              walletController.paymentSettingModel.value.paytm!.merchantKey,
        });

    final data = jsonDecode(response.body);

    await walletController
        .verifyCheckSum(
            checkSum: data["code"], amount: amount, orderId: orderId)
        .then((value) {
      initiatePayment(context, amount: amount, orderId: orderId).then((value) {
        GetPaymentTxtTokenModel result = value;
        String callback = "";
        if (walletController
                .paymentSettingModel.value.paytm!.isSandboxEnabled ==
            "true") {
          callback =
              "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        } else {
          callback =
              "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        }

        _startTransaction(
          context,
          txnTokenBy: result.body.txnToken,
          orderId: orderId,
          amount: amount,
        );
      });
    });
  }

  Future<GetPaymentTxtTokenModel> initiatePayment(BuildContext context,
      {required double amount, required orderId}) async {
    String initiateURL = "${API.baseUrl}payments/initiatepaytmpayment";
    String callback = "";
    if (walletController.paymentSettingModel.value.paytm!.isSandboxEnabled
            .toString() ==
        "true") {
      callback =
          "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    } else {
      callback =
          "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    }
    final response = await http.post(
        Uri.parse(
          initiateURL,
        ),
        headers: {
          'apikey': API.apiKey,
          'accesstoken': Preferences.getString(Preferences.accesstoken),
        },
        body: {
          "mid": walletController.paymentSettingModel.value.paytm!.merchantId!
              .trim(),
          "order_id": orderId,
          "key_secret": walletController
              .paymentSettingModel.value.paytm!.merchantKey!
              .trim(),
          "amount": amount.toString(),
          "currency": "INR",
          "callback_url": callback,
          "custId": "30",
          "issandbox": walletController
                      .paymentSettingModel.value.paytm!.isSandboxEnabled
                      .toString() ==
                  "true"
              ? "1"
              : "2",
        });
    final data = jsonDecode(response.body);

    if (data["body"]["txnToken"] == null ||
        data["body"]["txnToken"].toString().isEmpty) {
      Get.back();
      showSnackBarAlert(
        message: "Something went wrong, please contact admin.".tr,
        color: Colors.red.shade400,
      );
    }
    return GetPaymentTxtTokenModel.fromJson(data);
  }

  Future<void> _startTransaction(
    context, {
    required String txnTokenBy,
    required orderId,
    required double amount,
  }) async {
    try {
      var response = AllInOneSdk.startTransaction(
        walletController.paymentSettingModel.value.paytm!.merchantId.toString(),
        orderId,
        amount.toString(),
        txnTokenBy,
        "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId",
        isStaging,
        true,
        enableAssist,
      );

      response.then((value) {
        if (value!["RESPMSG"] == "Txn Success") {
          walletController.setAmount(amountController.text).then((value) {
            if (value != null) {
              Get.back();
              showSnackBarAlert(
                message: "Payment Successful!!",
                color: Colors.green.shade400,
              );
              _refreshAPI();
            }
          });
        }
      }).catchError((onError) {
        if (onError is PlatformException) {
          Get.back();

          result = "${onError.message} \n  ${onError.code}";
          showSnackBarAlert(
            message: "Something went wrong, please contact admin.".tr,
            color: Colors.red.shade400,
          );
        } else {
          result = onError.toString();
          Get.back();
          showSnackBarAlert(
            message: "Something went wrong, please contact admin.".tr,
            color: Colors.red.shade400,
          );
        }
      });
    } catch (err) {
      result = err.toString();
      Get.back();
      showSnackBarAlert(
        message: "Something went wrong, please contact admin.".tr,
        color: Colors.red.shade400,
      );
    }
  }

  ///MercadoPago Payment Method

  mercadoPagoMakePayment(BuildContext context) {
    makePreference().then((result) async {
      if (result.isNotEmpty) {
        // var clientId = result['response']['client_id'];
        // var preferenceId = result['response']['id'];
        String initPoint = result['response']['init_point'];
        final bool isDone =
            await Get.to(MercadoPagoScreen(initialURl: initPoint));

        if (isDone) {
          Get.back();
          walletController.setAmount(amountController.text).then((value) {
            if (value != null) {
              showSnackBarAlert(
                message: "Payment Successful!!",
                color: Colors.green.shade400,
              );
              _refreshAPI();
            }
          });
        } else {
          Get.back();
          showSnackBarAlert(
            message: "Payment UnSuccessful!!",
            color: Colors.red,
          );
        }
      } else {
        Get.back();
        showSnackBarAlert(
          message: "Error while transaction!",
          color: Colors.red,
        );
      }
    });
  }

  Future<Map<String, dynamic>> makePreference() async {
    final mp = MP.fromAccessToken(
        walletController.paymentSettingModel.value.mercadopago!.accesstoken);
    var pref = {
      "items": [
        {
          "title": "Wallet TopUp",
          "quantity": 1,
          "unit_price": double.parse(amountController.text)
        }
      ],
      "auto_return": "all",
      "back_urls": {
        "failure": "${API.baseUrl}payment/failure",
        "pending": "${API.baseUrl}payment/pending",
        "success": "${API.baseUrl}payment/success"
      },
    };

    var result = await mp.createPreference(pref);
    return result;
  }

  ///paypal
  ///
  final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  void initPayPal() async {
    //set debugMode for error logging
    FlutterPaypalNative.isDebugMode =
        walletController.paymentSettingModel.value.payPal!.isLive.toString() ==
                "false"
            ? true
            : false;

    //initiate payPal plugin
    await _flutterPaypalNativePlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: "com.rugbyrides.driver://paypalpay",
      //client id from developer dashboard
      clientID: walletController.paymentSettingModel.value.payPal!.appId!,
      //sandbox, staging, live etc
      payPalEnvironment: walletController
                  .paymentSettingModel.value.payPal!.isLive
                  .toString() ==
              "true"
          ? FPayPalEnvironment.live
          : FPayPalEnvironment.sandbox,
      //what currency do you plan to use? default is US dollars
      currencyCode: FPayPalCurrencyCode.usd,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );

    //call backs for payment
  }

  paypalPaymentSheet(String amount) {
    //add 1 item to cart. Max is 4!
    if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
      _flutterPaypalNativePlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          // random prices
          amount: double.parse(amount),

          ///please use your own algorithm for referenceId. Maybe ProductID?
          referenceId: FPayPalStrHelper.getRandomString(16),
        ),
      );
    }
    // initPayPal();
    _flutterPaypalNativePlugin.makeOrder(
      action: FPayPalUserAction.payNow,
    );
    _flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          //user canceled the payment
          ShowToastDialog.showToast("Payment canceled".tr);
        },
        onSuccess: (data) {
          //successfully paid
          //remove all items from queue
          // _flutterPaypalNativePlugin.removeAllPurchaseItems();

          walletController
              .setAmount(amountController.text.toString())
              .then((value) {
            Get.back();
            if (value != null) {
              showSnackBarAlert(
                message: "Payment Successful!!",
                color: Colors.green.shade400,
              );
              _refreshAPI();
            }
          });

          ShowToastDialog.showToast("Payment Successful!!".tr);
          // transactionAPI();
          // walletTopUp();
        },
        onError: (data) {
          //an error occured
          Get.back();
          ShowToastDialog.showToast("error: ${data.reason}");
        },
        onShippingChange: (data) {
          //the user updated the shipping address
          Get.back();
          ShowToastDialog.showToast(
              "shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}");
        },
      ),
    );
  }
  // _paypalPayment() async {
  //   PayPalClientTokenGen.paypalClientToken(
  //           walletController.paymentSettingModel.value.payPal)
  //       .then((value) async {
  //     final String tokenizationKey = walletController
  //         .paymentSettingModel.value.payPal!.tokenizationKey
  //         .toString();

  //     var request = BraintreePayPalRequest(
  //         amount: amountController.text,
  //         currencyCode: "USD",
  //         billingAgreementDescription: "djsghxghf",
  //         displayName: 'Cab company');
  //     BraintreePaymentMethodNonce? resultData;
  //     try {
  //       resultData =
  //           await Braintree.requestPaypalNonce(tokenizationKey, request);
  //     } on Exception catch (ex) {
  //       showSnackBarAlert(
  //         message: "Something went wrong, please contact admin. $ex",
  //         color: Colors.red.shade400,
  //       );
  //     }

  //     if (resultData?.nonce != null) {
  //       PayPalClientTokenGen.paypalSettleAmount(
  //         payPal: walletController.paymentSettingModel.value.payPal,
  //         nonceFromTheClient: resultData?.nonce,
  //         amount: amountController.text,
  //         deviceDataFromTheClient: resultData?.typeLabel,
  //       ).then((value) {
  //         if (value['success'] == "true" || value['success'] == true) {
  //           if (value['data']['success'] == "true" ||
  //               value['data']['success'] == true) {
  //             payPalSettel.PayPalClientSettleModel settleResult =
  //                 payPalSettel.PayPalClientSettleModel.fromJson(value);
  //             if (settleResult.data.success) {
  //               Get.back();

  //               Get.back();
  //               walletController.setAmount(amountController.text).then((value) {
  //                 if (value != null) {
  //                   showSnackBarAlert(
  //                     message: "Payment Successful!!",
  //                     color: Colors.green.shade400,
  //                   );
  //                   _refreshAPI();
  //                 }
  //               });
  //             }
  //           } else {
  //             payPalCurrModel.PayPalCurrencyCodeErrorModel settleResult =
  //                 payPalCurrModel.PayPalCurrencyCodeErrorModel.fromJson(value);
  //             Get.back();
  //             showSnackBarAlert(
  //               message: "Status : ${settleResult.data.message}",
  //               color: Colors.red.shade400,
  //             );
  //           }
  //         } else {
  //           payPalErrorSettle.PayPalErrorSettleModel settleResult =
  //               payPalErrorSettle.PayPalErrorSettleModel.fromJson(value);
  //           Get.back();
  //           showSnackBarAlert(
  //             message: "Status : ${settleResult.data.message}",
  //             color: Colors.red.shade400,
  //           );
  //         }
  //       });
  //     } else {
  //       Get.back();
  //       showSnackBarAlert(
  //         message: "Status : Payment Incomplete!!",
  //         color: Colors.red.shade400,
  //       );
  //     }
  //   });
  // }

  ///PayStack Payment Method
  payStackPayment(BuildContext context) async {
    var secretKey = walletController
        .paymentSettingModel.value.payStack!.secretKey
        .toString();
    await walletController
        .payStackURLGen(
      amount: amountController.text,
      secretKey: secretKey,
    )
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;

        bool isDone = await Get.to(() => PayStackScreen(
              walletController: walletController,
              secretKey: secretKey,
              initialURl: payStackModel.data.authorizationUrl,
              amount: amountController.text,
              reference: payStackModel.data.reference,
              callBackUrl: walletController
                  .paymentSettingModel.value.payStack!.callbackUrl
                  .toString(),
            ));
        Get.back();

        if (isDone) {
          walletController.setAmount(amountController.text).then((value) {
            if (value != null) {
              showSnackBarAlert(
                message: "Payment Successful!!",
                color: Colors.green.shade400,
              );
              _refreshAPI();
            }
          });
        } else {
          showSnackBarAlert(
              message: "Payment UnSuccessful!! \n", color: Colors.red);
        }
      } else {
        showSnackBarAlert(
            message: "Error while transaction! \n", color: Colors.red);
      }
    });
  }

  ///FlutterWave Payment Method

  flutterWaveInitiatePayment(
    BuildContext context,
  ) async {
    final style = FlutterwaveStyle(
      appBarText: "RugbyRides",
      buttonColor: const Color(0xff4774FF),
      buttonTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      appBarColor: const Color(0xff4774FF),
      dialogCancelTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      dialogContinueTextStyle: const TextStyle(
        color: Color(0xff4774FF),
        fontSize: 18,
      ),
      mainTextStyle:
          const TextStyle(color: Colors.black, fontSize: 19, letterSpacing: 2),
      dialogBackgroundColor: Colors.white,
      appBarTitleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
    final flutterwave = Flutterwave(
      amount: amountController.text.toString().trim(),
      currency: "NGN",
      style: style,
      customer: Customer(
        name: "demo",
        phoneNumber: "1234567890",
        email: "demo@gamil.com",
      ),
      context: context,
      publicKey: walletController
          .paymentSettingModel.value.flutterWave!.publicKey
          .toString(),
      paymentOptions: "ussd, card, barter, payattitude",
      customization: Customization(
        title: "RugbyRides",
      ),
      txRef: walletController.ref.value,
      isTestMode: walletController
                  .paymentSettingModel.value.flutterWave!.isSandboxEnabled ==
              'true'
          ? true
          : false,
      redirectUrl: '${API.baseUrl}success',
    );
    try {
      final ChargeResponse response = await flutterwave.charge();
      if (response.toString().isNotEmpty) {
        if (response.success!) {
          Get.back();
          walletController.setAmount(amountController.text).then((value) {
            if (value != null) {
              showSnackBarAlert(
                message: "Payment Successful!!",
                color: Colors.green.shade400,
              );
              _refreshAPI();
            }
          });
        } else {
          Get.back();
          showSnackBarAlert(
            message: response.status!,
            color: Colors.red,
          );
        }
      } else {
        Get.back();
        showSnackBarAlert(
          message: "No Response!",
          color: Colors.red,
        );
      }
    } catch (e) {
      Get.back();
      showSnackBarAlert(
        message: e.toString(),
        color: Colors.red,
      );
    }
  }
}
