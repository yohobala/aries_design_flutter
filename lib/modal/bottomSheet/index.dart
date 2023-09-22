import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

// 创建一个控制器
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
/// - `context` 上下文
void showAriBottomSheet(
  BuildContext context, {
  required ScrollableWidgetBuilder child,
  Color? backgroundColor,
  double heightFactor = 0.5,
  double minHeight = 300,
  AriBottomSheetController? controller,
  bool snap = true,
  List<double> snapSizes = const [0.3, 0.5, 0.9],
}) {
  final nbScaffold = AriNavigationBarScaffold.of(context);
  double factor = recalculateHeight(context, heightFactor, minHeight);
  if (nbScaffold != null) {
    final sheetController = nbScaffold.showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AriBottomSheet(
          child: child,
          backgroundColor: backgroundColor,
          heightFactor: factor,
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
          heightFactor: factor,
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
///
class AriBottomSheet extends StatelessWidget {
  //*--- 构造函数 ---*
  /// 底部弹出框
  const AriBottomSheet({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.heightFactor = 0.5,
    this.minHeight = 300,
    this.snap = false,
    this.snapSizes = const [],
  }) : super(key: key);

  /// 子组件
  final ScrollableWidgetBuilder child;

  /// 背景颜色
  final Color? backgroundColor;

  /// 百分比高度
  final double heightFactor;

  final double minHeight;

  final bool snap;

  final List<double> snapSizes;

  @override
  Widget build(BuildContext context) {
    double factor = recalculateHeight(context, heightFactor, minHeight);
    return Align(
      alignment: Alignment.bottomCenter,
      child: _AriBottomSheet(
        child: child,
        backgroundColor: backgroundColor,
        heightFactor: factor,
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
    this.heightFactor = 0.5,
    required this.snap,
    required this.snapSizes,
  })  : assert(snap == true ? snapSizes.length > 0 : true),
        super(key: key);

  /// 子组件
  final ScrollableWidgetBuilder child;

  /// 背景颜色
  final Color? backgroundColor;

  /// 百分比高度
  final double heightFactor;

  final bool snap;

  final List<double> snapSizes;

  @override
  State<StatefulWidget> createState() => _AriBottomSheetState();
}

class _AriBottomSheetState extends State<_AriBottomSheet> {
  bool isInit = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double minChildSize;
    double maxChildSize;
    if (widget.snap) {
      minChildSize = widget.snapSizes.isNotEmpty
          ? widget.snapSizes.first - 0.01
          : widget.heightFactor;
      maxChildSize = widget.snapSizes.isNotEmpty
          ? widget.snapSizes.last
          : widget.heightFactor;
    } else {
      minChildSize = widget.heightFactor;
      maxChildSize = widget.heightFactor;
    }
    return DraggableScrollableSheet(
      expand: false,
      snap: widget.snap,
      snapSizes: widget.snap ? widget.snapSizes : null,
      initialChildSize: widget.heightFactor,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (BuildContext context, ScrollController scrollController) {
        return RepaintBoundary(
          child: Container(
            decoration: AriThemeColor.of(context).modal.bottomSheet,
            padding: AriTheme.modal.bottomSheetContainer.padding,
            child: widget.child(context, scrollController),
          ),
        );
      },
    );
  }
}

double recalculateHeight(
    BuildContext context, double heightFactor, double minHeight) {
  double screenHeight = MediaQuery.of(context).size.height;
  double dynamicHeight = screenHeight * heightFactor;
  double height = max(minHeight, dynamicHeight);

  ScaffoldState state = Scaffold.of(context);
  double keyboardHeight = MediaQuery.of(state.context).viewInsets.bottom;
  double factor = height / (screenHeight - keyboardHeight);

  return factor;
}
