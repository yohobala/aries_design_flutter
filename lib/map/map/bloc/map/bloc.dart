import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

class AriMapBloc extends Bloc<AriMapEvent, AriMapState> {
  AriMapBloc(
    this.mapRepo,
    this.geoLocationRepo,
    this.markerBloc,
    this.mapController,
    this.openLocation,
  ) : super(InitAriMapBlocState()) {
    /***************  添加监听  ***************/
    on<InitAriMapEvent>(initAriMapEvent);
    on<InitAriMapCompleteEvent>(initAriMapCompleteEvent);
    on<CheckGeoLocationAvailableEvent>(checkGeoLocationAvailableEvent);

    on<MapMoveEvent>(mapMoveEvent);

    on<IsCenterOnLocationEvent>(isCenterOnLocationEvent);
    on<MoveToLocationEvent>(moveToLocationEvent);
    on<ChangeLocationEvent>(changeLocationEvent);
    on<UpdateLocationMarkerEvent>(updateLocationMarkerEvent);
    on<ChangeCompassEvent>(changeCompassEvent);

    on<UpdateLayerEvent>(updateLayerEvent);
    on<MoveMarkerStatusEvent>(moveMarkerStatusEvent);

    // 派发初始化事件
    add(InitAriMapEvent());
  }

  @override
  Future<void> close() {
    // 取消订阅
    cancelGeoLocationSubscription();
    return super.close();
  }

  /***************  公有变量  ***************/

  /// 地图仓库
  final AriMapRepo mapRepo;

  /// 定位仓库
  final AriGeoLocationRepo geoLocationRepo;

  final AriMapMarkerBloc markerBloc;

  final MapController mapController;

  final bool openLocation;

  /// 是否支持定位
  bool get geoLocationAvailable => _geoLocationAvailable;

  /// 图层
  List<AriLayerModel> get layers => _layers;

  /***************  私有变量  ***************/

  /// 是否已经初始化
  bool isInit = false;

  /// 定位流
  // ignore: unused_field
  StreamSubscription<LatLng>? _locationSubscription;

  /// 是否支持定位
  bool _geoLocationAvailable = false;

  /// 方位流
  // ignore: unused_field
  StreamSubscription<double>? _compassSubscription;

  bool _compassAvailabel = false;

  /// 图层
  List<AriLayerModel> _layers = [];

  /// GPS位置标记
  final AriMapMarkerModel _postionMarker = AriMapMarkerModel(
      key: defalutPositionMarkerKey,
      layerkey: defalutPositionMakerLayerKey,
      type: MarkerType.location);

  /// 当前移动的标记
  AriMapMarkerModel? currentMoveMarker;

  /// 当前移动标记的地图中心偏移量
  Offset? currentMoveMarkerOffset;

  /***************  初始化、权限有关事件 ***************/

  /// 初始化事件
  void initAriMapEvent(InitAriMapEvent event, Emitter<AriMapState> emit) async {
    if (!isInit) {
      if (openLocation) {
        /// NOTE:
        /// 检查定位权限
        _geoLocationAvailable = await geoLocationRepo.checkPermission();
        emit(UpdateGeoLocationAvailableState());

        /// NOTE:
        /// 开启定位流
        listenLocationStream();

        listenHeadingStream();
      }
    } else {
      emit(InitAriMapState());
    }
  }

  FutureOr<void> initAriMapCompleteEvent(
      InitAriMapCompleteEvent event, Emitter<AriMapState> emit) {
    emit(InitAriMapState());
  }

  FutureOr<void> checkGeoLocationAvailableEvent(
      CheckGeoLocationAvailableEvent event, Emitter<AriMapState> emit) async {
    _geoLocationAvailable = await geoLocationRepo.checkPermission();
    emit(UpdateGeoLocationAvailableState());
  }

  /***************  地图有关事件  ***************/

  /// 监听到地图移动
  void mapMoveEvent(MapMoveEvent event, Emitter<AriMapState> emit) async {
    // NOTE:
    // 如果当前有移动的标记
    //
    // offset在`flutter_map`的源代码中是`newPoint - CustomPoint(offset.dx, offset.dy)`这样操作的,
    // 但是这是对地图的偏移,通过计算地图中心点,实现地图偏移,
    // 如果offset = Offset(0, -100),那么中心点会是原来中心点`下方`100像素位置的点,
    // 但是地图是显示的结果是地图`上移`,
    // 这里我们得到的地图中心是向下偏移了100像素的点,
    // 所以我们需要`newPoint + CustomPoint(offset.dx, offset.dy)`,来还原真正的位置

    if (currentMoveMarker != null) {
      LatLng latLng;
      if (currentMoveMarkerOffset != null) {
        MapOptions options = MapOptions();
        CustomPoint<double> newPoint =
            options.crs.latLngToPoint(event.latLng, mapController.zoom);
        newPoint = newPoint +
            CustomPoint(
                currentMoveMarkerOffset!.dx, currentMoveMarkerOffset!.dy);
        latLng = options.crs.pointToLatLng(newPoint, mapController.zoom);
      } else {
        latLng = event.latLng;
      }

      currentMoveMarker!.latLng = latLng;
      markerBloc.add(UpdateMarkeEvent(marker: currentMoveMarker!));
    }
  }

