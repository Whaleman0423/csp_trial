import 'dart:convert';

class Event {
  // 依照文件的基礎屬性
  // 活動主題、介紹文、開始日期、結束日期、地區、標籤、圖片連結、活動文章連結
  String? eventTitle;
  String? introduction;
  String? startDate;
  String? endDate;
  String? eventOriginLink;
  String? eventPicUrl;
  String? eventTag;
  String? location;

  // 建構子
  Event({
    this.eventTitle,
    this.introduction,
    this.startDate,
    this.endDate,
    this.eventOriginLink,
    this.eventPicUrl,
    this.eventTag,
    this.location,
  });

  // 把物件直接轉換為json tring
  String toJsonString() {
    Map<String, dynamic> eventJsonMap = {
      "event_title": eventTitle,
      "introduction": introduction,
      "start_date": startDate,
      "end_date": endDate,
      "event_origin_link": eventOriginLink,
      "event_tag": eventTag!.split(","),
      "location": location,
      "event_pic_url": eventPicUrl
    };

    return jsonEncode(eventJsonMap);
  }

  /*
    工廠模式，將json轉換為物件
    {
      "event_title": "New - Amazon EC2 X2iezn Instances Powered by the Fastest Intel Xeon Scalable CPU for Memory-Intensive Workloads",
      "introduction": "Electronic Design Automation (EDA) workloads require high computing performance and a large memory footprint. These workloads are sensitive to faster CPU performance and higher clock speeds since the faster performance allows more jobs to be completed on the lower number of cores. At AWS re:Invent 2020, we launched Amazon EC2 M5zn instances which use second-generation [...]",
      "startDate": "20220130",
      "endDate": "20220130",
      "eventOriginLink":"https://aws.amazon.com/tw/blogs/aws/new-amazon-ec2-x2iezn-instances-powered-by-the-fastest-intel-xeon-scalable-cpu-for-memory-intensive-workloads/",
      "eventTag": ["Amazon EC2", "Launch, Event", "Semiconductor & Electronics"],
      "location": "Channy Yun"
    }
  * */
  factory Event.fromJson(Map<String, dynamic> json) {
    // 提取內容值，檢測，若有空值，則補值
    String eventTitle = json['event_title'] ?? "活動標題異常";
    String introduction = json['introduction'] ?? " ";
    String startDate = json['start_date'] ?? " ";
    String endDate = json['end_date'] ?? " ";
    String eventOriginLink = json['event_origin_link'] ?? " ";
    String eventPicUrl = json['event_pic_url'] ?? " ";
    String location = json['location'] ?? " ";

    // 原json為List<String> 需轉換為String
    List<dynamic> eventTagList = json['event_tag'] ?? [" "];
    // 將一整個String list 摺疊成一個String
    String eventTag = eventTagList.fold<String>(
        "", (previousValue, element) => previousValue + ", " + element);

    return Event(
      eventTitle: eventTitle,
      introduction: introduction,
      startDate: startDate,
      endDate: endDate,
      eventOriginLink: eventOriginLink,
      eventPicUrl: eventPicUrl,
      eventTag: eventTag,
      location: location,
    );
  }
}
