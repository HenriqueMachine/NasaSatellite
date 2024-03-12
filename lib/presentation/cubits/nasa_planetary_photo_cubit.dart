import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/core/database_helper.dart';
import 'package:nasa_satellite/core/state_view.dart';
import 'package:nasa_satellite/data/nasa_service.dart';
import 'package:nasa_satellite/domain/nasa_planetary_view_object.dart';
import 'package:http/http.dart' as http;
import 'package:nasa_satellite/domain/nasa_planetary_photo.dart';
import 'package:nasa_satellite/presentation/usecase/filter_photo_usecase.dart';
import 'package:nasa_satellite/presentation/usecase/get_planetary_list_usecase.dart';
import 'package:nasa_satellite/presentation/usecase/increment_month_usecase.dart';

class NasaPlanetaryPhotoCubit
    extends Cubit<StateView<List<NasaPlanetaryViewObject>>> {
  final GetPlanetaryListUseCase _getPlanetaryListUseCase;
  final FilterPhotosUseCase _filterPhotosUseCase;
  final IncrementMonthUseCase _incrementMonthUseCase;

  List<NasaPlanetaryViewObject> _viewObjectList = [];
  int _batchYearStart = 1999;
  int _batchYearEnd = 1999;
  int _batchMonthStart = 1;
  int _batchMonthEnd = 2;

  NasaPlanetaryPhotoCubit(
    this._getPlanetaryListUseCase,
    this._filterPhotosUseCase,
    this._incrementMonthUseCase,
  ) : super(StateView.loading());

  static NasaPlanetaryPhotoCubit create(http.Client httpClient) {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final NasaService nasaService =
        NasaService(databaseHelper, client: httpClient);
    final GetPlanetaryListUseCase getPlanetaryListUseCase =
        GetPlanetaryListUseCase(nasaService, databaseHelper);
    final FilterPhotosUseCase filterPhotosUseCase = FilterPhotosUseCase();
    final IncrementMonthUseCase incrementMonthUseCase = IncrementMonthUseCase();

    return NasaPlanetaryPhotoCubit(
      getPlanetaryListUseCase,
      filterPhotosUseCase,
      incrementMonthUseCase,
    );
  }

  Future<void> getPlanetaryList() async {
    final response = await _getPlanetaryListUseCase.fetchPhotos(
      _batchYearStart,
      _batchYearEnd,
      _batchMonthStart,
      _batchMonthEnd,
    );
    response.handleStatusCode(
      on200: _handleSuccess,
      on400: _handleError,
      unknownError: _handleError,
    );
  }

  void _handleSuccess(List<NasaPlanetaryPhoto> data) {
    data.removeLast();
    _viewObjectList = data
        .map((photo) => NasaPlanetaryViewObject.fromHttpResponse(photo))
        .toList();
    emitSuccess();
  }

  void _handleError(String errorMessage) {
    emit(StateView.error(error: errorMessage));
  }

  void emitSuccess() {
    emit(StateView.success(_viewObjectList));
  }

  void incrementMonth() {
    final updatedDates = _incrementMonthUseCase.incrementMonth(
      _batchYearStart,
      _batchYearEnd,
      _batchMonthStart,
      _batchMonthEnd,
    );
    _batchYearStart = updatedDates[0];
    _batchYearEnd = updatedDates[1];
    _batchMonthStart = updatedDates[2];
    _batchMonthEnd = updatedDates[3];
    getPlanetaryList();
  }

  void filterList(String queryFilter) {
    final filteredList =
        _filterPhotosUseCase.filterList(_viewObjectList, queryFilter);
    emit(StateView.success(filteredList));
  }
}
