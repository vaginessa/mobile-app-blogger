import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:http/http.dart' as http;

//changer par limit = 20
Future<List<PreviewPost>> getPreviewPosts({int limit = 20, int page = 0}) async {
  var res = await http
      .get(Uri.parse("$API_URL/posts?limit=$limit&page=$page"), headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${await getToken()}"
  });
  if (res.statusCode == HttpStatus.ok) {
    return (jsonDecode(res.body) as List)
        .map((jsonPost) => PreviewPost.fromJson(jsonPost))
        .toList();
  }
  handleError(res);

  return [];
}