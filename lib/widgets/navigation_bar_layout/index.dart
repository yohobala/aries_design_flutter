import 'package:aries_design_flutter/widgets/Index.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

enum _PageSlot {
  body,
  bottomNavigationBar,
  bottomSheet,
}

class AriNavigationBarScaffold extends StatefulWidget {
  AriNavigationBarScaffold({
    Key? key,
    required this.body,
    required this.bottomNavigationBar,
  }) : super(key: key);
  final Widget body;
  final Widget bottomNavigationBar;

  static _AriNavigationBarLayoutState? of(BuildContext context) {
    final _AriNavigationBarLayoutState? result =
        context.findAncestorStateOfType<_AriNavigationBarLayoutState>();
    return result;
  }

  @override
  State<AriNavigationBarScaffold> createState() =>
      _AriNavigationBarLayoutState();
}

class _AriNavigationBarLayoutState extends State<AriNavigationBarScaffold> {
  final GlobalKey _bodyKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final List<LayoutId> children = <LayoutId>[];
    addIfNonNull(
      context,
      children,
      _BodyBuilder(
        body: KeyedSubtree(
          key: _bodyKey,
          child: widget.body,
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
      widget.bottomNavigationBar,
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

      resizeToAvoidBottomInset: false,
      body: CustomMultiChildLayout(
        delegate: BttonNavigationLayoutDelegate(),
        children: children,
      ),
    );
  }
}

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
        minWidth: size.width,
        maxWidth: size.width,
        minHeight: size.height,
        maxHeight: size.height,
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

class _BodyBuilder extends StatefulWidget {
  _BodyBuilder({
    required this.body,
  });

  final Widget body;
  @override
  State<_BodyBuilder> createState() => _BodyBuilderState(body: body);
}

class _BodyBuilderState extends State<_BodyBuilder>
    with WidgetsBindingObserver {
  _BodyBuilderState({
    required this.body,
  });

  final Widget body;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final FlutterView view = View.of(context);
    final bottomInset = view.viewInsets.bottom;
    if (bottomInset > 0) {
      // Keyboard is shown
    } else {
      // Keyboard is hidden
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _BodyBoxConstraints bodyConstraints =
            constraints as _BodyBoxConstraints;
        final MediaQueryData metrics = MediaQuery.of(context);

        final double bottom = math.max(
            metrics.padding.bottom, bodyConstraints.bottomWidgetsHeight);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: MediaQuery(
            data: metrics.copyWith(
              padding: metrics.padding.copyWith(
                top: metrics.padding.top,
                bottom: bottom,
              ),
            ),
            child: body,
          ),
        );
      },
    );
  }
}

class _BodyBoxConstraints extends BoxConstraints {
  const _BodyBoxConstraints({
    super.maxWidth,
    super.maxHeight,
    super.minHeight,
    super.minWidth,
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
