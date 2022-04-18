import 'dart:convert';

class News {
  // 依照文件的基礎屬性
  String? articleTitle;
  String? description;
  String? publishDate;
  String? articleOriginLink;
  String? articlePicUrl;
  String? articleTag;
  String? articleAuthor;

  // 建構子
  News({
    this.articleTitle,
    this.description,
    this.publishDate,
    this.articleOriginLink,
    this.articlePicUrl,
    this.articleTag,
    this.articleAuthor,
  });

  // 把物件直接轉換為json tring
  String toJsonString() {
    Map<String, dynamic> newsJsonMap = {
      "article": articleTitle,
      "description": description,
      "publish_date": publishDate,
      "article_origin_link": articleOriginLink,
      "article_tag": articleTag!.split(","),
      "article_author": articleAuthor,
      "article_pic_url": articlePicUrl
    };

    return jsonEncode(newsJsonMap);
  }

  /*
    工廠模式，將json轉換為物件
    {
      "article": "New - Amazon EC2 X2iezn Instances Powered by the Fastest Intel Xeon Scalable CPU for Memory-Intensive Workloads",
      "description": "Electronic Design Automation (EDA) workloads require high computing performance and a large memory footprint. These workloads are sensitive to faster CPU performance and higher clock speeds since the faster performance allows more jobs to be completed on the lower number of cores. At AWS re:Invent 2020, we launched Amazon EC2 M5zn instances which use second-generation [...]",
      "publishDate": "20220130",
      "articleOriginLink":"https://aws.amazon.com/tw/blogs/aws/new-amazon-ec2-x2iezn-instances-powered-by-the-fastest-intel-xeon-scalable-cpu-for-memory-intensive-workloads/",
      "articleTag": ["Amazon EC2", "Launch, News", "Semiconductor & Electronics"],
      "articleAuthor": "Channy Yun"
    }
  * */
  factory News.fromJson(Map<String, dynamic> json) {
    // 提取內容值，檢測，若有空值，則補值
    String articleTitle = json['article'] ?? "新聞標題異常";
    String description = json['description'] ?? "無內容描述";
    String publishDate = json['publish_date'] ?? " ";
    String articleOriginLink = json['article_origin_link'] ?? " ";
    String articlePicUrl = json['article_pic_url'] ?? " ";
    String articleAuthor = json['article_author'] ?? " ";

    // 原json為List<String> 需轉換為String
    List<dynamic> articleTagList = json['article_tag'] ?? [" "];
    // 將一整個String list 摺疊成一個String
    String articleTag = articleTagList.fold<String>(
        "", (previousValue, element) => previousValue + ", " + element);

    return News(
      articleTitle: articleTitle,
      description: description,
      publishDate: publishDate,
      articleOriginLink: articleOriginLink,
      articlePicUrl: articlePicUrl,
      articleTag: articleTag,
      articleAuthor: articleAuthor,
    );
  }
}
