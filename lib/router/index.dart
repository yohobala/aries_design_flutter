export 'widget.dart';

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

var logger = Logger();

Set<String> _routeNames = {};
List<AriRouteItem> _routeItems = [];

bool _isNameUnique(String name) {
  if (_routeNames.contains(name)) {
    return false;
  } else {
    _routeNames.add(name);
    return true;
  }
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
/// - 如果[hasNavigation]为true，[navigationConfig]和[icon]不能为null,
/// - [name]必须唯一
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
      this.children = const [],
      this.isCover = false})
      : assert(
          !hasNavigation ||
              (hasNavigation &&
                  navigationConfig != null &&
                  icon != null &&
                  widget != null),
        ),
        assert(isCover || _isNameUnique(name));

  /// 路由名称，保证唯一性,主要用于路由跳转
  final String name;

  /// 路由对应的widget
  /// 如果[hasNavigation]为true，该值无效
  Widget Function(BuildContext)? widget;

  /// 路由的route
  /// 例如：/home
  String route;

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

  /// 子路由
  final List<AriRouteItem> children;

  /// 路由的标签, 用于底部导航栏
  String label = "";

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

/// 底部导航路由的配置
class AriRouteItemNavigationConfig {
  AriRouteItemNavigationConfig(
      {this.initialRoute = "/", required this.navigationItems});

  /// 初始路由,默认为/，这个和[AriRouteItem]的[route]不一样，
  /// 即使[AriRouteItem]的[route]设置为/home，这里也可以设置为/user
  /// 之后该底部导航栏的子路由都是/user/xxx
  ///
  /// 见 https://flutter.cn/docs/cookbook/effects/nested-nav
  final String initialRoute;

  /// 需要配置到底部导航栏的路由名字，是[AriRouteItem][children]中路由的name
  final List<AriRouteItem> navigationItems;
}

class AriRouter {
  factory AriRouter() {
    return _instance;
  }
  AriRouter._internal();
  // 存储单例
  static final AriRouter _instance = AriRouter._internal();

  //**************** 公有方法 ****************
  // 得到路由表
  Map<String, Widget Function(BuildContext)> getRoutes() {
    final Map<String, Widget Function(BuildContext)> routeMap =
        _generateRoutes(_routeItems);
    return routeMap;
  }

  // 设置路由表
  void setRoutes(List<AriRouteItem> routeItems,
      [AriNavigationBar Function(BuildContext)? bottomNavigationBar]) {
    _insertRoutes(routeItems, "/", bottomNavigationBar);
  }

  void pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  //**************** 私有方法 ****************
  /// 生成路由表
  Map<String, Widget Function(BuildContext)> _generateRoutes(
      List<AriRouteItem> routeItems) {
    final Map<String, Widget Function(BuildContext)> routeMap = {};
    for (var routeItem in routeItems) {
      routeMap[routeItem.route] = routeItem.widget!;
    }
    return routeMap;
  }

  /// 插入路由，检查路由名称是否重复
  void _insertRoutes(
    List<AriRouteItem> routeItems,
    String parentRoute,
    AriNavigationBar Function(BuildContext)? navigationBar,
  ) {
    for (var routeItem in routeItems) {
      // 设置route
      String route = routeItem.route;
      if (route.startsWith("/")) {
        route = route.substring(1);
      }
      // 设置widegt，如果是底部导航栏，需要设置底部导航栏的配置
      Widget Function(BuildContext)? widget = routeItem.widget;
      if (routeItem.hasNavigation) {
        Widget Function(BuildContext) widget =
            _generateBottomNavigationContainer(
          routeItem,
          navigationBar,
        );
      } else {
        if (widget == null) {
          assert(false, "当hasNavigation为false时，widget不能为null");
        }
      }

      AriRouteItem newRouteItem = routeItem.copyWith(
        route: join(parentRoute, route),
        widget: widget,
      );
      _routeItems.add(newRouteItem);
      if (routeItem.children.length > 1) {
        _insertRoutes(
          routeItem.children,
          newRouteItem.route,
          navigationBar,
        );
      }
    }
  }

  Widget Function(BuildContext) _generateBottomNavigationContainer(
    AriRouteItem routeItem,
    AriNavigationBar Function(BuildContext)? widget,
  ) {
    logger.i("生成底部导航栏");
    return (context) => _NavigationContainer(
          routeItem: routeItem,
          navigationBar: widget,
        );
  }
}

class _NavigationContainer extends StatefulWidget {
  const _NavigationContainer({
    super.key,
    required this.routeItem,
    required this.navigationBar,
  });

  /// 导航栏项
  final AriRouteItem routeItem;

  final Widget Function(BuildContext)? navigationBar;

  @override
  State<_NavigationContainer> createState() => __NavigationContainerState();
}

class __NavigationContainerState extends State<_NavigationContainer> {
  @override
  void initState() {
    logger.i("生成底部导航栏1");
    super.initState();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    logger.i("生成底部导航栏2");
    Widget navigationBar;
    if (widget.navigationBar != null) {
      navigationBar = widget.navigationBar!(context);
    } else {
      navigationBar = AriNavigationBar(
        itemChangeCallback: (int index, String route) {
          setState(() {
            selectedIndex = index;
          });
        },
        navigationItems: widget.routeItem.navigationConfig!.navigationItems,
      );
    }
    return Scaffold(
      /*
           * 底部导航栏，点击后会改变[selectedIndex]
           * 从而触发更新setState,重新渲染[RouteWidgets]
           */
      bottomNavigationBar: navigationBar,
      body: AriRouteNavigation(
          selectedIndex: selectedIndex, routeItem: widget.routeItem),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
