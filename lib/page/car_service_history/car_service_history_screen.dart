import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/controller/car_service_history_controller.dart';
import 'package:rugbydriver/model/car_service_book_model.dart';
import 'package:rugbydriver/page/car_service_history/show_service_doc_screen.dart';
import 'package:rugbydriver/page/car_service_history/upload_car_service_book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/constant_colors.dart';

class CarServiceBookHistory extends StatelessWidget {
  const CarServiceBookHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CarServiceHistoryController>(
        init: CarServiceHistoryController(),
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () => controller.getCarServiceBooks(),
            child: Scaffold(
              backgroundColor: ConstantColors.background,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.to(() => const AddCarServiceBookHistory());
                },
                backgroundColor: ConstantColors.yellow,
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : controller.serviceList.isEmpty
                      ? Center(
                          child:
                              Text('No car service history not available'.tr))
                      : ListView.builder(
                          itemCount: controller.serviceList.length,
                          itemBuilder: (context, index) {
                            return showServiceBookDetails(
                                serviceData: controller.serviceList[index]);
                          }),
            ),
          );
        });
  }

  showServiceBookDetails({required ServiceData serviceData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: GestureDetector(
        onTap: () => Get.to(() => ShowServiceDocScreen(
              serviceData: serviceData,
            )),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(
                  2.0,
                  3.0,
                ),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              ), //BoxShadow
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ), //BoxShadow
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.0),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          serviceData.modifier.toString(),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(
                              Icons.speed,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            serviceData.km.toString() + "KM".tr,
                            style: TextStyle(color: ConstantColors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: ConstantColors.blue,
                              borderRadius: BorderRadius.circular(1)),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.file_copy_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    Text(
                      serviceData.fileName.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
