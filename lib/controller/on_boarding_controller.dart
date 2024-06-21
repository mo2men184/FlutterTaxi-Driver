import 'package:rugbydriver/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingList.length - 1;
  var pageController = PageController();

  List<OnboardingModel> onBoardingList = [
    OnboardingModel(
        'assets/images/intro_1.png', 'intro_title_one'.tr, 'into_dec_one'.tr),
    OnboardingModel(
        'assets/images/intro_2.png', 'intro_title_two'.tr, 'into_dec_two'.tr),
    OnboardingModel('assets/images/intro_3.png', 'intro_title_three'.tr,
        'into_dec_three'.tr),
  ];
}
