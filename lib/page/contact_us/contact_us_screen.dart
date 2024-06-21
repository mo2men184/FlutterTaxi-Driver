// ignore_for_file: library_private_types_in_public_api
import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'Contact Us',
        onPressed: () {
          String url = 'tel:${Constant.contactUsPhone}';
          launchUrl(Uri.parse(url));
        },
        backgroundColor: ConstantColors.primary,
        child: const Icon(
          CupertinoIcons.phone_solid,
          color: Colors.white,
        ),
      ),
      body: Column(children: <Widget>[
        Material(
            elevation: 2,
            color: Colors.white,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16.0, left: 16, top: 16),
                    child: Text(
                      'Our Address'.tr,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16, top: 16, bottom: 16),
                    child: Text(
                        Constant.contactUsAddress!.replaceAll(r'\n', '\n')),
                  ),
                  ListTile(
                    title: Text(
                      'Email Us'.tr,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(Constant.contactUsEmail.toString()),
                    trailing: InkWell(
                      onTap: () {
                        String url = 'mailto: ${Constant.contactUsEmail}';
                        launchUrl(Uri.parse(url));
                      },
                      child: const Icon(
                        CupertinoIcons.chevron_forward,
                        color: Colors.black54,
                      ),
                    ),
                  )
                ]))
      ]),
    );
  }
}
