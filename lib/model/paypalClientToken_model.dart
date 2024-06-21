// To parse this JSON data, do
//
//     final payPalClientTokenModel = payPalClientTokenModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

PayPalClientTokenModel payPalClientTokenModelFromJson(String str) => PayPalClientTokenModel.fromJson(json.decode(str));

String payPalClientTokenModelToJson(PayPalClientTokenModel data) => json.encode(data.toJson());

class PayPalClientTokenModel {
  PayPalClientTokenModel({
    required this.success,
    required this.data,
  });

  bool success;
  String data;

  factory PayPalClientTokenModel.fromJson(Map<String, dynamic> json) => PayPalClientTokenModel(
        success: json["success"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data,
      };
}
