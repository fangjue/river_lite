import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/square/square.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class SquareHome extends StatefulWidget {
  const SquareHome({Key key}) : super(key: key);

  @override
  _SquareHomeState createState() => _SquareHomeState();
}

class _SquareHomeState extends State<SquareHome> {
  FocusNode _focusNode = new FocusNode();
  TextEditingController _controller = new TextEditingController();
  bool showCancel = false;
  bool get_done = false;
  var data = [];

  _getData() async {
    String tmp_txt = await getStorage(key: "column_data", initData: "");
    if (tmp_txt != "") {
      setState(() {
        data = (jsonDecode(tmp_txt))["list"];
      });
    }
    var tmp = await Api().forum_forumlist({});
    if (tmp != null && tmp["rs"] != 0 && tmp["list"] != null) {
      data = tmp["list"];
      setStorage(key: "column_data", value: jsonEncode(tmp));
    }
    setState(() {
      get_done = true;
    });
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.add(SpecialSquareCard());
    if (data != null && data.length != 0) {
      for (var i = 0; i < data.length; i++) {
        tmp.add(SquareCard(data: data[i], index: i));
      }
    } else {
      tmp.add(BottomLoading(color: Colors.transparent));
    }
    return tmp;
  }

  bool match(String a, String b) {
    bool flag = false;
    for (var i = 0; i < a.length; i++) {
      for (var j = 0; j < b.length; j++) {
        if (a[i] == b[j]) flag = true;
      }
    }
    return flag;
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        showCancel = _controller.text.length > 0;
      });
    });
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      appBar: AppBar(
        systemOverlayStyle: Provider.of<ColorProvider>(context).isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        title: Text("全部板块", style: TextStyle(fontSize: 16)),
        leading: Container(),
        leadingWidth: 0,
        elevation: 0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: _buildCont(),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    super.dispose();
  }

  Widget _getInput() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
      height: 50,
      decoration: BoxDecoration(
        color: os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: myInkWell(
        radius: 10,
        tap: () {
          Navigator.pushNamed(context, "/search", arguments: 0);
        },
        widget: Container(
          padding: EdgeInsets.only(left: 15),
          child: Center(
            child: Row(
              children: [
                Container(width: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 105,
                  child: Text(
                    "搜一搜",
                    style: TextStyle(
                      color: os_deep_grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(15),
                  child: os_svg(
                    path: "lib/img/search_blue.svg",
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SquareCard extends StatefulWidget {
  var data;
  int index;
  SquareCard({
    Key key,
    @required this.data,
    @required this.index,
  }) : super(key: key);

  @override
  State<SquareCard> createState() => _SquareCardState();
}

class _SquareCardState extends State<SquareCard> {
  List<Widget> _buildWrapWidget() {
    List<Widget> tmp = [];
    widget.data["board_list"].forEach((e) {
      tmp.add(
        Container(
          margin: EdgeInsets.only(right: 10, bottom: 10),
          child: myInkWell(
            tap: () {
              Navigator.pushNamed(context, "/column", arguments: e["board_id"]);
            },
            color: Provider.of<ColorProvider>(context).isDark
                ? os_white_opa
                : os_white,
            widget: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? Color(0x11FFFFFF)
                      : os_white,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
              child: Text(
                e["board_name"],
                style: TextStyle(
                  fontSize: 14,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
            ),
            radius: 15,
          ),
        ),
      );
    });
    return tmp;
  }

  Widget _getIcon(IconData iconData) {
    return Icon(
      iconData,
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_white : os_black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: widget.data["board_category_name"] == "站务管理"
                    ? _getIcon(Icons.sms_outlined)
                    : Container(
                        child: [
                          _getIcon(Icons.trending_up_outlined),
                          _getIcon(Icons.map_outlined),
                          _getIcon(Icons.school_outlined),
                          _getIcon(Icons.local_cafe_outlined),
                          _getIcon(Icons.directions_bike_outlined),
                          _getIcon(Icons.sms_outlined),
                        ][widget.index],
                      ),
              ),
              Container(width: 3),
              Text(
                widget.data["board_category_name"],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
            ],
          ),
          Container(height: 7.5),
          Container(
            width: MediaQuery.of(context).size.width - 60,
            child: Wrap(
              alignment: WrapAlignment.start,
              children: _buildWrapWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
