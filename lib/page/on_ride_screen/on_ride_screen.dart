import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/controller/on_ride_controller.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/page/route_view_screen/route_view_screen.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

class OnRideScreen extends StatelessWidget {
  const OnRideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<OnRideController>(
      init: OnRideController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => controller.getOnRideList(),
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
                              return onRideWidgets(context,
                                  controller.rideList[index], controller);
                            }),
              ),
            ));
      },
    );
  }

  Widget onRideWidgets(
      BuildContext context, RideData data, OnRideController controller) {
    return InkWell(
      onTap: () {
        var argumentData = {'type': 'on_ride'.tr, 'data': data};
        Get.to(const RouteViewScreen(), arguments: argumentData);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          "assets/icons/location.png",
                          height: 20,
                        ),
                        Image.asset(
                          "assets/icons/line.png",
                          height: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        data.departName.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.stops!.length,
                    itemBuilder: (context, int index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                String.fromCharCode(index + 65),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Image.asset(
                                "assets/icons/line.png",
                                height: 30,
                                color: ConstantColors.hintTextColor,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.stops![index].location.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/icons/round.png",
                      height: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        data.destinationName.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Image.asset(
                //       "assets/icons/ic_pic_drop_location.png",
                //       height: 60,
                //     ),
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               data.departName.toString(),
                //               maxLines: 2,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //             const Divider(),
                //             Text(
                //               data.destinationName.toString(),
                //               maxLines: 2,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     Text(
                //       'on_ride'.tr,
                //       style: TextStyle(color: ConstantColors.blue),
                //     )
                //   ],
                // ),

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
                                      Constant().amountShow(
                                          amount: data.montant.toString()),
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
                              Text(
                                  '${data.prenom.toString()} ${data.nom.toString()}',
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
                              backgroundColor: Colors.orange,
                              shape: const CircleBorder(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
