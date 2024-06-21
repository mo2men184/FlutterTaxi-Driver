import 'package:rugbydriver/model/driver_location_update.dart';
import 'package:dio/dio.dart';
import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/dash_board_controller.dart';
import 'package:rugbydriver/controller/ride_details_controller.dart';
import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/page/chats_screen/conversation_screen.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/themes/custom_alert_dialog.dart';
import 'package:rugbydriver/themes/custom_dialog_box.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:rugbydriver/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pinput/pinput.dart';

class RouteViewScreen extends StatefulWidget {
  const RouteViewScreen({Key? key}) : super(key: key);

  @override
  State<RouteViewScreen> createState() => _RouteViewScreenState();
}

class _RouteViewScreenState extends State<RouteViewScreen> {
  dynamic argumentData = Get.arguments;

  GoogleMapController? _mapcontroller;

  Map<PolylineId, Polyline> polyLines = {};

  PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;
  BitmapDescriptor? stopIcon;

  late LatLng departureLatLong;
  late LatLng destinationLatLong;

  final Map<String, Marker> _markers = {};

  String? type;
  RideData? rideData;
  double rotation = 0.0;
  String driverEstimateArrivalTime = '';

  @override
  void initState() {
    getArgumentData();
    setIcons();

    super.initState();
  }

  getArgumentData() async {
    if (argumentData != null) {
      type = argumentData['type'];
      rideData = argumentData['data'];

      departureLatLong = LatLng(
          double.parse(rideData!.latitudeDepart.toString()),
          double.parse(rideData!.longitudeDepart.toString()));
      destinationLatLong = LatLng(
          double.parse(rideData!.latitudeArrivee.toString()),
          double.parse(rideData!.longitudeArrivee.toString()));
      // await getDriver();

      if (rideData!.statut == "on ride" || rideData!.statut == 'confirmed') {
        Constant.driverLocationUpdate
            .doc(rideData!.idConducteur)
            .snapshots()
            .listen((event) async {
          DriverLocationUpdate driverLocationUpdate =
              DriverLocationUpdate.fromJson(
                  event.data() as Map<String, dynamic>);

          Dio dio = Dio();
          dynamic response = await dio.get(
              "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${rideData!.latitudeDepart},${rideData!.longitudeDepart}&destinations=${double.parse(driverLocationUpdate.driverLatitude.toString())},${double.parse(driverLocationUpdate.driverLongitude.toString())}&key=${Constant.kGoogleApiKey}");

          driverEstimateArrivalTime = response.data['rows'][0]['elements'][0]
                  ['duration']['text']
              .toString();

          setState(() {
            departureLatLong = LatLng(
                double.parse(driverLocationUpdate.driverLatitude.toString()),
                double.parse(driverLocationUpdate.driverLongitude.toString()));
            _markers[rideData!.id.toString()] = Marker(
                markerId: MarkerId(rideData!.id.toString()),
                infoWindow:
                    InfoWindow(title: rideData!.prenomConducteur.toString()),
                position: departureLatLong,
                icon: taxiIcon!,
                rotation:
                    double.parse(driverLocationUpdate.rotation.toString()));
            getDirections(
                dLat: double.parse(
                    driverLocationUpdate.driverLatitude.toString()),
                dLng: double.parse(
                    driverLocationUpdate.driverLongitude.toString()));
          });
        });
      } else {
        getDirections(dLat: 0.0, dLng: 0.0);
      }
    }
  }

