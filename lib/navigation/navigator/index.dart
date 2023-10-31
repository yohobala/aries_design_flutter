import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 多个[AriNavigator]的集合
///
/// 实现了[AriNavigator]的切换，并对页面切换添加了动画效果
///
/// 配合[AriNavigationBar]使用，当AriNavigationBar点击时，
/// 会触发index改变，从而触发页面切换
class AriNavigatorGroup extends StatefulWidget {
  const AriNavigatorGroup({
    GlobalKey<AriNavigatorGroupState>? key,
    required this.selectedIndex,
    required this.routeItems,
    required this.initialRoute,
  }) : super(key: key);

  /// 当前选中的导航栏项的索引
  final ValueNotifier<int> selectedIndex;

  /// 导航栏项
  final List<AriRouteItem> routeItems;

  final String initialRoute;
  @override
  State<AriNavigatorGroup> createState() => AriNavigatorGroupState();
}

class AriNavigatorGroupState extends State<AriNavigatorGroup>
    with TickerProviderStateMixin<AriNavigatorGroup> {
  @override
  void initState() {
    super.initState();
    widget.selectedIndex.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<AriRouteItem> navigationItems = widget.routeItems;

    List<AnimationController> faders = pageFade(this, navigationItems.length);
    List<Widget> elements = [];
    for (int i = 0; i < navigationItems.length; i++) {
      final AriRouteItem navigationItem = navigationItems[i];
      // index对应导航栏项的索引，
      // 当导航栏点击后，会改变index，
      // 通过index来判断显示的widget。
      final Widget view = AriNavigator(
        selectedIndex: i,
        routeItem: navigationItem,
        initialRoute: widget.initialRoute,
      );

      // widget是否显示
      bool offstage = false;
      if (i == widget.selectedIndex.value) {
        faders[i].forward();
      } else {
        faders[i].reverse();
        offstage = true;
      }

      // 创建widget
      Widget element = Offstage(
        offstage: offstage,
        child: FadeTransition(
          opacity: faders[i].drive(
            CurveTween(
              curve: Curves.easeIn,
            ),
          ),
          child: view,
        ),
        // child: view,
      );

      elements.add(element);
    }

    return Stack(
      children: elements,
    );
  }

  @override
  void dispose() {
    widget.selectedIndex.removeListener(() {});
    super.dispose();
  }
}

/// 生成和管理一个Navigator，处理页面的导航
///
/// 首先通过 onGenerateRoute 能够得到路由的配置,而onGenerateRoute需要Navigator,
/// 所以在widget外使用Navigator包裹
/// - `(settings.name == "/"`: 意味着是底部导航栏对应的页面，根据index判断显示的widget
/// - `否则`: 根据route显示
///
/// 见 https://flutter.cn/docs/cookbook/effects/nested-nav

class AriNavigator extends StatefulWidget {
  const AriNavigator({
    Key? key,
    required this.selectedIndex,
    required this.routeItem,
    required this.initialRoute,
  }) : super(key: key);

  /// 当前路由对应的导航栏的index
  final int selectedIndex;

  /// 当前路由项
  final AriRouteItem routeItem;

  final String initialRoute;
  @override
  State<AriNavigator> createState() => _AriNavigatorState();
}

class _AriNavigatorState extends State<AriNavigator> {
  @override
  Widget build(BuildContext context) {
    Map<String, AriRouteItem> children =
        getRouteItems([widget.routeItem], widget.initialRoute, null, null);

    return Navigator(
      initialRoute: widget.initialRoute,
      onGenerateRoute: (RouteSettings settings) {
        Widget Function(BuildContext) page;
        if (settings.name == widget.initialRoute) {
          page = widget.routeItem.widget!;
        } else if (children.containsKey(settings.name)) {
          page = children[settings.name]!.widget!;
        } else {
          // logger.w(settings.name);
          return null;
        }
        return MaterialPageRoute(
          builder: (BuildContext context) => page(context),
          settings: settings,
        );
      },
    );
  }
}
