import 'package:csp_news_blog/models/news.dart';
import 'package:csp_news_blog/styles/values.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsComponent extends StatefulWidget {
  final News news;
  const NewsComponent({Key? key, required this.news}) : super(key: key);

  @override
  State createState() => NewsComponentState();
}

class NewsComponentState extends State<NewsComponent> {
  // 是否滑過該component
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // 標題
    var contentTitle = InkWell(
      onTap: () {},
      onHover: (bool doesHover) {
        setState(() {
          isHovered = doesHover;
        });
      },
      hoverColor: primaryBackground,
      child: Align(
          alignment: Alignment.centerLeft,
          child: SelectableText.rich(
            TextSpan(
              text: "${widget.news.articleTitle}",
              mouseCursor: SystemMouseCursors.click,
            ),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: (MediaQuery.of(context).size.width <= 840) ? 18 : 24,
              letterSpacing: 1.2,
              color: isHovered ? Colors.blue : Colors.black,
              decoration:
                  isHovered ? TextDecoration.underline : TextDecoration.none,
            ),
            onTap: () {
              launch(
                "${widget.news.articleOriginLink}",
              );
            },
          )),
    );

    // 新聞作者、標籤
    var authorAndTag = Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          //author
          SizedBox(
              // width: 100,
              width: (MediaQuery.of(context).size.width <= 840) ? 50 : 100,
              child: Text(
                "${widget.news.articleAuthor}",
                softWrap: false,
                style: const TextStyle(fontSize: 16),
              )),
          const SizedBox(width: 10),
          // Tag
          SizedBox(
            // width: 300,
            width: (MediaQuery.of(context).size.width <= 840) ? 150 : 300,
            child: Text(
              "${widget.news.articleTag}",
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ), // Tag
        ],
      ),
    );

    // 描述文字
    var descriptionText = Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text(
        // description of the article
        "${widget.news.description}",
        maxLines: 3,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          height: 1.3,
          letterSpacing: 1.4,
        ),
      ),
    );

    var newsText = Container(
        margin: EdgeInsets.only(
            right: (MediaQuery.of(context).size.width <= 840) ? 8 : 16), //8
        alignment: Alignment.topLeft,
        width: (MediaQuery.of(context).size.width <= 840)
            ? MediaQuery.of(context).size.width * 0.55
            : 430,
        height: 270, //260
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [contentTitle, authorAndTag, descriptionText]));

    var newsPicture = InkWell(
      child: Container(
        // width: 280, //280
        width: (MediaQuery.of(context).size.width <= 840)
            ? MediaQuery.of(context).size.width * 0.3
            : 280, //140
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: k10pxRadius,
          image: DecorationImage(
            image: Image.network("${widget.news.articlePicUrl}").image,
            fit: BoxFit.contain,
          ),
        ),
      ),
      onTap: () => launch("${widget.news.articleOriginLink}"),
    );

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          border: Border.all(color: primaryElement), borderRadius: k10pxRadius),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        newsPicture,
        SizedBox(width: (MediaQuery.of(context).size.width <= 840) ? 13 : 26),
        newsText
      ]),
    );
  }
}
