import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../app_theme.dart';

class ImageViewer extends StatelessWidget {
  final String url;

  const ImageViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlue,
      body: Stack(
        children: [
          Hero(
            tag: url,
            child: PhotoView(
              backgroundDecoration:
              const BoxDecoration(color: AppTheme.deepBlue),
              imageProvider: NetworkImage(url),

              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.0,
            ),
          ),
        ],
      ),
    );
  }
}