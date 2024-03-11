import 'package:flutter/material.dart';

import '../../core/dimens.dart';

class CardTileItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final VoidCallback onTap;

  const CardTileItem({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: Dimensions.DimenDouble8,
        margin: const EdgeInsets.all(Dimensions.DimenDouble8),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: Dimensions.DimenDouble16,
              left: Dimensions.DimenDouble16,
              right: Dimensions.DimenDouble16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.DimenDouble16,
                    ),
                  ),
                  const SizedBox(height: Dimensions.DimenDouble8),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
