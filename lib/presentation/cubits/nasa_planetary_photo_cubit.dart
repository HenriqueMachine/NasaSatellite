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

  Future<void> getPlanetaryList() async {
    final ConnectivityResult network = await Connectivity().checkConnectivity();
    if (network.isConnected) {
      await _fetchPhotosFromService();
    } else {
      await _fetchPhotosFromDatabase();
    }
  }

  Future<void> _fetchPhotosFromService() async {
    final HttpResponse<List<NasaPlanetaryPhoto>> response = await service.fetchPhotos(
      "$_batchYearStart-$_batchMonthStart-01",
      "$_batchYearEnd-$_batchMonthEnd-01",
    );
    response.handleStatusCode(
      on200: _handleSuccess,
      on400: _handleError,
      unknownError: _handleError,
    );
  }

  Future<void> _fetchPhotosFromDatabase() async {
    final List<NasaPlanetaryEntity> response = await service.fetchPhotosFromDatabase();
    final List<NasaPlanetaryViewObject> viewObjectList = response.map((entity) {
      return NasaPlanetaryViewObject.fromEntity(entity);
    }).toList();
    _viewObjectList.addAll(viewObjectList);
    emitSuccess();
  }

  void _handleSuccess(List<NasaPlanetaryPhoto> data) {
    data.removeLast();
    final List<NasaPlanetaryViewObject> viewObjectList = data.map((photo) {
      return NasaPlanetaryViewObject.fromHttpResponse(photo);
    }).toList();
    _viewObjectList.addAll(viewObjectList);
    emitSuccess();
  }

  void _handleError(String errorMessage) {
    emit(StateView.error(error: errorMessage));
  }

  void emitSuccess() {
    emit(StateView.success(_viewObjectList));
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

  void filterList(String queryFilter) {
    if (queryFilter.isNotEmpty) {
      final String normalizeQuery = queryFilter.toLowerCase();
      final List<NasaPlanetaryViewObject> filteredList = _viewObjectList
          .where((photo) => photo.title!.toLowerCase().contains(normalizeQuery) || photo.date!.toLowerCase().contains(normalizeQuery))
          .toList();
      emit(StateView.success(filteredList));
    } else {
      emit(StateView.success(_viewObjectList));
    }
  }
}
