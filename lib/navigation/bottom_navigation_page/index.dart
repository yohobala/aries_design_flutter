import 'dart:ui';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

typedef OnTapcallback = void Function(int);

typedef BottomNavigationBarBuilder = Widget Function(
    BuildContext context,
    List<AriRouteItem> navigationItems,
    int selectedIndex,
    OnTapcallback onTap)?;

enum _PageSlot { body, bottomNavigationBar }

class BttonNavigationLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    double contentTop = 0.0;
    double bottomNavigationBarTop = 0.0;
    double bottomWidgetsHeight = 0.0;
    final BoxConstraints looseConstraints = BoxConstraints.loose(size);
    final fullWidthConstraints = looseConstraints.tighten(width: size.width);

    // bottomNavigationBar
    if (hasChild(_PageSlot.bottomNavigationBar)) {
      final double bottomNavigationBarHeight =
          layoutChild(_PageSlot.bottomNavigationBar, fullWidthConstraints)
              .height;
      bottomWidgetsHeight += bottomNavigationBarHeight;
      bottomNavigationBarTop = math.max(0.0, size.height - bottomWidgetsHeight);
      positionChild(
          _PageSlot.bottomNavigationBar, Offset(0.0, bottomNavigationBarTop));
    }

    // body
    if (hasChild(_PageSlot.body)) {
      final double contentBottom = size.height - bottomWidgetsHeight;
      double bodyMaxHeight = math.max(0.0, contentBottom - contentTop);

      bodyMaxHeight += bottomWidgetsHeight;
      bodyMaxHeight = clampDouble(
          bodyMaxHeight, 0.0, looseConstraints.maxHeight - contentTop);
      assert(bodyMaxHeight <=
          math.max(0.0, looseConstraints.maxHeight - contentTop));

      final BoxConstraints bodyConstraints = _BodyBoxConstraints(
        maxWidth: fullWidthConstraints.maxWidth,
        maxHeight: fullWidthConstraints.maxHeight,
        bottomWidgetsHeight: bottomWidgetsHeight,
      );
      layoutChild(_PageSlot.body, bodyConstraints);
      positionChild(_PageSlot.body, Offset(0.0, contentTop));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

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

class __AriBottomNavigationPageState extends State<AriBottomNavigationPage> {
  int selectedIndex = 0;
  String initialRoute = "/";

  final GlobalKey _bodyKey = GlobalKey();
  final GlobalKey _mediaQueryKey = GlobalKey();

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
    final List<LayoutId> children = <LayoutId>[];

    // NOTE:
    // Scaffold的MediaQueryData会自带TopPadding,和BottomPadding
    // body需要TopPadding,bottomNavigationBar不需要
    addIfNonNull(
      context,
      children,
      _BodyBuilder(
        mediaQueryKey: _mediaQueryKey,
        body: KeyedSubtree(
          key: _bodyKey,
          child: AriNavigatorGroup(
            initialRoute: initialRoute,
            routeItems: widget.routeItem.children,
            selectedIndex: selectedIndex,
          ),
        ),
      ),
      _PageSlot.body,
      removeLeftPadding: false,
      removeTopPadding: false,
      removeRightPadding: false,
      removeBottomPadding: false,
    );
    addIfNonNull(
      context,
      children,
      AriBottonNavigationBar(
        key: bottomNavigationBarKey,
        navigationItems: widget.routeItem.children,
        initSelectedIndex: selectedIndex,
        itemChangeCallback: (int index, String route) {
          setState(() {
            selectedIndex = index;
          });
        },
        navigationBar: widget.navigationBar,
        showNavigationBar: widget.showNavigationBar,
      ),
      _PageSlot.bottomNavigationBar,
      removeLeftPadding: false,
      removeTopPadding: true,
      removeRightPadding: false,
      removeBottomPadding: false,
    );
    return Scaffold(
        /*
      * 底部导航栏，点击后会改变[selectedIndex]
      * 从而触发更新setState,重新渲染[RouteWidgets]
      */
        // bottomNavigationBar: navigationBar,
        extendBody: true,
        body: CustomMultiChildLayout(
          delegate: BttonNavigationLayoutDelegate(),
          children: children,
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _BodyBuilder extends StatelessWidget {
  const _BodyBuilder({
    required this.body,
    required this.mediaQueryKey,
  });

  final Widget body;
  final Key mediaQueryKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _BodyBoxConstraints bodyConstraints =
            constraints as _BodyBoxConstraints;
        final MediaQueryData metrics = MediaQuery.of(context);

        final double bottom = math.max(
            metrics.padding.bottom, bodyConstraints.bottomWidgetsHeight);

        return MediaQuery(
          key: mediaQueryKey,
          data: metrics.copyWith(
            padding: metrics.padding.copyWith(
              top: metrics.padding.top,
              bottom: bottom,
            ),
          ),
          child: body,
        );
      },
    );
  }
}

class _BodyBoxConstraints extends BoxConstraints {
  const _BodyBoxConstraints({
    super.maxWidth,
    super.maxHeight,
    required this.bottomWidgetsHeight,
  }) : assert(bottomWidgetsHeight >= 0);

  final double bottomWidgetsHeight;

  // RenderObject.layout() will only short-circuit its call to its performLayout
  // method if the new layout constraints are not == to the current constraints.
  // If the height of the bottom widgets has changed, even though the constraints'
  // min and max values have not, we still want performLayout to happen.
  @override
  bool operator ==(Object other) {
    if (super != other) {
      return false;
    }
    return other is _BodyBoxConstraints &&
        other.bottomWidgetsHeight == bottomWidgetsHeight;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, bottomWidgetsHeight);
}
