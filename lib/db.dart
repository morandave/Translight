import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:best_flutter_ui_templates/data_model.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class CollectionDatabase {
  Future<Database>? database;
  Future<void>? _initCompleter;
  // 将以下代码放入构造函数中
  CollectionDatabase(String databasePath) {
    _initCompleter = init(databasePath);
  }
  init(String databasePath) async {
    // 创建目录（如果不存在的话）
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, databasePath);


      // 复制数据库文件到临时目录
      ByteData data = await rootBundle.load('assets/database/${databasePath}');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);

    // 创建数据库
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      dbPath,
      // When the database is first created, create a table to store dogs.
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // 插入数据
  // Define a function that inserts dogs into the database
  Future<void> insertCollection(Collection collection) async {
    await _initCompleter;
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    if (db != null) {
      await db.insert(
        'collections',
        collection.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Collection>> collections() async {
    await _initCompleter;
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.

    if (db != null) {
      final List<Map<String, Object?>> collectionMaps =
          await db.query('collections');
      print(collectionMaps.length);
    return [
      for (var map in collectionMaps)
        Collection(
          id: map['id'] as int,
          name: map['name'] as String? ?? '',  // 使用空安全运算符
          category: map['category'] as String? ?? '',
          existingLocation: map['existingLocation'] as String? ?? '',
          period: map['period'] as String? ?? '',
          dimensions: map['dimensions'] as String? ?? '',
          collectionSource: map['collectionSource'] as String? ?? '',
          introduction: map['introduction'] as String? ?? '',
          artist: map['artist'] as String? ?? '',
          image: map['image'] as String? ?? '',
        ),
    ];
    } else {
      // Handle the case where db is null, maybe throw an exception or return an empty list
      throw Exception('Database is not initialized');
      // or return [];
    }
  }

}
