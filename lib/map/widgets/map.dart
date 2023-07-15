import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:latlong2/latlong.dart';

const String token = "fb525d814e62751e358854e8f95155a6";

String getTianDiTuLayer(String layerName, String layerType) {
  return "http://t0.tianditu.gov.cn/$layerType/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=$layerName&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=$token";
}

///地图组件
class AriMap extends StatefulWidget {
  /// 地图组件
  ///
  /// 通过 [AriMapController] 来控制地图
  ///
  /// - `ariMapController` 地图控制器，如果没有传入，则会自动创建一个
  /// - `rightBottomChild` 右下角的子组件
  /// - `rightTopChild` 右上角的子组件
  ///
  /// *示例代码*
  ///
  /// ```dart
  /// class MapView extends StatelessWidget {
  ///  const MapView({Key? key}) : super(key: key);
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return AriMap(
  ///      ariMapController: ariMapController,
  ///      rightBottomChild: FloatingActionButton(
  ///        shape: const CircleBorder(),
  ///        onPressed: () {
  ///        },
  ///        child: const Icon(Icons.add, size: 36),
  ///      ),
  ///      rightTopChild: AriSegmentedIconButton(buttons: [
  ///        AriMapLocationButton(ariMapController: ariMapController).build(),
  ///      ]),
  ///    );
  ///  }
  /// }
  /// ```
  ///
  AriMap({
    Key? key,
    this.ariMapController,
    this.rightBottomChild,
    this.rightTopChild,
    this.onLongPress,
  });

  /// AriMap控制器
  final AriMapController? ariMapController;

  /// 地图右下角的子组件
  final Widget? rightBottomChild;

  /// 地图右上角的子组件
  final Widget? rightTopChild;

  final MapVoidCallback? onLongPress;

  @override
  State<AriMap> createState() => AriMapState(ariMapController);
}

class AriMapState extends State<AriMap> with WidgetsBindingObserver {
  AriMapState(AriMapController? ariMapController)
      : ariMapController = ariMapController ?? AriMapController();
  //*--- 公有变量 ---*
  //定位控制器
  late AriGeoLocationController ariGeoLocationController;

  // 标记控制器
  late AriMapMarkerController ariMapMarkerController;

  final MapController mapController = MapController();

  //*--- 私有变量 ---*
  final AriMapController ariMapController;

  //*--- 生命周期 ---*
  @override
  void initState() {
    super.initState();
    //*--- 初始化控制器 ---*
    ariMapMarkerController =
        AriMapMarkerController(initLayers: ariMapController.initMarkerLayers);
    ariGeoLocationController = AriGeoLocationController(
        ariMapMarkerController: ariMapMarkerController);

    //*--- 挂载到ariMapController ---*
    ariMapController.initController(
        geoLocationController: ariGeoLocationController,
        markerController: ariMapMarkerController,
        mapController: mapController);
    //移动到设备定位
    ariMapController.goToPosition();

    /*
     * 只有添加了WidgetsBinding.instance?.addObserver(this);
     * 才会触发didChangePlatformBrightness，didChangeAppLifecycleState等方法
     * 
     * WidgetsBinding.instance?.addObserver(this); 
     * 这一行代码是将当前对象添加为系统事件的观察者，其中 this 通常指向一个 WidgetsBindingObserver 的实例。
     * 当你把一个 WidgetsBindingObserver 添加为观察者之后，这个观察者的 didChangePlatformBrightness 方法就会在平台亮度发生变化时被调用
     * 一旦你不再需要监听平台亮度的变化，你应该使用 WidgetsBinding.instance?.removeObserver(this); 来移除观察者，避免内存泄漏。
     */
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 应用程序从后台切换回前台
    if (state == AppLifecycleState.resumed) {
      // 检查定位权限
      if (ariMapController.geoLocationController != null) {
        ariMapController.geoLocationController!.checkPermission();
      }
    }
  }

  /*
   * 使用Scaffold做最外层是因为子节点需要用到，比如:
   * - AriMapLocationButton
   */
  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).padding;
    double safeAreaTop = padding.top + AriTheme.windowsInsets.top;
    double safeAreaBottom = padding.bottom + AriTheme.windowsInsets.bottom;

    void onLongPress(tapPosition, LatLng latLng) {
      if (widget.onLongPress != null) {
        widget.onLongPress!(latLng);
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: ariMapController.center,
              zoom: ariMapController.zoom,
              maxZoom: ariMapController.maxZoom,
              minZoom: ariMapController.minZoom,
              onLongPress: onLongPress,
            ),
            children: [
              TileLayer(
                urlTemplate: getTianDiTuLayer("vec", "vec_w"),
              ),
              TileLayer(
                urlTemplate: getTianDiTuLayer("cva", "cva_w"),
                backgroundColor: Colors.transparent,
              ),
              AriMapMarkerLayersWidget(
                ariMapMarkerController: ariMapMarkerController,
              )
            ],
          ),
          // 右下角图标
          Positioned(
            child: widget.rightBottomChild ?? Container(),
            bottom: safeAreaBottom,
            right: AriTheme.windowsInsets.right,
          ),
          // 右上角图标
          Positioned(
            child: widget.rightTopChild ?? Container(),
            top: safeAreaTop,
            right: AriTheme.windowsInsets.right,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ariGeoLocationController.unregisterLocationListener();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
