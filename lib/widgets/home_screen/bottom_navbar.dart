import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const BottomNavBar({super.key, required this.selectedIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppTheme.deepBlue,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: 0,
          ),
          child: GNav(
              tabBorderRadius: AppTheme.sm,
              // backgroundColor: AppTheme.deepBlue,
              hoverColor: AppTheme.lightBlue,
              rippleColor: AppTheme.lightBlue,
              gap: 5,
              color: AppTheme.lightBlue,
              activeColor: AppTheme.lightBlue,
              iconSize: AppTheme.lg,
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppTheme.darkBlue,
                tabs: const [
                  GButton(
                      icon: Icons.home,
                      text: "Home"
                  ),
                  GButton(
                      icon: Icons.search,
                      text: "Search"
                  ),
                  GButton(
                      icon: Icons.person,
                      text: "Profile"
                  ),
                  // GButton(
                  //     icon: Icons.settings,
                  //     text: "Settings"
                  // ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        )
    );
  }
}
