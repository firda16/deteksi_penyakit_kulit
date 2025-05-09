import 'package:flutter/material.dart';

class ArticlePageProvider with ChangeNotifier {
  int _currentIndex = 0;

  // Getter
  int get currentIndex => _currentIndex;

  // Setter
  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}