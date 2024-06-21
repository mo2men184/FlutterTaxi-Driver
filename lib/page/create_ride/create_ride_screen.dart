import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/create_ride_controller.dart';
import 'package:rugbydriver/model/customer_model.dart';
import 'package:rugbydriver/model/tax_model.dart';
import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:rugbydriver/themes/custom_dialog_box.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as get_cord_address;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({Key? key}) : super(key: key);

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final CameraPosition _kInitialPosition = const CameraPosition(
      target: LatLng(20.9153, -100.7439), zoom: 11.0, tilt: 0, bearing: 0);

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final controller = Get.put(CreateRideController());
  final myKey = GlobalKey<DropdownSearchState<CustomerData>>();
  GoogleMapController? _controller;
  final Location currentLocation = Location();

  final Map<String, Marker> _markers = {};

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;
  BitmapDescriptor? stopIcon;

  LatLng? departureLatLong;
  LatLng? destinationLatLong;

  Map<PolylineId, Polyline> polyLines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    setIcons();
    getCurrentLocation(true);
    super.initState();
  }

  setIcons() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/pickup.png")
        .then((value) {
      departureIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/dropoff.png")
        .then((value) {
      destinationIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/ic_taxi.png")
        .then((value) {
      taxiIcon = value;
    });
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/location.png")
        .then((value) {
      stopIcon = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCurrentLocation(bool isDepartureSet) async {
    if (isDepartureSet) {
      LocationData location = await currentLocation.getLocation();
      List<get_cord_address.Placemark> placeMarks =
          await get_cord_address.placemarkFromCoordinates(
              location.latitude ?? 0.0, location.longitude ?? 0.0);

      final address = (placeMarks.first.subLocality!.isEmpty
              ? ''
              : "${placeMarks.first.subLocality}, ") +
          (placeMarks.first.street!.isEmpty
              ? ''
              : "${placeMarks.first.street}, ") +
          (placeMarks.first.name!.isEmpty ? '' : "${placeMarks.first.name}, ") +
          (placeMarks.first.subAdministrativeArea!.isEmpty
              ? ''
              : "${placeMarks.first.subAdministrativeArea}, ") +
          (placeMarks.first.administrativeArea!.isEmpty
              ? ''
              : "${placeMarks.first.administrativeArea}, ") +
          (placeMarks.first.country!.isEmpty
              ? ''
              : "${placeMarks.first.country}, ") +
          (placeMarks.first.postalCode!.isEmpty
              ? ''
              : "${placeMarks.first.postalCode}, ");
      departureController.text = address;
      setState(() {
        setDepartureMarker(
            LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Get.to(PaymentSelectionScreen());
      //   },
      // ),
      backgroundColor: ConstantColors.background,
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
            padding: const EdgeInsets.only(
              top: 18.0,
            ),
            initialCameraPosition: _kInitialPosition,
            onMapCreated: (GoogleMapController controller) async {
              _controller = controller;
              LocationData location = await currentLocation.getLocation();
              _controller!.moveCamera(CameraUpdate.newLatLngZoom(
                  LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
                  14));
            },
            polylines: Set<Polyline>.of(polyLines.values),
            myLocationEnabled: true,
            markers: _markers.values.toSet(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.fromLTRB(12, 2, 2, 2),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ConstantColors.titleTextColor,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Column(
                      children: [
                        Builder(builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 00),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/location.png",
                                  height: 25,
                                  width: 25,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      await controller
                                          .placeSelectAPI(context)
                                          .then((value) {
                                        if (value != null) {
                                          departureController.text = value
                                              .result.formattedAddress
                                              .toString();
                                          setDepartureMarker(LatLng(
                                              value.result.geometry!.location
                                                  .lat,
                                              value.result.geometry!.location
                                                  .lng));
                                        }
                                      });
                                    },
                                    child: buildTextField(
                                      title: "Departure".tr,
                                      textController: departureController,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    getCurrentLocation(true);
                                  },
                                  autofocus: false,
                                  icon: const Icon(
                                    Icons.my_location_outlined,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        ReorderableListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            for (int index = 0;
                                index < controller.multiStopListNew.length;
                                index += 1)
                              Container(
                                key: ValueKey(
                                    controller.multiStopListNew[index]),
                                child: Column(
                                  children: [
                                    const Divider(),
                                    InkWell(
                                        onTap: () async {
                                          await controller
                                              .placeSelectAPI(context)
                                              .then((value) {
                                            if (value != null) {
                                              controller.multiStopListNew[index]
                                                      .editingController.text =
                                                  value.result.formattedAddress
                                                      .toString();
                                              controller.multiStopListNew[index]
                                                      .latitude =
                                                  value.result.geometry!
                                                      .location.lat
                                                      .toString();
                                              controller.multiStopListNew[index]
                                                      .longitude =
                                                  value.result.geometry!
                                                      .location.lng
                                                      .toString();
                                              setStopMarker(
                                                  LatLng(
                                                      value.result.geometry!
                                                          .location.lat,
                                                      value.result.geometry!
                                                          .location.lng),
                                                  index);
                                            }
                                          });
                                        },
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                String.fromCharCode(index + 65),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: ConstantColors
                                                        .hintTextColor),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: buildTextField(
                                                  title:
                                                      "Where do you want to stop ?"
                                                          .tr,
                                                  textController: controller
                                                      .multiStopListNew[index]
                                                      .editingController,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  controller.removeStops(index);
                                                  _markers
                                                      .remove("Stop $index");
                                                  getDirections();
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  size: 25,
                                                  color: ConstantColors
                                                      .hintTextColor,
                                                ),
                                              )
                                            ])),
                                  ],
                                ),
                              ),
                          ],
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final AddStopModel item = controller
                                  .multiStopListNew
                                  .removeAt(oldIndex);
                              controller.multiStopListNew
                                  .insert(newIndex, item);
                            });
                          },
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/dropoff.png",
                              height: 25,
                              width: 25,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await controller
                                      .placeSelectAPI(context)
                                      .then((value) {
                                    if (value != null) {
                                      destinationController.text = value
                                          .result.formattedAddress
                                          .toString();
                                      setDestinationMarker(LatLng(
                                          value.result.geometry!.location.lat,
                                          value.result.geometry!.location.lng));
                                    }
                                  });
                                },
                                child: buildTextField(
                                  title: "Where do you want to stop ?".tr,
                                  textController: destinationController,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        InkWell(
                          onTap: () {
                            controller.addStops();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: ConstantColors.hintTextColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Add stop'.tr,
                                style: TextStyle(
                                    color: ConstantColors.hintTextColor,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  setDepartureMarker(LatLng departure) {
    setState(() {
      _markers.remove("Departure");
      _markers['Departure'] = Marker(
        markerId: const MarkerId('Departure'),
        infoWindow: const InfoWindow(title: "Departure"),
        position: departure,
        icon: departureIcon!,
      );
      departureLatLong = departure;
      _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(departure.latitude, departure.longitude), zoom: 14)));

      // _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(departure.latitude, departure.longitude), zoom: 18)));
      if (departureLatLong != null && destinationLatLong != null) {
        getDirections();
        conformationBottomSheet(context);
      }
    });
  }

  setDestinationMarker(LatLng destination) {
    setState(() {
      _markers['Destination'] = Marker(
        markerId: const MarkerId('Destination'),
        infoWindow: const InfoWindow(title: "Destination"),
        position: destination,
        icon: destinationIcon!,
      );
      destinationLatLong = destination;

      if (departureLatLong != null && destinationLatLong != null) {
        getDirections();
        conformationBottomSheet(context);
      }
    });
  }

  setStopMarker(LatLng destination, int index) {
    setState(() {
      _markers['Stop $index'] = Marker(
        markerId: MarkerId('Stop $index'),
        infoWindow:
            InfoWindow(title: "Stop ${String.fromCharCode(index + 65)}"),
        position: destination,
        icon: stopIcon!,
      ); //BitmapDescriptor.fromBytes(unit8List));
      // destinationLatLong = destination;

      if (departureLatLong != null && destinationLatLong != null) {
        getDirections();
        conformationBottomSheet(context);
      }
    });
  }

  Widget buildTextField(
      {required title, required TextEditingController textController}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextField(
        controller: textController,
        textInputAction: TextInputAction.done,
        style: TextStyle(color: ConstantColors.titleTextColor),
        decoration: InputDecoration(
          hintText: title,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabled: false,
        ),
      ),
    );
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constant.kGoogleApiKey.toString(),
      PointLatLng(departureLatLong!.latitude, departureLatLong!.longitude),
      PointLatLng(destinationLatLong!.latitude, destinationLatLong!.longitude),
      optimizeWaypoints: true,
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

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
    setState(() {});
  }

  conformationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ButtonThem.buildIconButton(context,
                        icon: Icons.arrow_back_ios,
                        iconColor: Colors.black,
                        btnHeight: 40,
                        btnWidthRatio: 0.25,
                        title: "Back".tr,
                        btnColor: ConstantColors.yellow,
                        txtColor: Colors.black, onPress: () {
                      Get.back();
                    }),
                  ),
                  Expanded(
                    child: ButtonThem.buildButton(context,
                        btnHeight: 40,
                        title: "Continue".tr,
                        btnColor: ConstantColors.primary,
                        txtColor: Colors.white, onPress: () async {
                      controller.checkBalance().then((value) {
                        if (value == true) {
                          controller.getDriverDetails().then((value) async {
                            if (value != null) {
                              await controller
                                  .getDurationDistance(
                                      departureLatLong!, destinationLatLong!)
                                  .then((durationValue) async {
                                if (durationValue != null) {
                                  if (Constant.distanceUnit == "KM") {
                                    controller.distance.value =
                                        durationValue['rows']
                                                .first['elements']
                                                .first['distance']['value'] /
                                            1000.00;
                                  } else {
                                    controller.distance.value =
                                        durationValue['rows']
                                                .first['elements']
                                                .first['distance']['value'] /
                                            1609.34;
                                  }

                                  controller.duration.value =
                                      durationValue['rows']
                                          .first['elements']
                                          .first['duration']['text'];
                                  Get.back();
                                  tripOptionBottomSheet(context);
                                }
                              });
                            } else {
                              ShowToastDialog.showToast(
                                  'Your document is not verified by admin'.tr);
                            }
                          });
                        } else {
                          ShowToastDialog.showToast(
                              "Your wallet balance must be".tr +
                                  Constant().amountShow(
                                      amount: Constant.minimumWalletBalance!
                                          .toString()) +
                                  'to book ride.'.tr);
                        }
                      });
                    }),
                  ),
                ],
              ),
            );
          });
        });
  }

  final passengerFirstNameController = TextEditingController();
  final passengerLastNameController = TextEditingController();
  final passengerEmailController = TextEditingController();
  final passengerNumberController = TextEditingController();
  final passengerController = TextEditingController();

  tripOptionBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Customer Info".tr,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            Visibility(
                              visible: controller.createUser.value,
                              child: InkWell(
                                onTap: () {
                                  controller.createUser.value = false;
                                  passengerFirstNameController.clear();
                                  passengerLastNameController.clear();
                                  passengerEmailController.clear();
                                  passengerNumberController.clear();
                                  passengerController.clear();
                                },
                                child: Text(
                                  "Select user".tr,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !controller.createUser.value,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownSearch<CustomerData>(
                                      key: myKey,

                                      popupProps: PopupProps.dialog(
                                        showSearchBox: true,
                                        showSelectedItems: true,
                                        searchFieldProps: TextFieldProps(
                                          cursorColor: ConstantColors.primary,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    8, 0, 8, 0),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                            hintText: "Search user".tr,
                                          ),
                                        ),
                                      ),
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  8, 0, 8, 0),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.0),
                                          ),
                                          hintText: "Select user".tr,
                                        ),
                                      ),

                                      compareFn: (item1, item2) =>
                                          item1.fullName() == item2.fullName(),
                                      itemAsString: (CustomerData u) =>
                                          u.userAsString(),
                                      onChanged: (CustomerData? value) async {
                                        controller.selectedUser = value;
                                        passengerFirstNameController.text =
                                            value!.prenom!;
                                        passengerLastNameController.text =
                                            value.nom!;
                                        passengerEmailController.text =
                                            value.email!;
                                        passengerNumberController.text =
                                            value.phone!;
                                      },
                                      items: controller.userList,
                                      selectedItem: controller.selectedUser,

                                      // filterFn: (user, filter) =>
                                      //     user.userFilterByCreationDate(filter),
                                    ),

                                    // DropdownButtonFormField(
                                    //     isExpanded: true,
                                    //     decoration: const InputDecoration(
                                    //       contentPadding:
                                    //           EdgeInsets.symmetric(
                                    //               vertical: 11,
                                    //               horizontal: 8),
                                    //       focusedBorder: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             color: Colors.grey,
                                    //             width: 1.0),
                                    //       ),
                                    //       enabledBorder: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             color: Colors.grey,
                                    //             width: 1.0),
                                    //       ),
                                    //       errorBorder: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             color: Colors.grey,
                                    //             width: 1.0),
                                    //       ),
                                    //       border: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             color: Colors.grey,
                                    //             width: 1.0),
                                    //       ),
                                    //       isDense: true,
                                    //     ),
                                    //     onChanged: (CustomerData? value) {
                                    //       controller.selectedUser = value;
                                    //       passengerFirstNameController
                                    //           .text = value!.nom!;
                                    //       passengerLastNameController.text =
                                    //           value.prenom!;
                                    //       passengerEmailController.text =
                                    //           value.email!;
                                    //       passengerNumberController.text =
                                    //           value.phone!;
                                    //     },
                                    //     hint: const Text("Select user"),
                                    //     items:
                                    //         controller.userList.map((item) {
                                    //       return DropdownMenuItem(
                                    //         value: item,
                                    //         child: Text(
                                    //           "${item.nom} ${item.prenom}",
                                    //         ),
                                    //       );
                                    //     }).toList()),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: passengerController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(8),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        hintText: 'No. of passenger'.tr,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                controller.selectedUser = null;
                                controller.createUser.value = true;
                                passengerFirstNameController.clear();
                                passengerLastNameController.clear();
                                passengerEmailController.clear();
                                passengerNumberController.clear();
                                passengerController.clear();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    color: ConstantColors.hintTextColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Create user'.tr,
                                    style: TextStyle(
                                        color: ConstantColors.hintTextColor,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.createUser.value,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: passengerFirstNameController,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(8),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        hintText: 'First name'.tr,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: passengerLastNameController,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(8),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        hintText: 'Last name'.tr,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passengerEmailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: 'email'.tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passengerNumberController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: 'Phone number'.tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passengerController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: 'No. of passenger'.tr,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ButtonThem.buildIconButton(context,
                                  icon: Icons.arrow_back_ios,
                                  iconColor: Colors.black,
                                  btnHeight: 40,
                                  btnWidthRatio: 0.25,
                                  title: "Back".tr,
                                  btnColor: ConstantColors.yellow,
                                  txtColor: Colors.black, onPress: () {
                                Get.back();
                              }),
                            ),
                            Expanded(
                              child: ButtonThem.buildButton(context,
                                  btnHeight: 40,
                                  title: "book_now".tr,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.white, onPress: () async {
                                if ((passengerFirstNameController.text.isEmpty ||
                                        passengerLastNameController
                                            .text.isEmpty ||
                                        passengerNumberController
                                            .text.isEmpty ||
                                        passengerEmailController
                                            .text.isEmpty) &&
                                    controller.selectedUser == null) {
                                  ShowToastDialog.showToast(
                                      "Please Enter Details".tr);
                                } else if (passengerController.text.isEmpty) {
                                  ShowToastDialog.showToast(
                                      "Please Enter Details".tr);
                                } else {
                                  double cout = 0.0;

                                  if (controller.distance.value >
                                      double.parse(controller.vehicleData!
                                          .minimumDeliveryChargesWithin!)) {
                                    cout = (controller.distance.value *
                                            double.parse(controller
                                                .vehicleData!.deliveryCharges!))
                                        .toDouble();
                                  } else {
                                    cout = double.parse(controller
                                        .vehicleData!.minimumDeliveryCharges
                                        .toString());
                                  }
                                  for (var i = 0;
                                      i < Constant.taxList.length;
                                      i++) {
                                    if (Constant.taxList[i].statut == 'yes') {
                                      if (Constant.taxList[i].type == "Fixed") {
                                        controller.taxAmount.value +=
                                            double.parse(Constant
                                                .taxList[i].value
                                                .toString());
                                      } else {
                                        controller.taxAmount.value += (cout *
                                                double.parse(Constant
                                                    .taxList[i].value!
                                                    .toString())) /
                                            100;
                                      }
                                    }
                                  }
                                  Get.back();
                                  conformDataBottomSheet(context, cout);
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  conformDataBottomSheet(BuildContext context, double tripPrice) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: buildDetails(
                                    title: "Cash".tr,
                                    value: 'Payment method'.tr)),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: buildDetails(
                                    title:
                                        "${controller.distance.value.toStringAsFixed(int.parse(Constant.decimal!))}${Constant.distanceUnit}",
                                    value: 'Distance'.tr)),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: buildDetails(
                                    title: controller.duration.value,
                                    value: 'Duration'.tr)),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: buildDetails(
                                    title: Constant().amountShow(
                                        amount: tripPrice.toString()),
                                    value: 'Trip Price'.tr,
                                    txtColor: ConstantColors.primary)),
                          ],
                        ),
                      ),
                      ListView.builder(
                        itemCount: Constant.taxList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          TaxModel taxModel = Constant.taxList[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            title: Text(
                              '${taxModel.libelle.toString()} (${taxModel.type == "Fixed" ? Constant().amountShow(amount: taxModel.value) : "${taxModel.value}%"})',
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.subTitleTextColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            trailing: Text(
                                Constant().amountShow(
                                    amount: controller
                                        .calculateTax(
                                            taxModel: taxModel,
                                            tripPrice: tripPrice)
                                        .toString()),
                                style: TextStyle(
                                    letterSpacing: 1.0,
                                    color: ConstantColors.subTitleTextColor,
                                    fontWeight: FontWeight.w800)),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total amount:".tr,
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.subTitleTextColor,
                                  fontWeight: FontWeight.w800)),
                          Text(
                              Constant().amountShow(
                                  amount:
                                      (tripPrice + controller.taxAmount.value)
                                          .toString()),
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.subTitleTextColor,
                                  fontWeight: FontWeight.w800))
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ButtonThem.buildIconButton(context,
                                icon: Icons.arrow_back_ios,
                                iconColor: Colors.black,
                                btnHeight: 40,
                                btnWidthRatio: 0.25,
                                title: "Back".tr,
                                btnColor: ConstantColors.yellow,
                                txtColor: Colors.black, onPress: () async {
                              Get.back();
                              tripOptionBottomSheet(context);
                            }),
                          ),
                          Expanded(
                            child: ButtonThem.buildButton(context,
                                btnHeight: 40,
                                title: "book_now".tr,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white, onPress: () {
                              List stopsList = [];
                              for (var i = 0;
                                  i < controller.multiStopListNew.length;
                                  i++) {
                                stopsList.add({
                                  "latitude": controller
                                      .multiStopListNew[i].latitude
                                      .toString(),
                                  "longitude": controller
                                      .multiStopListNew[i].longitude
                                      .toString(),
                                  "location": controller.multiStopListNew[i]
                                      .editingController.text
                                      .toString()
                                });
                              }
                              Map<String, dynamic> bodyParams = {
                                'user_id': controller.selectedUser != null
                                    ? controller.selectedUser!.id!
                                    : DateTime.now().millisecondsSinceEpoch,
                                'lat1': departureLatLong!.latitude.toString(),
                                'lng1': departureLatLong!.longitude.toString(),
                                'lat2': destinationLatLong!.latitude.toString(),
                                'lng2':
                                    destinationLatLong!.longitude.toString(),
                                'cout': tripPrice.toString(),
                                'distance': controller.distance.toString(),
                                'distance_unit':
                                    Constant.distanceUnit.toString(),
                                'duree': controller.duration.toString(),
                                'id_conducteur':
                                    Preferences.getInt(Preferences.userId)
                                        .toString(),
                                'id_payment': controller.paymentMethodId.value,
                                'depart_name': departureController.text,
                                'destination_name': destinationController.text,
                                'stops': stopsList,
                                'place': '',
                                'number_poeple': passengerController.text,
                                'image': '',
                                'image_name': "",
                                'user_detail': {
                                  'name':
                                      "${passengerFirstNameController.text} ${passengerLastNameController.text}",
                                  'phone':
                                      passengerNumberController.text.toString(),
                                  'email':
                                      passengerEmailController.text.toString()
                                },
                                'ride_type': "driver",
                                'statut_round': 'no',
                                'trip_objective': "",
                                'age_children1': "",
                                'age_children2': "",
                                'age_children3': "",
                              };

                              controller.bookRide(bodyParams).then((value) {
                                if (value != null) {
                                  if (value['success'] == "success") {
                                    Get.back();
                                    getDirections();
                                    setIcons();
                                    departureController.clear();
                                    destinationController.clear();
                                    polyLines = {};
                                    departureLatLong = null;
                                    destinationLatLong = null;

                                    passengerFirstNameController.clear();
                                    passengerLastNameController.clear();
                                    passengerEmailController.clear();
                                    passengerController.clear();
                                    passengerNumberController.clear();
                                    tripPrice = 0.0;
                                    _markers.clear();

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                            text: "Ok".tr,
                                            title: "",
                                            descriptions:
                                                "Your booking is confirmed".tr,
                                            onPress: () {
                                              Get.back();
                                              Get.back();
                                            },
                                            img: Image.asset(
                                                'assets/images/green_checked.png'),
                                          );
                                        });
                                  }
                                }
                              });
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  buildDetails({title, value, Color txtColor = Colors.black}) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.9,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, color: txtColor, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
