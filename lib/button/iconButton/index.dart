import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 点击事件
///
/// - `selectIndex` 当前icon的索引
/// - `animationController` 动画控制器
typedef AriIconButtonOnPressed = void Function(
    ValueNotifier<int> selectIndex, AnimationController animationController);

/// 背景填充的图标按钮
class AriFilledIconButton extends StatefulWidget {
  AriFilledIconButton(
      {Key? key,
      required this.icons,
      this.width = 40,
      this.height = 40,
      this.iconSize = 24,
      this.borderRadius,
      this.style,
      this.onPressed,
      this.padding})
      : super(key: key);

  final List<Widget?> icons;

  final double width;

  final double height;

  final double iconSize;

  final Radius? borderRadius;

  final ButtonStyle? style;

  /// 点击事件
  final AriIconButtonOnPressed? onPressed;

  final EdgeInsetsGeometry? padding;

  @override
  State<StatefulWidget> createState() => AriFilledIconButtonState();
}

class AriFilledIconButtonState extends State<AriFilledIconButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyle? buttonStyle =
        widget.style ?? AriThemeColor.of(context).button.filledIconButton;
    if (widget.borderRadius != null) {
      buttonStyle = buttonStyle.copyWith(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(widget.borderRadius!),
          ),
        ),
      );
    }
    return AriIconButton(
      icons: widget.icons,
      style: buttonStyle,
      onPressed: widget.onPressed,
      width: widget.width,
      height: widget.height,
      iconSize: widget.iconSize,
      padding: widget.padding,
    );
  }
}

/// 图标按钮
class AriIconButton extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 图标按钮
  ///
  /// - `icons` 图标列表，根据[selectIndex]显示相应的图标
  /// - `selectIndex` 选择的图标,默认为0
  /// - `rotateAngle` 旋转角度，默认为0.0
  /// - `onPressed` 点击事件
  /// - `borderRadius` 圆角
  /// - `style` 按钮样式，默认为[ButtonStyle]
  AriIconButton({
    GlobalKey<AriIconButtonState>? key,
    required this.icons,
    ValueNotifier<int>? selectIndex,
    double rotateAngle = 0.0,
    this.onPressed,
    BorderRadiusGeometry? borderRadius,
    this.style,
    this.width = 40,
    this.height = 40,
    this.iconSize = 24,
    this.padding,
  })  : selectIndex = selectIndex ?? ValueNotifier<int>(0),
        rotateAngle = ValueNotifier<double>(rotateAngle),
        borderRadius = ValueNotifier<BorderRadiusGeometry?>(borderRadius),
        iconKey = key ?? GlobalKey<AriIconButtonState>(),
        super(key: key);

  final GlobalKey<AriIconButtonState> iconKey;

  //*--- 公有变量 ---*
  /// 图标列表，根据[selectIndex]显示相应的图标
  final List<Widget?> icons;

  /// 选择的图标
  final ValueNotifier<int> selectIndex;

  /// 旋转角度
  final ValueNotifier<double> rotateAngle;

  /// 点击事件
  final AriIconButtonOnPressed? onPressed;

  /// 圆角
  final ValueNotifier<BorderRadiusGeometry?> borderRadius;

  /// 按钮样式
  final ButtonStyle? style;

  final double width;

  final double height;

  final double iconSize;

  final EdgeInsetsGeometry? padding;

  @override
  State<StatefulWidget> createState() => AriIconButtonState();
}

