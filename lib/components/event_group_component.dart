import 'dart:math';
import 'package:csp_news_blog/models/event.dart';
import 'package:csp_news_blog/models/news.dart';
import 'package:csp_news_blog/responsive.dart';
import 'package:flutter/material.dart';
import 'package:csp_news_blog/components/event_component.dart';
import 'package:csp_news_blog/components/news_component.dart';

class EventGroupComponent extends StatefulWidget {
  /*
  用來放 Event 的大區域，包含分頁按鍵
  希望每個區域有 3 個 Event，1 個廣告
  */

  // 建立參數，預計希望放 Event 的清單
  final List<Event> eventState;
  final List<News> eventAds;

  // // 用來放要呈現的 Event，預設為第一頁呈現第 1 ~ 3 則新聞，因此這個清單的長度會小於等於 3，可能會再額外加廣告
  // List<Event> eventThreeDemo = [];

  // 建構子
  const EventGroupComponent(
      {Key? key, required this.eventState, required this.eventAds})
      : super(key: key);

  // 建立分頁狀態
  @override
  State createState() {
    return _EventGroupComponent();
  }
}

class _EventGroupComponent extends State<EventGroupComponent> {
  // 當前頁數，預設第 1 頁
  int currentPageNum = 1;

  // 用來放要呈現的 Event，預設為第一頁呈現第 1 ~ 3 則新聞，因此這個清單的長度會小於等於 3，可能會再額外加廣告
  List<Event> eventThreeDemo = [];

  // 改變分頁、呈現 Event 的方法
  List<Event> changeCurrentPageNum({int userTap = 1}) {
    // 變換當前頁數為用戶點的頁數
    int currentPageNum = userTap;

    // 除以 3 後，剩下餘數 (可能值為 0、1、2)
    int eventLast = widget.eventState.length % 3;
    // 檢查目前分頁總數
    int maxPages;
    if (eventLast != 0) {
      maxPages = widget.eventState.length ~/ 3 + 1;
      // 當剩餘數為 0，代表整除，最大頁數的新聞數會為 3
    } else {
      maxPages = widget.eventState.length ~/ 3;
    }

    // 取出用戶點擊的該分頁所有 Event，裝到 eventThreeDemo
    if (maxPages >= 2) {
      if (maxPages > currentPageNum) {
        // print(maxPages);
        // print(currentPageNum);
        // print(eventLast);
        eventThreeDemo = widget.eventState
            .sublist((currentPageNum - 1) * 3, currentPageNum * 3);
        return eventThreeDemo;
      } else if (maxPages == currentPageNum) {
        if (eventLast != 0) {
          eventThreeDemo = widget.eventState.sublist(
              (currentPageNum - 1) * 3, (currentPageNum - 1) * 3 + eventLast);
          return eventThreeDemo;
        } else if (eventLast == 0) {
          eventThreeDemo = widget.eventState
              .sublist((currentPageNum - 1) * 3, currentPageNum * 3);
          return eventThreeDemo;
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
        if (eventLast != 0) {
          eventThreeDemo = widget.eventState.sublist(0, eventLast);
          return eventThreeDemo;
        } else if (eventLast == 0) {
          eventThreeDemo = widget.eventState.sublist(0, 3);
          return eventThreeDemo;
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
          margin: const EdgeInsets.only(left: 22),
          width: 32,
          child: const Text(
            "...",
            style: TextStyle(fontSize: 12),
          ),
        );
      } else if (page == "下一頁") {
        if (!Responsive.isMobile(context)) {
          return SizedBox(
            width: 56,
            child: TextButton(
              child: const Text(
                "下一頁",
                style: TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
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
            width: 96,
            child: TextButton(
              child: const Text(
                "下一頁",
                maxLines: 1,
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
        }
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
    int eventLast = -1;
    // 分頁清單
    List pageList;
    // 起始頁
    int startPage;

    if (eventLast == -1) {
      eventLast = widget.eventState.length % 3;
    }
    if (maxPages == 0) {
      if (eventLast != 0) {
        maxPages = widget.eventState.length ~/ 3 + 1;
        // 當剩餘數為 0，代表整除，最大頁數的新聞數會為 3
      } else {
        maxPages = widget.eventState.length ~/ 3;
      }
    }

    // 若要呈現的 Event 清單為空，則用戶尚未選擇分頁，但預設需為第 1 頁
    if (eventThreeDemo.isEmpty) {
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
    // 從清單 eventAds 隨機取一筆
    var random = Random();
    var i = random.nextInt(widget.eventAds.length);
    var advertisement = NewsComponent(news: widget.eventAds[i]);
    // 廣告插在第幾個
    int n = 1 + random.nextInt(3);
    if (currentPageNum == maxPages) {
      n = 1;
    }
    // 回傳 Container
    return SizedBox(
        // margin: EdgeInsets.only(left: 70.0.w, top: 40.h),
        width: (MediaQuery.of(context).size.width <= 840)
            ? MediaQuery.of(context).size.width * 0.9
            : 760,
        child: Column(
            children: [
          ...eventThreeDemo.map((event) {
            return EventComponent(event: event);
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
