import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tubes_semester_6/provider/article_page_provider.dart';
import 'package:tubes_semester_6/provider/page_provider.dart';
import 'package:tubes_semester_6/shared/size_config.dart';
import 'package:tubes_semester_6/shared/theme.dart';
import 'package:tubes_semester_6/ui/pages/home/article_page.dart';
import 'package:tubes_semester_6/ui/pages/home/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  static const snackBarDuration = Duration(seconds: 3);

  @override
  Widget build(BuildContext context) {
    DateTime? backButtonPressTime;
    final articleProvider = Provider.of<ArticlePageProvider>(context);
    final pageProvider = Provider.of<PageProvider>(context);

    Widget customNavigationBar() {
      return SizedBox(
        height: getProportionateScreenHeight(70),
        child: ClipRRect(
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
              items: [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Image.asset(
                    'assets/icon_home.png',
                    color: pageProvider.currentIndex == 0
                        ? yellowColor
                        : whiteColor,
                    width: getProportionateScreenWidth(30),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Article',
                  icon: Image.asset(
                    'assets/icon_article.png',
                    width: getProportionateScreenWidth(26),
                    color: pageProvider.currentIndex == 1
                        ? yellowColor
                        : whiteColor,
                  ),
                ),
              ],
            ),
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