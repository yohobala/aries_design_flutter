import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 背景渐变的按钮
class AriGradientButton extends StatelessWidget {
  const AriGradientButton({
    Key? key,
    required this.child,
    required this.gradient,
    required this.onPressed,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.style,
    this.padding,
  }) : super(key: key);

  //*--- 公有变量 ---*
  /// 按钮的子组件
  final Widget child;

  /// 按钮的渐变色
  final Gradient gradient;

  /// 按钮的宽度
  final double? width;

  /// 按钮的高度
  final double? height;

  /// 按钮的形状
  final BoxShape shape;

  final BorderRadius? borderRadius;

  final ButtonStyle? style;

  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;

  /// 按钮的点击事件
  final void Function() onPressed;

  //*--- 生命周期 ---*
  /*
   * InkWell需要放在一个Material组件中才能正确显示涟漪效果。
   */
  @override
  Widget build(BuildContext context) {
    ButtonStyle? buttonStyle =
        style ?? AriThemeColor.of(context).button.gradientButton;
    if (padding != null) {
      buttonStyle = buttonStyle.copyWith(
        padding: padding!,
      );
    }
    return Container(
      width: width ?? AriTheme.button.buttonSize.resolve({}).width,
      height: height ?? AriTheme.button.buttonSize.resolve({}).height,
      decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ],
          borderRadius: borderRadius,
          shape: shape),
      child: FilledButton(
        onPressed: () => {},
        child: child,
        style: buttonStyle,
      ),
    );
  }
}
