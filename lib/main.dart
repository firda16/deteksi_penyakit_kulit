import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:tubes_semester_6/provider/google_sign_in_provider.dart';
import 'package:tubes_semester_6/provider/page_provider.dart';
import 'package:tubes_semester_6/provider/article_page_provider.dart';
import 'package:tubes_semester_6/provider/liked_article_provider.dart';

import 'package:tubes_semester_6/ui/pages/splash_screen_page.dart';
import 'package:tubes_semester_6/ui/pages/onboarding_screen_page.dart';
import 'package:tubes_semester_6/ui/pages/home/register_page.dart';
import 'package:tubes_semester_6/ui/pages/home/login_page.dart';
import 'package:tubes_semester_6/ui/pages/home/main_page.dart';
import 'package:tubes_semester_6/ui/pages/about_us_screen_page.dart';

// ⬇️ Buat objek global notifikasi lokal
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inisialisasi notifikasi lokal (Android)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Atur orientasi aplikasi
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => ArticlePageProvider()),
        ChangeNotifierProvider(create: (_) => LikedArticleProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreenPage(),
          '/onboarding': (context) => const OnBoardingPage(),
          '/register': (context) => const RegisterPage(),
          '/login': (context) => const LoginPage(),
          '/main': (context) => const MainPage(),
          '/about-us': (context) => const AboutUsScreenPage(),
        },
      ),
    );
  }
}