  setIcons() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/icons/pickup.png")
        .then((value) {
      departureIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/icons/dropoff.png")
        .then((value) {
      destinationIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/images/ic_taxi.png")
        .then((value) {
      taxiIcon = value;
    });
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/icons/location.png")
        .then((value) {
      stopIcon = value;
    });
  }

  // getDriver() async {
  //   String orderId = (rideData!.idUserApp! < rideData!.idConducteur!)
  //       ? '${rideData!.idUserApp}-${rideData!.id}-${rideData!.idConducteur}'
  //       : '${rideData!.idConducteur}-${rideData!.id}-${rideData!.idUserApp}';
  //   Constant.location_update.doc(orderId).get().then((value) {
  //     dynamic driverData = value.data();

  //     driverLatLong = LatLng(
  //         double.parse(driverData['driver_latitude'].toString()),
  //         double.parse(driverData['driver_longitude'].toString()));

  //     rotation = driverData['rotation'];
  //     print('\x1b[92m --------> ${value.data()}');
  //   });
  //   // driverStream.listen((event) {
  //   //   print("--->${event.location.latitude} ${event.location.longitude}");
  //   //   setState(() => _driverModel = event);
  //   //   setState(() => MyAppState.currentUser = _driverModel);

  //   //   getDirections();
  //   //   if (_driverModel!.isActive) {
  //   //     if (_driverModel!.orderRequestData != null) {
  //   //       showDriverBottomSheet(_driverModel!);
  //   //       startTimer(_driverModel!);
  //   //     }
  //   //   }
  //   //   if (_driverModel!.inProgressOrderID != null) {
  //   //     getCurrentOrder();
  //   //   }
  //   // });
  // }

  final controllerRideDetails = Get.put(RideDetailsController());
  final controllerDashBoard = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(rideData!.latitudeDepart!),
                    double.parse(rideData!.longitudeDepart!)),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapcontroller = controller;
                _mapcontroller!.moveCamera(
                    CameraUpdate.newLatLngZoom(departureLatLong, 12));
              },
              polylines: Set<Polyline>.of(polyLines.values),
              myLocationEnabled: false,
              markers: _markers.values.toSet(),
            ),
            Positioned(
              top: 10,
              left: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12),
                        child: Column(
                          children: [
                            if (rideData!.statut == 'confirmed')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'estimate_reched_time_to_customer'.tr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      driverEstimateArrivalTime,
                                      style: TextStyle(
                                          color: ConstantColors.yellow,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Row(
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: [
                            //         Expanded(
                            //           child: Padding(
                            //             padding: const EdgeInsets.only(left: 5.0),
                            //             child: Container(
                            //               decoration: BoxDecoration(
                            //                   border: Border.all(
                            //                     color: Colors.black12,
                            //                   ),
                            //                   borderRadius: const BorderRadius.all(Radius.circular(10))),
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(vertical: 20),
                            //                 child: Column(
                            //                   children: [
                            //                     Image.asset(
                            //                       'assets/icons/passenger.png',
                            //                       height: 22,
                            //                       width: 22,
                            //                       color: ConstantColors.yellow,
                            //                     ),
                            //                     Padding(
                            //                       padding: const EdgeInsets.only(top: 8.0),
                            //                       child: Text(" ${rideData!.numberPoeple.toString()}",
                            //                           //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                            //                           style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54)),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //         Expanded(
                            //           child: Padding(
                            //             padding: const EdgeInsets.only(left: 5.0),
                            //             child: Container(
                            //               decoration: BoxDecoration(
                            //                   border: Border.all(
                            //                     color: Colors.black12,
                            //                   ),
                            //                   borderRadius: const BorderRadius.all(Radius.circular(10))),
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(vertical: 20),
                            //                 child: Column(
                            //                   children: [
                            //                     Text(
                            //                       Constant.currency.toString(),
                            //                       style: TextStyle(
                            //                         color: ConstantColors.yellow,
                            //                         fontWeight: FontWeight.bold,
                            //                         fontSize: 20,
                            //                       ),
                            //                     ),
                            //                     // Image.asset(
                            //                     //   'assets/icons/price.png',
                            //                     //   height: 22,
                            //                     //   width: 22,
                            //                     //   color: ConstantColors.yellow,
                            //                     // ),
                            //                     Text(
                            //                       Constant().amountShow(amount: rideData!.montant.toString()),
                            //                       style: const TextStyle(
                            //                         fontWeight: FontWeight.w800,
                            //                         color: Colors.black54,
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //         Expanded(
                            //           child: Padding(
                            //             padding: const EdgeInsets.only(left: 5.0),
                            //             child: Container(
                            //               decoration: BoxDecoration(
                            //                   border: Border.all(
                            //                     color: Colors.black12,
                            //                   ),
                            //                   borderRadius: const BorderRadius.all(Radius.circular(10))),
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(vertical: 20),
                            //                 child: Column(
                            //                   children: [
                            //                     Image.asset(
                            //                       'assets/icons/ic_distance.png',
                            //                       height: 22,
                            //                       width: 22,
                            //                       color: ConstantColors.yellow,
                            //                     ),
                            //                     Padding(
                            //                       padding: const EdgeInsets.only(top: 8.0),
                            //                       child: Text(
                            //                         "${double.parse(rideData!.distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${Constant.distanceUnit}",
                            //                         //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                            //                         style: const TextStyle(
                            //                           fontWeight: FontWeight.w800,
                            //                           color: Colors.black54,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //         Expanded(
                            //           child: Padding(
                            //             padding: const EdgeInsets.only(left: 5.0),
                            //             child: Container(
                            //               decoration: BoxDecoration(
                            //                   border: Border.all(
                            //                     color: Colors.black12,
                            //                   ),
                            //                   borderRadius: const BorderRadius.all(Radius.circular(10))),
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(vertical: 20),
                            //                 child: Column(
                            //                   children: [
                            //                     Image.asset(
                            //                       'assets/icons/time.png',
                            //                       height: 22,
                            //                       width: 22,
                            //                       color: ConstantColors.yellow,
                            //                     ),
                            //                     Padding(
                            //                       padding: const EdgeInsets.only(top: 8.0),
                            //                       child: TextScroll(rideData!.duree.toString(),
                            //                           mode: TextScrollMode.bouncing,
                            //                           pauseBetween: const Duration(seconds: 2),
                            //                           style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54)),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: rideData!.photoPath.toString(),
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        "assets/images/appIcon.png",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: rideData!.rideType! == 'driver' &&
                                              rideData!.existingUserId
                                                      .toString() ==
                                                  "null"
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${rideData!.userInfo!.name}',
                                                    style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                Text(
                                                    '${rideData!.userInfo!.email}',
                                                    style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${rideData!.prenom.toString()} ${rideData!.nom.toString()}',
                                                    style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                StarRating(
                                                    size: 18,
                                                    rating: double.parse(
                                                        rideData!.moyenneDriver
                                                            .toString()),
                                                    color:
                                                        ConstantColors.yellow),
                                              ],
                                            ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Visibility(
                                            visible: rideData!.statut ==
                                                        "confirmed" &&
                                                    rideData!.existingUserId
                                                            .toString() !=
                                                        "null"
                                                ? true
                                                : false,
                                            child: InkWell(
                                                onTap: () {
                                                  Get.to(ConversationScreen(),
                                                      arguments: {
                                                        'receiverId': int.parse(
                                                            rideData!.idUserApp
                                                                .toString()),
                                                        'orderId': int.parse(
                                                            rideData!.id
                                                                .toString()),
                                                        'receiverName':
                                                            '${rideData!.prenom} ${rideData!.nom}',
                                                        'receiverPhoto':
                                                            rideData!.photoPath
                                                      });
                                                },
                                                child: Image.asset(
                                                  'assets/icons/chat_icon.png',
                                                  height: 36,
                                                  width: 36,
                                                )),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: InkWell(
                                                onTap: () {
                                                  if (rideData!.existingUserId
                                                          .toString() !=
                                                      "null") {
                                                    Constant.makePhoneCall(
                                                        rideData!.phone
                                                            .toString());
                                                  } else {
                                                    Constant.makePhoneCall(
                                                        rideData!
                                                            .userInfo!.phone
                                                            .toString());
                                                  }
                                                },
                                                child: Image.asset(
                                                  'assets/icons/call_icon.png',
                                                  height: 36,
                                                  width: 36,
                                                )),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                            rideData!.dateRetour.toString(),
                                            style: const TextStyle(
                                                color: Colors.black26,
                                                fontWeight: FontWeight.w600)),
                                      ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Visibility(
                          visible: rideData!.statut == "new" ||
                                  rideData!.statut == "confirmed"
                              ? true
                              : false,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'REJECT'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: Colors.white,
                                txtColor: Colors.black.withOpacity(0.60),
                                btnBorderColor: Colors.black.withOpacity(0.20),
                                onPress: () async {
                                  buildShowBottomSheet(context);
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: rideData!.statut == "new" ? true : false,
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'ACCEPT'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.black,
                                onPress: () async {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title:
                                            "Do you want to confirm this booking?"
                                                .tr,
                                        onPressNegative: () {
                                          Get.back();
                                        },
                                        negativeButtonText: 'No'.tr,
                                        positiveButtonText: 'Yes'.tr,
                                        onPressPositive: () {
                                          Map<String, String> bodyParams = {
                                            'id_ride': rideData!.id.toString(),
                                            'id_user':
                                                rideData!.idUserApp.toString(),
                                            'driver_name':
                                                '${rideData!.prenomConducteur.toString()} ${rideData!.nomConducteur.toString()}',
                                            'lat_conducteur': rideData!
                                                .latitudeDepart
                                                .toString(),
                                            'lng_conducteur': rideData!
                                                .longitudeDepart
                                                .toString(),
                                            'lat_client': rideData!
                                                .latitudeArrivee
                                                .toString(),
                                            'lng_client': rideData!
                                                .longitudeArrivee
                                                .toString(),
                                            'from_id': Preferences.getInt(
                                                    Preferences.userId)
                                                .toString(),
                                          };

                                          controllerRideDetails
                                              .confirmedRide(bodyParams)
                                              .then((value) {
                                            if (value != null) {
                                              rideData!.statut = "confirmed";
                                              Get.back();
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomDialogBox(
                                                      title:
                                                          "Confirmed Successfully"
                                                              .tr,
                                                      descriptions:
                                                          "Ride Successfully confirmed."
                                                              .tr,
                                                      text: "Ok".tr,
                                                      onPress: () {
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      img: Image.asset(
                                                          'assets/images/green_checked.png'),
                                                    );
                                                  });
                                            }
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              rideData!.statut == "confirmed" ? true : false,
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'on_ride'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.black,
                                onPress: () async {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title:
                                            "Do you want to on ride this ride?"
                                                .tr,
                                        negativeButtonText: 'No'.tr,
                                        positiveButtonText: 'Yes'.tr,
                                        onPressNegative: () {
                                          Get.back();
                                        },
                                        onPressPositive: () {
                                          Get.back();
                                          if (Constant.rideOtp.toString() !=
                                              'yes') {
                                            Map<String, String> bodyParams = {
                                              'id_ride':
                                                  rideData!.id.toString(),
                                              'id_user': rideData!.idUserApp
                                                  .toString(),
                                              'use_name':
                                                  '${rideData!.prenomConducteur.toString()} ${rideData!.nomConducteur.toString()}',
                                              'from_id': Preferences.getInt(
                                                      Preferences.userId)
                                                  .toString(),
                                            };
                                            controllerRideDetails
                                                .setOnRideRequest(bodyParams)
                                                .then((value) {
                                              if (value != null) {
                                                Get.back();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title:
                                                            "On ride Successfully"
                                                                .tr,
                                                        descriptions:
                                                            "Ride Successfully On ride."
                                                                .tr,
                                                        text: "Ok".tr,
                                                        onPress: () {
                                                          Get.back();
                                                          Get.back();
                                                        },
                                                        img: Image.asset(
                                                            'assets/images/green_checked.png'),
                                                      );
                                                    });
                                              }
                                            });
                                          } else {
                                            controllerRideDetails
                                                    .otpController =
                                                TextEditingController();
                                            showDialog(
                                              barrierColor: Colors.black26,
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Container(
                                                    height: 200,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            top: 20,
                                                            right: 10,
                                                            bottom: 20),
                                                    decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.black,
                                                              offset:
                                                                  Offset(0, 10),
                                                              blurRadius: 10),
                                                        ]),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Enter OTP".tr,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.60)),
                                                        ),
                                                        Pinput(
                                                          controller:
                                                              controllerRideDetails
                                                                  .otpController,
                                                          defaultPinTheme:
                                                              PinTheme(
                                                            height: 50,
                                                            width: 50,
                                                            textStyle: const TextStyle(
                                                                letterSpacing:
                                                                    0.60,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            // margin: EdgeInsets.all(10),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: ConstantColors
                                                                      .textFieldBoarderColor,
                                                                  width: 0.7),
                                                            ),
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .phone,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          length: 6,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: ButtonThem
                                                                  .buildButton(
                                                                context,
                                                                title:
                                                                    'done'.tr,
                                                                btnHeight: 45,
                                                                btnWidthRatio:
                                                                    0.8,
                                                                btnColor:
                                                                    ConstantColors
                                                                        .primary,
                                                                txtColor: Colors
                                                                    .white,
                                                                onPress: () {
                                                                  if (controllerRideDetails
                                                                          .otpController
                                                                          .text
                                                                          .toString()
                                                                          .length ==
                                                                      6) {
                                                                    controllerRideDetails
                                                                        .verifyOTP(
                                                                      userId: rideData!
                                                                          .idUserApp!
                                                                          .toString(),
                                                                      rideId: rideData!
                                                                          .id!
                                                                          .toString(),
                                                                    )
                                                                        .then(
                                                                            (value) {
                                                                      if (value !=
                                                                              null &&
                                                                          value['success'] ==
                                                                              "success") {
                                                                        Map<String,
                                                                                String>
                                                                            bodyParams =
                                                                            {
                                                                          'id_ride': rideData!
                                                                              .id
                                                                              .toString(),
                                                                          'id_user': rideData!
                                                                              .idUserApp
                                                                              .toString(),
                                                                          'use_name':
                                                                              '${rideData!.prenomConducteur.toString()} ${rideData!.nomConducteur.toString()}',
                                                                          'from_id':
                                                                              Preferences.getInt(Preferences.userId).toString(),
                                                                        };
                                                                        controllerRideDetails
                                                                            .setOnRideRequest(bodyParams)
                                                                            .then((value) {
                                                                          if (value !=
                                                                              null) {
                                                                            Get.back();
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return CustomDialogBox(
                                                                                    title: "On ride Successfully".tr,
                                                                                    descriptions: "Ride Successfully On ride.".tr,
                                                                                    text: "Ok".tr,
                                                                                    onPress: () {
                                                                                      Get.back();
                                                                                      Get.back();
                                                                                    },
                                                                                    img: Image.asset('assets/images/green_checked.png'),
                                                                                  );
                                                                                });
                                                                          }
                                                                        });
                                                                      }
                                                                    });
                                                                  } else {
                                                                    ShowToastDialog.showToast(
                                                                        'Please Enter OTP'
                                                                            .tr);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Expanded(
                                                              child: ButtonThem
                                                                  .buildBorderButton(
                                                                context,
                                                                title:
                                                                    'cancel'.tr,
                                                                btnHeight: 45,
                                                                btnWidthRatio:
                                                                    0.8,
                                                                btnColor: Colors
                                                                    .white,
                                                                txtColor: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.60),
                                                                btnBorderColor: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.20),
                                                                onPress: () {
                                                                  Get.back();
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          // if (rideData!.carDriverConfirmed == 1) {
                                          //
                                          // } else if (rideData!.carDriverConfirmed == 2) {
                                          //   Get.back();
                                          //   ShowToastDialog.showToast("Customer decline the confirmation of driver and car information.");
                                          // } else if (rideData!.carDriverConfirmed == 0) {
                                          //   Get.back();
                                          //   ShowToastDialog.showToast("Customer needs to verify driver and car before you can start trip.");
                                          // }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: rideData!.statut == "on ride" ? true : false,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'START RIDE'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: Colors.white,
                                txtColor: Colors.black.withOpacity(0.60),
                                btnBorderColor: Colors.black.withOpacity(0.20),
                                onPress: () async {
                                  MapsLauncher.launchCoordinates(
                                      double.parse(
                                          rideData!.latitudeArrivee.toString()),
                                      double.parse(rideData!.longitudeArrivee
                                          .toString()));
                                  // Constant.launchMapURl(
                                  //     rideData!.latitudeArrivee,
                                  //     rideData!.longitudeArrivee);
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: rideData!.statut == "on ride" ? true : false,
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'COMPLETE'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.black,
                                onPress: () async {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title:
                                            "Do you want to complete this ride?"
                                                .tr,
                                        onPressNegative: () {
                                          Get.back();
                                        },
                                        negativeButtonText: 'No'.tr,
                                        positiveButtonText: 'Yes'.tr,
                                        onPressPositive: () {
                                          Map<String, String> bodyParams = {
                                            'id_ride': rideData!.id.toString(),
                                            'id_user':
                                                rideData!.idUserApp.toString(),
                                            'driver_name':
                                                '${rideData!.prenomConducteur.toString()} ${rideData!.nomConducteur.toString()}',
                                            'from_id': Preferences.getInt(
                                                    Preferences.userId)
                                                .toString(),
                                          };
                                          controllerRideDetails
                                              .setCompletedRequest(
                                                  bodyParams, rideData!)
                                              .then((value) {
                                            if (value != null) {
                                              Get.back();
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomDialogBox(
                                                      title:
                                                          "Completed Successfully"
                                                              .tr,
                                                      descriptions:
                                                          "Ride Successfully completed."
                                                              .tr,
                                                      text: "Ok".tr,
                                                      onPress: () {
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      img: Image.asset(
                                                          'assets/images/green_checked.png'),
                                                    );
                                                  });
                                            }
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  final resonController = TextEditingController();

  buildShowBottomSheet(BuildContext context) {
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
                      child: Text(
                        "Cancel Trip".tr,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Write a reason for trip cancellation".tr,
                        style: TextStyle(color: Colors.black.withOpacity(0.50)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: resonController,
                        keyboardType: TextInputType.text,
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'Cancel Trip'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white,
                                onPress: () async {
                                  if (resonController.text.isNotEmpty) {
                                    Get.back();
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title:
                                              "Do you want to reject this booking?"
                                                  .tr,
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          negativeButtonText: 'No'.tr,
                                          positiveButtonText: 'Yes'.tr,
                                          onPressPositive: () {
                                            Map<String, String> bodyParams = {
                                              'id_ride':
                                                  rideData!.id.toString(),
                                              'id_user': rideData!.idUserApp
                                                  .toString(),
                                              'name':
                                                  '${rideData!.prenomConducteur.toString()} ${rideData!.nomConducteur.toString()}',
                                              'from_id': Preferences.getInt(
                                                      Preferences.userId)
                                                  .toString(),
                                              'user_cat': controllerRideDetails
                                                  .userModel!.userData!.userCat
                                                  .toString(),
                                              'reason': resonController.text
                                                  .toString(),
                                            };
                                            controllerRideDetails
                                                .canceledRide(bodyParams)
                                                .then((value) {
                                              Get.back();
                                              if (value != null) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title:
                                                            "Reject Successfully"
                                                                .tr,
                                                        descriptions:
                                                            "Ride Successfully rejected."
                                                                .tr,
                                                        text: "Ok".tr,
                                                        onPress: () {
                                                          Get.back();
                                                          Get.back();
                                                        },
                                                        img: Image.asset(
                                                            'assets/images/green_checked.png'),
                                                      );
                                                    });
                                              }
                                            });
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please enter a reason".tr);
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Close'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: Colors.white,
                                txtColor: ConstantColors.primary,
                                btnBorderColor: ConstantColors.primary,
                                onPress: () async {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  getDirections({required double dLat, required double dLng}) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result;
    List<PolylineWayPoint> wayPointList = [];
    for (var i = 0; i < rideData!.stops!.length; i++) {
      wayPointList
          .add(PolylineWayPoint(location: rideData!.stops![i].location!));
    }
    if (rideData!.statut == "confirmed") {
      result = await polylinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleApiKey.toString(),
        PointLatLng(dLat, dLng),
        PointLatLng(double.parse(rideData!.latitudeDepart.toString()),
            double.parse(rideData!.longitudeDepart.toString())),
        wayPoints: wayPointList,
        optimizeWaypoints: true,
        travelMode: TravelMode.driving,
      );
    } else if (rideData!.statut == "on ride") {
      result = await polylinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleApiKey.toString(),
        PointLatLng(dLat, dLng),
        PointLatLng(destinationLatLong.latitude, destinationLatLong.longitude),
        wayPoints: wayPointList,
        optimizeWaypoints: true,
        travelMode: TravelMode.driving,
      );
    } else {
      result = await polylinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleApiKey.toString(),
        PointLatLng(departureLatLong.latitude, departureLatLong.longitude),
        PointLatLng(destinationLatLong.latitude, destinationLatLong.longitude),
        wayPoints: wayPointList,
        optimizeWaypoints: true,
        travelMode: TravelMode.driving,
      );
    }

    _markers['Departure'] = Marker(
      markerId: const MarkerId('Departure'),
      infoWindow: const InfoWindow(title: "Departure"),
      position: LatLng(double.parse(rideData!.latitudeDepart.toString()),
          double.parse(rideData!.longitudeDepart.toString())),
      icon: departureIcon!,
    );

    _markers['Destination'] = Marker(
      markerId: const MarkerId('Destination'),
      infoWindow: const InfoWindow(title: "Destination"),
      position: destinationLatLong,
      icon: destinationIcon!,
    );

    for (var i = 0; i < rideData!.stops!.length; i++) {
      _markers['${rideData!.stops![i]}'] = Marker(
        markerId: MarkerId('${rideData!.stops![i]}'),
        infoWindow: InfoWindow(title: rideData!.stops![i].location!),
        position: LatLng(double.parse(rideData!.stops![i].latitude!),
            double.parse(rideData!.stops![i].longitude!)),
        icon: stopIcon!,
      );
    }
    print('===${result.points}');
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    print('===${polylineCoordinates}');

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: ConstantColors.primary,
      points: polylineCoordinates,
      width: 4,
      geodesic: true,
    );
    polyLines[id] = polyline;
    updateCameraLocation(polylineCoordinates.first, _mapcontroller);

    setState(() {});
  }

  Future<void> updateCameraLocation(
    LatLng source,
    GoogleMapController? mapController,
  ) async {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: source,
          zoom: rideData!.statut == "on ride" || rideData!.statut == "confirmed"
              ? 20
              : 16,
        ),
      ),
    );
  }
}
