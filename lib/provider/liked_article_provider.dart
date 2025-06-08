import 'package:flutter/foundation.dart';

class LikedArticleProvider with ChangeNotifier {
  final Set<String> _likedTitles = {};

  bool isLiked(String title) => _likedTitles.contains(title);

  void toggleLike(String title) {
    if (_likedTitles.contains(title)) {
      _likedTitles.remove(title);
    } else {
      _likedTitles.add(title);
    }
    notifyListeners();
  }

  void removeLikedArticle(String title) {}

  void addLikedArticle(String title) {}
}
