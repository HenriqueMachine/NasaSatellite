import 'dart:convert';

import 'package:nasa_satellite/httpi_response.dart';
import 'package:nasa_satellite/nasa_planetary_photo.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../error_message.dart';

class NasaApi {
  static const String _nasaBaseUrl = AppConfig.nasaPlanetaryBaseUrl;

  Future<HttpResponse<List<NasaPlanetaryPhoto>>> fetchPhotos(
      DateTime startDate, DateTime endDate) async {
    try {
      final response = await http.get(
          Uri.parse("$_nasaBaseUrl&start_date=$startDate&end_date=$endDate"));
      return _handleResponse(response);
    } catch (e) {
      return HttpResponse<List<NasaPlanetaryPhoto>>(
        success: false,
        errorMessage: 'Error: $e',
      );
    }
  }

  HttpResponse<List<NasaPlanetaryPhoto>> _handleResponse(
      http.Response response) {
    try {
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<NasaPlanetaryPhoto> list =
            jsonList.map((json) => NasaPlanetaryPhoto.fromJson(json)).toList();
        return HttpResponse<List<NasaPlanetaryPhoto>>(
          success: true,
          data: list,
          statusCode: response.statusCode,
        );
      } else {
        return HttpResponse<List<NasaPlanetaryPhoto>>(
          success: false,
          errorMessage: ErrorMessage.messageErrorLoadListPhoto,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return HttpResponse<List<NasaPlanetaryPhoto>>(
        success: false,
        errorMessage: 'Error: $e',
      );
    }
  }
}
