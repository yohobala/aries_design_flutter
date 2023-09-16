import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

typedef OnTapcallback = void Function(int);

typedef BottomNavigationBarBuilder = Widget Function(
    BuildContext context,
    List<AriRouteItem> navigationItems,
    int selectedIndex,
    OnTapcallback onTap)?;

/// 包含了底部导航栏的页面
///
/// 该页面包含了一个导航栏navigationBar和 AriRouteNavigation （导航栏对应的页面）
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
  final BottomNavigationBarBuilder navigationBar;

  /// 是否显示导航栏,只对默认导航栏有效,
  /// 如果[navigationBar]不为空,则无效
  final ValueNotifier<bool>? showNavigationBar;

  @override
  State<AriBottomNavigationPage> createState() =>
      __AriBottomNavigationPageState();
}

class __AriBottomNavigationPageState extends State<AriBottomNavigationPage>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  String initialRoute = "/";

  late AnimationController _controller;
  late Animation<Offset> _offset;

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

    // 初始化显隐动画
    _controller = AnimationController(
      duration: AriTheme.duration.medium1,
      vsync: this,
    );
    _offset = Tween<Offset>(begin: Offset.zero, end: Offset(0, 1))
        .animate(_controller);

    if (widget.navigationBar == null) {
      if (widget.showNavigationBar?.value ?? true) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      widget.showNavigationBar
          ?.addListener(handleNavigationBarVisibilityChange);
    }
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
      navigationBar = SlideTransition(
        position: _offset,
        child: AriNavigationBar(
          itemChangeCallback: (int index, String route) {
            setState(() {
              selectedIndex = index;
              widget.showNavigationBar?.value =
                  !widget.showNavigationBar!.value;
            });
          },
          navigationItems: navigationItems,
          initSelectedIndex: selectedIndex,
        ),
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
    _controller.dispose();
    widget.showNavigationBar
        ?.removeListener(handleNavigationBarVisibilityChange);
  }

  // 添加监听器
  void handleNavigationBarVisibilityChange() {
    if (widget.showNavigationBar?.value ?? true) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}
