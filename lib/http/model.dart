import 'dart:convert';

import 'package:aries_design_flutter/aries_design_flutter.dart';

class FetchResponse<T> {
  FetchResponse({
    required this.code,
    required this.message,
    required this.data,
  });
  final T data;
  final int code;
  final String message;

  // factory FetchResponse.fromJson(
  //     Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
  //   return FetchResponse(
  //     data: fromJsonT(json['data']),
  //     code: json['code'] as int,
  //     message: json['message'] as String,
  //   );
  // }
  factory FetchResponse.fromJson(Map<String, dynamic> json) {
    return FetchResponse(
      data: json['data'] as T,
      code: json['code'] as int,
      message: json['message'] as String,
    );
  }
}

// FetchResponse<T> parseFetchResponse<T>(
//     String data, T Function(dynamic) fromJsonT) {
//   final Map<String, dynamic> jsonData = json.decode(data);
//   return FetchResponse<T>.fromJson(jsonData, fromJsonT);
// }

FetchResponse<dynamic> parseFetchResponse(String data) {
  final Map<String, dynamic> jsonData = json.decode(data);
  return FetchResponse<dynamic>.fromJson(jsonData);
}
