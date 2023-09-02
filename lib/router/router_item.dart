import 'package:flutter/widgets.dart';
import 'router.dart';

/// {@template ari_route_item_navigation_config}
/// 底部导航路由的配置
/// {@endtemplate}
class AriRouteItemNavigationConfig {
  /// {@macro ari_route_item_navigation_config}
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

/// {@template AriRouteItem}
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
/// {@endtemplate}
class AriRouteItem {
  /// {@macro AriRouteItem}
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
        assert(isCover || isNameUnique(name));

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
