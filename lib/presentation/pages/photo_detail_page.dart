import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        padding: const EdgeInsets.all(Dimensions.dimenDouble16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: photo.url ?? ErrorMessage.failToRecoverURL,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: Dimensions.dimenDouble16),
            Text(
              photo.title ?? ErrorMessage.failToRecoverTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.dimenDouble24,
              ),
            ),
            const SizedBox(height: Dimensions.dimenDouble8),
            Text(
              "Date: ${photo.date ?? ErrorMessage.failToRecoverDate}",
              style: const TextStyle(
                fontSize: Dimensions.dimenDouble16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: Dimensions.dimenDouble16),
            Text(
              photo.explanation ?? ErrorMessage.failToRecoverExplanation,
              style: const TextStyle(
                fontSize: Dimensions.dimenDouble16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
