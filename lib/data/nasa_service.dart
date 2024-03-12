import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nasa_satellite/core/database_helper.dart';
import 'package:nasa_satellite/core/http_response.dart';
import 'package:nasa_satellite/domain/nasa_planetary_entity.dart';
import 'package:nasa_satellite/domain/nasa_planetary_photo.dart';

import '../core/app_config.dart';
import '../core/error_message.dart';

/// A class responsible for interacting with the NASA API to fetch photos.
class NasaService {
  static const String _nasaBaseUrl = AppConfig.nasaPlanetaryBaseUrl;

  final DatabaseHelper databaseHelper;
  final http.Client client;

  NasaService(this.databaseHelper, {required this.client});

  /// Fetches photos from the NASA API based on the provided start and end dates.
  Future<HttpResponse<List<NasaPlanetaryPhoto>>> fetchPhotos(
      String startDate, String endDate) async {
    try {
      final response = await _fetchPhotosFromApi(startDate, endDate);
      return _handleResponse(response);
    } catch (e) {
      return HttpResponse<List<NasaPlanetaryPhoto>>(
        errorMessage: "Error: $e",
      );
    }
  }

  /// Internal method to perform the HTTP GET request to the NASA API.
  Future<http.Response> _fetchPhotosFromApi(
      String startDate, String endDate) async {
    return await client.get(
        Uri.parse("$_nasaBaseUrl&start_date=$startDate&end_date=$endDate"));
  }

  /// Handles the HTTP response from the NASA API and processes the data.
  HttpResponse<List<NasaPlanetaryPhoto>> _handleResponse(
      http.Response response) {
    try {
      if (response.statusCode == 200) {
        return _handleSuccess(response);
      } else {
        return HttpResponse<List<NasaPlanetaryPhoto>>(
          errorMessage: ErrorMessage.messageErrorLoadListPhoto,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return HttpResponse<List<NasaPlanetaryPhoto>>(
        errorMessage: "Error: $e",
      );
    }
  }

  /// Parses the successful HTTP response from the NASA API.
  HttpResponse<List<NasaPlanetaryPhoto>> _handleSuccess(
      http.Response response) {
    databaseHelper.clearTable();
    List<dynamic> jsonList = json.decode(response.body);
    List<NasaPlanetaryPhoto> list =
        jsonList.map((json) => NasaPlanetaryPhoto.fromJson(json)).toList();
    for (var element in list) {
      databaseHelper.insertData(
          NasaPlanetaryEntity.fromNasaPlanetaryPhoto(element).toMap());
    }
    return HttpResponse<List<NasaPlanetaryPhoto>>(
      data: list,
      statusCode: response.statusCode,
    );
  }

  /// Fetches photos from the local database.
  Future<List<NasaPlanetaryEntity>> fetchPhotosFromDatabase() async {
    return databaseHelper.getNasaPlanetaryEntities();
  }
}
