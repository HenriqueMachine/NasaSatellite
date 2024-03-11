import 'package:nasa_satellite/nasa_planetary_photo.dart';

class NasaPlanetaryEntity {
  final String? explanation;
  final String? title;
  final String? url;

  NasaPlanetaryEntity({
    this.explanation,
    this.title,
    this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'explanation': explanation,
      'title': title,
      'url': url,
    };
  }

  factory NasaPlanetaryEntity.fromNasaPlanetaryPhoto(
      NasaPlanetaryPhoto planetaryPhoto) {
    return NasaPlanetaryEntity(
        explanation: planetaryPhoto.explanation,
        title: planetaryPhoto.title,
        url: planetaryPhoto.url);
  }
}
