// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;

class SendNotification {
  static var SERVER_KEY = "AAAAes6iy30:APA91bEGZgbKE9VS68ummlUqXdX0u-JMAcnieJ8v7MX_q-oro5KrYySZ7Ho1oLvWvYDHHcZ-73pb8lLYo5s2xAt2kRoN8e2TDjIN8ikKVM6NPKeCqPB5qE0SpJ0JTiG7Sl8O5MxZssde";

  static sendMessageNotification(String token, String title, String body, Map<String, dynamic>? payload) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$SERVER_KEY',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': payload ?? <String, dynamic>{},
          'to': token
        },
      ),
    );
  }
}
