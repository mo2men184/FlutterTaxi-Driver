import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/controller/withdrawals_controller.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawalsScreen extends StatelessWidget {
  const WithdrawalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WithdrawalsController>(
      init: WithdrawalsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: AppBar(
            backgroundColor: ConstantColors.background,
            elevation: 0,
            leading: Padding(
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
                          blurRadius: 2,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                      ),
                    )),
              ),
            ),
            title: Text(
              "Withdrawals History".tr,
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.getWithdrawals(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: controller.isLoading.value
                        ? Constant.loader()
                        : controller.rideList.isEmpty
                            ? Constant.emptyView(
                                "Your don't have any Withdrawals request".tr)
                            : ListView.builder(
                                itemCount: controller.rideList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 2,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/icons/walltet_icons.png',
                                              width: 52,
                                              height: 52,
                                            ),
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          controller
                                                              .rideList[index]
                                                              .creer
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.80),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Text(
                                                        Constant().amountShow(
                                                            amount: controller
                                                                .rideList[index]
                                                                .amount
                                                                .toString()),
                                                        style: TextStyle(
                                                            color: controller
                                                                        .rideList[
                                                                            index]
                                                                        .statut
                                                                        .toString() ==
                                                                    "success"
                                                                ? Colors.green
                                                                : Colors.red,
                                                            fontSize: 16,
                                                            letterSpacing: 1.5,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    controller
                                                        .rideList[index].statut
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: controller
                                                                    .rideList[
                                                                        index]
                                                                    .statut
                                                                    .toString() ==
                                                                "success"
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontSize: 16,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 3.0),
                                                    child: Divider(
                                                      color: Colors.black
                                                          .withOpacity(0.40),
                                                    ),
                                                  ),
                                                  Text(
                                                    controller.rideList[index]
                                                        .bankName
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.80),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    controller.rideList[index]
                                                        .accountNo
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: ConstantColors
                                                            .subTitleTextColor,
                                                        fontSize: 16,
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 3.0),
                                                    child: Divider(
                                                      color: Colors.black
                                                          .withOpacity(0.40),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Note".tr.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.80),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    controller
                                                        .rideList[index].note
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: ConstantColors
                                                            .subTitleTextColor,
                                                        fontSize: 16,
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
