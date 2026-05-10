import 'package:flutter/material.dart';
import 'package:movietrackr/widgets/home_screen/profile_tab.dart';
import 'package:movietrackr/widgets/shared/loading_screen.dart';

import '../app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/home_screen/bottom_navbar.dart';
import '../widgets/home_screen/home_tab.dart';
import '../widgets/home_screen/search_tab.dart';

import '../widgets/shared/app_bar/app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int pageIndex = 0;

  @override
  void initState(){
    super.initState();
  }

  void handleTabChange(int index){
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authState, child) {
        final user = authState.user;

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          });

          return const Scaffold(
            backgroundColor: AppTheme.darkBlue,
            body: LoadingScreen(),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.darkBlue,
          appBar: const CustomAppBar(),
          body: IndexedStack(
            index: pageIndex,
            children: const [
              HomeTab(),
              SearchTab(),
              ProfileTab(),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
              selectedIndex: pageIndex,
              onTabChange: handleTabChange
          ),
        );
      },
    );
  }
}