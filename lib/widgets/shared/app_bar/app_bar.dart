import 'package:flutter/material.dart';
import 'package:movietrackr/services/auth_service.dart';

import '../../../app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.deepBlue,
      title: Text("MovieTrackr", style: AppTheme.h1SemiboldOnMediumBlue),
      actions: [
        ValueListenableBuilder(
          valueListenable: authService,
          builder: (context, authState, child) {
            final user = authState.user;

            if (user == null) {
              return Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, "/register"),
                    child: const Text("Register"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, "/login"),
                    child: const Text("Login"),
                  ),
                ],
              );
            }

            // If user IS logged in, show their email
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(right: AppTheme.md),
                child: Text(
                  user.displayName ?? "User",
                  style: AppTheme.h5SemiboldOnMediumBlue,
                ),
              ),
            );
          },
        ),
        // if(authService.value.user != null) ...[
        //   ElevatedButton(
        //       onPressed: () async {
        //         Navigator.pushNamed(context, "/register");
        //       },
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(AppTheme.md),
        //         ),
        //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //       ),
        //       child: Text("Register")
        //   ),
        //
        //   ElevatedButton(
        //       onPressed: () async {
        //         Navigator.pushNamed(context, "/login");
        //       },
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(AppTheme.md),
        //         ),
        //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //       ),
        //       child: Text("Login")
        //   ),
        // ]else ...[
        //   Text(authService.value.user!.email ?? "")
        // ]
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
