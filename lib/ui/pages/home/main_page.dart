import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tubes_semester_6/provider/article_page_provider.dart';
import 'package:tubes_semester_6/provider/page_provider.dart';
import 'package:tubes_semester_6/shared/size_config.dart';
import 'package:tubes_semester_6/shared/theme.dart';
import 'package:tubes_semester_6/ui/pages/home/article_page.dart';
import 'package:tubes_semester_6/ui/pages/home/home_page.dart';
import 'package:tubes_semester_6/ui/pages/home/riwayat_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  static const snackBarDuration = Duration(seconds: 3);

  @override
  Widget build(BuildContext context) {
    DateTime? backButtonPressTime;
    final articleProvider = Provider.of<ArticlePageProvider>(context);
    final pageProvider = Provider.of<PageProvider>(context);

    Widget customNavigationBar() {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: BottomAppBar(
          child: BottomNavigationBar(
            onTap: (value) => pageProvider.currentIndex = value,
            type: BottomNavigationBarType.fixed,
            currentIndex: pageProvider.currentIndex,
            backgroundColor: blueColor,
            selectedLabelStyle: opensansTextStyle.copyWith(
              color: whiteColor,
              fontSize: 12,
              fontWeight: weightBold,
            ),
            selectedItemColor: whiteColor,
            unselectedItemColor: whiteColor,
            iconSize: 24,
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'Artikel',
                icon: Icon(Icons.article),
              ),
              BottomNavigationBarItem(
                label: 'Riwayat',
                icon: Icon(Icons.history),
              ),
            ],
          ),
        ),
      );
    }

    Widget body() {
      switch (pageProvider.currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const ArticlePage();
        case 2:
          return const RiwayatPage();
        default:
          return const HomePage();
      }
    }

    Future<bool> handleWillPop(BuildContext context) async {
      final now = DateTime.now();
      final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
          backButtonPressTime == null ||
              now.difference(backButtonPressTime!) > snackBarDuration;

      if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
        backButtonPressTime = now;
        if (articleProvider.currentIndex != 5 &&
            pageProvider.currentIndex != 0) {
          articleProvider.currentIndex = 5;
          return false;
        } else if (articleProvider.currentIndex == 5 &&
            pageProvider.currentIndex == 1) {
          pageProvider.currentIndex = 0;
          return false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tekan tombol kembali lagi untuk keluar',
                style: opensansTextStyle.copyWith(
                  color: Colors.black,
                  fontWeight: weightMedium,
                  fontSize: 12,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: yellowColor,
              duration: snackBarDuration,
            ),
          );
          return false;
        }
      }

      return true;
    }
    ElevatedButton(
  onPressed: () async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  },
  child: Text("Logout"),
);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: WillPopScope(
        onWillPop: () async => handleWillPop(context),
        child: Scaffold(
          bottomNavigationBar: customNavigationBar(),
          body: body(),
        ),
      ),
    );
  }
}
