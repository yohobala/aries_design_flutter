import 'package:aries_design_flutter/router/index.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

//**************** 测试hasNavigation 的检测是否生效 ****************

List<AriRouteItem> childrenRoutes = [
  AriRouteItem(
    route: "",
    name: "首页",
    widget: (context) => Text("首页"),
    index: 0,
    hasNavigation: true,
    navigationConfig: AriRouteItemNavigationConfig(
      initialRoute: "/",
    ),
    children: [
      AriRouteItem(
          name: "page1",
          route: "page1",
          widget: (context) => Text("page1"),
          icon: Icon(Icons.home),
          hasNavigation: false,
          children: [
            AriRouteItem(
                name: "page1-1",
                route: "children1",
                widget: (context) => Text("children1"),
                icon: Icon(Icons.home),
                hasNavigation: false,
                children: [
                  AriRouteItem(
                    name: "page1-1-1",
                    route: "children1-1",
                    widget: (context) => Text("children1-1"),
                    icon: Icon(Icons.home),
                    hasNavigation: false,
                  ),
                ]),
          ]),
      AriRouteItem(
        name: "page2",
        route: "page2",
        widget: (context) => Text("首页2"),
        icon: Icon(Icons.home),
        hasNavigation: false,
      ),
    ],
  ),
];

