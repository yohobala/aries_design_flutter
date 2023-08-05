import 'package:aries_design_flutter/router/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'package:aries_design_flutter/test/router_test.dart';

var logger = Logger();

void main() {
  //**************** 测试hasNavigation 的检测是否生效 ****************
  // testWidgets("当[hasNavigation]为false时，widget不能为null", (tester) async {
  //   try {
  //     await tester.pumpWidget(TestRouterHasNavigationFalse());
  //   } catch (e) {
  //     expect(e, isInstanceOf<AssertionError>());
  //     if (e is AssertionError) {
  //       logger.d(e); // 输出异常的消息
  //     }
  //   }
  //   AriRouter.clear();
  // });
  // testWidgets("当[hasNavigation]为true时，children的数量必须大于等于2", (tester) async {
  //   try {
  //     await tester.pumpWidget(TestRouterHasNavigationTrue_1());
  //   } catch (e) {
  //     expect(e, isInstanceOf<AssertionError>());
  //     if (e is AssertionError) {
  //       logger.d(e); // 输出异常的消息
  //     }
  //   }
  //   AriRouter.clear();
  // });

  // testWidgets("当[hasNavigation]为true时，children的icon不能为null", (tester) async {
  //   try {
  //     await tester.pumpWidget(TestRouterHasNavigationTrue_3());
  //   } catch (e) {
  //     expect(e, isInstanceOf<AssertionError>());
  //     if (e is AssertionError) {
  //       logger.d(e); // 输出异常的消息
  //     }
  //   }
  //   AriRouter.clear();
  // });
  // testWidgets("当[hasNavigation]为true时，children的widget不能为null", (tester) async {
  //   try {
  //     await tester.pumpWidget(TestRouterHasNavigationTrue_4());
  //   } catch (e) {
  //     expect(e, isInstanceOf<AssertionError>());
  //     if (e is AssertionError) {
  //       logger.d(e); // 输出异常的消息
  //     }
  //   }
  //   AriRouter.clear();
  // });

  // testWidgets("当[hasNavigation]为true时，所有层级的children都不能设置hasNavigation为true",
  //     (tester) async {
  //   try {
  //     await tester.pumpWidget(TestRouterHasNavigationTrue_5());
  //   } catch (e) {
  //     expect(e, isInstanceOf<AssertionError>());
  //     if (e is AssertionError) {
  //       logger.d(e); // 输出异常的消息
  //     }
  //   }
  //   AriRouter.clear();
  //   try {
  //     await tester.pumpWidget(TestRouterHasNavigationTrue_5_2());
  //   } catch (e) {
  //     expect(e, isInstanceOf<AssertionError>());
  //     if (e is AssertionError) {
  //       logger.d(e); // 输出异常的消息
  //     }
  //   }
  //   AriRouter.clear();
  // });

//**************** 测试name唯一性的检测是否生效 ****************

  // testWidgets("测试name唯一性的检测是否生效", (tester) async {
  //   try {
  //     await tester.pumpWidget(TestRouterNameUnique());
  //   } catch (e) {
  //     expect(e, isInstanceOf<AssertionError>());
  //     if (e is AssertionError) {
  //       logger.d(e); // 输出异常的消息
  //     }
  //   }
  //   try {
  //     await tester.pumpWidget(TestRouterNameUnique2());
  //   } catch (e) {
  //     expect(e, isInstanceOf<AssertionError>());
  //     if (e is AssertionError) {
  //       AriRouter router = AriRouter();
  //       logger.d(e); // 输出异常的消息
  //     }
  //   }
  // });

  // testWidgets("测试route是否正确", (tester) async {
  //   await tester.pumpWidget(TestRouterRoute());
  //   await tester.pumpAndSettle();

  //   AriRouter router = AriRouter();
  //   Map<String, Widget Function(BuildContext)> routes = router.get();
  //   logger.i(routes);
  // });

  testWidgets('测试router', (tester) async {
    await tester.pumpWidget(TestRouterPush());

    await tester.pumpAndSettle();
    AriRouter router = AriRouter();
    logger.i(router.get());

    await tester.tap(find.byKey(Key('page1-Button')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('page2-1-Button')), findsOneWidget);

    await tester.tap(find.byKey(Key('page2-1-Button')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('page2-1-1-Button')), findsOneWidget);

    await tester.tap(find.byKey(Key('page2-1-1-Button')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('page2-1-2-Button')), findsOneWidget);

    await tester.tap(find.byKey(Key('page2-1-2-Button')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('page1-Button')), findsOneWidget);
  });
}
