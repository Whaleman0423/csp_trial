import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:csp_news_blog/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDaoCloudStorage {
  static Future<List<Event>?> getEvent(String cloudDir) async {
    // print("進到EventDaoCloudStorage getEvent");
    final FirebaseStorage storage = FirebaseStorage.instance;

    String cloudPath = 'assets/cloud-event/$cloudDir/event.json';

    // 瀏覽裡面的新聞
    Uint8List? allEventObjectPath = await storage.ref(cloudPath).getData();
    if (allEventObjectPath != null) {
      String jsonArrayString = utf8.decode(allEventObjectPath);
      List<dynamic> jsonObjectOfArray = jsonDecode(jsonArrayString);
      List<Event> listOfEvent = jsonObjectOfArray
          .map((jsonObject) => Event.fromJson(jsonObject))
          .toList();
      return listOfEvent;
    } else {
      return null;
    }
  }
}

class EventDaoLocalCache {
  static Future<List<Event>?> getEvent(String cloudDir) async {
    // print("進到EventDaoLocalCache getEvent");
    // print(cloudDir);
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    // print('即將取快取');
    List<String>? eventFromCache = _prefs.getStringList(cloudDir);
    // print('取完快取動作完成');
    if (eventFromCache != null) {
      // 回傳
      List<Event> eventList = eventFromCache
          .map((jsonString) => Event.fromJson(jsonDecode(jsonString)))
          .toList();
      // print("Event 從緩存內加載數據");
      return eventList;
    } else {
      // print("EventDaoLocalCache getEvent沒取到東西");
      return null;
    }
  }

  static Future<void> saveEventList(
      String cloudDir, List<Event> eventList) async {
    // print("進到EventDaoLocalCache saveEventList");

    // 快取的客戶端
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String> eventStringList = eventList.map((event) {
      return event.toJsonString();
    }).toList();

    bool? saveResult = await _prefs.setStringList(cloudDir, eventStringList);

    if (saveResult == true) {
      // print("成功將 $cloudDir 的資料存入快取");
    } else {
      // print("無法將 $cloudDir 的資料存入快取");
    }
  }
}
