import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({Key? key}) : super(key: key);
  // 404 錯誤頁面
  // 預計會有一個 404 的圖片，下面附有公司連結、各大雲連結、原本新知部落格連結

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(1280, 648),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.landscape);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Flexible(
              flex: 2,
              child: Image.asset(
                'images/page_not_found.png',
                fit: BoxFit.fill,
              )),
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 250.w),
                child: Row(
                  children: [
                    Flexible(
                      child: InkWell(
                        child: Text(
                          '雲育鏈',
                          style: TextStyle(fontSize: 30.sp),
                        ),
                        onTap: () => launch('https://www.cxcxc.io/'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.w),
                      // child: Expanded(
                      child: InkWell(
                        child: Text(
                          'Aws',
                          style: TextStyle(fontSize: 30.sp),
                        ),
                        onTap: () =>
                            launch('https://aws.amazon.com/tw/blogs/aws/'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.w),
                      // child: Expanded(
                      child: InkWell(
                        child: Text(
                          '亞馬遜 Aws',
                          style: TextStyle(fontSize: 30.sp),
                        ),
                        onTap: () =>
                            launch('https://aws.amazon.com/cn/blogs/china/'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.w),
                      // child: Expanded(
                      child: InkWell(
                        child: Text(
                          'Azure',
                          style: TextStyle(fontSize: 30.sp),
                        ),
                        onTap: () =>
                            launch('https://azure.microsoft.com/zh-tw/blog/'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.w),
                      // child: Expanded(
                      child: InkWell(
                        child: Text(
                          'GCP',
                          style: TextStyle(fontSize: 30.sp),
                        ),
                        onTap: () => launch('https://cloud.google.com/blog/'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.w),
                      // child: Expanded(
                      child: InkWell(
                        child: Text(
                          '雲端新知部落格',
                          style: TextStyle(fontSize: 30.sp),
                        ),
                        onTap: () => launch('https://www.cxcxc.io/'),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
