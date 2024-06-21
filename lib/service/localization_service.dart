import 'package:rugbydriver/lang/app_de.dart';
import 'package:rugbydriver/lang/app_en.dart';
import 'package:rugbydriver/lang/app_fr.dart';
import 'package:rugbydriver/lang/app_hi.dart';
import 'package:rugbydriver/lang/app_ja.dart';
import 'package:rugbydriver/lang/app_pt.dart';
import 'package:rugbydriver/lang/app_ru.dart';
import 'package:rugbydriver/lang/app_zh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  static final locales = [
    const Locale('en'),
    const Locale('fr'),
    const Locale('zh'),
    const Locale('ja'),
    const Locale('hi'),
    const Locale('de'),
    const Locale('pt'),
    const Locale('ru'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enUS,
        'fr': trFR,
        'zh': zhCH,
        'ja': jaJP,
        'hi': hiIN,
        'de': deGR,
        'pt': ptPO,
        'ru': ruRU,
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    Get.updateLocale(Locale(lang));
  }
}
