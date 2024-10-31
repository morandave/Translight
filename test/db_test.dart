import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:best_flutter_ui_templates/db.dart';
import 'package:best_flutter_ui_templates/data_model.dart';
import 'package:best_flutter_ui_templates/xuzhou_museum/model/collection_list_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<List<CollectionListData>> convertToCollectionListData(
    List<Collection> futureCollections) async {
  // 等待 futureCollections 完成，并获取 List<Collection> 的值
  final List<Collection> collections = await futureCollections;

  // 将 List<Collection> 转换为 List<CollectionListData>
  return collections.map((collection) {
    return CollectionListData(
      imageurl: collection.image,
      name: collection.name,
      category: collection.category,
      period: collection.period,
      existingLocation: collection.existingLocation,
      dimension: collection.dimensions,
      introduction: collection.introduction,
      origin: collection.collectionSource,
    );
  }).toList();
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test("test dbHelper", () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    CollectionDatabase xz_ch =
        CollectionDatabase('xuzhou_chinese.sqlite');
    List<CollectionListData> result = await convertToCollectionListData(await xz_ch.collections());
    print(await result.length);
  });
}
