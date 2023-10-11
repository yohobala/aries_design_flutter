import 'dart:ui';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

class AriMessageBar extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 消息条
  ///
  /// 会显示一个消息在屏幕顶部
  ///
  /// - `title` 标题
  /// - `content` 内容
  /// - `buttons` 按钮
  /// - `buttonWidth` 按钮宽度，默认为0.8
  const AriMessageBar(
    this.message, {
    Key? key,
    this.prefixChildren,
    this.suffixChildren,
    this.height,
    this.widthFactor,
    this.decoration,
  })  : assert(widthFactor == null || (widthFactor > 0 && widthFactor <= 1)),
        super(key: key);

  final String message;

  final List<Widget>? prefixChildren;

  final List<Widget>? suffixChildren;

  final double? height;

  final double? widthFactor;

  final Decoration? decoration;

  @override
  State<StatefulWidget> createState() => AriMessageBarState();
}

class AriMessageBarState extends State<AriMessageBar> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widget.widthFactor ?? AriTheme.modal.messageBarWidthFactor,
      child: ClipRect(
        // 确保将堆叠的子项剪辑为这个容器的形状
        child: BackdropFilter(
          // 应用背景滤镜
          filter: AriTheme.filter.standard,
          child: Container(
              height: widget.height ?? AriTheme.modal.messageBarHeight,
              decoration: BoxDecoration(
                borderRadius: AriTheme.modal.messageBarDecoration.borderRadius,
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(AriTheme.opacity.blurOpacity),
              ),
              child: Row(
                children: [
                  if (widget.prefixChildren != null) ...widget.prefixChildren!,
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.message,
                        style: AriThemeColor.of(context).text.messageBar,
                      ),
                    ),
                  ),
                  if (widget.suffixChildren != null) ...widget.suffixChildren!,
                ],
              )),
        ),
      ),
    );
  }
}
