class Store {
  // 单例实例
  static final Store _singleton = Store._internal();
  // 工厂构造函数返回单例实例
  factory Store() => _singleton;
  // 私有构造函数
  Store._internal();

  // 用于存储注册模型的私有映射
  final Map<Type, dynamic> _models = {};

  /// 注册模型
  void register<T>(T model) {
    _models[T] = model;
  }

  // 作为可调用类，可以直接调用此方法来获取模型
  T call<T>() {
    return _models[T] as T;
  }
}
