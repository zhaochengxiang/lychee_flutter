import 'package:flutter/material.dart';

import 'package:lychee/widget/base/BaseState.dart';
import 'package:lychee/widget/base/BaseScrollState.dart';
import 'package:lychee/widget/base/BaseScrollWidget.dart';
import 'package:lychee/common/util/CommonUtils.dart';
import 'package:lychee/widget/SectionWdiget.dart';
import 'package:lychee/widget/SwiperWidget.dart';
import 'package:lychee/widget/LessonItem.dart';
import 'package:lychee/common/model/LessonHome.dart';
import 'package:lychee/common/model/Lesson.dart';
import 'package:lychee/common/style/Style.dart';
import 'package:lychee/widget/SeparatorWidget.dart';
import './LessonDetailPage.dart';
import './SearchPage.dart';
import './SearchLessonPage.dart';
import 'package:lychee/common/model/Search.dart';
import './LessonAllPage.dart';

class LessonPage extends StatefulWidget {
  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with AutomaticKeepAliveClientMixin<LessonPage>,BaseState<LessonPage>, BaseScrollState<LessonPage> {

  LessonHome lessonHome;

  @override
  remotePath() {
    return "/lesson/home";
  }

  @override
  generateRemoteParams() {
    return {};    
  }

  @override
  jsonConvertToModel(Map<String,dynamic> json) {
    return LessonHome.fromJson(json);
  }

  _buildBannerWidget() {
    if (lessonHome==null) return new Container();

    var fineList = lessonHome.fineList;

    List imageUrls = List();
    if (fineList != null) {
      for (int i=0;i<fineList.length;i++) {
        Lesson course = fineList[i];
        imageUrls.add(course.cover);
      }
    }

    return (fineList==null||fineList.length==0)?new Container():new SwiperWidget(
      height: 125,
      imageUrls: imageUrls,
      dotActiveColor: Color(YYColors.primary),
      selectItemChanged:(selectIndex) {
       
      },
    );
  }

  _buildRecommendLessonWidget() {
    if (lessonHome == null) return new Container();

    var recommends = lessonHome.recommendList;

    return (recommends==null||recommends.length==0)?new Container():new Column(
      children: <Widget>[
        SectionWidget(
          title: "推荐小讲",
          subtitle: "全部小讲",
          onPressed: (){CommonUtils.openPage(context, LessonAllPage());},
        ),
        new ListView.separated(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index)=>SeparatorWidget(),
          itemBuilder: (context, index) {
            Lesson recommend = recommends[index];
            return new LessonItem(recommend,onPressed: (){
              CommonUtils.openPage(context, LessonDetailPage({"uuid":recommend.uuid}));
            });
          },
          itemCount: recommends.length,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    lessonHome = control.data;

    return new Scaffold(
      appBar: new AppBar(
        title:Text("小讲"),
        centerTitle: true, 
        leading: IconButton(
          icon: Image.asset(CommonUtils.Local_Icon_prefix+"back.png",width: 18,height: 18),
          onPressed: (){
            CommonUtils.closePage(context);
          },
        ),
        actions: <Widget>[
          IconButton(
          icon: new Image.asset(CommonUtils.Local_Icon_prefix+"search_gray.png",width: 18.0,height: 18.0),
          onPressed: () {
            CommonUtils.openPage(context, SearchPage(type:Search.SEARCH_LESSON,onPressed:(keyword) {
              CommonUtils.openPage(context, SearchLessonPage(keyword: keyword));
            }));
          })
        ]
      ),
      body: BaseScrollWidget(
        control:control,
        onRefresh:handleRefresh,
        refreshKey: refreshIndicatorKey,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBannerWidget(),
            _buildRecommendLessonWidget(),
          ]
        ),
      ),
    );
  }
}