  /***************  位置有关事件  ***************/

  FutureOr<void> isCenterOnLocationEvent(
      IsCenterOnLocationEvent event, Emitter<AriMapState> emit) {
    if (_geoLocationAvailable) {
      emit(IsCenterOnLocation(isCenter: false));
    }
  }

  /// 地图移动到当前定位
  void moveToLocationEvent(
      MoveToLocationEvent event, Emitter<AriMapState> emit) async {
    if (_geoLocationAvailable) {
      if (event.latLng == null) {
        LatLng latLng = await geoLocationRepo.getLocation();
        // NOTE: 移动地图
        emit(MoveToLocationState(
          center: latLng,
          zoom: event.zoom ?? 13,
          offset: event.offset,
          isAnimated: event.isAnimated,
        ));
        // NOTE:
        // 改变为当前位置是在地图中心
        emit(IsCenterOnLocation(isCenter: true));
      } else {
        LatLng latLng = event.latLng!;
        emit(MoveToLocationState(
          center: latLng,
          zoom: event.zoom,
          offset: event.offset,
          isAnimated: event.isAnimated,
        ));
      }
    }
  }

  /// GPS定位发生改变
  void changeLocationEvent(
      ChangeLocationEvent event, Emitter<AriMapState> emit) async {
    /// NOTE:
    /// 更新定位标记
    LatLng latLng = await geoLocationRepo.getLocation();

    // NOTE:
    // 发出当前位置改变状态
    emit(ChangeLocation(latLng: latLng));

    // NOTE:
    // 改变为当前位置是在地图中心
    emit(IsCenterOnLocation(isCenter: false));

    if (openLocation) {
      add(UpdateLocationMarkerEvent(latLng: latLng, direction: null));
    }
  }

  /// 更新定位标记
  FutureOr<void> updateLocationMarkerEvent(
      UpdateLocationMarkerEvent event, Emitter<AriMapState> emit) {
    if (event.latLng != null) {
      _postionMarker.latLng = event.latLng!;
    }
    if (event.direction != null) {
      _postionMarker.direction = event.direction!;
    }
    markerBloc.add(UpdateMarkeEvent(marker: _postionMarker));
  }

  FutureOr<void> changeCompassEvent(
      ChangeCompassEvent event, Emitter<AriMapState> emit) {
    emit(ChangeCompassState(direction: event.direction));

    if (openLocation) {
      add(UpdateLocationMarkerEvent(latLng: null, direction: event.direction));
    }
  }

  /***************  图层有关事件  ***************/

  /// 更新图层
  void updateLayerEvent(
      UpdateLayerEvent event, Emitter<AriMapState> emit) async {
    _layers = event.layers;
    emit(UpdateLayerState(layers: event.layers));
  }

  FutureOr<void> moveMarkerStatusEvent(
      MoveMarkerStatusEvent event, Emitter<AriMapState> emit) {
    if (event.isStart) {
      AriMapMarkerModel marker = event.marker;
      assert(marker.selected);

      currentMoveMarker = marker;
      if (event.offset != Offset.zero) {
        currentMoveMarkerOffset = event.offset;
      }
    } else {
      currentMoveMarker = null;
      currentMoveMarkerOffset = null;
    }
  }

  /***************  公有方法  ***************/

  /// 监听定位流
  Future<void> listenLocationStream() async {
    if (_geoLocationAvailable && _locationSubscription == null) {
      _locationSubscription = geoLocationRepo.locationStream.listen(
        (location) {
          if (!isInit) {
            isInit = true;
            add(InitAriMapCompleteEvent());
          }
          // 处理新的位置信息
          add(ChangeLocationEvent(latLng: location));
        },
        onError: (error) {
          // 在这里处理错误
          isInit = true;
        },
        onDone: () {
          // 处理流关闭的情况
          isInit = true;
        },
      );
    }
  }

  void cancelGeoLocationSubscription() {
    _locationSubscription?.cancel();
  }

  /// 监听方位流
  Future<void> listenHeadingStream() async {
    if (_geoLocationAvailable && _compassSubscription == null) {
      _compassSubscription = geoLocationRepo.compassStream.listen(
        (direction) {
          add(ChangeCompassEvent(direction: direction));
          _compassAvailabel = true;
        },
        onError: (error) {
          _compassAvailabel = false;
        },
        onDone: () {
          _compassAvailabel = false;
        },
      );
    }
  }

  void cancelHeadingSubscription() {
    _compassSubscription?.cancel();
  }
}
