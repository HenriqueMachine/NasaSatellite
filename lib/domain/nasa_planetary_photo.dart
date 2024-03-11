class NasaPlanetaryPhoto {
  final String? date;
  final String? explanation;
  final String? hdurl;
  final String? mediaType;
  final String? serviceVersion;
  final String? title;
  final String? url;
  final String? copyright;

  NasaPlanetaryPhoto({
    this.date,
    this.explanation,
    this.hdurl,
    this.mediaType,
    this.serviceVersion,
    this.title,
    this.url,
    this.copyright,
  });

  factory NasaPlanetaryPhoto.fromJson(Map<String, dynamic> json) {
    return NasaPlanetaryPhoto(
      date: json['date'],
      explanation: json['explanation'],
      hdurl: json['hdurl'],
      mediaType: json['media_type'],
      serviceVersion: json['service_version'],
      title: json['title'],
      url: json['url'],
      copyright: json['copyright'],
    );
  }
}
