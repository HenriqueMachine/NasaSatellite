import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/http_response.dart';
import 'package:nasa_satellite/nasa_planetary_photo.dart';
import 'package:nasa_satellite/stateview.dart';

import 'nasa_service.dart';

class NasaPlanetaryPhotoCubit
    extends Cubit<StateView<List<NasaPlanetaryPhoto>>> {
  final NasaService service;

  NasaPlanetaryPhotoCubit(this.service) : super(StateView.loading());

  static NasaPlanetaryPhotoCubit create() {
    final NasaService nasaService = NasaService();
    return NasaPlanetaryPhotoCubit(nasaService);
  }

  void getPlanetaryList() async {
    HttpResponse<List<NasaPlanetaryPhoto>> response =
        await service.fetchPhotos("1999-01-01", "1999-01-01");

    response.handleStatusCode(on200: (data) {
      emit(StateView.success(data));
    }, on400: (errorMessage) {
      emit(StateView.error(error: errorMessage));
    }, unknownError: (errorMessage) {
      emit(StateView.error(error: errorMessage));
    });
  }
}
