import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 点击事件
///
/// - `selectIndex` 当前icon的索引
/// - `animationController` 动画控制器
typedef AriIconButtonOnPressed = void Function(
    ValueNotifier<int> selectIndex, AnimationController animationController);

/// 图标按钮
class AriIconButton extends StatefulWidget {
  AriIconButton(
      {Key? key,
      required this.icons,
      int selectIndex = 0,
      double rotateAngle = 0.0,
      this.onPressed,
      BorderRadiusGeometry? borderRadius,
      ButtonStyle? style})
      : selectIndex = ValueNotifier<int>(selectIndex),
        rotateAngle = ValueNotifier<double>(rotateAngle),
        borderRadius = ValueNotifier<BorderRadiusGeometry?>(borderRadius),
        style = ValueNotifier<ButtonStyle>(style ?? ButtonStyle()),
        super(key: key);

  /// 图标列表，根据[selectIndex]显示相应的图标
  final List<Widget> icons;

  /// 选择的图标
  final ValueNotifier<int> selectIndex;

  /// 旋转角度
  final ValueNotifier<double> rotateAngle;

  /// 点击事件
  final AriIconButtonOnPressed? onPressed;

  /// 圆角
  final ValueNotifier<BorderRadiusGeometry?> borderRadius;

  /// 按钮样式
  final ValueNotifier<ButtonStyle> style;

  @override
  State<StatefulWidget> createState() => AriIconButtonState();
}

class AriIconButtonState extends State<AriIconButton>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  //*--- 公有变量 ---*
  bool isFav = false;

  /// 点击事件，回调函数
  ///
  /// - `selectIndex` 当前icon的索引
  /// - `animationController` 动画控制器
  ///
  /// 这个方法主要是为了继承AriIconButtonState时触发onPressed。
  /// 如果是直接使用AriIconButton创建widget用不到
  ///
  /// 效果等同于AriIconButton中的onPressed
  late final AriIconButtonOnPressed? onPressedCallback;

  //*--- 私有变量 ---*
  /// 动画控制器
  late AnimationController _animationController;

  /// 动画
  late Animation<double> _animation;

  /// 亮度
  Brightness? brightness;

  //*--- 生命周期 ---*
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AriTheme.duration.buttonScaleDuration,
    );

    /// 设置缩放动画
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.0),
        weight: 50.0,
      ),
    ]).animate(_animationController);

    widget.style.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    /// 图标
    /// 如果图标数量大于1，使用动画
    Widget iconWidget = widget.icons.length > 1
        ? AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                  scale: _animation.value,
                  child: Transform.rotate(
                      angle: widget.rotateAngle.value,
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        heightFactor: 1,
                        child: widget.icons[widget.selectIndex.value],
                      )));
            })
        : Transform.rotate(
            angle: widget.rotateAngle.value,
            child: widget.icons[widget.selectIndex.value],
          );
    return IconButton(
      onPressed: _onPressed,
      icon: iconWidget,
      style: widget.style.value,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  //*--- 公有方法 ---*
  /// 播放动画
  ///
  /// `@return` 动画控制器
  ///
  /// 用于在触发图标切换动画
  AnimationController animationForward() {
    AnimationController pressAnimationController = AnimationController(
      vsync: this,
    );
    _animationController.reset();
    _animationController.forward();

    return pressAnimationController;
  }

  //*--- 私有方法 ---*
  /// 点击事件
  void _onPressed() {
    setState(() {
      isFav = !isFav;
      AnimationController pressAnimationController = animationForward();
      widget.onPressed?.call(widget.selectIndex, pressAnimationController);
      if (onPressedCallback != null) {
        onPressedCallback!.call(widget.selectIndex, pressAnimationController);
      }
    });
  }
}
