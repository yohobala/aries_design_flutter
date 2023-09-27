import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// 地图无返回值的回调函数
typedef MapVoidCallback = void Function(LatLng latLng);

/// 初始化AriMap的依赖
List<SingleChildWidget> ariMapProvider({bool openLoaction = true}) {
  return [
    ...ariMarkerProvider(),
    Provider<AriMapRepo>(create: (_) => AriMapRepo()),
    Provider<MapController>(create: (_) => MapController()),
    Provider<MapController>(create: (_) => MapController()),
    ProxyProvider4<AriMapRepo, AriGeoLocationRepo, AriMarkerBloc, MapController,
        AriMapBloc>(
      update: (_, ariMapRepo, ariGeoLocationRepo, ariMarkerBloc, mapController,
              __) =>
          AriMapBloc(
        ariMapRepo,
        ariGeoLocationRepo,
        ariMarkerBloc,
        mapController,
        openLoaction,
      ),
    ),
  ];
}

/// 地图组件
///
/// 首先通过ariMapProvider注入所需的依赖
/// 之后可以通过调用AriMapBloc来实现对AriMap的控制
///
/// *示例代码*
///
/// ```dart
/// class MapPage extends StatelessWidget {
///   const MapPage({Key? key}) : super(key: key);
///   @override
///   Widget build(BuildContext context) {
///     return MultiProvider(
///       providers: ariMapProvider(),
///       child: const _MapPageWidget(),
///     );
///   }
/// }
/// class _MapPageWidget extends StatelessWidget {
///   const _MapPageWidget({Key? key}) : super(key: key);
///   @override
///   Widget build(BuildContext context) {
///     final ariMapBloc = context.read<AriMapBloc>();
///     return BlocListener<AriMapBloc, AriMapState>(
///       listener: (context, state) {
///         // Do something else
///       },
///       child: AriMap(),
///     );
///   }
/// }
/// ```
class AriMap extends StatefulWidget {
  /// 地图组件
  ///
  /// - `ariMapController` 地图控制器，如果没有传入，则会自动创建一个
  /// - `rightBottomChild` 右下角的子组件
  /// - `rightTopChild` 右上角的子组件

  AriMap({
    Key? key,
    this.rightBottomChild,
    this.rightTopChild,
    this.leftTopChild,
    this.zoom = 1.0,
    this.maxZoom = 18,
    this.minZoom = 1,
    this.center,
    this.onLongPress,
    this.buildMarker,
  });

  /// 地图右下角的子组件
  final Widget? rightBottomChild;

  /// 地图右上角的子组件
  final Widget? rightTopChild;

  final Widget? leftTopChild;

  /// 打开地图时，地图的缩放等级
  final double zoom;

  /// 地图的最大缩放级别
  final double maxZoom;

  /// 地图的最小缩放级别
  final double minZoom;

  /// 当打开地图时，地图的中心点坐标,默认为LatLng(0, 0)
  final LatLng? center;

  final MapVoidCallback? onLongPress;

  /// 构建标记的回调
  ///
  /// 如果为空,将使用自带的标记样式
  ///
  /// 可以通过AriMarkerState的SelectdMarkerState来判断marker是否被选中
  /// 需要先调用SelectedMarkerEvent来触发,可以在AriMarkerModel的onTap中调用
  final BuildMarker? buildMarker;

  @override
  State<AriMap> createState() => _AriMapState();
}

