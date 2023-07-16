import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

import 'package:app_settings/app_settings.dart';

///定位按钮
///
/// *功能*
/// 1. 点击按钮后，如果当前地图中心不是GPS位置，则会移动到GPS位置图标变成[LocationButtonEnum.aligned].
///    如果当前地图中心是GPS位置，则不会移动
/// 2. 当地图中心不是GPS位置时，图标变成[LocationButtonEnum.offset]
///
/// *示例代码*
/// ```dart
/// AriSegmentedIconButton(buttons: [
///   AriMapLocationButton(ariMapController: ariMapController).build(),
///])
class AriMapLocationButton extends AriIconButton {
  /// 定位按钮
  ///
  /// - `ariMapController` 地图控制器
  AriMapLocationButton({required this.ariMapController})
      : super(
          icons: const [
            Icon(
              Icons.near_me_outlined,
            ),
            Icon(Icons.near_me),
            Icon(Icons.near_me_disabled_outlined)
          ],
          selectIndex: LocationButtonEnum.offset.index,
          rotateAngle: 0,
        );

  /// 地图控制器
  final AriMapController ariMapController;

  @override
  AriMapLocationButtonState createState() =>
      AriMapLocationButtonState(ariMapController: ariMapController);
}

class AriMapLocationButtonState extends AriIconButtonState {
  //*--- 构造函数 ---*
  AriMapLocationButtonState({
    required this.ariMapController,
  });

  //*--- 公有变量 ---*
  /// 地图控制器
  late final AriMapController ariMapController;

  //*--- 私有变量 ---*
  /// 地图中心是否位于GPS位置的上一个状态
  late bool _beforeIsCenterOnPostion;

  //*--- 生命周期 ---*
  @override
  void initState() {
    super.initState();

    void handlerIsGeoLocationAvailable() {
      if (!ariMapController.isGeoLocationAvailable.value) {
        setState(() {
          widget.selectIndex.value = LocationButtonEnum.unauthorized.index;
        });
      } else {
        setState(() {
          widget.selectIndex.value = LocationButtonEnum.offset.index;
        });
      }
    }

    handlerIsGeoLocationAvailable();
    ariMapController.isGeoLocationAvailable.addListener(() {
      handlerIsGeoLocationAvailable();
    });

    // 地图移动监听
    _beforeIsCenterOnPostion = ariMapController.isCenterOnPostion.value;
    ariMapController.isCenterOnPostion.addListener(() {
      //
      if (_beforeIsCenterOnPostion !=
          ariMapController.isCenterOnPostion.value) {
        setState(() {
          if (ariMapController.isCenterOnPostion.value) {
            widget.selectIndex.value = LocationButtonEnum.aligned.index;
          } else {
            widget.selectIndex.value = LocationButtonEnum.offset.index;
          }
          _beforeIsCenterOnPostion = ariMapController.isCenterOnPostion.value;
          super.animationForward();
        });
      }
    });

    // 按钮点击回调
    onPressedCallback = (selectIndex, animationController) {
      animationController.duration = AriTheme.duration.mapDuration;
      if (ariMapController.isGeoLocationAvailable.value) {
        if (selectIndex.value == LocationButtonEnum.offset.index) {
          ariMapController.goToPosition(
              animationController: animationController);
          selectIndex.value = LocationButtonEnum.aligned.index;
        }
      } else {
        selectIndex.value = LocationButtonEnum.unauthorized.index;

        // 标题

        Widget title = Text(
          AriLocalizations.of(context)!.locatio_services_failed_title,
          textAlign: TextAlign.center,
        );
        // 内容
        Widget content = Text(
          AriLocalizations.of(context)!.locatio_services_failed_content,
          textAlign: TextAlign.center,
        );

        List<Widget> buttonBuilder(BuildContext innerContext) {
          return [
            // 打开设置按钮
            FilledButton.tonal(
                onPressed: () => {
                      //关闭

                      Navigator.pop(innerContext, 'ok'),
                      // 跳到系统设置里
                      //ios平台
                      AppSettings.openAppSettings(
                          type: AppSettingsType.settings),
                    },
                child: Text(AriLocalizations.of(innerContext)!
                    .location_server_failed_open)),
            // 取消按钮
            TextButton(
                onPressed: () => {Navigator.pop(innerContext, 'cancel')},
                child: Text(AriLocalizations.of(innerContext)!
                    .location_server_failed_cancel))
          ];
        }

        showAriDialog(context,
            title: title,
            content: content,
            buttonBuilder: buttonBuilder,
            barrierDismissible: false);
      }
    };
  }
}
