import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 底部弹出框
///
/// 可以通过[showAriBottomSheet]调用
///
///
class AriBottomSheet extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 底部弹出框
  const AriBottomSheet(
      {Key? key,
      required this.children,
      this.backgroundColor,
      this.heightFactor = 0.5})
      : super(key: key);

  /// 子组件
  final List<Widget> children;

  /// 背景颜色
  final Color? backgroundColor;

  /// 百分比高度
  final double? heightFactor;

  @override
  State<StatefulWidget> createState() => AriBottomSheetState();
}

class AriBottomSheetState extends State<AriBottomSheet> {
  @override
  Widget build(BuildContext context) {
    AriTheme.insets.extraLarge;
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    AriThemeColor theme = AriThemeController().getThemeColor(brightness);
    return Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: widget.heightFactor,
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
                      theme.colorScheme.surface.withOpacity(0.6),
                  padding: AriTheme.modal.bottomSheetContainer.padding,
                  child: _build(),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _build() {
    return Column(
      children: widget.children,
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
  double? heightFactor,
}) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AriBottomSheet(
        children: children,
        backgroundColor: backgroundColor,
        heightFactor: heightFactor,
      );
    },
  );
}
