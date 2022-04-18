import 'package:flutter/material.dart';
import 'package:csp_news_blog/daos/news_dao.dart';
import '../components/news_component.dart';
import '../models/news.dart';

class FunctionTestScreen extends StatefulWidget {
  const FunctionTestScreen({Key? key}) : super(key: key);
  @override
  State createState() {
    return _FunctionTestScreen();
  }
}

class _FunctionTestScreen extends State<FunctionTestScreen> {
  List<News> newsState = [];

  @override
  Widget build(BuildContext context) {
    Widget textButtonAboutLoadNews = TextButton(
      child: const Text("載入數據"),
      onPressed: () async {
        // 從緩存讀取
        List<News>? listOfNewsInCache =
            await NewsDaoLocalCache.getNews("aws", 0);
        if (listOfNewsInCache != null) {
          newsState = listOfNewsInCache;
          setState(() {});
          // 從cloud storage 讀取
        } else {
          List<News>? listOfNews = await NewsDaoCloudStorage.getNews("aws", 0);
          if (listOfNews != null) {
            await NewsDaoLocalCache.saveNewsList("aws", listOfNews);
            newsState = listOfNews;
            setState(() {});
          } else {
            // print("cloud storage 沒有數據");
          }
        }
      },
    );

    Widget textOfNews = Text(newsState.fold(' ',
        (previousValue, element) => previousValue + element.toJsonString()));

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          textButtonAboutLoadNews,
          textOfNews,
          ...newsState.map((news) => NewsComponent(news: news))
        ],
      ),
    ));
  }
}
