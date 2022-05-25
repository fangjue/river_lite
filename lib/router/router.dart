import 'package:offer_show/page/404.dart';
import 'package:offer_show/page/about/about.dart';
import 'package:offer_show/page/account/account.dart';
import 'package:offer_show/page/blacklist/black_list.dart';
import 'package:offer_show/page/broke.dart';
import 'package:offer_show/page/column/column.dart';
import 'package:offer_show/page/crop/crop.dart';
import 'package:offer_show/page/explore/explore.dart';
import 'package:offer_show/page/explore_detail/explore_detail.dart';
import 'package:offer_show/page/home.dart';
import 'package:offer_show/page/hot/homeHot.dart';
import 'package:offer_show/page/home/myhome.dart';
import 'package:offer_show/page/login/login.dart';
import 'package:offer_show/page/login/login_helper.dart';
import 'package:offer_show/page/me/me.dart';
import 'package:offer_show/page/me_func/me_func.dart';
import 'package:offer_show/page/msg_detail/msg_detail.dart';
import 'package:offer_show/page/msg_three/msg_three.dart';
import 'package:offer_show/page/new/new.dart';
import 'package:offer_show/page/person_detail/personDetail.dart';
import 'package:offer_show/page/personal/personal.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/question/question.dart';
import 'package:offer_show/page/search/search.dart';
import 'package:offer_show/page/setting/setting.dart';
import 'package:offer_show/page/square/square.dart';
import 'package:offer_show/page/test/test.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/page/user_list/user_list.dart';
import 'package:offer_show/page/waterTask/water_task.dart';

final routers = {
  "/": () => Home(),
  "/question": () => Question(),
  "/login": (data) => Login(index: data ?? 0),
  "/water_task": () => WaterTask(),
  "/person_detail": (uid) => PersonDetail(uid: uid),
  "/about": () => About(),
  "/test": () => Test(),
  "/setting": () => Setting(),
  "/account": () => Account(),
  "/explore": () => Explore(),
  "/explore_detail": (data) => ExploreDetail(index: data),
  "/login_helper": () => LoginHelper(),
  "/broke": () => Broke(),
  "/me": () => Me(),
  "/myhome": () => MyHome(),
  "/square": () => Square(),
  "/404": () => Page404(),
  "/me_func": (data) => MeFunc(type: data["type"], uid: data["uid"]),
  "/person_center": (data) => PersonCenter(param: data),
  "/topic_detail": (data) => TopicDetail(topicID: data),
  "/search": () => Search(),
  "/crop": () => CropImg(),
  "/column": (data) => TopicColumn(columnID: data),
  "/hot": () => Hot(),
  "/new": (data) => PostNew(board_id: data),
  "/black_list": () => BlackList(),
  "/msg_three": (data) => MsgThree(type: data),
  "/msg_detail": (data) => MsgDetail(usrInfo: data),
  "/user_list": (data) => UserList(data: data),
  "/photo_view": ({data}) => PhotoPreview(
        galleryItems: data.galleryItems,
        defaultImage: data.defaultImage,
        pageChanged: data.pageChanged,
        direction: data.direction,
        decoration: data.decoration,
      ),
};
