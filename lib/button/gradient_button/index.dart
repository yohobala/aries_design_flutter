import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

class GradientButton extends StatelessWidget {
  //*--- 构造函数 ---*
  /// 渐变按钮
  const GradientButton({
    Key? key,
    required this.child,
    required this.gradient,
    required this.onPressed,
    this.width,
    this.height,
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

  /// 按钮的点击事件
  final void Function() onPressed;

  //*--- 生命周期 ---*
  /*
   * InkWell需要放在一个Material组件中才能正确显示涟漪效果。
   */
  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    AriThemeColor themeColor = AriThemeController().getTheme(brightness);

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
          borderRadius: BorderRadius.all(AriTheme.borderRadius.standard)),
      child: FilledButton(
        onPressed: () => {},
        child: child,
        style: themeColor.button.gradientButton,
      ),
    );
  }
}
