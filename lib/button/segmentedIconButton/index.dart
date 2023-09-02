import 'package:aries_design_flutter/button/iconButton/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/index.dart';
import '../index.dart';

/// 分段图标按钮
///
/// 支持横向排列和纵向排列
///
/// 如果只有一个button，会变成圆形按钮
///
/// *示例代码*
/// ```dart
/// AriSegmentedIconButton(buttons: [
///   AriMapLocationButton(ariMapController: ariMapController),
/// ])
/// ```
class AriSegmentedIconButton extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 分段图标按钮
  ///
  /// - `buttons` 按钮列表
  /// - `width` 图标宽度，默认为[AriTheme.button.segmentedIconButtonSize]的宽度
  /// - `direction` 排列方向，默认为[Axis.vertical]
  AriSegmentedIconButton(
      {Key? key,
      required this.buttons,
      double? width,
      this.direction = Axis.vertical})
      : width = width ??= AriTheme.button.segmentedIconButtonSize;

  //*--- 公有变量 ---*
  /// 按钮列表
  final List<AriIconButton> buttons;

  /// 图标宽度
  final double width;

  /// 排列方向
  final Axis direction;

  @override
  State<StatefulWidget> createState() => _AriSegmentedIconButton();
}

class _AriSegmentedIconButton extends State<AriSegmentedIconButton> {
  //*--- 私有变量 ---*
  // Brightness _brightness;

  //*--- 生命周期 ---*
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 获取系统的亮度和主题
    // 一个状态管理库 Provider。
    // 在顶层的Widget中获取亮度值，并将其提供给应用中的其他部分。
    // 这样，当亮度变化时，只有依赖于亮度值的部分会被重建，其他部分不会受到影响。
    // 通过 下面的代码，添加
    // ```dart
    // Provider<Brightness>.value(
    //   value: brightness,
    //   child: MyHomePage(),
    // );
    // ```
    // 之后就可以在子节点获取Provider.of<Brightness>(context);
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    AriThemeColor themeColor = AriThemeController().getThemeColor(brightness);

    // 建立按钮列表
    var buttonList = _BuildButtonList(
            buttons: widget.buttons,
            width: widget.width,
            direction: widget.direction,
            style: themeColor.button.segmentedIconButton)
        .build();

    // 设置容器样式
    Decoration decoration = themeColor.button.segmentedIconButtonContainer;
    if (buttonList.length == 1) {
      decoration = themeColor.button.segmentedIconButtonContainer.copyWith(
          borderRadius: BorderRadius.all(AriTheme.borderRadius.circle));
    }
    if (widget.direction == Axis.horizontal) {
      return Provider<Brightness>.value(
        value: brightness,
        child: Container(
          width: widget.width,
          decoration: decoration,
          child: Row(
            children: buttonList,
          ),
        ),
      );
    } else {
      return Container(
        width: widget.width,
        decoration: decoration,
        child: Column(
          children: buttonList,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _BuildButtonList {
  _BuildButtonList(
      {
      /// 按钮列表
      required this.buttons,

      /// 按钮的宽度
      required this.width,

      /// 按钮的排列方向
      required this.direction,
      required this.style});

  /**************** 公有变量 ***************/
  /// 按钮列表
  final List<AriIconButton> buttons;

  /// 按钮的宽度
  final double width;

  /// 按钮的排列方向
  final Axis direction;

  /// 按钮的样式
  ButtonStyle style;

  //*--- 公有方法 ---*
  List<Widget> build() {
    Widget dividerWdiget = _buildDivider(direction, width);

    List<Widget> rebuttons = [];
    for (int i = 0; i < buttons.length; i++) {
      BorderRadiusGeometry? borderRadius;
      Radius radius = AriTheme.borderRadius.standard;
      bool isCircle = false;

      // NOTE:
      // 如果只有一个按钮: 那么就是圆形按钮
      // 如果是第一个按钮: 那么就是左上角和右上角是圆角
      // 如果是最后一个按钮: 那么就是左下角和右下角是圆角
      if (buttons.length == 1) {
        borderRadius = BorderRadius.all(AriTheme.borderRadius.circle);
        isCircle = true;
      } else if (i == 0) {
        borderRadius = BorderRadius.only(topLeft: radius, topRight: radius);
      } else if (i == buttons.length - 1) {
        borderRadius =
            BorderRadius.only(bottomLeft: radius, bottomRight: radius);
      }
      // borderRadius = BorderRadius.all(AriTheme.borderRadius.zero);
      buttons[i].borderRadius.value = borderRadius;
      buttons[i].style.value = style.copyWith(
        minimumSize: MaterialStateProperty.all<Size>(Size(width, width)),
        maximumSize: MaterialStateProperty.all<Size>(Size(width, width)),
      );
      rebuttons.add(_buildButton(buttons[i], width, isCircle: isCircle));
      // 添加分割线
      if (i < buttons.length - 1) {
        rebuttons.add(dividerWdiget);
      }
    }
    return rebuttons;
  }

  //*--- 私有方法 ---*
  /// 构建分割线
  Widget _buildDivider(Axis direction, double width) {
    if (direction == Axis.horizontal) {
      return SizedBox(
        height: width,
        child: Divider(
          height: width,
          thickness: 1,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        child: Divider(
          height: 1,
          thickness: 1,
        ),
      );
    }
  }

  /// 构建按钮
  Widget _buildButton(AriIconButton button, double width, {isCircle = false}) {
    // 判断是否是圆形按钮
    if (!isCircle) {
      return SizedBox(
        width: width,
        child: button,
      );
    } else {
      return button;
    }
  }
}
