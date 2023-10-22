import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 底部导航栏
typedef BottomNavigationBarBuilder = Widget Function(
  BuildContext context,

  /// 底部导航栏项
  List<AriRouteItem> navigationItems,

  /// 初始选中的导航栏index
  int initSelectedIndex,

  /// 底部导航栏切换回调,调用这个才会切换页面
  PageChangeCallback pageChangeCallback,
);

/// 包含了底部导航栏的页面
///
/// 该页面包含了一个AriBottonNavigationBar(导航栏) 和 AriNavigatorGroup （导航栏对应的页面）
class AriBottomNavigationPage extends StatefulWidget {
  const AriBottomNavigationPage({
    super.key,
    required this.routeItem,
    required this.navigationBar,
    required this.showNavigationBar,
  });

  /// 导航栏项
  final AriRouteItem routeItem;

  /// 自定义的导航栏
  final BottomNavigationBarBuilder? navigationBar;

  /// 是否显示导航栏,只对默认导航栏有效,
  /// 如果[navigationBar]不为空,则无效
  final ValueNotifier<bool>? showNavigationBar;

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
    AriNavigatorGroup group = AriNavigatorGroup(
      initialRoute: initialRoute,
      routeItems: widget.routeItem.children,
      selectedIndex: selectedIndex,
    );
    AriBottonNavigationBar navigationBar = AriBottonNavigationBar(
      key: bottomNavigationBarKey,
      navigationItems: widget.routeItem.children,
      initSelectedIndex: selectedIndex,
      pageChangeCallback: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      navigationBar: widget.navigationBar,
      showNavigationBar: widget.showNavigationBar,
    );

    Widget element;
    if (widget.routeItem.navigationConfig?.container != null) {
      element =
          widget.routeItem.navigationConfig!.container!(group, navigationBar);
    } else {
      element = AriNavigationBarScaffold(
        body: group,
        bottomNavigationBar: navigationBar,
      );
    }

    return element;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
