import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nasa_satellite/core/database_helper.dart';
import 'package:nasa_satellite/core/http_response.dart';
import 'package:nasa_satellite/core/network_extensions.dart';
import 'package:nasa_satellite/data/nasa_service.dart';
import 'package:nasa_satellite/domain/nasa_planetary_entity.dart';
import 'package:nasa_satellite/domain/nasa_planetary_photo.dart';

class GetPlanetaryListUseCase {
  final NasaService service;
  final DatabaseHelper databaseHelper;

  GetPlanetaryListUseCase(this.service, this.databaseHelper);

  Future<HttpResponse<List<NasaPlanetaryPhoto>>> fetchPhotos(int batchYearStart,
      int batchYearEnd, int batchMonthStart, int batchMonthEnd) async {
    final ConnectivityResult network = await Connectivity().checkConnectivity();
    if (network.isConnected) {
      return await _fetchPhotosFromService(
          batchYearStart, batchYearEnd, batchMonthStart, batchMonthEnd);
    } else {
      return await _fetchPhotosFromDatabase();
    }
  }

  Future<HttpResponse<List<NasaPlanetaryPhoto>>> _fetchPhotosFromService(
      int batchYearStart,
      int batchYearEnd,
      int batchMonthStart,
      int batchMonthEnd) async {
    final response = await service.fetchPhotos(
      "$batchYearStart-$batchMonthStart-01",
      "$batchYearEnd-$batchMonthEnd-01",
    );
    return response;
  }

  Future<HttpResponse<List<NasaPlanetaryPhoto>>>
      _fetchPhotosFromDatabase() async {
    final List<NasaPlanetaryEntity> response =
        await databaseHelper.getNasaPlanetaryEntities();
    final List<NasaPlanetaryPhoto> photos = response.map((entity) {
      return NasaPlanetaryPhoto.fromEntity(entity);
    }).toList();
    return HttpResponse<List<NasaPlanetaryPhoto>>(data: photos);
  }
}
