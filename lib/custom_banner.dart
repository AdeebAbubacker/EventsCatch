import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class InAppNotificationBanner extends StatelessWidget {
  final String title;
  final String body;
  final List<String>? imageUrls;
  final VoidCallback onClose;

  const InAppNotificationBanner({
    super.key,
    required this.title,
    required this.body,
    this.imageUrls,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(title),
              subtitle: Text(body),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ),
            if (imageUrls != null && imageUrls!.isNotEmpty)
      PageStorage(
  bucket: PageStorageBucket(),
  child: CarouselSlider(
    key: PageStorageKey('in_app_carousel'),
    options: CarouselOptions(
      height: 150,
      enlargeCenterPage: true,
      autoPlay: true,
    ),
    items: imageUrls!.map((url) => Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey,
        child: const Icon(Icons.broken_image, size: 50),
      ),
    )).toList(),
  ),
)

          ],
        ),
      ),
    );
  }
}


