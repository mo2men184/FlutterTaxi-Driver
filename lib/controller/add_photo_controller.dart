import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/model/user_model.dart';
import 'package:rugbydriver/service/api.dart';
import 'package:rugbydriver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddPhotoController extends GetxController {
  String userCat = "driver";

  @override
  void onInit() {
    getUserdata();
    super.onInit();
  }

  getUserdata() async {
    UserModel? userModel = Constant.getUserData();
    userCat = userModel.userData!.userCat!;
  }

  RxString image = "".obs;
  RxString licenceImage = "".obs;
  RxString roadWorthyDoc = "".obs;
  RxString carServiceBook = "".obs;

  Future<dynamic> uploadProfile() async {
    try {
      ShowToastDialog.showLoader("Please wait");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.userUpdateProfile),
      );
      request.headers.addAll(API.header);

      request.files.add(http.MultipartFile.fromBytes(
          'image', File(image.value).readAsBytesSync(),
          filename: File(image.value).path.split('/').last));
      request.fields['id_user'] =
          Preferences.getInt(Preferences.userId).toString();
      request.fields['user_cat'] = userCat;

      var res = await request.send();
      var responseData = await res.stream.toBytes();
      Map<String, dynamic> response =
          jsonDecode(String.fromCharCodes(responseData));
      if (res.statusCode == 200) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Uploaded!");
        return response;
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }

// Future<dynamic> userLicenseID() async {
//   try {
//     ShowToastDialog.showLoader("Please wait");
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(API.userLicence),
//     );
//     request.headers.addAll(API.header);
//     request.files.add(http.MultipartFile.fromBytes('image', File(licenceImage.value).readAsBytesSync(), filename: File(licenceImage.value).path.split('/').last));
//     request.fields['id_driver'] = Preferences.getInt(Preferences.userId).toString();
//
//     var res = await request.send();
//
//     var responseData = await res.stream.toBytes();
//     Map<String, dynamic> response = jsonDecode(String.fromCharCodes(responseData));
//
//     if (res.statusCode == 200) {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast("Uploaded!");
//       return response;
//     } else {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast('Something want wrong. Please try again later');
//       throw Exception('Failed to load album');
//     }
//   } on TimeoutException catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.message.toString());
//   } on SocketException catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.message.toString());
//   } on Error catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.toString());
//   } catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.toString());
//   }
// }
//
// Future<dynamic> userRoadWorthyDoc() async {
//   try {
//     ShowToastDialog.showLoader("Please wait");
//
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(API.userRoadWorthyDoc),
//     );
//     request.headers.addAll(API.header);
//
//     request.files.add(http.MultipartFile.fromBytes('image', File(roadWorthyDoc.value).readAsBytesSync(), filename: File(roadWorthyDoc.value).path.split('/').last));
//     request.fields['id_driver'] = Preferences.getInt(Preferences.userId).toString();
//
//     var res = await request.send();
//     var responseData = await res.stream.toBytes();
//     Map<String, dynamic> response = jsonDecode(String.fromCharCodes(responseData));
//     if (res.statusCode == 200) {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast("Uploaded!");
//       return response;
//     } else {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast('Something want wrong. Please try again later');
//       throw Exception('Failed to load album');
//     }
//   } on TimeoutException catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.message.toString());
//   } on SocketException catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.message.toString());
//   } on Error catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.toString());
//   } catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.toString());
//   }
// }
//
// Future<dynamic> userCarServiceBook() async {
//   try {
//     ShowToastDialog.showLoader("Please wait");
//
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(API.userCarServiceBook),
//     );
//     request.headers.addAll(API.header);
//
//     request.files.add(http.MultipartFile.fromBytes('image', File(carServiceBook.value).readAsBytesSync(), filename: File(carServiceBook.value).path.split('/').last));
//     request.fields['id_driver'] = Preferences.getInt(Preferences.userId).toString();
//
//     var res = await request.send();
//     var responseData = await res.stream.toBytes();
//     Map<String, dynamic> response = jsonDecode(String.fromCharCodes(responseData));
//     if (res.statusCode == 200) {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast("Uploaded!");
//       return response;
//     } else {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast('Something want wrong. Please try again later');
//       throw Exception('Failed to load album');
//     }
//   } on TimeoutException catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.message.toString());
//   } on SocketException catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.message.toString());
//   } on Error catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.toString());
//   } catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.toString());
//   }
// }
}
