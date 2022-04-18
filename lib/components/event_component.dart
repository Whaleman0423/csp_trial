import 'package:csp_news_blog/models/event.dart';
import 'package:csp_news_blog/styles/values.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventComponent extends StatefulWidget {
  final Event event;
  const EventComponent({Key? key, required this.event}) : super(key: key);

  @override
  State createState() => EventComponentState();
}

class EventComponentState extends State<EventComponent> {
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
      // child: Align(
      // alignment: Alignment.centerLeft,
      child: SelectableText.rich(
        TextSpan(
          text: "${widget.event.eventTitle}",
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
            "${widget.event.eventOriginLink}",
          );
        },
      ),
    );

    // 新聞作者、標籤
    var locationAndTag = Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          // location
          SizedBox(
              width: (MediaQuery.of(context).size.width <= 840) ? 50 : 100,
              child: Text(
                "${widget.event.location}",
                softWrap: false,
                style: const TextStyle(fontSize: 16),
              )),
          const SizedBox(width: 12),
          // Tag
          SizedBox(
            width: (MediaQuery.of(context).size.width <= 840) ? 150 : 300,
            child: Text(
              "${widget.event.eventTag}",
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ), // Tag
        ],
      ),
    );

    // 描述文字
    var introductionText = Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text(
        // introduction of the event
        "${widget.event.introduction}",
        maxLines: 3,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          height: 1.3,
          letterSpacing: 1.6,
        ),
      ),
    );

    var eventText = Container(
        margin: EdgeInsets.only(
            right: (MediaQuery.of(context).size.width <= 840) ? 8 : 16),
        alignment: Alignment.topLeft,
        width: (MediaQuery.of(context).size.width <= 840)
            ? MediaQuery.of(context).size.width * 0.55
            : 430,
        height: 270, //260
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [contentTitle, locationAndTag, introductionText]));

    var eventPicture = InkWell(
      child: Container(
        width: (MediaQuery.of(context).size.width <= 840)
            ? MediaQuery.of(context).size.width * 0.3
            : 280, //280
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: k10pxRadius,
          image: DecorationImage(
            image: Image.network("${widget.event.eventPicUrl}").image,
            fit: BoxFit.contain,
          ),
        ),
      ),
      onTap: () => launch("${widget.event.eventOriginLink}"),
    );

    // if (!Responsive.isMobile(context)) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      // 邊框框線
      decoration: BoxDecoration(
          border: Border.all(color: primaryElement), borderRadius: k10pxRadius),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            eventPicture,
            SizedBox(
                width: (MediaQuery.of(context).size.width <= 840) ? 13 : 26),
            eventText
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  flex: (MediaQuery.of(context).size.width <= 840) ? 1 : 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.calendar_month,
                      size:
                          (MediaQuery.of(context).size.width <= 840) ? 18 : 20,
                    ),
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      "${widget.event.startDate}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: (MediaQuery.of(context).size.width <= 840)
                              ? 13
                              : 16),
                    ),
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: const Text(
                      " ~ ",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 8,
                        right: (MediaQuery.of(context).size.width <= 840)
                            ? 16
                            : 32),
                    child: Text(
                      "${widget.event.endDate}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: (MediaQuery.of(context).size.width <= 840)
                              ? 14
                              : 16),
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}
