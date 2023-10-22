import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 底部导航栏
///
/// 与[AriNavigationBar]不同的是,[AriBottonNavigationBar]是基于[AriNavigationBar],
/// 这个导航栏可以自定义,如果没有传入[navigationBar]参数,则使用[AriNavigationBar],
///
/// 同时带有显隐动画
class AriBottonNavigationBar extends StatefulWidget {
  const AriBottonNavigationBar({
    Key? key,
    required this.navigationItems,
    required this.initSelectedIndex,
    required this.itemChangeCallback,
    this.navigationBar,
    this.showNavigationBar,
  }) : super(key: key);

  final List<AriRouteItem> navigationItems;
  final int initSelectedIndex;
  final void Function(int index, String route) itemChangeCallback;

  /// 自定义的导航栏
  final BottomNavigationBarBuilder? navigationBar;

  /// 是否显示导航栏,只对默认导航栏有效,
  /// 如果[navigationBar]不为空,则无效
  final ValueNotifier<bool>? showNavigationBar;

  @override
  State<AriBottonNavigationBar> createState() => AriBottonNavigationBarState();
}

class AriBottonNavigationBarState extends State<AriBottonNavigationBar>
    with TickerProviderStateMixin {
  int selectedIndex = 0;

  late AnimationController controller;
  late Animation<Offset> offset;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initSelectedIndex;

    // 初始化显隐动画
    controller = AnimationController(
      duration: AriTheme.duration.medium1,
      vsync: this,
    );
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0, 1))
        .animate(controller);

    if (widget.navigationBar == null) {
      if (widget.showNavigationBar?.value ?? true) {
        controller.reverse();
      } else {
        controller.forward();
      }
      widget.showNavigationBar
          ?.addListener(handleNavigationBarVisibilityChange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBottomNavigationBar(context);
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    /// 导航栏项
    List<AriRouteItem> navigationItems = widget.navigationItems;

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
      navigationBar = Visibility(
        visible: widget.showNavigationBar?.value ?? true,
        child: SlideTransition(
          position: offset,
          child: AriNavigationBar(
            itemChangeCallback: (int index, String route) {
              selectedIndex = index;
              widget.itemChangeCallback(index, route);
            },
            navigationItems: navigationItems,
            initSelectedIndex: selectedIndex,
          ),
        ),
      );
    }
    return navigationBar;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    widget.showNavigationBar
        ?.removeListener(handleNavigationBarVisibilityChange);
  }

  // 添加监听器
  void handleNavigationBarVisibilityChange() {
    if (widget.showNavigationBar?.value ?? true) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}
