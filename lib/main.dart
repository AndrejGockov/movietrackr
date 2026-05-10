import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movietrackr/screens/login.dart';

import 'package:movietrackr/screens/main_screen.dart';
import 'package:movietrackr/screens/movie_screen.dart';
import 'package:movietrackr/screens/register.dart';
import 'package:movietrackr/screens/see_more_screen.dart';
import 'package:movietrackr/screens/settings.dart';

import 'app_theme.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppTheme.deepBlue,
    // systemNavigationBarIconBrightness: Brightness.light,
    // systemNavigationBarDividerColor:  Colors.transparent,
  ));

  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieTrackr',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: AppTheme.darkBlue,
        canvasColor: AppTheme.darkBlue,
      ),
      initialRoute: "/",
      routes: {
        "/" : (context) => const MainPage(),
        "/movie" : (context) => const MoviePage(),
        "/see_more" : (context) => const SeeMorePage(),
        "/register" : (context) => const Register(),
        "/login" : (context) => const Login(),
        "/settings" : (context) => const Settings(),
      },
    );
  }
}