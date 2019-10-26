import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SendMessageApi {
  static final Client client = Client();

  static const String serverKey =
      'AAAAxkNhj3g:APA91bETzmz1EBeJ8Lobe1KnhkviVGN7zDFmmYNFnWy0qsAk8uQKU2cTtuAfMja0bO4Fn4JOoZS3Nw7URS5XvQbcSdQYsTrGgkWD1yYERv_tDJY7Qj8HfUjjqmrEtRFa3qx0sbSlOiGo';

  static const String url = 'https://fcm.googleapis.com/fcm/send';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic({
    @required String title,
    @required String body,
    @required String topic,
  }) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        url,
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}

/*
//How To Use:
final response = await SendMessageApi.sendToTopic(title, body, userIDToSend);
if(response.statusCode != 200){
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('[${response.statusCode}] Error Message: ${response.body}'),
    )
   );
}
*/