/// 当[hasNavigation]为false时，widget不能为null
class TestRouterHasNavigationFalse extends StatelessWidget {
  TestRouterHasNavigationFalse({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: null, //(context) => Text("首页"),
      index: 0,
      hasNavigation: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
  }
}

/// 当[hasNavigation]为true时，children的数量必须大于等于2
class TestRouterHasNavigationTrue_1 extends StatelessWidget {
  TestRouterHasNavigationTrue_1({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: true,
      navigationConfig: AriRouteItemNavigationConfig(
        initialRoute: "/",
      ),
      children: [
        AriRouteItem(
            name: "page1",
            route: "page1",
            widget: (context) => Text("page1"),
            icon: Icon(Icons.home),
            hasNavigation: false,
            children: [
              AriRouteItem(
                  name: "page1-1",
                  route: "children1",
                  widget: (context) => Text("children1"),
                  icon: Icon(Icons.home),
                  hasNavigation: false,
                  children: [
                    AriRouteItem(
                      name: "page1-1-1",
                      route: "children1-1",
                      widget: (context) => Text("children1-1"),
                      icon: Icon(Icons.home),
                      hasNavigation: false,
                    ),
                  ]),
            ]),
        AriRouteItem(
          name: "page2",
          route: "page2",
          widget: (context) => Text("首页2"),
          icon: Icon(Icons.home),
          hasNavigation: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
  }
}

/// 当[hasNavigation]为true时，需要设置navigationConfig
class TestRouterHasNavigationTrue_2 extends StatelessWidget {
  TestRouterHasNavigationTrue_2({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: true,
      navigationConfig: AriRouteItemNavigationConfig(
        initialRoute: "/",
      ),
      children: [
        AriRouteItem(
            name: "page1",
            route: "page1",
            widget: (context) => Text("page1"),
            icon: Icon(Icons.home),
            hasNavigation: false,
            children: [
              AriRouteItem(
                  name: "page1-1",
                  route: "children1",
                  widget: (context) => Text("children1"),
                  icon: Icon(Icons.home),
                  hasNavigation: false,
                  children: [
                    AriRouteItem(
                      name: "page1-1-1",
                      route: "children1-1",
                      widget: (context) => Text("children1-1"),
                      icon: Icon(Icons.home),
                      hasNavigation: false,
                    ),
                  ]),
            ]),
        AriRouteItem(
          name: "page2",
          route: "page2",
          widget: (context) => Text("首页2"),
          icon: Icon(Icons.home),
          hasNavigation: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
  }
}

/// 当[hasNavigation]为true时，children的icon不能为null
class TestRouterHasNavigationTrue_3 extends StatelessWidget {
  TestRouterHasNavigationTrue_3({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: true,
      navigationConfig: AriRouteItemNavigationConfig(
        initialRoute: "/",
      ),
      children: [
        AriRouteItem(
            name: "page1",
            route: "page1",
            widget: (context) => Text("page1"),
            icon: Icon(Icons.home),
            hasNavigation: false,
            children: [
              AriRouteItem(
                  name: "page1-1",
                  route: "children1",
                  widget: (context) => Text("children1"),
                  icon: Icon(Icons.home),
                  hasNavigation: false,
                  children: [
                    AriRouteItem(
                      name: "page1-1-1",
                      route: "children1-1",
                      widget: (context) => Text("children1-1"),
                      icon: Icon(Icons.home),
                      hasNavigation: false,
                    ),
                  ]),
            ]),
        AriRouteItem(
          name: "page2",
          route: "page2",
          widget: (context) => Text("首页2"),
          icon: null, //Icon(Icons.home),
          hasNavigation: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
  }
}

/// 当[hasNavigation]为true时，children的widget不能为null
class TestRouterHasNavigationTrue_4 extends StatelessWidget {
  TestRouterHasNavigationTrue_4({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: true,
      navigationConfig: AriRouteItemNavigationConfig(
        initialRoute: "/",
      ),
      children: [
        AriRouteItem(
            name: "page1",
            route: "page1",
            widget: (context) => Text("page1"),
            icon: Icon(Icons.home),
            hasNavigation: false,
            children: [
              AriRouteItem(
                  name: "page1-1",
                  route: "children1",
                  widget: (context) => Text("children1"),
                  icon: Icon(Icons.home),
                  hasNavigation: false,
                  children: [
                    AriRouteItem(
                      name: "page1-1-1",
                      route: "children1-1",
                      widget: (context) => Text("children1-1"),
                      icon: Icon(Icons.home),
                      hasNavigation: false,
                    ),
                  ]),
            ]),
        AriRouteItem(
          name: "page2",
          route: "page2",
          widget: null, //(context) => Text("首页2"),
          icon: Icon(Icons.home),
          hasNavigation: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
  }
}

/// 当[hasNavigation]为true时，所有层级的children都不能设置hasNavigation为true
class TestRouterHasNavigationTrue_5 extends StatelessWidget {
  TestRouterHasNavigationTrue_5({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: true,
      navigationConfig: AriRouteItemNavigationConfig(
        initialRoute: "/",
      ),
      children: [
        AriRouteItem(
            name: "page1",
            route: "page1",
            widget: (context) => Text("page1"),
            icon: Icon(Icons.home),
            hasNavigation: false,
            children: [
              AriRouteItem(
                  name: "page1-1",
                  route: "children1",
                  widget: (context) => Text("children1"),
                  icon: Icon(Icons.home),
                  hasNavigation: true,
                  children: [
                    AriRouteItem(
                      name: "page1-1-1",
                      route: "children1-1",
                      widget: (context) => Text("children1-1"),
                      icon: Icon(Icons.home),
                      hasNavigation: false,
                    ),
                  ]),
            ]),
        AriRouteItem(
          name: "page2",
          route: "page2",
          widget: (context) => Text("首页2"),
          icon: Icon(Icons.home),
          hasNavigation: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
  }
}

class TestRouterHasNavigationTrue_5_2 extends StatelessWidget {
  TestRouterHasNavigationTrue_5_2({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: true,
      navigationConfig: AriRouteItemNavigationConfig(
        initialRoute: "/",
      ),
      children: [
        AriRouteItem(
            name: "page1",
            route: "page1",
            widget: (context) => Text("page1"),
            icon: Icon(Icons.home),
            hasNavigation: false,
            children: [
              AriRouteItem(
                  name: "page1-1",
                  route: "children1",
                  widget: (context) => Text("children1"),
                  icon: Icon(Icons.home),
                  hasNavigation: false,
                  children: [
                    AriRouteItem(
                      name: "page1-1-1",
                      route: "children1-1",
                      widget: (context) => Text("children1-1"),
                      icon: Icon(Icons.home),
                      hasNavigation: true,
                    ),
                  ]),
            ]),
        AriRouteItem(
          name: "page2",
          route: "page2",
          widget: (context) => Text("首页2"),
          icon: Icon(Icons.home),
          hasNavigation: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
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
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
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
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
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
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
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
          initialRoute: "/",
        ),
        children: [
          AriRouteItem(
              name: "TestRouterRoute-page2-1",
              route: "",
              widget: (context) => TextButton(
                    child: const Text('页面13232'),
                    key: Key('page1'), // 给按钮添加一个 key，以便在测试中找到它
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
              icon: Icon(Icons.abc),
              hasNavigation: false,
              children: [
                AriRouteItem(
                    name: "TestRouterRoute-page2-1-1",
                    route: "",
                    widget: (context) => Text(key: Key("page2"), "页面1-1"),
                    icon: Icon(Icons.abc),
                    hasNavigation: false),
                AriRouteItem(
                    name: "TestRouterRoute-page2-1-2",
                    route: "",
                    widget: (context) => Text(key: Key("page2"), "页面1-2"),
                    icon: Icon(Icons.abc),
                    hasNavigation: false)
              ]),
          AriRouteItem(
              name: "TestRouterRoute-page2-2",
              route: "",
              widget: (context) => Text(key: Key("page2"), "页面2"),
              icon: Icon(Icons.abc),
              hasNavigation: false),
        ]),
  ];

  @override
  Widget build(BuildContext context) {
    router.set(routes);
    return MaterialApp(initialRoute: '/', routes: router.get());
  }
}
