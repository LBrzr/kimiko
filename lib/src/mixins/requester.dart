import 'dart:convert' show json;
import 'dart:io' show File;

import 'package:flutter/cupertino.dart' show debugPrint;

import 'package:http/http.dart' as http;

mixin RequesterMixin {
  String? get authorizationToken;

  List<Map<String, dynamic>> defaultListTonListJson(data) =>
      data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();

  /// master http requests method
  Future<T?> sendRequest<T>({
    headers = const <String, String>{},
    required String method,
    required String endPoint,
    List<MapEntry<String, File>>? files,
    Map<String, dynamic>? body,
    List<Map<String, dynamic>>? listBody,
    bool auth = true,
    bool returnAny = false,
    T? result,
    ok = 200,
    bool convert = false,
    bool decode = true,
  }) async {
    if (result != null) {
      // ! todo: comment
      debugPrint("Faked Result: $method, $endPoint");
      return Future.delayed(const Duration(seconds: 1), () => result);
    }

    // debugPrint(pref.authorizationToken); // ! todo
    debugPrint(endPoint);
    if (body != null || listBody != null) {
      debugPrint(json.encode(body ?? listBody));
    }
    /*
    if (files != null) {
      debugPrint(files.map((e) => e.value.path).toString());
    } */

    try {
      final dynamic request;
      if (files != null) {
        request = http.MultipartRequest(method, Uri.parse(endPoint));
        request.files.addAll(await Future.wait(files.map((entry) =>
            http.MultipartFile.fromPath(entry.key, entry.value.path))));
      } else {
        request = http.Request(method, Uri.parse(endPoint));
      }
      if (headers != null) {
        request.headers.addAll(headers);
      }
      if (auth && authorizationToken != null) {
        request.headers
            .addAll({"Authorization": "Bearer ${authorizationToken!}"});
      }
      if (body != null) {
        request.headers.addAll({"content-type": "application/json"});
        if (request is http.MultipartRequest) {
          request.fields.addAll(
            body.map((key, value) => MapEntry(
                  key,
                  value is Map || value is List
                      ? json.encode(value)
                      : value.toString(),
                )),
          );
        } else {
          request.body = json.encode(body);
        }
      } else if (listBody != null) {
        request.headers.addAll({"content-type": "application/json"});
        request.body = json.encode(listBody);
      }
      final response = await request.send();
      debugPrint(request.method);
      debugPrint(endPoint);
      debugPrint(response.reasonPhrase);
      final content = await response.stream.bytesToString();
      // todo
      debugPrint(content);
      if (response.statusCode == ok || returnAny) {
        if (!decode) return content;
        final data = json.decode(content);
        return convert ? defaultListTonListJson(data) : data;
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }
}
