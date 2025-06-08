import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_semester_6/shared/size_config.dart';
import 'package:tubes_semester_6/shared/theme.dart';
import 'package:tubes_semester_6/ui/widgets/profile_info_widget.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class AboutUsScreenPage extends StatefulWidget {
  const AboutUsScreenPage({Key? key}) : super(key: key);

  @override
  _AboutUsScreenPageState createState() => _AboutUsScreenPageState();
}

class _AboutUsScreenPageState extends State<AboutUsScreenPage> {
  _storeOnboardInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('screen', 0);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        toolbarHeight: getProportionateScreenHeight(60),
        flexibleSpace: Container(
          padding: EdgeInsets.only(top: getProportionateScreenHeight(10)),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: blueColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: (() => Navigator.pop(context)),
                  child: Container(
                    margin:
                        EdgeInsets.only(left: getProportionateScreenWidth(10)),
                    child: const Icon(Icons.arrow_back_rounded,
                        size: 24, color: whiteColor),
                  )),
              Text(
                'Profil',
                style: latoTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: weightBold,
                  color: whiteColor,
                ),
              ),
              const SizedBox(width: 20)
            ],
          ),
        ),
      ),
      body: VsScrollbar(
        controller: _scrollController,
        showTrackOnHover: true, // default false
        isAlwaysShown: true,
        style: VsScrollbarStyle(
          color: Color(0xff9D9F9F),
          hoverThickness: 100.0,
          radius: Radius.circular(5),
          thickness: 7,
        ),
        child: ListView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          padding:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
          children: [
            GestureDetector(
              onDoubleTap: () {
                _storeOnboardInfo();
                // show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'OnBoarding Diaktifkan 😊. Restarting in 3 seconds...',
                      style: latoTextStyle.copyWith(
                        fontSize: getProportionateScreenWidth(12),
                        fontWeight: weightBold,
                        color: whiteColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: blueColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                });
              },
              child: ProfileInfoWidget(
                image: 'assets/azizah.jpg',
                name: 'Azizah Dwi Lestari ',
                info: 'Azizah | RPL3C | 2205065',
              ),
            ),
            ProfileInfoWidget(
              image: 'assets/windi.jpg',
              name: 'Windini',
              info: 'Windi | RPL3C | 2205081',
            ),
            ProfileInfoWidget(
              image: 'assets/firda.jpg',
              name: 'Firda Amalia',
              info: 'Firda | RPL3C | 2205086',
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
          ],
        ),
      ),
    );
  }
}