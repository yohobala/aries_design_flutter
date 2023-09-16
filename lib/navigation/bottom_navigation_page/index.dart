import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

typedef OnTapcallback = void Function(int);

/// 包含了底部导航栏的页面
///
/// 该页面包含了一个导航栏navigationBar和 AriRouteNavigation （导航栏对应的页面）
class AriBottomNavigationPage extends StatefulWidget {
  const AriBottomNavigationPage({
    super.key,
    required this.routeItem,
    required this.navigationBar,
  });

  /// 导航栏项
  final AriRouteItem routeItem;

  final Widget Function(
          BuildContext, List<AriRouteItem>, int selectedIndex, OnTapcallback)?
      navigationBar;

  @override
  State<AriBottomNavigationPage> createState() =>
      __AriBottomNavigationPageState();
}

class __AriBottomNavigationPageState extends State<AriBottomNavigationPage> {
  int selectedIndex = 0;
  String initialRoute = "/";
  @override
  void initState() {
    super.initState();
    AriRouteItemNavigationConfig? navigationConfig =
        widget.routeItem.navigationConfig;
    initialRoute = navigationConfig != null
        ? navigationConfig.initialRoute
        : AriRouteItemNavigationConfig().initialRoute;
    selectedIndex = navigationConfig != null
        ? navigationConfig.initialIndex
        : AriRouteItemNavigationConfig().initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    /// 导航栏项
    List<AriRouteItem> navigationItems = widget.routeItem.children;

    /// 底部导航栏
    Widget navigationBar;
    if (widget.navigationBar != null) {
      navigationBar = widget.navigationBar!(
        context,
        navigationItems,
        selectedIndex,
        (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      );
    } else {
      navigationBar = AriNavigationBar(
        itemChangeCallback: (int index, String route) {
          setState(() {
            selectedIndex = index;
          });
        },
        navigationItems: navigationItems,
        initSelectedIndex: selectedIndex,
      );
    }

    return Scaffold(
      /*
      * 底部导航栏，点击后会改变[selectedIndex]
      * 从而触发更新setState,重新渲染[RouteWidgets]
      */
      bottomNavigationBar: navigationBar,
      body: AriNavigatorGroup(
          selectedIndex: selectedIndex,
          routeItems: navigationItems,
          initialRoute: initialRoute),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