class _AriMapState extends State<AriMap>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AriMapBloc mapBloc;
  late final MapController mapController;

  late final AnimationController? controller;
  late final Animation<Offset>? offset;

  late EdgeInsets padding;
  late double safeAreaTop;
  late double safeAreaBottom;

  late AnimationController moveLocationController;

  @override
  void initState() {
    super.initState();

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

    mapBloc = context.read<AriMapBloc>();
    // final markerBloc = context.read<AriMarkerBloc>();
    mapController = mapBloc.mapController;

    // NOTE:
    // 针对底部导航栏的监听
    AriBottonNavigationBarState? state = bottomNavigationBarKey.currentState;
    controller = state?.controller;
    offset = state?.offset;
    state?.widget.showNavigationBar?.addListener(() {
      if (state.widget.showNavigationBar?.value ?? true) {
        controller?.reverse();
      } else {
        controller?.forward();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 应用程序从后台切换回前台
    if (state == AppLifecycleState.resumed) {
      // 检查定位权限
      final mapBloc = context.read<AriMapBloc>();
      mapBloc.add(CheckGeoLocationAvailableEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    var mapBloc = context.read<AriMapBloc>();

    // NOTE:
    // 获取安全区域
    // 用于对自定义的widget进行定位
    // 防止出现在安全区域之外被遮挡的情况
    padding = MediaQuery.of(context).padding;
    safeAreaTop = padding.top + AriTheme.windowsInsets.top;
    safeAreaBottom = padding.bottom + AriTheme.windowsInsets.bottom;
    _addMapControllerListener(mapController, mapBloc);

    // NOTE:
    // 使用Scaffold做最外层是因为子节点需要用到，比如:
    // AriMapLocationButton
    return RepaintBoundary(
        child: Stack(
      children: [
        BlocListener<AriMapBloc, AriMapState>(
          bloc: mapBloc,

          /// MODULE:
          /// 监听BLoC的状态
          listener: (context, state) => {
            if (state is InitAriMapState)
              {
                mapBloc.add(MoveToLocationEvent()),
              }
            else if (state is MoveToLocationState)
              {
                moveLocationController = AnimationController(
                  vsync: this,
                  duration: AriTheme.duration.mapDuration,
                ),
                _moveToLocation(
                  mapController: mapController,
                  latLng: state.center,
                  zoom: state.zoom,
                  offset: state.offset,
                  animationController:
                      state.isAnimated ? moveLocationController : null,
                )
              }
            else if (state is ChangeLocation)
              {}
          },

          /// MODULE:
          /// 设置FlutterMap
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: widget.center,
              zoom: widget.zoom,
              maxZoom: widget.maxZoom,
              minZoom: widget.minZoom,
              onLongPress: onLongPress,
            ),
            nonRotatedChildren: [
              RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
            children: [
              AriMapLayer(),
              AriMarker(buildMarker: widget.buildMarker),
            ],
          ),
        ),

        // MODULE:
        // 自定义的widget
        Positioned(
          child: widget.leftTopChild ?? Container(),
          top: safeAreaTop,
          left: AriTheme.windowsInsets.left,
        ),
        Positioned(
          child: widget.rightTopChild ?? Container(),
          top: safeAreaTop,
          right: AriTheme.windowsInsets.right,
        ),
        Positioned(
          child: SlideTransition(
            position: offset!,
            child: widget.rightBottomChild ?? Container(),
          ),
          bottom: safeAreaBottom,
          right: AriTheme.windowsInsets.right,
        ),
      ],
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    mapBloc.cancelGeoLocationSubscription();
    moveLocationController.dispose();
    super.dispose();
  }

  /// NOTE:
  /// 地图长按事件
  void onLongPress(tapPosition, LatLng latLng) {
    if (widget.onLongPress != null) {
      widget.onLongPress!(latLng);
    }
  }
}

/***************  私有方法  ***************/

/// 添加地图控制器的动作监听
void _addMapControllerListener(
    MapController mapController, AriMapBloc mapBloc) {
  mapController.mapEventStream.listen((evt) {
    //  事件：MapEventMoveEnd 的evt.source 是dragEnd
    if (evt.source == MapEventSource.dragEnd) {
      mapBloc.add(IsCenterOnLocationEvent(isCenter: false));
    } else if (evt is MapEventWithMove) {
      mapBloc.add(MapMoveEvent(latLng: evt.center));
    }
    // else if(evt.source == MapEventSource.)
  });
}

/// 地图中心跳转到指定位置
///
/// 判断是否传入[animationController] :
/// - `有animationController`: 通过动画控制器实现平滑跳转，会有一个缓慢的移动和缩放效果
/// - `没有animationController`: 直接跳转，不平滑
void _moveToLocation({
  required MapController mapController,
  required LatLng latLng,
  required double? zoom,
  required Offset offset,
  AnimationController? animationController,
}) async {
  if (animationController != null) {
    /// 纬度跳转区间
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: latLng.latitude);

    /// 经度跳转区间
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: latLng.longitude);

    /// 缩放跳转区间
    final zoomTween = Tween<double>(
        begin: mapController.zoom, end: zoom ?? mapController.zoom);

    final offsetTween = Tween<Offset>(begin: Offset(0, 0), end: offset);

    /// 动画设置
    final Animation<double> animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    animationController.addListener(() {
      _mapFlyToPostion(
          mapController, animation, latTween, lngTween, zoomTween, offsetTween);
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      } else if (status == AnimationStatus.dismissed) {
        animationController.dispose();
      }
    });
    animationController.forward();
  } else {
    mapController.move(latLng, zoom ?? mapController.zoom, offset: offset);
  }
}

/// 地图通过平滑地平移和缩放到指定的位置
///
/// - `animation`: 动画控制器
/// - `latTween`: 纬度跳转区间
/// - `lngTween`: 经度跳转区间
/// - `zoomTween`: 缩放跳转区间
///
/// 通过 Tween 类的 evaluate 方法实现动画效果。
///
/// Tween 类的 evaluate 方法用于根据动画对象的当前状态计算出中间值。
/// 这个方法通常接收一个 Animation<double> 对象作为参数。
/// ```dart
/// final Tween<double> tween = Tween<double>(begin: 0, end: 200);
/// final AnimationController controller = AnimationController(
///  duration: const Duration(seconds: 2),
///  vsync: this, // 'this' would typically refer to a State object that is a TickerProvider
/// );
/// controller.forward();
/// print(tween.evaluate(controller)); // 输出依赖于controller当前的值
/// ```
void _mapFlyToPostion(
    MapController mapController,
    Animation<double> animation,
    Tween<double> latTween,
    Tween<double> lngTween,
    Tween<double> zoomTween,
    Tween<Offset> offsetTween) {
  try {
    mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        offset: offsetTween.evaluate(animation));
  } catch (e) {
    logger.w(e);
  }
}
