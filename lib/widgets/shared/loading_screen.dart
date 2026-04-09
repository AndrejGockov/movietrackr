import 'package:flutter/material.dart';

import '../../app_theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.darkBlue,
      body: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightBlue,
        ),
      ),
    );
  }
}
