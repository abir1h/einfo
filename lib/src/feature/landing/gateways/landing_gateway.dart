import 'dart:io';

import '../../../common/models/action_result.dart';
import '../../../common/network/api_service.dart';



mixin SendTokenGateway {
static Future<ActionResult<ServerResponse>> endToken(
    String token, String name) async {
  return Server.instance.postRequest(
    url: "store-fcm-token",
    postData: {
      "firebase_token": token,
      "user_id": name
    },
  ).then((value) {
    return ActionResult<ServerResponse>.fromServerResponse(
      response: value,
      generateData: (x) => value,
    );
  }).catchError((e) {
    return ActionResult<ServerResponse>.error();
  });
}
static Future<ActionResult<NotificationSeenResponse>> markNotificationAsSeen({
  required String userId,
  required String sourceId,
  required String type,
}) async {
  return Server.instance.postRequest(
    url: "update-seen",
    postData: {
      "user_id": userId,
      "source_id": sourceId,
      "type": type,
      "seen": true,
    },
  ).then((response) {
    return ActionResult<NotificationSeenResponse>.fromServerResponse(
      response: response,
      generateData: (data) => NotificationSeenResponse.fromJson(data),
    );
  }).catchError((e) {
    return ActionResult<NotificationSeenResponse>.error();
  });
}

static Future<ActionResult<ServerResponse>> removeToken(
    String token, String name) async {
  return Server.instance.postRequest(
    url: "store-fcm-token",
    postData: {
      "firebase_token": null,
      "user_id": name
    },
  ).then((value) {
    return ActionResult<ServerResponse>.fromServerResponse(
      response: value,
      generateData: (x) => value,
    );
  }).catchError((e) {
    return ActionResult<ServerResponse>.error();
  });
}

// static Future<ActionResult<ServerResponse>> forgetPassword(
//     String email, String userType) async {
//   return Server.instance.postRequest(
//     url: "forget-password",
//     postData: {
//       "email_or_username": email,
//       "user_type": userType
//     },
//   ).then((value) {
//     return ActionResult<ServerResponse>.fromServerResponse(
//       response: value,
//       generateData: (x) => value,
//     );
//   }).catchError((e) {
//     return ActionResult<ServerResponse>.error();
//   });
// }
}
class NotificationSeenResponse {
  final String message;
  final Map<String, dynamic> notification;

  NotificationSeenResponse({
    required this.message,
    required this.notification,
  });

  factory NotificationSeenResponse.fromJson(Map<String, dynamic> json) {
    return NotificationSeenResponse(
      message: json['message'] ?? '',
      notification: json['notification'] ?? {},
    );
  }
}