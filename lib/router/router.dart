import 'package:aries_design_flutter/navigation/bottom_navigation_page/index.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

import 'router_item.dart';

Map<String, AriRouteItem> routeItemMap = {};
Set<String> routeNames = {};

/// {@template ari_router}
/// 路由
///
/// get前需要先调用set方法，设置下路由表
/// {@endtemplate}
class AriRouter {
  /// {@macro ari_router}
  factory AriRouter() {
    return _instance;
  }
  AriRouter._internal();
  // 存储单例
  static final AriRouter _instance = AriRouter._internal();

  /// 得到路由表,返回MaterialApp中routes属性支持的格式
  ///
  /// 例如：
  /// {"/home": (context) => Home()}
  Map<String, Widget Function(BuildContext)> get() {
    final Map<String, Widget Function(BuildContext)> routeMap =
        _generateRoutes(routeItemMap);
    return routeMap;
  }

  /// 设置路由表
  ///
  /// - `routeItems`: 需要设置的路由
  /// - `navigationBar`: 导航栏
  /// - `showNavigationBar`: 是否显示导航栏,只对默认的导航栏有效,如果navigationBar不为空,则无效
  ///
  /// *说明*
  /// 1. 会根据父路由,重新设置route
  /// 2. 如果路由的[hasNavigation]为true，会重新设置widget，
  /// 3. 设置自定义的导航栏  优先使用传入的[navigationBar]
  void set(List<AriRouteItem> routeItems,
      {BottomNavigationBarBuilder? navigationBar,
      ValueNotifier<bool>? showNavigationBar}) {
    routeItemMap.addAll(
        getRouteItems(routeItems, "/", navigationBar, showNavigationBar));
  }

  /// 跳转到指定name的路由
  ///
  /// - `context`: 上下文
  /// - `name`: [AriRouteItem]的name
  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    try {
      if (routeItemMap.containsKey(routeName)) {
        String route = routeItemMap[routeName]!.route;
        Navigator.of(context, rootNavigator: true)
            .pushNamed(route, arguments: arguments);
      } else {
        Navigator.of(context).pushNamed(routeName, arguments: arguments);
      }
    } catch (e) {
      assert(false, "pushNamed error: $e");
    }
  }

  static void pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    try {
      if (routeItemMap.containsKey(routeName)) {
        String route = routeItemMap[routeName]!.route;
        Navigator.of(context, rootNavigator: true)
            .pushReplacementNamed(route, arguments: arguments);
      } else {
        Navigator.of(context)
            .pushReplacementNamed(routeName, arguments: arguments);
      }
    } catch (e) {
      assert(false, "pushReplacementNamed error: $e");
    }
  }

  /// 清空路由表
  static void clear() {
    routeItemMap.clear();
    routeNames.clear();
  }

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
    BottomNavigationBarBuilder? navigationBar,
    ValueNotifier<bool>? showNavigationBar) {
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
          routeItem, navigationBar, showNavigationBar);
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
    if (!routeItem.hasNavigation && routeItem.children.isNotEmpty) {
      lr.addAll(getRouteItems(
        routeItem.children,
        newRouteItem.route,
        navigationBar,
        showNavigationBar,
      ));
    }
  }
  return lr;
}

/// 判断路由的name是否唯一
bool isNameUnique(String name) {
  if (routeNames.contains(name)) {
    return false;
  } else {
    routeNames.add(name);
    return true;
  }
}

/// 生成底部导航栏容器
Widget Function(BuildContext) _generateBottomNavigationContainer(
    AriRouteItem routeItem,
    BottomNavigationBarBuilder? widget,
    ValueNotifier<bool>? showNavigationBar) {
  return (context) => AriBottomNavigationPage(
        routeItem: routeItem,
        navigationBar: widget,
        showNavigationBar: showNavigationBar,
      );
}
