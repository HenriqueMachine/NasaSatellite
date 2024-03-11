import 'package:flutter/material.dart';
import 'package:nasa_satellite/domain/nasa_planetary_view_object.dart';

class PhotoDetailPage extends StatelessWidget {
  final NasaPlanetaryViewObject photo;

  const PhotoDetailPage({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.title ?? ""),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(photo.url ?? ""),
            const SizedBox(height: 16.0),
            Text(
              photo.title ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Date: ${photo.date ?? ""}",
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              photo.explanation ?? "",
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
