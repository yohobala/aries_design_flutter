import 'package:flutter/material.dart';

class AriDialog extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 对话框
  ///
  /// - `title` 标题
  /// - `content` 内容
  /// - `buttons` 按钮
  /// - `buttonWidth` 按钮宽度，默认为0.8
  const AriDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.buttons,
    this.buttonWidth = 0.8,
    this.elevation = 0,
  }) : super(key: key);

  //*--- 公有变量 ---*
  /// 标题
  final Widget? title;

  /// 内容
  final Widget? content;

  /// 按钮
  final List<Widget>? buttons;

  /// 按钮宽度
  final double buttonWidth;

  final double elevation;

  @override
  State<StatefulWidget> createState() => AriDialogState();
}

class AriDialogState extends State<AriDialog> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AlertDialog(
        elevation: widget.elevation,
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
/// *参数*
/// - `context` 上下文
/// - `title` 标题
/// - `content` 内容
/// - `buttonBuilder` 按钮
/// - `barrierDismissible` 是否允许点击外部关闭
/// - `isOnly` 是否关闭其他的dialog
/// - `elevation` 高度值,会影响颜色的整体颜色,见`https://m3.material.io/styles/elevation/overview`
///
/// *return*
/// 会返回一个Future，可以通过Navigator.pop/ Navigator.of(context).pop等触发,
/// 例如在[buttonBuilder]的一个button的onPressed方法中调用`Navigator.pop(context, 'ok')`，
/// 那么这个Future的值就是'ok'。同时会产生关闭dialog的效果
///
/// buttonBuilder的示例：
/// ```dart
/// List<Widget> buttonBuilder(BuildContext innerContext) {
///   return [
///     FilledButton.tonal(
///         onPressed: () => {},
///         child: Text("ok")
///    ),
///     TextButton(
///         onPressed: () => {Navigator.pop(innerContext, 'Cancel')},
///         child: Text("Cancel")
///    )
///   ];
/// }
/// ```
Future<T?> showAriDialog<T>(
  BuildContext context, {
  Widget? title,
  Widget? content,
  List<Widget> Function(BuildContext)? buttonBuilder,

  /// 是否允许点击外部关闭
  bool barrierDismissible = true,
  bool isOnly = true,
  double elevation = 0,
}) {
  if (isOnly) {
    /// 关闭其他的dialog
    Navigator.of(context).popUntil((Route<dynamic> route) {
      // 如果不是 DialogRoute 类型，就保留，否则关闭。
      return route is! DialogRoute;
    });
  }

  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      // 注意：在这里我们创建了一个新的BuildContext，通过Builder
      return Builder(builder: (BuildContext innerContext) {
        return AriDialog(
          title: title,
          content: content,
          buttons: buttonBuilder != null ? buttonBuilder(innerContext) : null,
          elevation: elevation,
        );
      });
    },
  );
}
