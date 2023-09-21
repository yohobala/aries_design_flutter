import 'dart:async';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

enum _PageSlot {
  body,
  bottomNavigationBar,
}

class AriNavigationBarScaffold extends StatefulWidget {
  AriNavigationBarScaffold({
    Key? key,
    required this.body,
    required this.bottomNavigationBar,
  }) : super(key: key);
  final Widget body;
  final Widget bottomNavigationBar;

  static AriNavigationBarLayoutState? of(BuildContext context) {
    final AriNavigationBarLayoutState? result =
        context.findAncestorStateOfType<AriNavigationBarLayoutState>();
    return result;
  }

  @override
  State<AriNavigationBarScaffold> createState() =>
      AriNavigationBarLayoutState();
}

class AriNavigationBarLayoutState extends State<AriNavigationBarScaffold>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey _bodyKey = GlobalKey();

  // MODULE:
  // 软键盘相关参数
  double bottomViewInset = 0;
  double keyboardHeight = 0;
  double prevKeyboardHeight = 0;
  Timer? debounceTimer;
  bool isCalculateKeyboardHeight = false;
  ValueNotifier<bool> isKeyboardUp = ValueNotifier(false);
  late AnimationController keyboardAnimationController;
  late Animation keyboardAnimation;

  PersistentBottomSheetController? bottomSheetController; // 增加一个成员变量来存储控制器

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    keyboardAnimationController = AnimationController(
      duration: AriTheme.duration.medium1,
      vsync: this,
    );
    isKeyboardUp.addListener(() {
      if (keyboardAnimationController.status == AnimationStatus.completed ||
          keyboardAnimationController.status == AnimationStatus.dismissed) {
        if (isKeyboardUp.value) {
          keyboardAnimationController.forward().then((value) {});
        } else {
          keyboardAnimationController.reverse().then((value) {});
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 如果是第一次弹出软键盘,那么[isCalculateKeyboardHeight]是false
  /// bottomSheet会随着[bottomViewInset]变化,每次都会重新渲染
  ///
  /// 如果不是第一次弹出软键盘,判断[bottomViewInset]与[prevKeyboardHeight]来确定是升起还是收起
  ///
  /// 每次改变都会出现一个定时器,定时器结束的时候,
  /// - newHeight > keyboardHeight 那么说明需要改变软键盘的高度
  /// - 如果newHeight == 0 && keyboardHeight > 0 && !isCalculateKeyboardHeight,
  ///   则意味着是第一次弹出软键盘,并且此时是收起了状态,那么改变动画和[isCalculateKeyboardHeight],
  ///   并且刷新bottomSheet,因为有可能出现没有关闭bottomSheet又打开软键盘的情况
  @override
  void didChangeMetrics() {
    bottomViewInset = MediaQuery.of(context).viewInsets.bottom;

    if (!isCalculateKeyboardHeight) {
      bottomSheetController!.setState!(() {});
    } else {
      if (prevKeyboardHeight < bottomViewInset) {
        isKeyboardUp.value = true;
      } else if (prevKeyboardHeight > bottomViewInset) {
        isKeyboardUp.value = false;
      }
      prevKeyboardHeight = bottomViewInset;
    }
    debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: 200), () {
      final double newHeight = MediaQuery.of(context).viewInsets.bottom;
      if (newHeight > keyboardHeight) {
        keyboardHeight = newHeight;
      } else if (newHeight == 0 &&
          keyboardHeight > 0 &&
          !isCalculateKeyboardHeight) {
        isCalculateKeyboardHeight = true;
        keyboardAnimation = Tween<double>(begin: 0, end: keyboardHeight)
            .animate(keyboardAnimationController);
        bottomSheetController?.setState!(() {});
      }
    });
  }

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
      body: Stack(
        children: [
          CustomMultiChildLayout(
            delegate: BttonNavigationLayoutDelegate(),
            children: children,
          ),
        ],
      ),
    );
  }

  PersistentBottomSheetController showBottomSheet({
    required BuildContext context,
    required Color backgroundColor,
    required Widget Function(BuildContext) builder,
  }) {
    Widget child = builder(context);

    bottomSheetController = Scaffold.of(context).showBottomSheet(
      // (context) =>
      (context) => isCalculateKeyboardHeight
          ? AnimatedBuilder(
              animation: keyboardAnimation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: keyboardAnimation.value), // 控制垂直偏移
                  child: builder(context),
                );
              },
            )
          : Padding(
              padding: EdgeInsets.only(bottom: bottomViewInset),
              child: child,
            ),
      backgroundColor: backgroundColor,
    );

    return bottomSheetController!;
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
  State<_BodyBuilder> createState() => _BodyBuilderState();
}

class _BodyBuilderState extends State<_BodyBuilder>
    with WidgetsBindingObserver {
  _BodyBuilderState();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeMetrics() {
  //   final FlutterView view = View.of(context);
  //   final bottomInset = view.viewInsets.bottom;
  //   if (bottomInset > 0) {
  //     // Keyboard is shown
  //   } else {
  //     // Keyboard is hidden
  //   }
  // }

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
            child: widget.body,
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

class YourBottomSheet extends StatelessWidget {
  final VoidCallback onClose;

  YourBottomSheet({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.blue,
      child: Center(
        child: ElevatedButton(
          onPressed: onClose,
          child: Text('Close BottomSheet'),
        ),
      ),
    );
  }
}
