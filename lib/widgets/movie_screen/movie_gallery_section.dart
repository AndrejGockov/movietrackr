import 'package:flutter/material.dart';
import 'package:movietrackr/widgets/shared/section_separator.dart';
import 'package:movietrackr/widgets/shared/image_viewer.dart';
import 'package:movietrackr/widgets/shared/loading_screen.dart';

import '../../app_theme.dart';
import '../../models/gallery.dart';

class MovieGallery extends StatelessWidget {
  final Gallery gallery;

  const MovieGallery({super.key, required this.gallery});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gallery", style: AppTheme.h3SemiboldOnMediumBlue),

        SectionSeparator(),

        SizedBox(
          height: 160,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: gallery.backdrops.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(right: AppTheme.md),
                width: 250,
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.xs),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageViewer(
                          url: gallery.backdrops[index].display(),
                        ),
                      ),
                    ),

                    child: Hero(
                      tag: gallery.backdrops[index].filePath,
                      child: Image.network(
                        gallery.backdrops[index].display(),
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (
                            BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                            ) {
                          if (loadingProgress == null) return child;
                          return LoadingScreen();
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: AppTheme.xl),
      ],
    );
  }
}