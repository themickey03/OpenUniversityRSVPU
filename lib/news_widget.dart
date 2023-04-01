import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/SingleNewsModel.dart';
import 'package:open_university_rsvpu/SingleNewsWidget.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  _WithNewsWidgetState createState() => _WithNewsWidgetState();
}

class _WithNewsWidgetState extends State<NewsWidget>
    with AutomaticKeepAliveClientMixin<NewsWidget> {
  //TODO change link
  final url = "https://koralex.fun/back/news";
  var _postsJson = [];
  void fetchDataNews() async {

    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  initState() {
    super.initState();
    fetchDataNews();
  }

  Future refresh() async {
    setState(() {
      fetchDataNews();
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
            itemCount: _postsJson.length,
            itemBuilder: (context, index) {
              var title = "";
              if (_postsJson[index]["title"] != null) {
                title = _postsJson[index]["title"];
              }

              var description = "";
              if (_postsJson[index]["description"] != null) {
                description = _postsJson[index]["description"];
              }

              var imagelink =
              //TODO change link
                  "http://koralex.fun:3000/_nuxt/assets/images/logo.png";
              if (_postsJson[index]["img"]["id"] != null &&
                  _postsJson[index]["img"]["format"] != null) {
                imagelink =
                //TODO change link
                    "https://koralex.fun/back/imgs/${_postsJson[index]["img"]["id"]}.${_postsJson[index]["img"]["format"]}";
              }
              var publishDate = "";
              if (_postsJson[index]["date"] != null) {
                publishDate = _postsJson[index]["date"];
              }
              var views = "0";
              if (_postsJson[index]["views"] != null) {
                views = _postsJson[index]["views"].toString();
              }
              var truePublishDate = "";
              var dt = DateTime.parse(publishDate);
              try {
                truePublishDate =
                    DateFormat('dd.MM.yyyy в kk:mm').format(dt);
              } catch (err) {
                truePublishDate = publishDate;
              }
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                            SingleNewsWidget(
                              singleNewsModel:
                                SingleNewsModel(
                                  title,
                                  imagelink,
                                  description,
                                  truePublishDate,
                                  views),
                            )
                        )
                      );
                    },
                    child: SizedBox(
                        child: Column(
                      crossAxisAlignment:
                        CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width:
                            MediaQuery.of(context).size.width - 10.0,
                          height:
                            (MediaQuery.of(context).size.width - 10.0) / 16 * 9,
                          child: FadeInImage.assetNetwork(
                            alignment: Alignment.topCenter,
                            placeholder:
                              'images/Loading_icon.gif',
                            image: imagelink,
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                            height: double.maxFinite,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 5),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 5),
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 5,
                              bottom: 5),
                          child: Row(
                            children: [
                              Text("Просмотров: $views",
                                  style: const TextStyle(
                                      color: Colors.grey)),
                              const Spacer(),
                              Text(truePublishDate,
                                  style: const TextStyle(
                                      color: Colors.grey)),
                            ],
                          ),
                        )
                      ],
                    )),
                  )),
              );
            }))
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
