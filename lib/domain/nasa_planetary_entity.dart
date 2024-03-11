import 'nasa_planetary_photo.dart';

class NasaPlanetaryEntity {
  final String? explanation;
  final String? title;
  final String? url;
  final String? date;

  NasaPlanetaryEntity({
    this.explanation,
    this.title,
    this.url,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "explanation": explanation,
      "title": title,
      "url": url,
      "date": date,
    };
  }

  factory NasaPlanetaryEntity.fromNasaPlanetaryPhoto(
      NasaPlanetaryPhoto planetaryPhoto) {
    return NasaPlanetaryEntity(
        explanation: planetaryPhoto.explanation,
        title: planetaryPhoto.title,
        url: planetaryPhoto.url,
        date: planetaryPhoto.date);
  }
}
