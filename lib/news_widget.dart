import 'dart:convert';
import 'package:open_university_rsvpu/NewsItemWidget.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);


  @override
  _WithNewsWidgetState createState() => _WithNewsWidgetState();
}

class _WithNewsWidgetState extends State<NewsWidget>
    with AutomaticKeepAliveClientMixin<NewsWidget> {

  final url = "http://45.8.147.95:3333/news";

  var _postsJson = [];
  void fetchDataNews() async{

    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postsJson = jsonData;
      });
    } catch (err){
      print(err);
    }
  }

  @override
  void initState(){
    super.initState();
    fetchDataNews();
  }

  final items = List<String>.generate(10, (i) => "Новость № $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: _postsJson.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  height: 300,
                  child: NewsItemWidget(oneNews: OneNews(
                      _postsJson[index]["title"],
                      _postsJson[index]["description"],
                      "http://45.8.147.95:3333/imgs/${_postsJson[index]["img"]["id"]}.${_postsJson[index]["img"]["format"]}",
                      _postsJson[index]["date"],
                      _postsJson[index]["views"].toString())),
                )
              ],
            );
          },
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}