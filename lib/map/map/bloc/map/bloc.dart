import 'dart:async';

import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

class AriMapBloc extends Bloc<AriMapEvent, AriMapState> {
  AriMapBloc(this.mapRepo, this.geoLocationRepo, this.markerBloc)
      : super(InitAriMapBlocState()) {
    /***************  添加监听  ***************/
    on<InitAriMapEvent>(initAriMapEvent);
    on<InitAriMapCompleteEvent>(initAriMapCompleteEvent);
    on<CheckGeoLocationAvailableEvent>(checkGeoLocationAvailableEvent);

    on<MapMoveEvent>(mapMoveEvent);

    on<MoveToLocationEvent>(moveToLocationEvent);
    on<ChangeLocationEvent>(changeLocationEvent);
    on<UpdateLocationMarkerEvent>(updateLocationMarkerEvent);

    on<UpdateLayerEvent>(updateLayerEvent);

    // 派发初始化事件
    add(InitAriMapEvent());
  }

  /***************  公有变量  ***************/

  /// 地图仓库
  final AriMapRepo mapRepo;

  /// 定位仓库
  final AriGeoLocationRepo geoLocationRepo;

  final AriMarkerBloc markerBloc;

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

  /// 图层
  List<AriLayerModel> _layers = [];

  /// GPS位置标记
  final AriMarkerModel _postionMarker = AriMarkerModel(
      key: defalutPositionMarkerKey,
      layerkey: defalutPositionMakerLayerKey,
      type: MarkerType.location);

  @override
  Future<void> close() {
    // 取消订阅
    cancelGeoLocationSubscription();
    return super.close();
  }

  /***************  初始化、权限有关事件 ***************/

  /// 初始化事件
  void initAriMapEvent(InitAriMapEvent event, Emitter<AriMapState> emit) async {
    if (!isInit) {
      /// NOTE:
      /// 检查定位权限
      _geoLocationAvailable = await geoLocationRepo.checkPermission();
      emit(UpdateGeoLocationAvailableState());

      /// NOTE:
      /// 开启定位流
      listenLocationStream();
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
    if (_geoLocationAvailable) {
      emit(IsCenterOnPostion(isCenter: event.isCenter));
    }
  }

  /***************  位置有关事件  ***************/

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
        emit(IsCenterOnPostion(isCenter: true));
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
    // NOTE:
    // 发出当前位置改变状态
    emit(ChangeLocation());

    // NOTE:
    // 改变为当前位置是在地图中心
    emit(IsCenterOnPostion(isCenter: false));

    /// NOTE:
    /// 更新定位标记
    LatLng latLng = await geoLocationRepo.getLocation();
    updateLocationMarkerEvent(UpdateLocationMarkerEvent(latLng: latLng), emit);
  }

  /// 更新定位标记
  FutureOr<void> updateLocationMarkerEvent(
      UpdateLocationMarkerEvent event, Emitter<AriMapState> emit) {
    _postionMarker.updateLatLng(event.latLng);
    markerBloc.add(UpdateMarkeEvent(marker: _postionMarker));
  }

  /***************  图层有关事件  ***************/

  /// 更新图层
  void updateLayerEvent(
      UpdateLayerEvent event, Emitter<AriMapState> emit) async {
    _layers = event.layers;
    emit(UpdateLayerState(layers: event.layers));
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
          isInit = true;
          // 在这里处理错误
          logger.d("出现错误");
        },
        onDone: () {
          isInit = true;
          // 处理流关闭的情况
          logger.d("处理流关闭的情况");
        },
      );
    }
  }

  void cancelGeoLocationSubscription() {
    _locationSubscription?.cancel();
  }

  /***************  私有方法  ***************/
}
