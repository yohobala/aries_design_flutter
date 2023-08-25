import 'package:latlong2/latlong.dart';
import 'event.dart';
import 'repository.dart';
import 'state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

class AriMapBloc extends Bloc<AriMapEvent, AriMapState> {
  AriMapBloc(this.ariMapRepository, this.ariGeoLocationRepository)
      : super(InitialState()) {
    on<GoToPositionEvent>(_GoToPositionEvent);
  }

  final AriMapRepository ariMapRepository;
  final AriGeoLocationRepository ariGeoLocationRepository;

  void _GoToPositionEvent(
      GoToPositionEvent event, Emitter<AriMapState> emit) async {
    LatLng latLng = await ariGeoLocationRepository.getLocation();
    emit(MapLocationState(center: latLng, zoom: 13));
  }
}
