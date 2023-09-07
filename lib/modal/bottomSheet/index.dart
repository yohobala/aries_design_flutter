import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

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
    required this.children,
    this.backgroundColor,
    this.heightFactor = 0.5,
    this.minHeight = 300,
  }) : super(key: key);

  /// 子组件
  final List<Widget> children;

  /// 背景颜色
  final Color? backgroundColor;

  /// 百分比高度
  final double heightFactor;

  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: _AriBottomSheet(
        children: children,
        backgroundColor: backgroundColor,
        heightFactor: heightFactor,
        minHeight: minHeight,
      ),
    );
  }
}

/// 显示AirBottomSheet
///
/// - `context` 上下文
void showAriBottomSheet(
  BuildContext context, {
  required List<Widget> children,
  Color? backgroundColor,
  double heightFactor = 0.5,
  double minHeight = 300,
  AriBottomSheetController? controller,
}) {
  final sheetController = showBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _AriBottomSheet(
        children: children,
        backgroundColor: backgroundColor,
        heightFactor: heightFactor,
        minHeight: minHeight,
      );
    },
  );

  // 将关闭函数保存到控制器中
  controller?.closeFunction = () {
    sheetController.close();
  };
}

// 创建一个控制器
class AriBottomSheetController {
  VoidCallback? closeFunction;

  /// 关闭
  void close() {
    closeFunction?.call();
  }
}

class _AriBottomSheet extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 底部弹出框
  const _AriBottomSheet({
    Key? key,
    required this.children,
    this.backgroundColor,
    this.heightFactor = 0.5,
    this.minHeight = 300,
  }) : super(key: key);

  /// 子组件
  final List<Widget> children;

  /// 背景颜色
  final Color? backgroundColor;

  /// 百分比高度
  final double heightFactor;

  final double minHeight;

  @override
  State<StatefulWidget> createState() => _AriBottomSheetState();
}

class _AriBottomSheetState extends State<_AriBottomSheet> {
  late final double finalHeight;
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
      // NOTE:
      // 计算高度
      double screenHeight = MediaQuery.of(context).size.height;
      double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      double availableHeight = screenHeight - keyboardHeight;
      double dynamicHeight = availableHeight * widget.heightFactor;

      double minHeight = widget.minHeight;
      finalHeight = max(minHeight, dynamicHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    AriThemeColor theme = AriThemeController().getThemeColor(brightness);
    return Container(
      height: finalHeight,
      width: MediaQuery.of(context).size.width,
      child: Container(
        // NOTE:
        // 设置了容器的圆角，阴影
        // 这个圆角这主要影响容器自身的边界。如
        // 果容器内部有其他元素（如图片、背景色等）超出了这个边界，这些元素不会被裁剪
        decoration: theme.modal.bottomSheet,
        // 使用 ClipRect 这个组件实际上会裁剪其子组件，
        // 防止模糊效果超过容器范围
        child: ClipRRect(
          borderRadius: AriTheme.modal.bottomSheet.borderRadius!,
          child: BackdropFilter(
            filter: AriTheme.filter.standard,
            child: Container(
              color: widget.backgroundColor ??
                  theme.colorScheme.background.withOpacity(0.8),
              padding: AriTheme.modal.bottomSheetContainer.padding,
              child: _build(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _build() {
    return Column(
      children: widget.children,
    );
  }
}
