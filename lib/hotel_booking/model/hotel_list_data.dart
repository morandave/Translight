// class HotelListData {
//   HotelListData({
//     this.imageurl = '',
//     this.name = '',
//     this.category = "",
//     this.period = "",
//     this.existingLocation = '',
//     this.dist = 1.8,
//     this.reviews = 80,
//     this.rating = 4.5,
//     this.perNight = 180,
//   });
//
//   String imageurl;
//   String name;
//   String category;
//   String period;
//   String existingLocation;
//   double dist;
//   double rating;
//   int reviews;
//   int perNight;
//
//   static List<HotelListData> hotelList = <HotelListData>[
//     HotelListData(
//       imageurl:
//           'https://moran-collection.obs.cn-north-4.myhuaweicloud.com/XuZhouMuseum/西汉“楚祠祀印”铜印.jpg',
//       name: '西汉“楚祠祀印”铜印',
//       category: '玺印',
//       period: '西汉',
//       existingLocation: '徐州博物馆',
//       dist: 2.0,
//       reviews: 80,
//       rating: 4.4,
//       perNight: 180,
//     ),
//     HotelListData(
//       imageurl:
//           'https://moran-collection.obs.cn-north-4.myhuaweicloud.com/XuZhouMuseum/西汉“楚骑千人”铜印.jpg',
//       name: '西汉“楚骑千人”铜印',
//       category: '玺印',
//       period: '西汉',
//       existingLocation: '徐州博物馆',
//       dist: 4.0,
//       reviews: 74,
//       rating: 4.5,
//       perNight: 200,
//     ),
//     HotelListData(
//       imageurl:
//           'https://moran-collection.obs.cn-north-4.myhuaweicloud.com/XuZhouMuseum/西汉“楚候之印”铜印.jpg',
//       name: '西汉“楚候之印”铜印',
//       category: '玺印',
//       period: '西汉',
//       existingLocation: '徐州博物馆',
//       dist: 3.0,
//       reviews: 62,
//       rating: 4.0,
//       perNight: 60,
//     ),
//     HotelListData(
//       imageurl:
//           'https://moran-collection.obs.cn-north-4.myhuaweicloud.com/XuZhouMuseum/西汉“楚司马印”铜印.jpg',
//       name: '西汉“楚司马印”铜印',
//       category: '玺印',
//       period: '西汉',
//       existingLocation: '徐州博物馆',
//       dist: 7.0,
//       reviews: 90,
//       rating: 4.4,
//       perNight: 170,
//     ),
//     HotelListData(
//       imageurl:
//           'https://moran-collection.obs.cn-north-4.myhuaweicloud.com/XuZhouMuseum/西汉“宛朐侯埶”龟钮金印.jpg',
//       name: '西汉“宛朐侯埶”龟钮金印',
//       category: '玺印',
//       period: '西汉',
//       existingLocation: '徐州博物馆',
//       dist: 2.0,
//       reviews: 240,
//       rating: 4.5,
//       perNight: 200,
//     ),
//   ];
// }
import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkRequest {
  final String url;
  Dio dio = Dio();

  NetworkRequest({required this.url});

  Future<List<HotelListData>> fetchData() async {
    var response = await dio.get(url);
    if (response.statusCode == 200) {

      List<dynamic> jsonResponse = response.data;
      List<String> processedResponse = [];

      strprocess(jsonResponse, processedResponse);

      List<Map<String, dynamic>> parsedResponse = [];
      responseConvert(processedResponse, parsedResponse);
      return parsedResponse.map((item) => HotelListData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void responseConvert(List<String> processedResponse, List<Map<String, dynamic>> parsedResponse) {
    for (var item in processedResponse) {
      Map<String, dynamic> map = {};
      RegExp exp = RegExp(r'(\w+)=([^,]*)');
      Iterable<RegExpMatch> matches = exp.allMatches(item);

      for (var match in matches) {
        String key = match.group(1) ?? '';
        dynamic value = match.group(2) ?? '';
        map[key] = value;
      }

      parsedResponse.add(map);
    }
  }

  void strprocess(List<dynamic> jsonResponse, List<String> processedResponse) {
    for (var item in jsonResponse) {
      if (item is String) {
        String processedItem = item.substring(1, item.length - 1);
        processedResponse.add(processedItem);
      }
    }
  }
}


class HotelListData {
  HotelListData({
    this.imageurl = '',
    this.name = '',
    this.category = "",
    this.period = "",
    this.existingLocation = '',
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
  });

  String imageurl;
  String name;
  String category;
  String period;
  String existingLocation;
  double dist;
  double rating;
  int reviews;
  int perNight;

  factory HotelListData.fromJson(Map<String, dynamic> json) {
    return HotelListData(
      imageurl: json['image'],
      name: json['name'],
      category: json['category'],
      period: json['period'],
      existingLocation: json['existingLocation'],
      dist: 2.0,
      reviews: 80,
      rating: 4.4,
      perNight: 180,
    );
  }
}
