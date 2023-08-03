import 'package:aries_design_flutter/router/index.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

//**************** 测试hasNavigation 的检测是否生效 ****************

/// 当[hasNavigation]为true时，[navigationConfig]和[icon]必须设置
class TestRouterHasNavigation extends StatelessWidget {
  TestRouterHasNavigation({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: router.getRoutes());
  }
}

//**************** 测试name唯一性的检测是否生效 ****************

class TestRouterNameUnique extends StatelessWidget {
  TestRouterNameUnique({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: false,
    ),
    AriRouteItem(
      route: "home",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.setRoutes(routes);
    return MaterialApp(initialRoute: '/', routes: router.getRoutes());
  }
}

class TestRouterNameUnique2 extends StatelessWidget {
  TestRouterNameUnique2({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "同名",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: false,
    ),
    AriRouteItem(
        route: "home",
        name: "p1",
        widget: (context) => Text("首页"),
        index: 0,
        hasNavigation: false,
        children: [
          AriRouteItem(
              name: "p2",
              route: "home3",
              widget: (context) => Text("首页3"),
              hasNavigation: false),
          AriRouteItem(
              name: "同名",
              route: "home4",
              widget: (context) => Text("首页3"),
              hasNavigation: false),
        ]),
  ];

  @override
  Widget build(BuildContext context) {
    router.setRoutes(routes);
    return MaterialApp(initialRoute: '/', routes: router.getRoutes());
  }
}

//**************** 测试route是否正确 ****************
class TestRouterRoute extends StatelessWidget {
  TestRouterRoute({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "/",
      name: "TestRouterRoute-page1",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: false,
    ),
    AriRouteItem(
        route: "/home",
        name: "TestRouterRoute-page2",
        widget: (context) => Text("首页"),
        index: 0,
        hasNavigation: false,
        children: [
          AriRouteItem(
              name: "TestRouterRoute-page2-1",
              route: "/page1/test",
              widget: (context) => Text("页面1"),
              hasNavigation: false),
          AriRouteItem(
              name: "TestRouterRoute-page2-2",
              route: "page2",
              widget: (context) => Text("页面2"),
              hasNavigation: false),
        ]),
  ];

  @override
  Widget build(BuildContext context) {
    router.setRoutes(routes);
    return MaterialApp(initialRoute: '/', routes: router.getRoutes());
  }
}

/// 测试router是否能正确跳
class TestRouterPush extends StatelessWidget {
  TestRouterPush({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "/",
      name: "TestRouterRoute-page1",
      widget: (context) => TextButton(
        child: const Text('登录'),
        key: Key('loginButton'), // 给按钮添加一个 key，以便在测试中找到它
        onPressed: () {
          // 导航到 home 页面
          Navigator.pushNamed(context, '/home');
        },
      ),
      index: 0,
      hasNavigation: false,
    ),
    AriRouteItem(
        route: "/home",
        name: "TestRouterRoute-page2",
        widget: (context) => TextButton(
              child: const Text('home'),
              key: Key('home'), // 给按钮添加一个 key，以便在测试中找到它
              onPressed: () {},
            ),
        index: 0,
        hasNavigation: true,
        icon: Icon(Icons.abc),
        navigationConfig: AriRouteItemNavigationConfig(
            initialRoute: "/home",
            navigationItems: [
              AriRouteItem(
                  name: "TestRouterRoute-page2-1",
                  route: "/page1/test",
                  widget: (context) => Text(key: Key("page1"), "页面1"),
                  hasNavigation: false),
              AriRouteItem(
                  name: "TestRouterRoute-page2-2",
                  route: "page2",
                  widget: (context) => Text(key: Key("page2"), "页面2"),
                  hasNavigation: false),
            ]),
        children: []),
  ];

  @override
  Widget build(BuildContext context) {
    router.setRoutes(routes);
    return MaterialApp(initialRoute: '/', routes: router.getRoutes());
  }
}
