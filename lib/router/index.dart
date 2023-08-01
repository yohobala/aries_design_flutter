import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:path/path.dart';

/// AriRoute单个路由的配置
///
/// - [hasNavigation]为false时，用到的是Map<String, Widget Function(BuildContext)>进行配置，
///   见https://flutter.cn/docs/cookbook/navigation/named-routes的介绍
/// - [hasNavigation]为true，该[AriRouteItem]的所有路由通过onGenerateRoute生成，
///   见https://flutter.cn/docs/cookbook/effects/nested-nav关于onGenerateRoute的介绍
///   这个[AriRouteItem]下的所有路由都有底部导航栏。
///   同时配置的子路由只能在该这个[AriRouteItem]进行跳转，子路由的[hasNavigation]必须为false
///
/// *assert*
/// - 如果[hasNavigation]为true，[navigationConfig]和[icon]不能为null,
///
///
class AriRouteItem {
  AriRouteItem(
      {required this.route,
      required this.name,
      required this.widget,
      this.index,
      this.icon,
      this.hasNavigation = false,
      this.navigationConfig,
      this.children = const []})
      : assert(
          !hasNavigation ||
              (hasNavigation && navigationConfig != null && icon != null),
        );

  /// 路由名称，保证唯一性
  final String name;

  /// 路由对应的widget
  final Widget Function(BuildContext) widget;

  /// 路由的route
  /// 例如：/home
  final String route;

  /// 路由的索引
  final int? index;

  /// 路由的图标
  ///
  /// 当是底部导航栏时，需要设置
  ///
  /// 例如：Icon(Icons.home)
  final Icon? icon;

  /// 是否是导航栏
  final bool hasNavigation;

  /// 导航栏的配置
  final AriRouteItemNavigationConfig? navigationConfig;

  final List<AriRouteItem> children;
}

/// 底部导航路由的配置
class AriRouteItemNavigationConfig {
  AriRouteItemNavigationConfig(
      {this.initialRoute = "/", required this.navigationItemNames});

  /// 初始路由,默认为/，这个和[AriRouteItem]的[route]不一样，
  /// 即使[AriRouteItem]的[route]设置为/home，这里也可以设置为/user
  /// 之后该底部导航栏的子路由都是/user/xxx
  ///
  /// 见 https://flutter.cn/docs/cookbook/effects/nested-nav
  final String initialRoute;

  /// 需要配置到底部导航栏的路由名字，是[AriRouteItem][children]中路由的name
  final List<String> navigationItemNames;
}

class AriRouter {
  factory AriRouter() {
    return _instance;
  }
  AriRouter._internal();
  // 存储单例
  static final AriRouter _instance = AriRouter._internal();

  //**************** 私有变量 ****************
  late List<AriRouteItem> _routes = [];
  Set<String> _routeNames = {};

  //**************** 公有方法 ****************
  // 得到路由表
  Map<String, Widget Function(BuildContext)> getRoutes() {
    final Map<String, Widget Function(BuildContext)> routeMap =
        _generateRoutes(_routes);
    return routeMap;
  }

  // 设置路由表
  void setRoutes(List<AriRouteItem> routes) {
    _insertRoutes(routes);
  }

  void pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  //**************** 私有方法 ****************
  /// 生成路由表
  Map<String, Widget Function(BuildContext)> _generateRoutes(
      List<AriRouteItem> routes) {
    final Map<String, Widget Function(BuildContext)> routeMap = {};
    routes.forEach((element) {
      routeMap[element.route] = element.widget;
    });
    return routeMap;
  }

  /// 插入路由，检查路由名称是否重复
  void _insertRoutes(List<AriRouteItem> routes) {
    routes.forEach((route) {
      _addRoute(route);
    });
  }

  void _addRoute(AriRouteItem route) {
    final String name = route.name;
    // final BuildContext context = route.context;
    if (_isNameUnique(name)) {
      // assert(false,
      //     AriLocalizations.of(context)!.ariRouteItem_name_duplicate(name));
    } else {
      _routeNames.add(name);
      _routes.add(route);
      if (route.children.length > 1) {
        _insertRoutes(route.children);
      }
    }
  }

  bool _isNameUnique(String name) {
    if (_routeNames.contains(name)) {
      return true;
    } else {
      return false;
    }
  }
}
