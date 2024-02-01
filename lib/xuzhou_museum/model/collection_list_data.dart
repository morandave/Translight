import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkRequest {
  final String url;
  Dio dio = Dio();

  NetworkRequest({required this.url});

  Future<Map<String, dynamic>> fetchData() async {
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = response.data["data"];
      int collectionNum = response.data["collectionNum"];
      List<String> processedResponse = [];

      strprocess(jsonResponse, processedResponse);

      List<Map<String, dynamic>> parsedResponse = [];
      responseConvert(processedResponse, parsedResponse);
      List<CollectionListData> hotelList = parsedResponse
          .map((item) => CollectionListData.fromJson(item))
          .toList();

      return {
        'hotelList': hotelList,
        'collectionNum': collectionNum,
      };
    } else {
      throw Exception('Failed to load data');
    }
  }


  void responseConvert(List<String> processedResponse,
      List<Map<String, dynamic>> parsedResponse) {
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

class CollectionListData {
  CollectionListData({
    this.imageurl = '',
    this.name = '',
    this.category = "",
    this.period = "",
    this.existingLocation = '',
    this.dimension = '',
    this.introduction = '',
    this.origin = '',
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
  String dimension;
  String introduction;
  String origin;
  double dist;
  double rating;
  int reviews;
  int perNight;

  factory CollectionListData.fromJson(Map<String, dynamic> json) {
    return CollectionListData(
      imageurl: json['image'],
      name: json['name'],
      category: json['category'],
      period: json['period'],
      existingLocation: json['existingLocation'],
      introduction: json['introduction'],
      origin: json['collectionSource'],
      dimension: json['dimensions'],
      dist: 2.0,
      reviews: 80,
      rating: 4.4,
      perNight: 180,
    );
  }
}
