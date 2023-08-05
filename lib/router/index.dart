export '../navigation/navigation/index.dart';

import 'dart:ffi';
import 'dart:math';

import 'package:aries_design_flutter/navigation/bottom_navigation_page/index.dart';
import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

var logger = Logger();

Set<String> _routeNames = {};

Map<String, AriRouteItem> _routeItems = {};

/// 底部导航路由的配置
class AriRouteItemNavigationConfig {
  AriRouteItemNavigationConfig({
    this.initialRoute = "/",
    this.initialIndex = 0,
  });

  /// 初始路由,默认为/，这个和[AriRouteItem]的[route]不一样，
  /// 即使[AriRouteItem]的[route]设置为/home，这里也可以设置为/user
  /// 之后该底部导航栏的子路由都是/user/xxx
  ///
  /// 见 https://flutter.cn/docs/cookbook/effects/nested-nav
  final String initialRoute;

  /// 默认打开的底部导航栏的index
  final int initialIndex;
}

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
/// - 如果[hasNavigation]为true，
///   - 当前[AriRouteItem]的children的[icon]和[widget]不能为null
///   - 当前[AriRouteItem]的children的数量必须大于等于2
///   - 当前[AriRouteItem]下所有层级的children都不能设置hasNavigation为true，
///     即children的children也不能设置hasNavigation为true
/// - 如果[hasNavigation]为false
///   - [widget]不能为null
/// - [name]必须唯一
///
class AriRouteItem {
  AriRouteItem(
      {required this.name,
      required this.widget,
      required this.route,
      this.index,
      this.icon,
      this.hasNavigation = false,
      this.navigationConfig,
      this.children = const [],
      this.isCover = false})
      : assert(_checkHasNavigationCondition(
          hasNavigation,
          widget,
          navigationConfig,
          children,
        )),
        assert(isCover || _isNameUnique(name));

  /// 路由名称，保证唯一性,主要用于pushNamed路由跳转使用
  final String name;

  /// 路由对应的widget
  /// 如果[hasNavigation]为true，该值无效
  /// 如果[hasNavigation]为false，该值必须设置，否则出现AssertionError
  final Widget Function(BuildContext)? widget;

  /// 路由的route
  /// 例如：/home
  String route;

  /// 路由的索引
  final int? index;

  /// 路由的图标
  ///
  /// 当父路由的[hasNavigation]为true时，该值必须设置，否则出现AssertionError
  ///
  /// 例如：Icon(Icons.home)
  final Icon? icon;

  /// 是否是导航栏
  final bool hasNavigation;

  /// 导航栏的配置
  final AriRouteItemNavigationConfig? navigationConfig;

  /// 子路由
  final List<AriRouteItem> children;

  /// 路由的标签, 用于底部导航栏
  String? label;

  /// 当这个值为true时，如果[name]相同，会覆盖原来的路由
  /// 默认为false
  bool isCover;

  AriRouteItem copyWith({
    String? name,
    Widget Function(BuildContext)? widget,
    String? route,
    int? index,
    Icon? icon,
    bool? hasNavigation,
    AriRouteItemNavigationConfig? navigationConfig,
    List<AriRouteItem>? children,
    bool isCover = true,
  }) {
    return AriRouteItem(
      name: name ?? this.name,
      widget: widget ?? this.widget,
      route: route ?? this.route,
      index: index ?? this.index,
      icon: icon ?? this.icon,
      hasNavigation: hasNavigation ?? this.hasNavigation,
      navigationConfig: navigationConfig ?? this.navigationConfig,
      children: children ?? this.children,
      isCover: isCover,
    );
  }
}

class AriRouter {
  factory AriRouter() {
    return _instance;
  }
  AriRouter._internal();
  // 存储单例
  static final AriRouter _instance = AriRouter._internal();

  //**************** 公有方法 ****************
  /// 得到路由表,返回MaterialApp中routes属性支持的格式
  ///
  /// 例如：
  /// {"/home": (context) => Home()}
  Map<String, Widget Function(BuildContext)> get() {
    final Map<String, Widget Function(BuildContext)> routeMap =
        _generateRoutes(_routeItems);
    return routeMap;
  }

  /// 设置路由表
  ///
  /// - `routeItems`: 需要设置的路由
  /// - `navigationBar`: 导航栏
  ///
  /// *说明*
  /// 1. 会根据父路由,重新设置route
  /// 2. 如果路由的[hasNavigation]为true，会重新设置widget，
  ///   优先使用传入的[navigationBar]
  void set(List<AriRouteItem> routeItems,
      [AriNavigationBar Function(BuildContext)? navigationBar]) {
    _routeItems.addAll(getRouteItems(routeItems, "/", navigationBar));
  }

