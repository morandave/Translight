import 'package:best_flutter_ui_templates/xuzhou_museum/collection_home_screen.dart';
import 'package:flutter/widgets.dart';

import '../nanjing_museum/collection_home_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/NanJingMuseum.jpg',
      navigateScreen: NanjingHomeScreen(),
    ),
    HomeList(
      imagePath: 'assets/hotel/XuZhouMuseum.jpg',
      navigateScreen: HotelHomeScreen(),
     ),
    // HomeList(
    //   imagePath: 'assets/fitness_app/GuGongMuseum.png',
    //   navigateScreen: HotelHomeScreen(),
    // ),
    // HomeList(
    //   imagePath: 'assets/introduction_animation/NanJingMuseum.jpg',
    //   navigateScreen: HotelHomeScreen(),
    // ),
  ];
}
