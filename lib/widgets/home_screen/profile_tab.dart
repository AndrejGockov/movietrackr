import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../services/auth_service.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: authService,
        builder: (context, authState, child) {
          final user = authState.user;

          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pushNamed(context, "/settings", arguments: {});
                },
                child: CircleAvatar(
                  radius: AppTheme.md,
                  backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
                  child: Icon(
                    Icons.settings,
                    size: AppTheme.lg,
                    color: AppTheme.textOnMediumBlue,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // Text(user.displayName ?? "User"),
    );
  }
}
