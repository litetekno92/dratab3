import 'dart:async';
import 'dart:io';

import '../models/post_model.dart';
import 'repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class PostsDbProvider implements Source, Cache {
  Database db;

  PostsDbProvider() {
    init();
  }

  // Todo - store and fetch top ids
  Future<List<int>> fetchTopIds() {
    return null;
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "chroniques.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""CREATE TABLE Posts(
            id INTEGER PRIMARY KEY
            , title TEXT
            ,content TEXT
            ,excerpt TEXT
            ,author TEXT
            ,featuredMedia INTEGER
            ,featuredMediaUrl TEXT
            ,link TEXT
            ,categories BLOB
        )""");
      },
    );
  }

  
  Future<int> clear() {
    return db.delete("Posts");
  }

  @override
  Future<int> addPosts(int category,List<Post> posts) async {
    int nbRecords = 0;
    int nbTotalRecords = 0;
    for (var post in posts) {
      nbRecords = await db.insert(
        "Posts",
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      nbTotalRecords += nbRecords;
    }
    return nbTotalRecords;
  }

  @override
  Future<List<Post>> fetchDataCat(int category, int page) async {
    List<Post> posts;
    final maps = await db.query(
      "Posts",
      columns: null,
 //     where: "categories IN ?",
 //     whereArgs: [category],
//      limit: 20,
//      offset: 20 * (page - 1),
    );
    if (maps.length > 0) {
      posts = maps.map((model) => Post.fromDb(model)).toList();
      return posts;
    }
    return null; 
  }

  @override
  Future<List<Post>> fetchDataSearch(String searchText, int page) {
    // TODO: implement fetchDataSearch
    return null;
  }
}



PostsDbProvider postDbProvider = PostsDbProvider();
