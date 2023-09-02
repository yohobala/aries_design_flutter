import 'dart:math';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 带边框的输入框
///
class AriTextFormField extends StatefulWidget {
  const AriTextFormField({
    super.key,
    this.textFieldKey,
    this.textFieldType,
    this.controller,
    this.focusNode,
    required this.width,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.enabled = true,
    this.autofillHints,
    this.loadingController,
    this.inertiaController,
    this.interval = const Interval(0.0, 1.0),
    this.labelText,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.suffixIconOnPressed,
  });

  /// 输入框的key
  ///
  /// 可以通过`GlobalKey<FormFieldState>()`创建,
  /// 这样就能通过focusNode监听该输入框的变化了
  final Key? textFieldKey;

  /// 输入框的类型
  ///
  /// 设置后会对[validator],[autofillHints]进行默认设置
  final TextFieldType? textFieldType;

  /// 文本控制器
  final TextEditingController? controller;

  /// 输入框的焦点控制
  final FocusNode? focusNode;

  /// 输入框的宽度
  final double width;

  /// 设置弹出哪种类型的虚拟键盘
  final TextInputType? keyboardType;

  /// 是否隐藏文本
  final bool obscureText;

  /// 字段验证
  final FormFieldValidator<String>? validator;

  final bool enabled;

  /// 自动填充
  final Iterable<String>? autofillHints;

  // MODULE:
  // 动画相关设置

  /// 加载动画控制器
  ///
  /// 主要用于控制输入框加载和显隐
  ///
  /// 如果不需要可以不设置
  ///
  /// *示例代码*
  /// ```dart
  /// var _formLoadingController = AnimationController(
  ///   vsync: this,
  ///   duration: const Duration(milliseconds: 1150),
  ///   reverseDuration: const Duration(milliseconds: 300),
  /// );
  /// _formLoadingController.forward();
  /// ```
  final AnimationController? loadingController;

  /// 用于输入框图标的控制器
  final AnimationController? inertiaController;

  /// 动画间隔，用于对动画的时间范围进行分段处理
  final Interval? interval;

  // MODULE:
  // 关于InputDecoration的设置

  /// InputDecoration中的labelText
  ///
  /// 当输入字段获得焦点时显示在输入字段上方的标签
  final String? labelText;

  /// 前缀图标
  final Widget? prefixIcon;

  /// 前缀图标颜色
  final Color? prefixIconColor;

  /// 后缀图标
  final List<Widget>? suffixIcon;

  /// 后缀图标颜色
  final Color? suffixIconColor;

  /// 点击事件
  final AriIconButtonOnPressed? suffixIconOnPressed;

  @override
  State<AriTextFormField> createState() => _BorderTextFieldState();
}

class _BorderTextFieldState extends State<AriTextFormField>
    with TickerProviderStateMixin {
  /// 缩放动画
  late Animation<double> scaleAnimation;

  /// 容器尺寸变化动画
  late Animation<double> sizeAnimation;

  late Iterable<String>? autofillHints;
  late TextInputType? keyboardType;

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    final loadingController = widget.loadingController;

    // NOTE:
    // 如果有加载动画控制器，则设置动画
    if (loadingController != null) {
      scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: loadingController,
          curve: generateInterval(
            0,
            0.2,
            widget.interval!.begin,
            widget.interval!.end,
            curve: Curves.easeOutBack,
          ),
        ),
      );
      print(widget.width);
      sizeAnimation = Tween<double>(
        begin: 48.0,
        end: widget.width,
      ).animate(
        CurvedAnimation(
          parent: loadingController,
          curve: generateInterval(
            0.2,
            1.0,
            widget.interval!.begin,
            widget.interval!.end,
            curve: Curves.linearToEaseOut,
          ),
          reverseCurve: Curves.easeInExpo,
        ),
      );
    }

    if (widget.inertiaController != null) {
      widget.inertiaController!.addStatusListener(handleAnimationStatus);
    }

    if (widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        setState(() {});
      });
    }

    if (widget.textFieldType != null) {
      if (widget.textFieldType == TextFieldType.email) {
        autofillHints = widget.autofillHints ?? [AutofillHints.email];
        keyboardType = widget.keyboardType ?? TextInputType.emailAddress;
      }
    }

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget inputField;
    inputField = TextFormField(
      key: widget.textFieldKey,
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: _getInputDecoration(theme),
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      validator: widget.validator,
      enabled: widget.enabled,
      autofillHints: widget.autofillHints,
    );
    if (widget.loadingController != null) {
      inputField = ScaleTransition(
        scale: scaleAnimation,
        child: AnimatedBuilder(
            animation: sizeAnimation,
            // NOTE:
            // ConstrainedBox 用于限制子组件的宽度
            builder: (context, child) => ConstrainedBox(
                  constraints:
                      BoxConstraints.tightFor(width: sizeAnimation.value),
                  child: child,
                ),
            child: inputField),
      );
    }
    return inputField;
  }

  @override
  void dispose() {
    widget.inertiaController?.removeStatusListener(handleAnimationStatus);
    super.dispose();
  }

  void handleAnimationStatus(AnimationStatus status) {
    print(status);
    if (status == AnimationStatus.completed) {
      widget.inertiaController?.reverse();
    }
  }

  InputDecoration _getInputDecoration(ThemeData theme) {
    print(widget.suffixIcon);
    return InputDecoration(
      filled: true,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon != null
          ? Container(
              padding:
                  AriTheme.textField.borderTextfieldInputDecorationIconPadding,
              child: widget.prefixIcon,
            )
          : null,
      prefixIconColor: widget.prefixIconColor,
      suffixIcon: widget.suffixIcon != null
          ? AriIconButton(
              icons: widget.suffixIcon!, onPressed: widget.suffixIconOnPressed)
          : null,
      suffixIconColor: widget.suffixIconColor,
      border: AriTheme.textField.borderTextfieldInputDecoration.border,
    );
  }
}
