import 'package:aries_design_flutter/router/index.dart';
import 'package:aries_design_flutter/theme/index.dart';
import 'package:flutter/material.dart';

class AriRouteNavigation extends StatefulWidget {
  const AriRouteNavigation({
    Key? key,
    required this.selectedIndex,
    required this.routeItem,
  }) : super(key: key);

  final int selectedIndex;

  /// 导航栏项
  final AriRouteItem routeItem;
  @override
  State<AriRouteNavigation> createState() => _AriRouteNavigationState();
}

class _AriRouteNavigationState extends State<AriRouteNavigation>
    with TickerProviderStateMixin<AriRouteNavigation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("DAOZHE");
    List<AriRouteItem> navigationItems =
        widget.routeItem.navigationConfig!.navigationItems;

    //构建所有widget的动画控制器
    List<AnimationController> widgetFaders = List<AnimationController>.generate(
      navigationItems.length,
      (int index) => buildFaderController(),
    );

    return Stack(
        children: navigationItems.map((AriRouteItem navigationItem) {
      final int index = navigationItem.index!;
      final Widget view =
          RouteWidget(selectedIndex: index, routeItem: navigationItem);

      /// widget是否显示
      bool offstage = false;
      if (index == widget.selectedIndex) {
        widgetFaders[index].forward();
      } else {
        widgetFaders[index].reverse();
        offstage = true;
      }
      return Offstage(
          offstage: offstage,
          child: FadeTransition(
              opacity:
                  widgetFaders[index].drive(CurveTween(curve: Curves.easeIn)),
              child: view));
    }).toList());
  }

  /// 页面切换动画
  AnimationController buildFaderController() {
    final AnimationController controller = AnimationController(
        vsync: this, duration: AriTheme.duration.pageDration, value: 0);
    controller.addStatusListener((AnimationStatus status) {});
    return controller;
  }
}

/// 单个路由的widget
///
/// 首先通过 onGenerateRoute 能够得到路由的配置,而onGenerateRoute需要Navigator,
/// 所以在widget外使用Navigator包裹
/// - `(settings.name == "/"`: 意味着是底部导航栏对应的页面，根据index判断显示的widget
/// - `否则`: 根据route显示
///
/// 见 https://flutter.cn/docs/cookbook/effects/nested-nav
///
/// - `selectedIndex`：底部导航栏选中的index
class RouteWidget extends StatefulWidget {
  const RouteWidget({
    Key? key,
    required this.selectedIndex,
    required this.routeItem,
  }) : super(key: key);

  final int selectedIndex;

  final AriRouteItem routeItem;
  @override
  State<StatefulWidget> createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  @override
  Widget build(BuildContext context) {
    List<AriRouteItem> navigationItems =
        widget.routeItem.navigationConfig!.navigationItems;

    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        print(settings.name);
        return MaterialPageRoute(
          builder: (BuildContext context) {
            if (settings.name == "/") {
              return widget.routeItem.widget!(context);
            } else {
              return navigationItems
                  .firstWhere((item) => item.name == settings.name)
                  .widget!(context);
            }
          },
          settings: settings,
        );
      },
    );
  }
}
