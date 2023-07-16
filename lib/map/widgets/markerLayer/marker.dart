import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 标记widget
///
/// 用在[Marker]的builder中构建自定义的标记
///
/// 在AriMapMarker生成实例的时候，会自动调用该widget
///
class AriMapMarkerWidget extends StatefulWidget {
  /// 标记widget
  ///
  /// - `type`: 标记类型
  const AriMapMarkerWidget({
    Key? key,
    required this.type,
  }) : super(key: key);

  /// 地图标记类型
  final MarkerType type;

  @override
  AriMapMarkerWidgetState createState() => AriMapMarkerWidgetState();
}

class AriMapMarkerWidgetState extends State<AriMapMarkerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildMarker(),
    );
  }

  Widget _buildMarker() {
    switch (widget.type) {
      case MarkerType.normal:
        return _NormalWidget();
      case MarkerType.position:
        return _PostionWidget();
      default:
        return _NormalWidget();
    }
  }
}

/// 普通标记
class _NormalWidget extends StatelessWidget {
  const _NormalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.location_on);
  }
}

/// 位置标记
class _PostionWidget extends StatelessWidget {
  const _PostionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterLogo();
  }
}
