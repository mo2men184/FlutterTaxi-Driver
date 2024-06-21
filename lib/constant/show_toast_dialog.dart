import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowToastDialog {
  static showToast(String? message, {EasyLoadingToastPosition position = EasyLoadingToastPosition.top}) {
    EasyLoading.showToast(message!, toastPosition: position);
  }

  static showLoader(String message) {
    EasyLoading.show(
      status: message,
    );
  }

  static showBlackLoader(String message) {
    EasyLoading.show(
      status: message,
      maskType: EasyLoadingMaskType.black,
    );
  }

  static closeLoader() {
    EasyLoading.dismiss();
  }
}
