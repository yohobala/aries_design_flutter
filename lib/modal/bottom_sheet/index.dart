import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 创建一个控制器

class AriBottomSheetController {
  Function? _closeFunction;

  void setCloseFunction(Function closeFunction) {
    _closeFunction = closeFunction;
  }

  /// 关闭
  void close() {
    if (_closeFunction != null) {
      _closeFunction!();
    }
  }
}

/// 显示AirBottomSheet
///
/// *参数*
/// - `context`: 上下文
/// - `child`: 子组件
/// - `backgroundColor`: 背景颜色
/// - `initHeightFactor`: 初始化百分比高度
/// - `initMinHeight`: 初始化高度的最小高度
/// - `controller`: 控制器
/// - `snap`: 是否启用snap动画,启动后,当拖动bottomSheet,会自动移动到最近的[snapSizes]中的一个
/// - `snapSizes`: snap动画的大小,必须是从小到大排序的
///
/// [initHeightFactor]和[initMinHeight]是初始化高度的参数,它们会通过比较选取高度大的那个值为高度
void showAriBottomSheet(
  BuildContext context, {
  required Widget Function(
          BuildContext context, ScrollController? scrollController)
      child,
  Color? backgroundColor,
  double initHeightFactor = 0.5,
  double initMinHeight = 300,
  AriBottomSheetController? controller,
  bool snap = true,
  List<double> snapSizes = const [0.3, 0.5, 0.9],
}) {
  assert(snap == true ? snapSizes.isNotEmpty : true);
  final nbScaffold = AriNavigationBarScaffold.of(context);
  if (nbScaffold != null) {
    final sheetController = nbScaffold.showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AriBottomSheet(
          child: child,
          backgroundColor: backgroundColor,
          initHeightFactor: initHeightFactor,
          initMinHeight: initMinHeight,
          snap: snap,
          snapSizes: snapSizes,
        );
      },
    );
    void close() {
      sheetController.close();
    }

    // 将关闭函数保存到控制器中
    controller?.setCloseFunction(close);
  } else {
    final sheetController = showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AriBottomSheet(
          child: child,
          backgroundColor: backgroundColor,
          initHeightFactor: initHeightFactor,
          initMinHeight: initMinHeight,
          snap: snap,
          snapSizes: snapSizes,
        );
      },
    );
    void close() {
      sheetController.close();
    }

    // 将关闭函数保存到控制器中
    controller?.setCloseFunction(close);
  }
}

/// 底部弹出框
///
/// 可以通过[showAriBottomSheet]调用
///
/// [initHeightFactor]和[initMinHeight]是初始化高度的参数,它们会通过比较选取高度大的那个值为高度
class AriBottomSheet extends StatelessWidget {
  //*--- 构造函数 ---*
  /// 底部弹出框
  const AriBottomSheet({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.initHeightFactor = 0.5,
    this.initMinHeight = 300,
    this.snap = false,
    this.snapSizes = const [],
  }) : super(key: key);

  /// 子组件
  final Widget Function(
      BuildContext context, ScrollController? scrollController) child;

  /// 背景颜色
  final Color? backgroundColor;

  /// 初始化百分比高度
  final double initHeightFactor;

  /// 初始化高度的最小高度
  final double initMinHeight;

  final bool snap;

  final List<double> snapSizes;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: _AriBottomSheet(
        child: child,
        backgroundColor: backgroundColor,
        initHeightFactor: initHeightFactor,
        initMinHeight: initMinHeight,
        snap: snap,
        snapSizes: snapSizes,
      ),
    );
  }
}

class _AriBottomSheet extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 底部弹出框
  const _AriBottomSheet({
    Key? key,
    required this.child,
    this.backgroundColor,
    required this.initHeightFactor,
    required this.initMinHeight,
    required this.snap,
    required this.snapSizes,
  })  : assert(snap == true ? snapSizes.length > 0 : true),
        super(key: key);

  /// 子组件
  final Widget Function(
      BuildContext context, ScrollController? scrollController) child;

  /// 背景颜色
  final Color? backgroundColor;

  /// 初始化百分比高度
  final double initHeightFactor;

  /// 初始化高度的最小高度
  final double initMinHeight;

  final bool snap;

  final List<double> snapSizes;

  @override
  State<StatefulWidget> createState() => _AriBottomSheetState();
}

