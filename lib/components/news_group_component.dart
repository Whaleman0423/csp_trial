import 'dart:math';
import 'package:csp_news_blog/models/news.dart';
import 'package:flutter/material.dart';
import 'package:csp_news_blog/components/news_component.dart';

class NewsGroupComponent extends StatefulWidget {
  /*
  用來放 News 的大區域，包含分頁按鍵
  希望每個區域有 3 個 News，1 個廣告
  */

  // 建立參數，預計希望放 News 的清單
  final List<News> newsState;
  final List<News> newsAds;

  // 建構子newsThreeDemo
  const NewsGroupComponent(
      {Key? key, required this.newsState, required this.newsAds})
      : super(key: key);

  // // 用來放要呈現的 News，預設為第一頁呈現第 1 ~ 3 則新聞，因此這個清單的長度會小於等於 3，可能會再額外加廣告
  // List<News> newsThreeDemo = [];

  // 建立分頁狀態
  @override
  State createState() {
    return _NewsGroupComponent();
  }
}

class _NewsGroupComponent extends State<NewsGroupComponent> {
  // 用來放要呈現的 News，預設為第一頁呈現第 1 ~ 3 則新聞，因此這個清單的長度會小於等於 3，可能會再額外加廣告
  List<News> newsThreeDemo = [];
  // 當前頁數，預設第 1 頁
  int currentPageNum = 1;

