import 'package:flutter/material.dart';
import 'package:nasa_satellite/core/dimens.dart';
import 'package:nasa_satellite/core/error_message.dart';
import 'package:nasa_satellite/domain/nasa_planetary_view_object.dart';

class PhotoDetailPage extends StatelessWidget {
  final NasaPlanetaryViewObject photo;

  const PhotoDetailPage({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.title ?? ErrorMessage.failToRecoverTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.DimenDouble16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(photo.url ?? ErrorMessage.failToRecoverURL),
            const SizedBox(height: Dimensions.DimenDouble16),
            Text(
              photo.title ?? ErrorMessage.failToRecoverTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.DimenDouble24,
              ),
            ),
            const SizedBox(height: Dimensions.DimenDouble8),
            Text(
              "Date: ${photo.date ?? ErrorMessage.failToRecoverDate}",
              style: const TextStyle(
                fontSize: Dimensions.DimenDouble16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: Dimensions.DimenDouble16),
            Text(
              photo.explanation ?? ErrorMessage.failToRecoverExplanation,
              style: const TextStyle(
                fontSize: Dimensions.DimenDouble16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