class AriIconButtonState extends State<AriIconButton>
    with TickerProviderStateMixin {
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
  AriIconButtonOnPressed? onPressedCallback;

  /// 亮度
  Brightness? brightness;

  //*--- 私有变量 ---*
  /// 动画控制器
  late List<AnimationController> _animationControllers;

  /// 上一个选择的图标索引
  late int preSelectIndex;

  /// 图标列表
  late List<Widget> _elements;

  ButtonStyle? _style;

  int get hashCode => Object.hash(
        widget.icons,
        widget.selectIndex,
        widget.rotateAngle,
        widget.onPressed,
        widget.borderRadius,
        widget.style,
      );

  //*--- 生命周期 ---*
  @override
  void initState() {
    super.initState();

    preSelectIndex = widget.selectIndex.value;
    _animationControllers =
        ariIconSwitchAnimationController(this, widget.icons.length);

    widget.selectIndex.addListener(() {
      animationForward();
    });

    _style = widget.style;

    // NOTE:
    // 不应该移动到build里
    // 因为当动画播放后,build会刷新,
    // 如果_build放到build中执行,会造成icon重新绘制
    // 会造成1.icon无法切换 2.icon放大后突然消失
    _elements = _build(widget.width, widget.height);
  }

  @override
  void didUpdateWidget(covariant AriIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hashCode != widget.hashCode) {
      _elements = _build(widget.width, widget.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _elements,
    );
  }

  //*--- 公有方法 ---*
  /// 播放动画
  ///
  /// 用于在触发图标切换动画
  /// 动画呈现先缩小再放大的效果
  void animationForward() {
    if (widget.icons.length > 1) {
      // NOTE:
      // 如果当前图标为null，则不进行动画
      if (widget.icons[preSelectIndex] == null) {
        if (widget.icons[widget.selectIndex.value] != null) {
          if (_animationControllers[widget.selectIndex.value].value == 0.0) {
            _animationControllers[widget.selectIndex.value].reset();
            _animationControllers[widget.selectIndex.value].forward();
          } else {
            _animationControllers[widget.selectIndex.value].reverse();
          }
        }
        preSelectIndex = widget.selectIndex.value;
      }
      // NOTE:
      // 当前动画为正向动画时，点击后反向动画
      else if (_animationControllers[preSelectIndex].value == 1.0) {
        _animationControllers[preSelectIndex].reverse().then((value) {
          if (widget.icons[widget.selectIndex.value] != null) {
            if (_animationControllers[widget.selectIndex.value].value == 0.0) {
              _animationControllers[widget.selectIndex.value].reset();
              _animationControllers[widget.selectIndex.value].forward();
            } else {
              _animationControllers[widget.selectIndex.value].reverse();
            }
          }
          preSelectIndex = widget.selectIndex.value;
        });
      }
      // NOTE:
      // 当前动画为反向动画时，点击后正向动画
      else {
        _animationControllers[preSelectIndex].forward().then((value) {
          if (widget.icons[widget.selectIndex.value] != null) {
            if (_animationControllers[widget.selectIndex.value].value == 0.0) {
              _animationControllers[widget.selectIndex.value].reset();
              _animationControllers[widget.selectIndex.value].forward();
            } else {
              _animationControllers[widget.selectIndex.value].reverse();
            }
          }

          preSelectIndex = widget.selectIndex.value;
        });
      }
    } else if (widget.icons.length == 1) {
      _animationControllers[0].reset();
      _animationControllers[0].forward();
    }
  }

  //*--- 私有方法 ---*
  /// 点击事件
  void _onPressed() {
    AnimationController pressAnimationController = AnimationController(
      vsync: this,
    );

    widget.onPressed?.call(widget.selectIndex, pressAnimationController);
    if (onPressedCallback != null) {
      onPressedCallback!.call(widget.selectIndex, pressAnimationController);
    }
  }

  List<Widget> _build(double width, double height) {
    // 旋转图标
    Widget iconWidget(int index) => Transform.rotate(
          angle: widget.rotateAngle.value,
          // child: FractionallySizedBox(
          //   widthFactor: 1,
          //   heightFactor: 1,
          child: Center(
            child: widget.icons[index],
          ),
          // ),
        );

    List<Widget> elements = [];
    if (widget.icons.length > 1) {
      for (int i = 0; i < widget.icons.length; i++) {
        bool isSelected = i == widget.selectIndex.value;
        var animation = ariIconSwitchAnimatedBuilder(
          iconWidget(i),
          _animationControllers[i],
          reverse: !isSelected,
        );
        Widget element = SizedBox(
          width: width,
          height: height,
          child: IconButton(
            onPressed: _onPressed,
            icon: animation,
            style: _style,
            iconSize: widget.iconSize,
          ),
        );
        elements.add(element);
      }
    } else if (widget.icons.length == 1) {
      var animation = ariIconSwitchAnimatedBuilder(
        iconWidget(0),
        _animationControllers[0],
        signle: true,
      );
      Widget element = SizedBox(
        width: width,
        height: height,
        child: IconButton(
          padding: widget.padding,
          onPressed: _onPressed,
          icon: animation,
          style: widget.style,
          iconSize: widget.iconSize,
        ),
      );
      elements.add(element);
    }
    return elements;
  }

  void updateStyle(ButtonStyle? style) {
    setState(() {
      _style = style ?? _style;
    });
  }
}
