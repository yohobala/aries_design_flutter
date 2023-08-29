//常用的状态码主要是200、201、204和206，分别表示请求成功、创建成功、删除成功和部分请求成功。

/// 这是最常见的状态码，表示请求成功。
/// 对于GET请求，它表示请求的资源已成功返回；
/// 对于POST或PUT请求，它表示请求的操作已成功完成,但并没有创建新的资源。
const int statusOk = 200;

/// 这个状态码通常在POST请求中使用，表示请求成功，并且服务器创建了一个新的资源。
/// 这通常伴随着一个Location头，指示新创建资源的URI。
const int statusCreated = 201;

/// 服务器已接受请求，但还未处理完成，通常用于异步操作。
/// 响应中应该包含一些指示处理进度的信息，或者指示客户端在何处能获取处理结果。
const int statusAccepted = 202;

/// 请求成功，但返回的元信息不是从原始服务器，而是从一个副本或者其他地方获取的。
const int statusNonAuthoritativeInformation = 203;

/// 请求成功，但没有需要返回的实体内容。通常用于DELETE请求，或者是更新操作的PUT请求。
const int statusNoContent = 204;

/// 和204类似，但此外还要求请求者重置文档视图
const int statusResetContent = 205;

/// 表示客户端进行了范围请求，服务器成功执行了部分GET请求。
/// 范围请求允许客户端请求资源的一部分，而不是整个资源。这对于大文件特别有用，例如视频或音频流。
const int statusPartialContent = 206;

/// 4xx: 客户端错误
/// 这些状态码表示请求可能出错，妨碍了服务器的处理。

///  服务器无法理解或无法处理客户端发送的请求。例如，请求的消息体格式不正确。
const int statusBadRequest = 400;

///  该请求需要用户认证
const int statusUnauthorized = 401;

/// 服务器已经理解请求，但是拒绝执行它。
const int statusForbidden = 403;

/// 服务器找不到请求的资源。对于网站，这意味着页面不存在。
const int statusNotFound = 404;

/// 请求中指定的方法不适用于所请求的资源。例如，尝试用 POST 方法访问一个只接受 GET 方法的资源。
const int statusMethodNotAllowed = 405;

/// 服务器不能生成与客户端在请求中定义的 Accept 头匹配的响应。
const int statusNotAcceptable = 406;

const int statusProxyAuthenticationRequired = 407;

/// 请求超时。服务器在等待客户端发送请求时超时。
const int statusRequestTimeout = 408;

/// 客户端发送了太多的请求。通常与限速相关。
const int statusTooManyRequests = 429;

///5xx: 服务器错误
///这些状态码表示服务器在尝试处理请求时出错。

/// 服务器遇到了一个未知的错误，导致无法完成请求。
const int statusInternalServerError = 500;

/// 服务器不支持请求所需要的功能。例如，服务器不识别请求方法。
const int statusNotImplemented = 501;

/// 服务器作为网关或代理时收到了无效响应。
const int statusBadGateway = 502;

/// 服务器目前无法使用（由于过载或停机维护）。通常，这只是暂时的状态。
const int statusServiceUnavailable = 503;

/// 服务器作为网关或代理，但是没有及时从上游服务器收到请求。
const int statusGatewayTimeout = 504;

/// 服务器不支持请求中所使用的 HTTP 版本。
const int statusHTTPVersionNotSupported = 505;
