import 'package:rugbydriver/model/tax_model.dart';

class SettingsModel {
  String? success;
  String? error;
  String? message;
  Data? data;

  SettingsModel({this.success, this.error, this.message, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? footer;
  String? email;
  String? websiteColor;
  String? driverappColor;
  String? adminpanelColor;
  String? appLogo;
  String? appLogoSmall;
  String? googleMapApiKey;
  String? isSocialMedia;
  String? driverRadios;
  String? userRideScheduleTimeMinute;
  String? tripAcceptRejectDriverTimeSec;
  String? showRideWithoutDestination;
  String? showRideOtp;
  String? showRideLater;
  String? deliveryDistance;
  String? appVersion;
  String? webVersion;
  String? contactUsAddress;
  String? contactUsPhone;
  String? contactUsEmail;
  String? creer;
  String? modifier;
  String? currency;
  String? decimalDigit;
  String? taxName;
  String? taxType;
  String? taxValue;
  String? minimumWithdrawalAmount;
  String? minimumDepositAmount;
  String? symbolAtRight;
  List<TaxModel>? taxModel;
  String? mapType;
  String? driverLocationUpdate;

  Data({
    this.id,
    this.title,
    this.footer,
    this.email,
    this.websiteColor,
    this.driverappColor,
    this.adminpanelColor,
    this.appLogo,
    this.appLogoSmall,
    this.googleMapApiKey,
    this.isSocialMedia,
    this.driverRadios,
    this.userRideScheduleTimeMinute,
    this.tripAcceptRejectDriverTimeSec,
    this.showRideWithoutDestination,
    this.showRideOtp,
    this.showRideLater,
    this.deliveryDistance,
    this.appVersion,
    this.webVersion,
    this.contactUsAddress,
    this.contactUsPhone,
    this.contactUsEmail,
    this.creer,
    this.modifier,
    this.currency,
    this.decimalDigit,
    this.taxName,
    this.taxType,
    this.minimumWithdrawalAmount,
    this.minimumDepositAmount,
    this.symbolAtRight,
    this.taxValue,
    this.taxModel,
    this.mapType,
    this.driverLocationUpdate,
  });

  Data.fromJson(Map<String, dynamic> json) {
    List<TaxModel>? taxList;
    if (json['tax'] != null) {
      taxList = <TaxModel>[];
      json['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    id = json['id'].toString();
    title = json['title'].toString();
    footer = json['footer'].toString();
    email = json['email'].toString();
    websiteColor = json['website_color'].toString();
    driverappColor = json['driverapp_color'].toString();
    adminpanelColor = json['adminpanel_color'].toString();
    appLogo = json['app_logo'].toString();
    appLogoSmall = json['app_logo_small'].toString();
    googleMapApiKey = json['google_map_api_key'].toString();
    isSocialMedia = json['is_social_media'].toString();
    driverRadios = json['driver_radios'].toString();
    userRideScheduleTimeMinute =
        json['user_ride_schedule_time_minute'].toString();
    tripAcceptRejectDriverTimeSec =
        json['trip_accept_reject_driver_time_sec'].toString();
    showRideWithoutDestination =
        json['show_ride_without_destination'].toString();
    showRideOtp = json['show_ride_otp'].toString();
    showRideLater = json['show_ride_later'].toString();
    deliveryDistance = json['delivery_distance'].toString();
    appVersion = json['app_version'].toString();
    webVersion = json['web_version'].toString();
    contactUsAddress = json['contact_us_address'].toString();
    contactUsPhone = json['contact_us_phone'].toString();
    contactUsEmail = json['contact_us_email'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    currency = json['currency'].toString();
    decimalDigit = json['decimal_digit'].toString();
    taxName = json['tax_name'].toString();
    taxType = json['tax_type'].toString();
    taxValue = json['tax_value'].toString() ?? "0";
    minimumWithdrawalAmount = json['minimum_withdrawal_amount'] ?? '0';
    minimumDepositAmount = json['minimum_deposit_amount'] ?? '0';
    symbolAtRight = json['symbol_at_right'].toString() ?? 'false';
    driverLocationUpdate = json['driverLocationUpdate'].toString();
    mapType = json['mapType'].toString();
    taxModel = taxList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['footer'] = footer;
    data['email'] = email;
    data['website_color'] = websiteColor;
    data['driverapp_color'] = driverappColor;
    data['adminpanel_color'] = adminpanelColor;
    data['app_logo'] = appLogo;
    data['app_logo_small'] = appLogoSmall;
    data['google_map_api_key'] = googleMapApiKey;
    data['is_social_media'] = isSocialMedia;
    data['driver_radios'] = driverRadios;
    data['user_ride_schedule_time_minute'] = userRideScheduleTimeMinute;
    data['trip_accept_reject_driver_time_sec'] = tripAcceptRejectDriverTimeSec;
    data['show_ride_without_destination'] = showRideWithoutDestination;
    data['show_ride_otp'] = showRideOtp;
    data['show_ride_later'] = showRideLater;
    data['delivery_distance'] = deliveryDistance;
    data['app_version'] = appVersion;
    data['web_version'] = webVersion;
    data['contact_us_address'] = contactUsAddress;
    data['contact_us_phone'] = contactUsPhone;
    data['contact_us_email'] = contactUsEmail;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['currency'] = currency;
    data['decimal_digit'] = decimalDigit;
    data['tax_name'] = taxName;
    data['tax_type'] = taxType;
    data['tax_value'] = taxValue;
    data['minimum_withdrawal_amount'] = minimumWithdrawalAmount;
    data['minimum_deposit_amount'] = minimumDepositAmount;
    data['symbol_at_right'] = symbolAtRight;
    data['mapType'] = mapType;
    data['driverLocationUpdate'] = driverLocationUpdate;

    data['tax'] =
        taxModel != null ? taxModel!.map((v) => v.toJson()).toList() : null;
    return data;
  }
}
