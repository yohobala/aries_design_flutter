import 'package:http/http.dart' as http;

class AriException implements Exception {
  final String message;
  final int code;

  AriException({this.code = -1, this.message = ""});

  @override
  String toString() {
    return "CustomException: $message (code: $code)";
  }
}

AriException handleAPI(http.Response response) {
  return AriException(code: response.statusCode);
}

AriException handleException(Object e) {
  if (e is AriException) {
    return e;
  }
  return AriException(message: e.toString());
}
