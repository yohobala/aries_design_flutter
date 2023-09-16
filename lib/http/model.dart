import 'dart:convert';

class FetchRes<T> {
  FetchRes({
    required this.code,
    required this.message,
    required this.data,
  });
  final T data;
  final int code;
  final String message;

  factory FetchRes.fromJson(Map<String, dynamic> json) {
    return FetchRes(
      data: json['data'] as T,
      code: json['code'] as int,
      message: json['message'] as String,
    );
  }
}

FetchRes<dynamic> parseFetchRes(dynamic data) {
  final Map<String, dynamic> jsonData = json.decode(data);
  return FetchRes<dynamic>.fromJson(jsonData);
}
