import 'dart:io';

import 'package:rugbydriver/utils/Preferences.dart';

class API {
  static const baseUrl = "https://rugbyrides.co.uk/admin/api/v1/"; // live
  static const apiKey = "base64:NFoMAvliR/msJxyCG/b4Qpd/QnC8Aba8WrWXqb01c10=";

  static Map<String, String> authheader = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
  };
  static Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
    'accesstoken': Preferences.getString(Preferences.accesstoken)
  };

  static const userSignUP = "${baseUrl}user";
  static const userLogin = "${baseUrl}user-login";
  static const getProfileByPhone = "${baseUrl}profilebyphone";
  static const getExistingUserOrNot = "${baseUrl}existing-user";
  static const sendResetPasswordOtp = "${baseUrl}reset-password-otp";
  static const getCustomer = "${baseUrl}users";

  static const resetPasswordOtp = "${baseUrl}resert-password";

  static const updatePreName = "${baseUrl}user-pre-name";
  static const updateLastName = "${baseUrl}user-name";

  static const updateLocation = "${baseUrl}update-position";
  static const contactUs = "${baseUrl}contact-us";
  static const changeStatus = "${baseUrl}change-status";
  static const updateToken = "${baseUrl}update-fcm";
  static const feelSafeAtDestination = "${baseUrl}feel-safe";
  static const conformPaymentByCash = "${baseUrl}payment-by-cash";
  static const getFcmToken = "${baseUrl}fcm-token";
  static const getRideReview = "${baseUrl}get-ride-review";

  static const userUpdateProfile = "${baseUrl}update-user-photo";
  static const documentList = "${baseUrl}documents";
  static const getDriverUploadedDocument = "${baseUrl}driver-documents";
  static const driverDocumentAdd = "${baseUrl}driver-documents-add";
  static const driverDocumentUpdate = "${baseUrl}driver-documents-update";

  static const conformRide = "${baseUrl}confirm-requete";
  static const rejectRide = "${baseUrl}set-rejected-requete";

  static const updateUserName = "${baseUrl}user-name";
  static const updateUserPhone = "${baseUrl}user-phone";
  static const updateUserEmail = "${baseUrl}update-user-email";
  static const changePassword = "${baseUrl}update-user-mdp";
  static const walletHistory = "${baseUrl}wallet-history";

  static const userLicence = "${baseUrl}update-user-licence";
  static const userRoadWorthyDoc = "${baseUrl}update-user-roadworthy";
  static const userCarServiceBook = "${baseUrl}update-user-carservice";
  static const getCarServiceBook = "${baseUrl}car-service-book?id_driver=";

  static const bookRides = "${baseUrl}requete-register";
  static const onRideRequest = "${baseUrl}onride-requete";
  static const getConformRide = "${baseUrl}requete-confirm";
  static const getOnRide = "${baseUrl}requete-onride";
  static const getCompletedRide = "${baseUrl}requete-complete";
  static const setCompleteRequest = "${baseUrl}complete-requete";
  static const getRejectRequest = "${baseUrl}requete-reject";

  static const getVehicleData = "${baseUrl}vehicle-driver?id_driver=";

  static const uploadCarServiceBook = "${baseUrl}car-service";

  static const updateVBrand = "${baseUrl}update-vehicle-brand";

  static const updateVColors = "${baseUrl}update-vehicle-color";
  static const updateVNoPlate = "${baseUrl}update-vehicle-numberplate";
  static const updateVModel = "${baseUrl}update-vehicle-model";
  static const categoryVModel = "${baseUrl}update-Vehicle-category";

  static const vehicleRegister = "${baseUrl}vehicle";
  static const vehicleCategory = "${baseUrl}Vehicle-category";

  static const driverAllRides = "${baseUrl}driver-all-rides";
  static const newRide = "${baseUrl}requete";
  static const brand = "${baseUrl}brand";
  static const model = "${baseUrl}model";
  static const bankDetails = "${baseUrl}bank-details";
  static const addBankDetails = "${baseUrl}add-bank-details";
  static const withdrawalsRequest = "${baseUrl}withdrawals";
  static const withdrawalsList = "${baseUrl}withdrawals-list";

  static const addReview = "${baseUrl}user-note";
  static const addComplaint = "${baseUrl}complaints";

  static const getLanguage = "${baseUrl}language";
  static const deleteUser = "${baseUrl}user-delete?user_id=";
  static const settings = "${baseUrl}settings";
  static const privacyPolicy = "${baseUrl}privacy-policy";
  static const termsOfCondition = "${baseUrl}terms-of-condition";
  static const rideOtpVerify = "${baseUrl}otp_verify";
  static const reGenerateOtp = "${baseUrl}otp";

  static const rideDetails = "${baseUrl}ridedetails";

  static const getPaymentMethod = "${baseUrl}payment-method";
  static const amount = "${baseUrl}amount";
  static const paymentSetting = "${baseUrl}payment-settings";
  static const payRequestCash = "${baseUrl}payment-by-cash";

  static const driverDetails = "${baseUrl}driver";
}
