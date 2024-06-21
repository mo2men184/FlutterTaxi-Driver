import 'package:rugbydriver/controller/privacy_policy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyPolicyController>(
        init: PrivacyPolicyController(),
        builder: (controller) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: controller.privacyData != null
                  ? Html(
                      data: controller.privacyData,
                    )
                  : const Offstage(),
            ),
          );
        });
  }
}
