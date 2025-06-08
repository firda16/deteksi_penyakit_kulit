import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tubes_semester_6/shared/size_config.dart';
import 'package:tubes_semester_6/shared/theme.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigateFromSplash();
  }

  Future<void> _navigateFromSplash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int screen = prefs.getInt('screen') ?? 0;

    // Delay 3 detik (biar splash tampil dulu)
    await Future.delayed(const Duration(seconds: 3));

    if (screen == 0) {
      // Belum onboarding
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      // Sudah onboarding, cek login Firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: primaryGradient,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo_hand.png',
                    width: getProportionateScreenWidth(170),
                  ),
                  Text(
                    'Aiskin',
                    style: latoTextStyle.copyWith(
                      fontSize: 90,
                      fontWeight: weightBold,
                      color: whiteColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    width: MediaQuery.of(context).size.width - 160,
                    height: 3,
                    color: whiteColor,
                  ),
                  Text(
                    'Jadikan Kulit Anda Sehat!',
                    style: latoTextStyle.copyWith(
                      fontWeight: weightNormal,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 100),
                child: Lottie.asset(
                  'assets/loading2.json',
                  height: getProportionateScreenHeight(100),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Copyright © 2025 Kelompok 4',
                  style: latoTextStyle.copyWith(
                    fontSize: 16,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
