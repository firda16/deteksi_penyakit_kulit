import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tubes_semester_6/provider/article_page_provider.dart';
import 'package:tubes_semester_6/provider/liked_article_provider.dart'; // Import provider baru
import 'package:tubes_semester_6/shared/size_config.dart';
import 'package:tubes_semester_6/shared/theme.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class DetailArticle extends StatefulWidget {
  const DetailArticle({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.image,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final String image;

  @override
  State<DetailArticle> createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {
  final ScrollController _scrollController = ScrollController();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotification();
  }

  void _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showLikeNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'like_channel_id',
      'Notifikasi Like',
      channelDescription: 'Notifikasi saat artikel disukai',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Artikel Disukai',
      'Kamu menyukai artikel ini.',
      platformDetails,
    );
  }

    void _showUnlikeNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'like_channel_id',
      'Notifikasi Unlike',
      channelDescription: 'Notifikasi saat artikel tidak disukai lagi',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification',
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      1, // ID berbeda dari notifikasi like
      'Artikel Tidak Disukai',
      'Kamu tidak menyukai artikel "${widget.title}" lagi',
      platformDetails,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    ArticlePageProvider articlePageProvider =
        Provider.of<ArticlePageProvider>(context);
    // Tambahkan provider untuk artikel yang disukai
    LikedArticleProvider likedProvider =
        Provider.of<LikedArticleProvider>(context);
    // Cek status like dari provider
    bool isLiked = likedProvider.isLiked(widget.title);

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        toolbarHeight: getProportionateScreenHeight(60),
        centerTitle: true,
        flexibleSpace: Container(
          padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: blueColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  widget.title,
                  style: latoTextStyle.copyWith(
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: weightBold,
                    color: whiteColor,
                  ),
                ),
              ),
              Positioned(
                left: getProportionateScreenWidth(20),
                top: getProportionateScreenHeight(24),
                child: GestureDetector(
                  onTap: () => articlePageProvider.currentIndex = 5,
                  child: const Icon(Icons.arrow_back_sharp,
                      size: 25, color: whiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
      body: VsScrollbar(
        controller: _scrollController,
        showTrackOnHover: true,
        isAlwaysShown: true,
        style: VsScrollbarStyle(
          color: Color(0xff9D9F9F),
          hoverThickness: 1,
          radius: Radius.circular(5),
          thickness: 7,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
            vertical: getProportionateScreenHeight(30),
          ),
          children: [
            Hero(
              tag: articlePageProvider.currentIndex,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(23),
                ),
                height: getProportionateScreenHeight(191),
                width: getProportionateScreenWidth(338),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: latoTextStyle.copyWith(
                      fontSize: getProportionateScreenWidth(24),
                      fontWeight: weightMedium,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    likedProvider.toggleLike(widget.title);
                    if (likedProvider.isLiked(widget.title)) {
                      _showLikeNotification();
                    } else {
                      _showUnlikeNotification();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(14)),
            Text(
              widget.subTitle,
              style: latoTextStyle.copyWith(
                fontSize: getProportionateScreenWidth(16),
                fontWeight: weightMedium,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

class _showUnlikeNotification {

}
