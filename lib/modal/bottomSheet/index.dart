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
                child: Center(child: Text('Hello, World!')),
              ),
            ),
          ),
        ),
      ),
      //     Container(
      //   decoration: BoxDecoration(
      //     borderRadius: AriTheme.modal.bottomSheet.borderRadius,
      //     boxShadow: [
      //       theme.shadow.standarOffsetDy,
      //     ],
      //   ),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(10),
      //     child: Container(
      //       child: BackdropFilter(
      //         filter: AriTheme.filter.standard,
      //         child: Container(
      //           child: Center(child: Text('Hello, World!')),
      //         ),
      //       ),
      //     ),
      //   ),
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
