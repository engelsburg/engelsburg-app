import 'package:engelsburg_app/src/pages/cafeteria_page.dart';
import 'package:engelsburg_app/src/pages/news_page.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const bottomNavigationBarItems = [
    BottomNavigationBarItem(label: 'News', icon: Icon(Icons.library_books)),
    BottomNavigationBarItem(
        label: 'Cafeteria', icon: Icon(Icons.restaurant_menu)),
  ];
  static const bottomNavigationBarPages = <Widget>[
    NewsPage(),
    CafeteriaPage(),
  ];
  static const schoolDescriptionSourceUrl =
      'https://www1.kassel.de/verzeichnisse/schulen/gymnasiale-oberstufen-und-gymnasien/engelsburg.php';
  static const schoolDescriptionSourceDomain = 'kassel.de';
  static const pforteNumber = '+49561789670';
  static const sekretariatNumber = '+495617896727';
  static const sekretariatEmail = 'sekretariat@engelsburg.smmp.de';
  static const appStoreUrl =
      'https://apps.apple.com/app/engelsburg-app/id1529725542';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=de.dariotrombello.engelsburg_app';
  static const githubUrl = 'https://github.com/engelsburg';
  static const darioEmail = 'info@dariotrombello.com';
}
