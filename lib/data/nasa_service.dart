import 'dart:convert';

import 'package:nasa_satellite/core/database_helper.dart';
import 'package:nasa_satellite/core/http_response.dart';
import 'package:nasa_satellite/domain/nasa_planetary_entity.dart';
import 'package:http/http.dart' as http;
import '../core/app_config.dart';
import '../domain/nasa_planetary_photo.dart';
import '../core/error_message.dart';

class NasaService {
  static const String _nasaBaseUrl = AppConfig.nasaPlanetaryBaseUrl;

  Future<HttpResponse<List<NasaPlanetaryPhoto>>> fetchPhotos(
      String startDate, String endDate) async {
    try {
      final response = await http.get(
          Uri.parse("$_nasaBaseUrl&start_date=$startDate&end_date=$endDate"));
      return _handleResponse(response);
    } catch (e) {
      return HttpResponse<List<NasaPlanetaryPhoto>>(
        errorMessage: 'Error: $e',
      );
    }
  }

  Future<List<NasaPlanetaryEntity>> fetchPhotosFromDatabase() async {
    return DatabaseHelper().getNasaPlanetaryEntities();
  }

  HttpResponse<List<NasaPlanetaryPhoto>> _handleResponse(
      http.Response response) {
    try {
      if (response.statusCode == 200) {
        DatabaseHelper().clearTable();
        List<dynamic> jsonList = json.decode(response.body);
        List<NasaPlanetaryPhoto> list =
            jsonList.map((json) => NasaPlanetaryPhoto.fromJson(json)).toList();
        for (var element in list) {
          DatabaseHelper().insertData(
              NasaPlanetaryEntity.fromNasaPlanetaryPhoto(element).toMap());
        }
        return HttpResponse<List<NasaPlanetaryPhoto>>(
          data: list,
          statusCode: response.statusCode,
        );
      } else {
        return HttpResponse<List<NasaPlanetaryPhoto>>(
          errorMessage: ErrorMessage.messageErrorLoadListPhoto,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return HttpResponse<List<NasaPlanetaryPhoto>>(
        errorMessage: 'Error: $e',
      );
    }
  }
}
