import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:csp_news_blog/models/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

// NewAds 是用 News model 取廣告，屬性跟 News一樣
class NewsAdsDaoCloudStorage {
  static Future<List<News>?> getNewsAds(String cloudDir) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    String cloudPath = 'assets/news-ad-news/$cloudDir/ad.json';

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

class NewsAdsDaoLocalCache {
  static Future<List<News>?> getNewsAds(String cloudDir) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String>? newsAdsFromCache = _prefs.getStringList('${cloudDir}Ads');

    if (newsAdsFromCache != null) {
      // 回傳
      List<News> newsAdsList = newsAdsFromCache
          .map((jsonString) => News.fromJson(jsonDecode(jsonString)))
          .toList();
      // print("從緩存內加載數據");
      return newsAdsList;
    } else {
      return null;
    }
  }

  static Future<void> saveNewsAdsList(
      String cloudDir, List<News> newsAdsList) async {
    // 快取的客戶端
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String> newsAdsStringList = newsAdsList.map((newsAd) {
      return newsAd.toJsonString();
    }).toList();

    bool? saveResult =
        await _prefs.setStringList('${cloudDir}Ads', newsAdsStringList);

    if (saveResult == true) {
      // print("成功將 $cloudDir Ads 的資料存入快取");
    } else {
      // print("無法將 $cloudDir Ads 的資料存入快取");
    }
  }
}