  /// 跳转到指定name的路由
  ///
  /// - `context`: 上下文
  /// - `name`: [AriRouteItem]的name
  static void pushNamed(BuildContext context, String routeName) {
    try {
      if (_routeItems.containsKey(routeName)) {
        String route = _routeItems[routeName]!.route;
        Navigator.of(context, rootNavigator: true).pushNamed(route);
      } else {
        Navigator.of(context).pushNamed(routeName);
      }
    } catch (e) {
      assert(false, "pushNamed error: $e");
    }
  }

  static void clear() {
    _routeItems.clear();
    _routeNames.clear();
  }

  //**************** 私有方法 ****************
  /// 生成路由表
  Map<String, Widget Function(BuildContext)> _generateRoutes(
      Map<String, AriRouteItem> routeItems) {
    final Map<String, Widget Function(BuildContext)> routeMap = {};
    routeItems.forEach((key, routeItem) {
      routeMap[routeItem.route] = routeItem.widget!;
    });
    return routeMap;
  }
}

/// 递归得到全部的[AriRouteItem]
///
/// 1. 如果[hasNavigation]为true，会根据[navigationBar]重新设置widget
/// 2. 会根据[parentRoute],重新设置route
///
/// *参数*
/// - `routeItems`: 需要设置的路由
/// - `parentRoute`: 父路由
/// - `navigationBar`: 导航栏
///
/// *return*
/// 返回全部的[AriRouteItem]
Map<String, AriRouteItem> getRouteItems(
  List<AriRouteItem> routeItems,
  String parentRoute,
  AriNavigationBar Function(BuildContext)? navigationBar,
) {
  Map<String, AriRouteItem> lr = {};
  for (var routeItem in routeItems) {
    // 设置route
    String route = routeItem.route;
    if (route.startsWith("/")) {
      route = route.substring(1);
    }
    // 设置widegt，如果是底部导航栏，需要设置底部导航栏的配置
    Widget Function(BuildContext)? widget = routeItem.widget;
    if (routeItem.hasNavigation) {
      widget = _generateBottomNavigationContainer(
        routeItem,
        navigationBar,
      );
    } else {
      if (widget == null) {
        assert(false, "当hasNavigation为false时，widget不能为null");
      }
    }

    // 生成新的routeItem
    AriRouteItem newRouteItem = routeItem.copyWith(
      route: join(parentRoute, route),
      widget: widget,
    );
    lr[newRouteItem.name] = newRouteItem;

    // 如果hasNavigation为true,子路由不加入路由表
    if (!routeItem.hasNavigation && routeItem.children.length > 1) {
      lr.addAll(getRouteItems(
        routeItem.children,
        newRouteItem.route,
        navigationBar,
      ));
    }
  }
  return lr;
}

/// 判断路由的name是否唯一
bool _isNameUnique(String name) {
  if (_routeNames.contains(name)) {
    return false;
  } else {
    _routeNames.add(name);
    return true;
  }
}

/// 判断HasNavigation不同情况下AriRouteItem的正确性
///
/// - 当hasNavigation为true时
///   - children的[icon]和[widget]不能为null
///   - children的数量必须大于等于2
///   - 所有层级的children都不能设置hasNavigation为true
/// - 当hasNavigation为false时
///   - widget不能为null
bool _checkHasNavigationCondition(
  bool hasNavigation,
  Widget Function(BuildContext)? widget,
  AriRouteItemNavigationConfig? navigationConfig,
  List<AriRouteItem> children,
) {
  if (hasNavigation &&
      children.every((child) => child.icon != null && child.widget != null) &&
      _checkChildrenNavigation(children) &&
      children.length >= 2) {
    return true;
  } else if (!hasNavigation && widget != null) {
    return true;
  } else {
    return false;
  }
}

/// 判断子路由是否都没有导航栏
bool _checkChildrenNavigation(List<AriRouteItem> children) {
  for (var child in children) {
    if (child.hasNavigation || (!_checkChildrenNavigation(child.children))) {
      return false;
    }
  }
  return true;
}

/// 生成底部导航栏容器
Widget Function(BuildContext) _generateBottomNavigationContainer(
  AriRouteItem routeItem,
  AriNavigationBar Function(BuildContext)? widget,
) {
  return (context) => AriBottomNavigationPage(
        routeItem: routeItem,
        navigationBar: widget,
      );
}
