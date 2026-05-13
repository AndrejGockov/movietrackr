import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_theme.dart';

class ProfileHeader extends StatelessWidget {
  final String? name;
  final  String? email;
  final DateTime? memberSince;
  final String? bio;

  const ProfileHeader({super.key, this.name, required this.bio, required this.email, this.memberSince});

  @override
  Widget build(BuildContext context) {
    String dateStr = memberSince != null
        ? DateFormat('MMMM dd, yyyy').format(memberSince!)
        : "Unknown";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name ?? "User", style: AppTheme.h2SemiboldOnMediumBlue),

              SizedBox(height: AppTheme.xs),

              Text(
                  email ?? "Email",
                  style: AppTheme.h6SemiboldOnMediumBlue.copyWith(
                    color: AppTheme.lightBlue,
                  )
              ),

              Text(
                "Member since: $dateStr",
                style: AppTheme.h6SemiboldOnMediumBlue.copyWith(
                  color: AppTheme.lightBlue,
                )
              ),

              SizedBox(height: AppTheme.sm),

              Text(
                  "Bio",
                  style: AppTheme.h4SemiboldOnMediumBlue
              ),

              Text(
                  bio ?? "",
                  style: AppTheme.h6SemiboldOnMediumBlue.copyWith(
                    color: AppTheme.lightBlue,
                  )
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, "/settings"),
          icon: CircleAvatar(
            backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
            child: const Icon(Icons.settings, color: AppTheme.textOnMediumBlue),
          ),
        ),
      ],
    );
  }
}
