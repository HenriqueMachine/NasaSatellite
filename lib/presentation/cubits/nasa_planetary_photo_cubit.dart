import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/core/http_response.dart';
import 'package:nasa_satellite/domain/nasa_planetary_view_object.dart';
import 'package:nasa_satellite/core/network_extensions.dart';
import 'package:nasa_satellite/core/state_view.dart';

import '../../domain/nasa_planetary_entity.dart';
import '../../data/nasa_service.dart';
import '../../domain/nasa_planetary_photo.dart';

class NasaPlanetaryPhotoCubit
    extends Cubit<StateView<List<NasaPlanetaryViewObject>>> {

  int _batchYearStart = 1999;
  int _batchYearEnd = 1999;
  int _batchMonthStart = 1;
  int _batchMonthEnd = 2;

  final List<NasaPlanetaryViewObject> _viewObjectList = [];
  final NasaService service;

  NasaPlanetaryPhotoCubit(this.service) : super(StateView.loading());

  static NasaPlanetaryPhotoCubit create() {
    final NasaService nasaService = NasaService();
    return NasaPlanetaryPhotoCubit(nasaService);
  }

  Future getPlanetaryList() async {
    emit(StateView.loading());
    ConnectivityResult network = await Connectivity().checkConnectivity();
    if (network.isConnected) {
      HttpResponse<List<NasaPlanetaryPhoto>> response =
          await service.fetchPhotos("$_batchYearStart-$_batchMonthStart-01",
              "$_batchYearEnd-$_batchMonthEnd-01");

      response.handleStatusCode(on200: (data) {
        List<NasaPlanetaryViewObject> viewObject = data.map((element) {
          return NasaPlanetaryViewObject.fromHttpResponse(element);
        }).toList();
        _viewObjectList.addAll(viewObject);
        emit(StateView.success(_viewObjectList));
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
      _viewObjectList.addAll(viewObject);
      emit(StateView.success(_viewObjectList));
    }
  }

  void incrementMonth() {
    _batchMonthStart++;
    _batchMonthEnd++;
    if (_batchMonthEnd > 12) {
      _batchYearEnd++;
      _batchMonthEnd = 1;
      _batchYearStart = _batchYearEnd - 1;
    }
    getPlanetaryList();
  }

  void filterList(String queryFilter){
    List<NasaPlanetaryViewObject> filteredList = [];
    if(queryFilter.isNotEmpty){

    }
  }

}
