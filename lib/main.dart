import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tubes_semester_6/provider/article_page_provider.dart';
import 'package:tubes_semester_6/provider/page_provider.dart';
import 'package:tubes_semester_6/ui/pages/about_us_screen_page.dart';
import 'package:tubes_semester_6/ui/pages/home/main_page.dart';
import 'package:tubes_semester_6/ui/pages/onboarding_screen_page.dart';
import 'package:tubes_semester_6/ui/pages/splash_screen_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => ArticlePageProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashScreenPage(),
          '/onboarding': (context) => const OnBoardingPage(),
          '/main': (context) => const MainPage(),
          '/about-us': (context) => const AboutUsScreenPage(),
        },
      ),
    );
  }
}