import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/controller/completed_controller.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/page/complaint/add_complaint_screen.dart';
import 'package:rugbydriver/page/review_screens/add_review_screen.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CompletedController>(
      init: CompletedController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => controller.getCompletedRide(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: controller.isLoading.value
                    ? Constant.loader()
                    : controller.rideList.isEmpty
                        ? Constant.emptyView("Your don't have any ride booked.")
                        : ListView.builder(
                            itemCount: controller.rideList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return completedRideWidgets(context,
                                  controller.rideList[index], controller);
                            }),
              ),
            ));
      },
    );
  }

  Widget completedRideWidgets(
      BuildContext context, RideData data, CompletedController controller) {
    return InkWell(
      onTap: () async {
        // bool isDone = await Get.to(TripHistoryScreen(data: data), arguments: {
        //   "rideData": data,
        // });
        // if (isDone == true) {
        //   controller.getCompletedRide();
        // }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/ic_pic_drop_location.png",
                      height: 60,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.departName.toString()),
                            const Divider(),
                            Text(data.destinationName.toString()),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'completed'.tr,
                      style: TextStyle(color: ConstantColors.blue),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/passenger.png',
                                      height: 22,
                                      width: 22,
                                      color: ConstantColors.yellow,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          " ${data.numberPoeple.toString()}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      Constant.currency.toString(),
                                      style: TextStyle(
                                        color: ConstantColors.yellow,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    // Image.asset(
                                    //   'assets/icons/price.png',
                                    //   height: 22,
                                    //   width: 22,
                                    //   color: ConstantColors.yellow,
                                    // ),
                                    Text(
                                      Constant()
                                          .amountShow(amount: data.montant),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/ic_distance.png',
                                      height: 22,
                                      width: 22,
                                      color: ConstantColors.yellow,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          "${double.parse(data.distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${Constant.distanceUnit}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/time.png',
                                      height: 22,
                                      width: 22,
                                      color: ConstantColors.yellow,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: TextScroll(data.duree.toString(),
                                          mode: TextScrollMode.bouncing,
                                          pauseBetween:
                                              const Duration(seconds: 2),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: data.photoPath.toString(),
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${data.prenom} ${data.nom}',
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600)),
                              StarRating(
                                  size: 18,
                                  rating: double.parse(
                                      data.moyenneDriver.toString()),
                                  color: ConstantColors.yellow),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Constant.makePhoneCall(data.phone.toString());
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              shape: const CircleBorder(),
                              backgroundColor: Colors.orange,
                              padding:
                                  const EdgeInsets.all(6), // <-- Splash color
                            ),
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          Text(data.dateRetour.toString(),
                              style: const TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: ButtonThem.buildButton(context,
                              btnHeight: 40,
                              title: data.statutPaiement == "yes"
                                  ? "Paid"
                                  : "Not paid",
                              btnColor: data.statutPaiement == "yes"
                                  ? Colors.green
                                  : ConstantColors.primary,
                              txtColor: Colors.white, onPress: () {
                        // if (data.payment == "Cash") {
                        //   controller.conformPaymentByCache(data.id.toString()).then((value) {
                        //     if (value != null) {
                        //       showDialog(
                        //           context: context,
                        //           builder: (BuildContext context) {
                        //             return CustomDialogBox(
                        //               title: "Payment by cash",
                        //               descriptions: "Payment collected successfully",
                        //               text: "Ok",
                        //               onPress: () {
                        //                 Get.back();
                        //                 controller.getCompletedRide();
                        //               },
                        //               img: Image.asset('assets/images/green_checked.png'),
                        //             );
                        //           });
                        //     }
                        //   });
                        // } else {}
                      })),
                      Visibility(
                        visible: data.statutPaiement == "yes",
                        child: Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Add Review'.tr,
                                btnWidthRatio: 0.8,
                                btnHeight: 40,
                                btnColor: Colors.white,
                                txtColor: ConstantColors.primary,
                                btnBorderColor: ConstantColors.primary,
                                onPress: () async {
                                  Get.to(const AddReviewScreen(), arguments: {
                                    'rideData': data,
                                  });
                                },
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: data.statutPaiement == "yes",
                  child: ButtonThem.buildBorderButton(
                    context,
                    title: 'Add Complaint'.tr,
                    btnHeight: 40,
                    btnColor: Colors.white,
                    txtColor: ConstantColors.primary,
                    btnBorderColor: ConstantColors.primary,
                    onPress: () async {
                      Get.to(AddComplaintScreen(), arguments: {
                        'rideData': data,
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
