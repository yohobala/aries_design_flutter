import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

class AriBottomSheet extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 底部弹出框
  const AriBottomSheet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AriBottomSheetState();
}

class AriBottomSheetState extends State<AriBottomSheet> {
  @override
  Widget build(BuildContext context) {
    AriTheme.insets.extraLarge;
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    AriThemeColor theme = AriThemeController().getTheme(brightness);
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.5,
      child: Container(
        decoration: theme.modal.bottomSheet,
        child: ClipRRect(
          borderRadius: AriTheme.modal.bottomSheet.borderRadius,
          child: Container(
            // 使用 ClipRect 防止模糊效果超过容器范围
            child: BackdropFilter(
              filter: AriTheme.filter.standard,
              child: Container(
                child: _build(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _build() {
    return Column(
      children: [
        Text("标题"),
        Text("功能"),
        Text("图像"),
        Text("文本"),
      ],
    );
  }
}

/// 显示AirBottomSheet
///
/// - `context` 上下文
void showAriBottomSheet(BuildContext context) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AriBottomSheet();
    },
  );
}
