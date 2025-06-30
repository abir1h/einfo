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
