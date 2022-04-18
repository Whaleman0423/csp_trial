import 'package:csp_news_blog/models/event.dart';
import 'package:flutter/material.dart';
import 'package:csp_news_blog/styles/values.dart';
import 'package:csp_news_blog/daos/news_dao.dart';
import 'package:csp_news_blog/daos/event_dao.dart';
import 'package:csp_news_blog/daos/news_ad_dao.dart';
import 'package:csp_news_blog/models/news.dart';
import 'package:csp_news_blog/components/news_group_component.dart';
import 'package:csp_news_blog/components/event_group_component.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 如果沒有附上 news 的圖片網址，就給該 News 主題的預設圖
  final Map<String, List<String>> defaultPictureUrl = {
    "aws-news": [
      "https://i.imgur.com/sXrtqPE.png",
      "https://i.imgur.com/YsPm7ie.png",
      "https://i.imgur.com/hfxxYSP.png"
    ],
    "aws-cn-news": [
      "https://i.imgur.com/CTJ91uX.png",
      "https://i.imgur.com/UDW9M5J.png",
      "https://i.imgur.com/I26YOaN.png"
    ],
    "azure-news": [
      "https://i.imgur.com/runlPVX.png",
      "https://i.imgur.com/RiSpao9.png",
      "https://i.imgur.com/Ljdvlbx.png"
    ],
    "gcp-news": [
      "https://i.imgur.com/RYHbytf.png",
      "https://i.imgur.com/pW6uJmi.png",
      "https://i.imgur.com/TjgTfw0.png"
    ],
    "aws-event": [
      "https://i.imgur.com/sXrtqPE.png",
      "https://i.imgur.com/YsPm7ie.png",
      "https://i.imgur.com/hfxxYSP.png"
    ],
    "azure-event": [
      "https://i.imgur.com/runlPVX.png",
      "https://i.imgur.com/RiSpao9.png",
      "https://i.imgur.com/Ljdvlbx.png"
    ],
    "aws-cn-event": [
      "https://i.imgur.com/CTJ91uX.png",
      "https://i.imgur.com/UDW9M5J.png",
      "https://i.imgur.com/I26YOaN.png"
    ],
    "gcp-event": [
      "https://i.imgur.com/RYHbytf.png",
      "https://i.imgur.com/pW6uJmi.png",
      "https://i.imgur.com/TjgTfw0.png"
    ],
    "news-ad": ["https://i.imgur.com/NRJMfqp.png"]
  };
  // 用來轉換按鈕名稱，轉成我們熟悉的縮寫
  final Map<String, String> titleAbbreviation = {
    "AWS": "aws-news",
    "AWS-中文": "aws-cn-news",
    "GCP": "gcp-news",
    "Azure": "azure-news",
    "雲端活動": "cloud-event"
  };
  bool eventShow = false;
  dynamic childComponent;
  // 用來判斷當前的 News 主題
  String currentNewsTitle = "aws-news";
  // 用來裝從 Dao 取得的 News 清單
  List<News> newsState = [];
  List<Event> eventState = [];
  List<News> newsAds = [];
  // 上方按鈕
  Widget btnCloud(String title) {
    return Container(
        margin: (MediaQuery.of(context).size.width <= 840)
            ? const EdgeInsets.symmetric(horizontal: 8)
            : const EdgeInsets.symmetric(horizontal: 16),
        width: (MediaQuery.of(context).size.width <= 840)
            ? MediaQuery.of(context).size.width * 0.15
            : MediaQuery.of(context).size.width * 0.12, //160
        height: 48,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: primaryElement,
            shape: const RoundedRectangleBorder(
              side: primaryBorder,
              borderRadius: k5pxRadius,
            ),
          ),
          onPressed: () {
            // 當用戶點了之後觸發切換狀態
            setState(() {
              if (title == '雲端活動') {
                eventShow = true;
                newsState = [];
              } else {
                eventShow = false;
                currentNewsTitle = titleAbbreviation[title] as String;
                eventState = [];
              }
            });
          },
          child: Text(title,
              style: const TextStyle(
                fontSize: 16,
                color: primaryTextElement,
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // 跟緩存拿資料
    Future<List<News>> getData() async {
      try {
        List<News>? listOfNewsInCache =
            await NewsDaoLocalCache.getNews(currentNewsTitle, 0);
        // 若緩存有資料
        if (listOfNewsInCache != null) {
          newsState = listOfNewsInCache;
          // 若緩存沒資料，跟 Cloud Storage 拿
        } else {
          List<News>? listOfNews =
              await NewsDaoCloudStorage.getNews(currentNewsTitle, 0);
          // 如果 Cloud Storage 有資料
          if (listOfNews != null) {
            // 存一份到緩存
            NewsDaoLocalCache.saveNewsList(currentNewsTitle, listOfNews);
            newsState = listOfNews;
          } else {
            // print("cloud storage 沒有數據");
          }
        }
        //  若圖片網址為空，給他預設
        for (News news in newsState) {
          // print("主題: ${news.article_title}");
          // if (news.article_pic_url == " ") {
          var random = Random();
          var i = random.nextInt(defaultPictureUrl[currentNewsTitle]!.length);
          news.articlePicUrl = defaultPictureUrl[currentNewsTitle]![i];
          // }
        }
      } catch (e) {
        newsState = [
          News.fromJson({
            "article": '目前暫無資訊',
            "description": '目前暫無資訊',
            "publish_date": ' ',
            "article_origin_link": "https://www.cxcxc.io/",
            "article_tag": ' ',
            "article_author": ' ',
            "article_pic_url": "https://i.imgur.com/HWZdmMI.png"
          })
        ];
      }

      return newsState;
    }

    // 拿廣告資料
    Future<List<News>> getAdsData() async {
      try {
        List<News>? listOfNewsAdsInCache =
            await NewsAdsDaoLocalCache.getNewsAds(currentNewsTitle);
        // 若緩存有資料
        if (listOfNewsAdsInCache != null) {
          newsAds = listOfNewsAdsInCache;
          // 若緩存沒資料，跟 Cloud Storage 拿
        } else {
          List<News>? listOfNewsAds =
              await NewsAdsDaoCloudStorage.getNewsAds(currentNewsTitle);
          // 如果 Cloud Storage 有資料
          if (listOfNewsAds != null) {
            // 存一份到緩存
            NewsAdsDaoLocalCache.saveNewsAdsList(
                currentNewsTitle, listOfNewsAds);
            newsAds = listOfNewsAds;
          } else {
            // print("cloud storage 沒有 Ads 數據");
          }
        }
        //  若圖片網址為空，給他預設
        for (News newsAd in newsAds) {
          // print("主題: ${news.article_title}");
          var random = Random();
          var i = random.nextInt(defaultPictureUrl["news-ad"]!.length);
          newsAd.articlePicUrl = defaultPictureUrl["news-ad"]![i];
        }
      } catch (e) {
        newsAds = [];
      }
      return newsAds;
    }

    // 拿雲端活動的資料
    Future<List<Event>> getEvent(cloudDir) async {
      try {
        // print('event 拿緩存');
        // 要一次拿四大家的活動資料緩存
        List<Event>? listOfEventInCache =
            await EventDaoLocalCache.getEvent(cloudDir);

        // 若緩存有資料
        if (listOfEventInCache != null) {
          eventState = listOfEventInCache;
          // 若緩存沒資料，跟 Cloud Storage 拿
        } else {
          List<Event>? listOfEvent =
              await EventDaoCloudStorage.getEvent(cloudDir);

          // 如果 Cloud Storage 有資料
          if (listOfEvent != null) {
            // 存一份到緩存
            EventDaoLocalCache.saveEventList(cloudDir, listOfEvent);

            eventState = listOfEvent;
          } else {}
        }
        //  若圖片網址為空，給他預設
        for (Event event in eventState) {
          // print("主題: ${news.article_title}");
          var random = Random();
          var i = random.nextInt(defaultPictureUrl[cloudDir]!.length);
          event.eventPicUrl = defaultPictureUrl[cloudDir]![i];
        }
      } catch (e) {
        // print('event 出錯');
        eventState = [
          Event.fromJson({
            "event_title": '目前暫無活動標題',
            "introduction": '目前暫無活動介紹',
            "start_date": ' ',
            "end_date": ' ',
            "event_origin_link": "https://www.cxcxc.io/",
            "event_tag": " ",
            "location": " ",
            "event_pic_url": "https://i.imgur.com/HWZdmMI.png"
          })
        ];
      }

      return eventState;
    }

    return FutureBuilder(
        // 讀取遠端資料
        future: Future.wait([
          getData(),
          getAdsData(),
          getEvent("aws-cn-event"),
          getEvent("aws-event"),
          getEvent("azure-event"),
          getEvent("gcp-event")
        ]),
        builder: (BuildContext context,
            AsyncSnapshot<List<dynamic>> asyncOfNewsAndAds) {
          // if (asyncOfNewsAndAds.connectionState == ConnectionState.done && asyncOfNewsAndAds.hasData) {
          if (asyncOfNewsAndAds.connectionState == ConnectionState.done) {
            // if (asyncOfNewsAndAds.hasData) {
            newsState = asyncOfNewsAndAds.data![0];
            newsAds = asyncOfNewsAndAds.data![1];

            eventState = asyncOfNewsAndAds.data![2] +
                asyncOfNewsAndAds.data![3] +
                asyncOfNewsAndAds.data![4] +
                asyncOfNewsAndAds.data![5];
            eventState.shuffle();
            // print('有資料');
            // print("${currentNewsTitle}");
            if (eventShow == true) {
              childComponent = EventGroupComponent(
                  eventState: eventState, eventAds: newsAds);
            } else if (eventShow == false) {
              // print('newState: ${this.widget.newsState}');
              childComponent =
                  NewsGroupComponent(newsState: newsState, newsAds: newsAds);
            }

            // if (!Responsive.isMobile(context)) {
            return Scaffold(
                body: SafeArea(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            top: 16,
                            bottom: 16,
                            right: (MediaQuery.of(context).size.width <= 840)
                                ? 16 //16
                                : 40,
                            left: (MediaQuery.of(context).size.width <= 840)
                                ? 16 //16
                                : 40),
                        child: Column(
                          children: [
                            // 上方的首頁 logo
                            Center(
                                child: SizedBox(
                              height: 220,
                              child: InkWell(
                                child: Image.asset('images/screen_title.png'),
                                onTap: () =>
                                    launch('http://csp-news-blog.cxcxc.info/'),
                              ),
                            )),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                btnCloud("AWS-中文"),
                                btnCloud("AWS"),
                                btnCloud("GCP"),
                                btnCloud("Azure"),
                                btnCloud("雲端活動")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 一整個 news component
                                // Container(child: childComponent),
                                childComponent,

                                if (!Responsive.isMobile(context))
                                  const SizedBox(
                                    width: 100,
                                  ),

                                if (!Responsive.isMobile(context))
                                  Column(
                                    children: [
                                      InkWell(
                                          onTap: () => launch(
                                              "https://aws.amazon.com/tw/"),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: primaryElement,
                                                  width: 1.5),
                                              // borderRadius: k10pxRadius
                                            ),
                                            alignment: Alignment.topCenter,
                                            width: 300,
                                            child: Image(
                                              fit: BoxFit.scaleDown,
                                              image: Image.network(
                                                "https://i.imgur.com/8PFwWNp.png",
                                              ).image,
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 300,
                                      ),
                                      InkWell(
                                          onTap: () => launch(
                                              "https://console.cloud.google.com/?hl=zh-TW"),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: primaryElement,
                                                  width: 1.5),
                                              // borderRadius: k10pxRadius
                                            ),
                                            alignment: Alignment.topCenter,
                                            width: 300,
                                            child: Image(
                                              fit: BoxFit.scaleDown,
                                              image: Image.network(
                                                      "https://i.imgur.com/wBfuJZE.png")
                                                  .image,
                                            ),
                                          ))
                                    ],
                                  ),
                              ],
                            ),
                            if (!Responsive.isDesktop(context))
                              const SizedBox(height: 16),
                            if (!Responsive.isDesktop(context))
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () =>
                                          launch("https://aws.amazon.com/tw/"),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: primaryElement,
                                              width: 1.5),
                                          // borderRadius: k10pxRadius
                                        ),
                                        width: (MediaQuery.of(context)
                                                    .size
                                                    .width <=
                                                840)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4
                                            : 300,
                                        child: Image(
                                          fit: BoxFit.contain,
                                          image: Image.network(
                                            "https://i.imgur.com/8PFwWNp.png",
                                          ).image,
                                        ),
                                      )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  InkWell(
                                      onTap: () => launch(
                                          "https://console.cloud.google.com/?hl=zh-TW"),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: primaryElement,
                                              width: 1.5),
                                          // borderRadius: k10pxRadius
                                        ),
                                        width: (MediaQuery.of(context)
                                                    .size
                                                    .width <=
                                                840)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4
                                            : 300,
                                        child: Image(
                                          fit: BoxFit.contain,
                                          image: Image.network(
                                                  "https://i.imgur.com/wBfuJZE.png")
                                              .image,
                                        ),
                                      )),
                                ],
                              )
                          ],
                        ))));
          } else {
            return Center(
                child: Container(
                    margin: const EdgeInsets.all(50),
                    child: const CircularProgressIndicator()));
          }
        });
  }
}
