import 'package:aries_design_flutter/router/index.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

/// 测试hasNavigation 的检测是否生效
/// 当[hasNavigation]为true时，[navigationConfig]和[icon]必须设置
class TestRouterHasNavigation extends StatelessWidget {
  TestRouterHasNavigation({super.key});
  AriRouter router = AriRouter();

  List<AriRouteItem> routes = [
    AriRouteItem(
      route: "/",
      name: "首页",
      widget: (context) => Text("首页"),
      index: 0,
      hasNavigation: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    router.setRoutes(routes);
    return MaterialApp(initialRoute: '/', routes: router.getRoutes());
  }
}

/// 测试router是否能正确跳转
// class TestRouterPush extends StatelessWidget {
//   AriRouter router = AriRouter();
//   @override
//   Widget build(BuildContext context) {
//     var home = Text(
//       "首页",
//       key: Key('home'),
//     );
//     List<AriRouteItem> routes = [
//       AriRouteItem(
//         route: "/",
//         name: "首页",
//         widget: (context) => TextButton(
//           child: const Text('登录'),
//           key: Key('loginButton'), // 给按钮添加一个 key，以便在测试中找到它
//           onPressed: () {
//             // 导航到 home 页面
//             Navigator.pushNamed(context, '/home');
//           },
//         ),
//         index: 0,
//         icon: const Icon(Icons.abc),
//       ),
//       AriRouteItem(
//           route: "/home",
//           name: "新页面",
//           widget: (context) => home,
//           index: 1,
//           icon: Icon(Icons.abc),
//           hasNavigation: true,
//           navigationConfig: AriRouteItemNavigationConfig(
//               initialRoute: "/home", navigationItemNames: ["首页", "我的"]),
//           children: [
//             AriRouteItem(
//                 name: "我的", widget: (context) => Text("我的"), route: "/mine"),
//             AriRouteItem(
//                 name: "首页", widget: (context) => Text("首页"), route: "/home"),
//           ]),
//     ];
//     router.setRoutes(routes);
//     return MaterialApp(initialRoute: '/', routes: router.getRoutes());
//   }
// }