  // 改變分頁、呈現 News 的方法
  List<News> changeCurrentPageNum({int userTap = 1}) {
    // 變換當前頁數為用戶點的頁數
    int currentPageNum = userTap;

    // 除以 3 後，剩下餘數 (可能值為 0、1、2)
    int newsLast = widget.newsState.length % 3;
    // 檢查目前分頁總數
    int maxPages;
    if (newsLast != 0) {
      maxPages = widget.newsState.length ~/ 3 + 1;
      // 當剩餘數為 0，代表整除，最大頁數的新聞數會為 3
    } else {
      maxPages = widget.newsState.length ~/ 3;
    }

    // 取出用戶點擊的該分頁所有 News，裝到 newsThreeDemo
    if (maxPages >= 2) {
      if (maxPages > currentPageNum) {
        // print(maxPages);
        // print(currentPageNum);
        // print(newsLast);
        newsThreeDemo = widget.newsState
            .sublist((currentPageNum - 1) * 3, currentPageNum * 3);
        return newsThreeDemo;
      } else if (maxPages == currentPageNum) {
        if (newsLast != 0) {
          newsThreeDemo = widget.newsState.sublist(
              (currentPageNum - 1) * 3, (currentPageNum - 1) * 3 + newsLast);
          return newsThreeDemo;
        } else if (newsLast == 0) {
          newsThreeDemo = widget.newsState
              .sublist((currentPageNum - 1) * 3, currentPageNum * 3);
          return newsThreeDemo;
        } else {
          // print("最大頁數大於2，當前頁數為最大頁數，但剩餘新聞數有問題，請檢查");
          return [];
        }
      } else {
        // print("currentPageNum > maxPages，錯誤，用戶選的頁數大於總頁數");
        return [];
      }
    } else if (maxPages == 1) {
      if (currentPageNum == 1) {
        if (newsLast != 0) {
          newsThreeDemo = widget.newsState.sublist(0, newsLast);
          return newsThreeDemo;
        } else if (newsLast == 0) {
          newsThreeDemo = widget.newsState.sublist(0, 3);
          return newsThreeDemo;
        } else {
          // print("最大頁碼為 1，剩餘新聞數有狀況，請檢查");
          return [];
        }
      } else {
        // print("總頁數為 1，但用戶選的頁數不為 1，不合理");
        return [];
      }
    } else {
      // print("總頁數小於 1，系統出錯，請檢查資料來源");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // 頁碼要幾個
    List<String> pagesList(int maxPages, int currentPageNum) {
      if (maxPages >= 4) {
        if (currentPageNum > 2) {
          if ((maxPages - currentPageNum) > 1) {
            return [
              (currentPageNum - 1).toString(),
              (currentPageNum).toString(),
              (currentPageNum + 1).toString(),
              "...",
              "下一頁"
            ];
          } else {
            return [
              (maxPages - 2).toString(),
              (maxPages - 1).toString(),
              (maxPages).toString()
            ];
          }
        } else {
          return ["1", "2", "3", "...", "下一頁"];
        }
      } else if (maxPages >= 3) {
        return ["1", "2", "3"];
      } else if (maxPages >= 2) {
        return ["1", "2"];
      } else if (maxPages >= 1) {
        return ["1"];
      } else {
        // print("最大頁數小於 1，請檢查");
        return [];
      }
    }

    // 分頁按鍵，
    Widget pageButton(page) {
      if (page == "...") {
        return Container(
          margin: const EdgeInsets.only(left: 24),
          width: 32,
          child: const Text(
            "...",
            style: TextStyle(fontSize: 12),
          ),
        );
      } else if (page == "下一頁") {
        // if (MediaQuery.of(context).size.width >
        //     MediaQuery.of(context).size.height) {
        return SizedBox(
          width: 60,
          child: TextButton(
            child: const Text(
              "下一頁",
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () {
              // print("用戶點擊下一頁");
              setState(() {
                currentPageNum = currentPageNum + 1;
                changeCurrentPageNum(userTap: currentPageNum);
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              primary: const Color(0xFF607D8B),
            ),
          ),
        );
      } else {
        return SizedBox(
          width: 60,
          child: TextButton(
            child: Text(
              page,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            onPressed: () {
              switch (page) {
                case "下一頁":
                  // print("用戶點擊下一頁");
                  setState(() {
                    currentPageNum = currentPageNum + 1;
                    changeCurrentPageNum(userTap: currentPageNum);
                  });
                  break;
                // case "...":
                //   print("用戶點擊...");
                //   break;
                default:
                  setState(() {
                    currentPageNum = int.parse(page);
                    changeCurrentPageNum(userTap: currentPageNum);
                  });
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              primary: const Color(0xFF607D8B),
            ),
          ),
        );
      }
    }

    // 最初初始化狀態
    // 目前分頁總數
    int maxPages = 0;
    // 除以 3 後，剩下餘數 (可能值為 0、1、2)
    int newsLast = -1;
    // 分頁清單
    List pageList;
    // 起始頁
    int startPage;

    if (newsLast == -1) {
      newsLast = widget.newsState.length % 3;
    }
    if (maxPages == 0) {
      if (newsLast != 0) {
        maxPages = widget.newsState.length ~/ 3 + 1;
        // 當剩餘數為 0，代表整除，最大頁數的新聞數會為 3
      } else {
        maxPages = widget.newsState.length ~/ 3;
      }
    }

    // 若要呈現的 News 清單為空，則用戶尚未選擇分頁，但預設需為第 1 頁
    if (newsThreeDemo.isEmpty) {
      // 變換頁數
      int currentPageNum = 1;
      changeCurrentPageNum(userTap: currentPageNum);
      pageList = pagesList(maxPages, 1);
      // print("重新導入");
      // 重新導入時，初始頁面需為第一頁
      startPage = 1;
    } else {
      // 已經導入過
      startPage = currentPageNum;
      pageList = pagesList(maxPages, currentPageNum);
    }
    // 判斷當前的頁面需為第幾頁
    currentPageNum = startPage;

    // 廣告，取資料
    // 從清單 newsAds 隨機取一筆
    var random = Random();
    var i = random.nextInt(widget.newsAds.length);
    var advertisement = NewsComponent(news: widget.newsAds[i]);
    // 廣告插在第幾個
    int n = 1 + random.nextInt(3);
    if (currentPageNum == maxPages) {
      n = 1;
    }
    // 回傳 Container
    return SizedBox(
        // margin: EdgeInsets.only(right: 16, left: 16),
        width: (MediaQuery.of(context).size.width <= 840) ? null : 760,
        child: Column(
            children: [
          ...newsThreeDemo.map((news) {
            return NewsComponent(news: news);
          }),
          // 頁碼按鈕
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ...pageList.map((page) {
              return pageButton(page);
            })
          ])
        ]..insert(n, advertisement)));
  }
}
