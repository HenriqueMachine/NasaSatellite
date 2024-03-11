import 'package:nasa_satellite/domain/nasa_planetary_entity.dart';

import 'nasa_planetary_photo.dart';

class NasaPlanetaryViewObject {
  final String? explanation;
  final String? title;
  final String? url;
  final String? date;

  NasaPlanetaryViewObject({
    this.explanation,
    this.title,
    this.url,
    this.date,
  });

  factory NasaPlanetaryViewObject.fromEntity(
      NasaPlanetaryEntity planetaryPhoto) {
    return NasaPlanetaryViewObject(
        explanation: planetaryPhoto.explanation,
        title: planetaryPhoto.title,
        url: planetaryPhoto.url,
        date: planetaryPhoto.date);
  }

  factory NasaPlanetaryViewObject.fromHttpResponse(
      NasaPlanetaryPhoto planetaryPhoto) {
    return NasaPlanetaryViewObject(
        explanation: planetaryPhoto.explanation,
        title: planetaryPhoto.title,
        url: planetaryPhoto.url,
        date: planetaryPhoto.date);
  }
}
