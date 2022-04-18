import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:csp_news_blog/models/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDaoCloudStorage {
  static Future<List<News>?> getNews(String cloudDir, int pageNum) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    String cloudPath = 'assets/$cloudDir/latest/news.json';

    // 瀏覽裡面的新聞
    Uint8List? allNewsObjectPath = await storage.ref(cloudPath).getData();
    if (allNewsObjectPath != null) {
      String jsonArrayString = utf8.decode(allNewsObjectPath);
      List<dynamic> jsonObjectOfArray = jsonDecode(jsonArrayString);
      List<News> listOfNews = jsonObjectOfArray
          .map((jsonObject) => News.fromJson(jsonObject))
          .toList();
      return listOfNews;
    } else {
      return null;
    }
  }
}

class NewsDaoLocalCache {
  static Future<List<News>?> getNews(String cloudDir, int pageNum) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String>? newsFromCache = _prefs.getStringList(cloudDir);

    if (newsFromCache != null) {
      // 回傳
      List<News> newsList = newsFromCache
          .map((jsonString) => News.fromJson(jsonDecode(jsonString)))
          .toList();
      // print("從緩存內加載數據");
      return newsList;
    } else {
      return null;
    }
  }

  static Future<void> saveNewsList(String cloudDir, List<News> newsList) async {
    // 快取的客戶端
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String> newsStringList = newsList.map((news) {
      return news.toJsonString();
    }).toList();

    bool? saveResult = await _prefs.setStringList(cloudDir, newsStringList);

    if (saveResult == true) {
      // print("成功將 $cloudDir 的資料存入快取");
    } else {
      // print("無法將 $cloudDir 的資料存入快取");
    }
  }
}
