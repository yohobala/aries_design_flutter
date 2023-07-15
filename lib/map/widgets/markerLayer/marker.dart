import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

class AriMapMarkerWidget extends StatefulWidget {
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

class _NormalWidget extends StatelessWidget {
  const _NormalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.location_on);
  }
}

class _PostionWidget extends StatelessWidget {
  const _PostionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterLogo();
  }
}
