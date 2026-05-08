import 'package:flutter/material.dart';
import 'package:movietrackr/services/auth_service.dart';

import '../../app_theme.dart';

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.deepBlue,
      title: Text(
        "MovieTrackr",
        style: AppTheme.h1SemiboldOnMediumBlue,
      ),
      actions: [
      ],
    );
  }
}
