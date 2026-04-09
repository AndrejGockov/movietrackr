import 'package:flutter/cupertino.dart';

import '../../../app_theme.dart';

class SectionSeparator extends StatelessWidget {
  const SectionSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppTheme.sm),

        Container(
          width: double.infinity,
          height: AppTheme.xxs,
          color: AppTheme.textOnMediumBlue,
        ),

        const SizedBox(height: AppTheme.md),
      ],
    );
  }
}