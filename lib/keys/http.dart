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

const int statusBadRequest = 400;
