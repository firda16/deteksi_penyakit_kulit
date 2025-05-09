import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_semester_6/provider/article_page_provider.dart';
import 'package:tubes_semester_6/provider/page_provider.dart';
import 'package:tubes_semester_6/shared/size_config.dart';

class ArticleHomeTile extends StatelessWidget {
  const ArticleHomeTile({Key? key, required this.image, required this.id})
      : super(key: key);
  final String image;
  final int id;

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    final articlePageProvider = Provider.of<ArticlePageProvider>(context);
    
    return GestureDetector(
      onTap: () {
        pageProvider.currentIndex = 1;
        articlePageProvider.currentIndex = id;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        margin: EdgeInsets.only(
          right: getProportionateScreenWidth(16),
        ),
        child: Image.asset(
          image,
          width: 135,
          height: 90,
        ),
      ),
    );
  }
}