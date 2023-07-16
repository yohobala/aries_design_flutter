import 'dart:async';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

class AriDialog extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 对话框
  ///
  /// - `title` 标题
  /// - `content` 内容
  /// - `buttons` 按钮
  /// - `buttonWidth` 按钮宽度，默认为0.8
  const AriDialog(
      {Key? key,
      required this.title,
      required this.content,
      required this.buttons,
      this.buttonWidth = 0.8})
      : super(key: key);

  //*--- 公有变量 ---*
  /// 标题
  final Widget? title;

  /// 内容
  final Widget? content;

  /// 按钮
  final List<Widget>? buttons;

  /// 按钮宽度
  final double buttonWidth;

  @override
  State<StatefulWidget> createState() => AriDialogState();
}

class AriDialogState extends State<AriDialog> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AlertDialog(
        title: widget.title,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600, fontSize: 18),
        content: widget.content,
        actions: <Widget>[
          widget.buttons == null
              ? Container()
              : FractionallySizedBox(
                  widthFactor: 1,
                  alignment: Alignment.center,
                  child: Column(
                      children: widget.buttons!
                          .map((e) => FractionallySizedBox(
                              widthFactor: widget.buttonWidth, child: e))
                          .toList()),
                )
        ],
      ),
    );
  }
}

/// 显示一个AriDialog
///
/// - `context` 上下文
/// - `title` 标题
/// - `content` 内容
/// - `buttonBuilder` 按钮
///
/// buttonBuilder的示例：
/// ```dart
/// List<Widget> buttonBuilder(BuildContext innerContext) {
///   return [
///     FilledButton.tonal(
///         onPressed: () => {},
///         child: Text("ok")
///     TextButton(
///         onPressed: () => {Navigator.pop(innerContext, 'Cancel')},
///         child: Text("Cancel")
///   ];
/// }
/// ```
void showAriDialog(
  BuildContext context, {
  Widget? title,
  Widget? content,
  List<Widget> Function(BuildContext)? buttonBuilder,

  /// 是否允许点击外部关闭
  bool barrierDismissible = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      // 注意：在这里我们创建了一个新的BuildContext，通过Builder
      return Builder(builder: (BuildContext innerContext) {
        return AriDialog(
          title: title,
          content: content,
          buttons: buttonBuilder != null ? buttonBuilder(innerContext) : null,
        );
      });
    },
  );
}
