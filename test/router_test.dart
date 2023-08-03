import 'package:aries_design_flutter/router/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'package:aries_design_flutter/test/router_test.dart';

var logger = Logger();

void main() {
  testWidgets("测试hasNavigation的检测是否生效", (tester) async {
    try {
      await tester.pumpWidget(TestRouterHasNavigation());
    } catch (e) {
      expect(e, isInstanceOf<AssertionError>());
      if (e is AssertionError) {
        logger.d(e); // 输出异常的消息
      }
    }
  });
  testWidgets("测试name唯一性的检测是否生效", (tester) async {
    try {
      await tester.pumpWidget(TestRouterNameUnique());
    } catch (e) {
      expect(e, isInstanceOf<AssertionError>());
      if (e is AssertionError) {
        logger.d(e); // 输出异常的消息
      }
    }
    try {
      await tester.pumpWidget(TestRouterNameUnique2());
    } catch (e) {
      expect(e, isInstanceOf<AssertionError>());
      if (e is AssertionError) {
        AriRouter router = AriRouter();
        logger.i(router.getRoutes());
        logger.d(e); // 输出异常的消息
      }
    }
  });

  testWidgets("测试route是否正确", (tester) async {
    await tester.pumpWidget(TestRouterRoute());
    await tester.pumpAndSettle();

    AriRouter router = AriRouter();
    logger.i(router.getRoutes());
  });

  // testWidgets('测试router', (tester) async {
  //   await tester.pumpWidget(TestRouterPush());

  //   await tester.pumpAndSettle();

  //   // Tap the add button.
  //   await tester.tap(find.byKey(Key('loginButton')));

  //   // Rebuild the widget after the state has changed.
  //   await tester.pumpAndSettle();

  //   // Expect to find the item on screen.
  //   expect(find.byKey(Key('home')), findsOneWidget);
  //   expect(find.byKey(Key('loginButton')), findsNothing);
  // });
}
