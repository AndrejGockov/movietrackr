import 'dart:async';

import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/auth_service.dart';
import '../services/db_context.dart';
import '../services/user_service.dart';
import '../widgets/settings_screen/delete_account_dialog.dart';
import '../widgets/settings_screen/sign_out_dialog.dart';
import '../widgets/settings_screen/settings_button.dart';
import '../widgets/settings_screen/update_bio_dialog.dart';
import '../widgets/settings_screen/update_username_dialog.dart';
import '../widgets/shared/loading_screen.dart';
import '../widgets/shared/reusable_header.dart';
import '../widgets/shared/section_separator.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? bio;
  bool isBioLoading = true;
  StreamSubscription<String>? bioSubscription; // Add this

  @override
  void initState() {
    super.initState();
    listenToBio();
  }

  @override
  void dispose() {
    bioSubscription?.cancel();
    super.dispose();
  }

  void listenToBio() {
    final uid = authService.value.user?.uid;
    if (uid == null) return;
    bioSubscription = UserService().getBioStream(uid).listen((newBio) {
      if (mounted) {
        setState(() {
          bio = newBio;
          isBioLoading = false;
        });
      }
    });
  }

  void triggerUpdateUsernameFlow(String currentName) {
    showDialog(
      context: context,
      builder: (context) => UpdateUsernameDialog(
        currentName: currentName,
        onConfirm: (newName) async {
          await authService.value.updateUsername(username: newName);
        },
      ),
    );
  }

  void triggerUpdateBioFlow(String currentBio) {
    showDialog(
      context: context,
      builder: (context) => UpdateBioDialog(
        currentBio: currentBio,
        onConfirm: (newBio) async {
          final uid = authService.value.user?.uid;
          if (uid != null) {
            await UserService().updateBio(uid, newBio);
            setState(() => bio = newBio);
          }
        },
      ),
    );
  }

  void triggerSignOutFlow() {
    showDialog(
      context: context,
      builder: (context) => SignOutDialog(
        onConfirm: () async {
          await authService.value.signOut();
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        },
      ),
    );
  }

  void triggerDeleteFlow() {
    showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(
        onConfirm: (email, password) async {
          await authService.value.deleteAccount(
            email: email,
            password: password,
          );

          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      body: ValueListenableBuilder(
        valueListenable: authService,
        builder: (context, authState, child) {
          final user = authState.user;

          if (user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            });

            return const Scaffold(
              backgroundColor: AppTheme.darkBlue,
              body: LoadingScreen(),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: AppTheme.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppTheme.xl),

                  ReusableHeader(title: "Settings"),

                  // PROFILE SECTION
                  SizedBox(height: AppTheme.md),

                  Text("Profile", style: AppTheme.h2SemiboldOnMediumBlue),

                  const SectionSeparator(),

                  const SizedBox(height: AppTheme.sm),

                  Text("Username:", style: AppTheme.h4SemiboldOnMediumBlue),

                  const SizedBox(height: AppTheme.sm),

                  Row(
                    children: [
                      Text(
                        user.displayName ?? 'User',
                        style: AppTheme.h4SemiboldOnMediumBlue,
                      ),
                      SizedBox(width: AppTheme.sm),
                      GestureDetector(
                        onTap: () =>
                            triggerUpdateUsernameFlow(user.displayName ?? ''),
                        child: CircleAvatar(
                          radius: AppTheme.md,
                          backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
                          child: Icon(
                            Icons.edit,
                            size: AppTheme.md,
                            color: AppTheme.textOnMediumBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.sm),

                  Text("Email:", style: AppTheme.h4SemiboldOnMediumBlue),

                  const SizedBox(height: AppTheme.sm),

                  Text(
                    user.email ?? 'email',
                    style: AppTheme.h4SemiboldOnMediumBlue,
                  ),

                  const SizedBox(height: AppTheme.sm),

                  Text("Bio:", style: AppTheme.h4SemiboldOnMediumBlue),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (bio == null || bio!.isEmpty) ? "" : bio!,
                          style: AppTheme.h5SemiboldOnMediumBlue,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            triggerUpdateBioFlow(bio ?? ''),
                        child: CircleAvatar(
                          radius: AppTheme.md,
                          backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
                          child: Icon(
                            Icons.edit,
                            size: AppTheme.md,
                            color: AppTheme.textOnMediumBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.md),

                  // ACCOUNT SECTION
                  Text("Account", style: AppTheme.h2SemiboldOnMediumBlue),

                  const SectionSeparator(),

                  SettingsButton(
                    text: "Sign Out",
                    textStyle: AppTheme.h6SemiboldOnMediumBlue,
                    onPressed: triggerSignOutFlow,
                  ),

                  SettingsButton(
                    text: "Delete Account",
                    textStyle: AppTheme.h6SemiboldPrimaryRed,
                    onPressed: triggerDeleteFlow,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
