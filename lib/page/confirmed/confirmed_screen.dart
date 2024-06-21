import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/controller/confirmed_controller.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/page/chats_screen/conversation_screen.dart';
import 'package:rugbydriver/page/route_view_screen/route_view_screen.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

class ConfirmedScreen extends StatelessWidget {
  const ConfirmedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ConfirmedController>(
      init: ConfirmedController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => controller.getConformRideList(),
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
                              return confirmedRideWidgets(context,
                                  controller.rideList[index], controller);
                            }),
              ),
            ));
      },
    );
  }

  Widget confirmedRideWidgets(
      BuildContext context, RideData data, ConfirmedController controller) {
    return InkWell(
      onTap: () async {
        var argumentData = {'type': 'confirmed'.tr, 'data': data};
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
                            Text(
                              data.departName.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Divider(),
                            Text(
                              data.destinationName.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'confirmed'.tr,
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
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Get.to(ConversationScreen(), arguments: {
                                  'receiverId':
                                      int.parse(data.idUserApp.toString()),
                                  'orderId': int.parse(data.id.toString()),
                                  'receiverName': '${data.prenom} ${data.nom}',
                                  'receiverPhoto': data.photoPath
                                });
                              },
                              child: Image.asset(
                                'assets/icons/chat_icon.png',
                                height: 36,
                                width: 36,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: InkWell(
                                onTap: () {
                                  Constant.makePhoneCall(data.phone.toString());
                                },
                                child: Image.asset(
                                  'assets/icons/call_icon.png',
                                  height: 36,
                                  width: 36,
                                )),
                          ),
                        ],
                      ),
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