class _AriBottomSheetState extends State<_AriBottomSheet>
    with TickerProviderStateMixin {
  bool isInit = false;

  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  late double heightFactor;
  late double height;
  late double minChildSize;
  late double maxChildSize;
  @override
  void initState() {
    super.initState();
    // NOTE:
    // 解决了即使解决了即使_draggableController附加到widget中, _draggableController.isAttached依然为false
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;

      double screenHeight = MediaQuery.of(context).size.height;
      double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      double availableHeight = screenHeight - keyboardHeight;
      double dynamicHeight = availableHeight * widget.initHeightFactor;

      double minHeight = widget.initMinHeight;
      height = max(minHeight, dynamicHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snap) {
      double screenHeight = MediaQuery.of(context).size.height;
      heightFactor = recalculateHeight(context, height, screenHeight);
      minChildSize = widget.snapSizes.isNotEmpty
          ? widget.snapSizes.first - 0.01
          : heightFactor;
      maxChildSize =
          widget.snapSizes.isNotEmpty ? widget.snapSizes.last : heightFactor;
    }
    return widget.snap
        ? DraggableScrollableSheet(
            controller: _draggableController,
            expand: false,
            snap: widget.snap,
            snapSizes: widget.snap ? widget.snapSizes : null,
            initialChildSize: heightFactor,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (BuildContext context, ScrollController scrollController) {
              return RepaintBoundary(
                child: GestureDetector(
                  // NOTE:
                  // 添加_draggableController.isAttached添加判断 => 避免出现
                  // `DraggableScrollableController not Attached to any scroll views`,导致的不能滑动
                  onVerticalDragUpdate: _draggableController.isAttached
                      ? (details) {
                          if (widget.snap) {
                            double newPosition = _draggableController.pixels -
                                details.delta.dy; // 1000 是一个缩放因子，你可以根据需要调整
                            double size =
                                _draggableController.pixelsToSize(newPosition);
                            // newPosition = newPosition.clamp(0.0, 1.0); // 确保新位置在有效范围内
                            _draggableController.jumpTo(
                              size,
                            );
                          } else {
                            return;
                          }
                        }
                      : null,
                  // 放手后的动画
                  onVerticalDragEnd: _draggableController.isAttached
                      ? (details) {
                          if (widget.snap) {
                            double velocity =
                                details.primaryVelocity ?? 0; // 获取速度
                            double currentPixels =
                                _draggableController.pixels; // 当前像素,也就是当前大小

                            // NOTE:
                            // 创建 _SnappingSimulation
                            // 源代码里_SnappingSimulation的速度是可滑动列表内容的滑动速度,
                            // 所以对可滑动列表向上滑动的时候,源代码里的velocity是正数.
                            // 但是这里获得的速度是手指移动速度,手指向上滑动,速度是负数.
                            // 所有速度需要取反
                            final Simulation simulation = _SnappingSimulation(
                              position: currentPixels,
                              initialVelocity: -velocity,
                              pixelSnapSize: widget.snapSizes
                                  .map((size) =>
                                      _draggableController.sizeToPixels(size))
                                  .toList(),
                              snapAnimationDuration:
                                  Duration(milliseconds: 300),
                              tolerance: Tolerance(),
                            );

                            // 创建 AnimationController
                            final AnimationController controller =
                                AnimationController.unbounded(
                              vsync: this, // 你需要提供一个TickerProvider
                            );

                            // 监听 AnimationController
                            controller.addListener(() {
                              _draggableController.jumpTo(_draggableController
                                  .pixelsToSize(controller.value));
                            });

                            // 使用 _SnappingSimulation 开始动画
                            controller.animateWith(simulation).then((_) {
                              // 动画完成后的操作
                              controller.dispose();
                            });
                          } else {
                            return;
                          }
                        }
                      : null,
                  child: Container(
                    decoration: AriThemeColor.of(context).modal.bottomSheet,
                    padding: AriTheme.modal.bottomSheetContainer.padding,
                    child: Column(children: [
                      if (widget.snap)
                        Center(
                          child: Container(
                            height: 5,
                            width: 80,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.all(
                                  AriTheme.borderRadius.standard),
                            ),
                          ),
                        ),
                      // NOTE:
                      // 添加Expanded => 修复了Colum和ListView的渲染冲突
                      Expanded(
                        child: widget.child(context, scrollController),
                      )
                    ]),
                  ),
                ),
              );
            },
          )
        : RepaintBoundary(
            child: Container(
              height: height,
              width: MediaQuery.of(context).size.width,
              decoration: AriThemeColor.of(context).modal.bottomSheet,
              // color: widget.backgroundColor ??
              //     theme.colorScheme.background.withOpacity(0.4),
              padding: AriTheme.modal.bottomSheetContainer.padding,
              child: widget.child(context, null),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _draggableController.dispose();
  }
}

double recalculateHeight(
    BuildContext context, double height, double screenHeight) {
  double keyboardHeight;
  var nbScaffold = AriNavigationBarScaffold.of(context);
  if (nbScaffold != null) {
    keyboardHeight = nbScaffold.bottomViewInset;
  } else {
    ScaffoldState state = Scaffold.of(context);
    keyboardHeight = MediaQuery.of(state.context).viewInsets.bottom;
  }

  double factor = height / (screenHeight - keyboardHeight);

  return (factor * 100).ceilToDouble() / 100;
}

/// @copy
/// flutter/lib/scr/widgets/draggable_scrollable_sheet.dart
///
/// 复制了flutter中DraggableScrollableSheet关于snap动画的实现
class _SnappingSimulation extends Simulation {
  _SnappingSimulation({
    required this.position,
    required double initialVelocity,
    required List<double> pixelSnapSize,
    Duration? snapAnimationDuration,
    super.tolerance,
  }) {
    _pixelSnapSize = _getSnapSize(initialVelocity, pixelSnapSize);

    if (snapAnimationDuration != null &&
        snapAnimationDuration.inMilliseconds > 0) {
      velocity = (_pixelSnapSize - position) *
          1000 /
          snapAnimationDuration.inMilliseconds;
    }
    // Check the direction of the target instead of the sign of the velocity because
    // we may snap in the opposite direction of velocity if velocity is very low.
    else if (_pixelSnapSize < position) {
      velocity = math.min(-minimumSpeed, initialVelocity);
    } else {
      velocity = math.max(minimumSpeed, initialVelocity);
    }
  }

  final double position;
  late final double velocity;

  // A minimum speed to snap at. Used to ensure that the snapping animation
  // does not play too slowly.
  static const double minimumSpeed = 1600.0;

  late final double _pixelSnapSize;

  @override
  double dx(double time) {
    if (isDone(time)) {
      return 0;
    }
    return velocity;
  }

  @override
  bool isDone(double time) {
    return x(time) == _pixelSnapSize;
  }

  @override
  double x(double time) {
    final double newPosition = position + velocity * time;
    if ((velocity >= 0 && newPosition > _pixelSnapSize) ||
        (velocity < 0 && newPosition < _pixelSnapSize)) {
      // We're passed the snap size, return it instead.
      return _pixelSnapSize;
    }
    return newPosition;
  }

  // Find the two closest snap sizes to the position. If the velocity is
  // non-zero, select the size in the velocity's direction. Otherwise,
  // the nearest snap size.
  double _getSnapSize(double initialVelocity, List<double> pixelSnapSizes) {
    final int indexOfNextSize =
        pixelSnapSizes.indexWhere((double size) => size >= position);
    if (indexOfNextSize == 0) {
      return pixelSnapSizes.first;
    }
    final double nextSize = pixelSnapSizes[indexOfNextSize];
    final double previousSize = pixelSnapSizes[indexOfNextSize - 1];
    if (initialVelocity.abs() <= tolerance.velocity) {
      // If velocity is zero, snap to the nearest snap size with the minimum velocity.
      if (position - previousSize < nextSize - position) {
        return previousSize;
      } else {
        return nextSize;
      }
    }
    // Snap forward or backward depending on current velocity.
    if (initialVelocity < 0.0) {
      return pixelSnapSizes[indexOfNextSize - 1];
    }
    return pixelSnapSizes[indexOfNextSize];
  }
}
