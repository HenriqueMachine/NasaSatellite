import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/http_response.dart';
import 'package:nasa_satellite/nasa_planetary_photo.dart';
import 'package:nasa_satellite/nasa_planetary_view_object.dart';
import 'package:nasa_satellite/network_extensions.dart';
import 'package:nasa_satellite/stateview.dart';

import 'nasa_planetary_entity.dart';
import 'nasa_service.dart';

class NasaPlanetaryPhotoCubit
    extends Cubit<StateView<List<NasaPlanetaryViewObject>>> {
  final NasaService service;

  NasaPlanetaryPhotoCubit(this.service) : super(StateView.loading());

  static NasaPlanetaryPhotoCubit create() {
    final NasaService nasaService = NasaService();
    return NasaPlanetaryPhotoCubit(nasaService);
  }

  void getPlanetaryList() async {
    ConnectivityResult network = await Connectivity().checkConnectivity();
    if (network.isConnected) {
      HttpResponse<List<NasaPlanetaryPhoto>> response =
          await service.fetchPhotos("1999-01-01", "1999-02-01");

      response.handleStatusCode(on200: (data) {
        List<NasaPlanetaryViewObject> viewObject = data.map((element) {
          return NasaPlanetaryViewObject.fromHttpResponse(element);
        }).toList();
        emit(StateView.success(viewObject));
      }, on400: (errorMessage) {
        emit(StateView.error(error: errorMessage));
      }, unknownError: (errorMessage) {
        emit(StateView.error(error: errorMessage));
      });
    } else {
      List<NasaPlanetaryEntity> response =
          await service.fetchPhotosFromDatabase();
      List<NasaPlanetaryViewObject> viewObject = response.map((element) {
        return NasaPlanetaryViewObject.fromEntity(element);
      }).toList();
      emit(StateView.success(viewObject));
    }
  }
}
