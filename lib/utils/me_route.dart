import 'dart:convert';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';

Future<User?> getMe() async {
  var res = await customGetRequest("$API_URL/@me");
  if (res == null) {
    return null;
  }

  if (res.statusCode == 200) {
    return User.fromJson(jsonDecode(res.body));
  }
  await handleError(res);
  return null;
}
