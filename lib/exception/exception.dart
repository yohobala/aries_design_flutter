import 'package:http/http.dart' as http;

class AriException implements Exception {
  AriException({
    this.code = -1,
    this.message = "",
    this.statckTrace = StackTrace.empty,
  });
  final String message;
  final int code;
  final StackTrace statckTrace;

  @override
  String toString() {
    return "CustomException:\nmessage: $message \ncode: $code,\n$statckTrace";
  }
}

AriException handleAPI(http.Response response) {
  return AriException(code: response.statusCode);
}

AriException handleException(Object e, StackTrace s) {
  if (e is AriException) {
    return e;
  }
  return AriException(message: e.toString(), statckTrace: s);
}
