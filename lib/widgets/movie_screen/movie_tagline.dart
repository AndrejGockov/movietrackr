import 'package:flutter/cupertino.dart';

import '../../app_theme.dart';

class Tagline extends StatelessWidget {
  final String tagline;

  const Tagline({super.key, required this.tagline});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppTheme.sm),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.md),
          child: Text(
            tagline,
            style: AppTheme.h5SemiboldOnMediumBlue,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}