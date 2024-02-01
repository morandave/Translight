// class CollectionList {
//   CollectionList({
//       required this.collectionNum,
//       required this.data,});
//
//   CollectionList.fromJson(dynamic json) {
//     collectionNum = json['collectionNum'];
//     data = json['data'] != null ? json['data'].cast<String>() : [];
//   }
//   int collectionNum;
//   List<String> data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['collectionNum'] = collectionNum;
//     map['data'] = data;
//     return map;
//   }
//
// }