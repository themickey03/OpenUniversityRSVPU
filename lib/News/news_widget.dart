import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/News/SingleNewsModel.dart';
import 'package:open_university_rsvpu/News/SingleNewsWidget.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  _WithNewsWidgetState createState() => _WithNewsWidgetState();
}

class _WithNewsWidgetState extends State<NewsWidget>
    with AutomaticKeepAliveClientMixin<NewsWidget> {
  final url = "http://api.bytezone.online/news";
  var _postsJson = [];
  var _postsJsonFiltered = [];
  String _searchValue = '';
  void fetchDataNews() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      final prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString("news_output", json.encode(jsonData));
        _postsJson = jsonData;
      });
    } catch (err) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        if (prefs.containsKey("news_output")){
          _postsJson = json.decode(prefs.getString("news_output")!);
        }
      });
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
    if (_searchValue != "") {
      _postsJsonFiltered.clear();
      for (int i = 0; i < _postsJson.length; i++) {
        if (_postsJson[i]["title"]
                .toString()
                .toLowerCase()
                .contains(_searchValue.toLowerCase()) ||
            _postsJson[i]["description"]
                .toString()
                .toLowerCase()
                .contains(_searchValue.toLowerCase())) {
          _postsJsonFiltered.add(_postsJson[i]);
        }
      }
    } else {
      _postsJsonFiltered.clear();
      for (int i = 0; i < _postsJson.length; i++) {
        _postsJsonFiltered.add(_postsJson[i]);
      }
    }
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: EasySearchBar(
          title: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Новости", style: TextStyle(fontSize: 24))),
          onSearch: (value) => setState(() => _searchValue = value),
          foregroundColor: Colors.white,
          backgroundColor:
              !themeNotifier.isDark
                  ? const Color.fromRGBO(34, 76, 164, 1)
                  : ThemeData.dark().primaryColor,
        ),
        body: Center(
            child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                    itemCount: _postsJsonFiltered.length,
                    itemBuilder: (context, index) {
                      var title = "";
                      if (_postsJsonFiltered[index]["title"] != null) {
                        title = _postsJsonFiltered[index]["title"];
                      }

                      var description = "";
                      if (_postsJsonFiltered[index]["description"] != null) {
                        description = _postsJsonFiltered[index]["description"];
                      }

                      var imagelink =
                          "http://koralex.fun:3000/_nuxt/assets/images/logo.png";
                      if (_postsJsonFiltered[index]["img"]["id"] != null &&
                          _postsJsonFiltered[index]["img"]["format"] != null) {
                        imagelink =
                            "http://api.bytezone.online/imgs/${_postsJsonFiltered[index]["img"]["id"]}.${_postsJsonFiltered[index]["img"]["format"]}";
                      }
                      var publishDate = "";
                      if (_postsJsonFiltered[index]["date"] != null) {
                        publishDate = _postsJsonFiltered[index]["date"];
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SingleNewsWidget(
                                          singleNewsModel: SingleNewsModel(
                                              title,
                                              imagelink,
                                              description,
                                              truePublishDate),
                                        )));
                              },
                              child: SizedBox(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        10.0,
                                    height: (MediaQuery.of(context).size.width -
                                            10.0) /
                                        16 *
                                        9,
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => const Image(image: AssetImage('images/Loading_icon.gif')),
                                      imageUrl: imagelink,
                                      fit: BoxFit.cover,
                                      width: double.maxFinite,
                                      height: double.maxFinite,
                                      alignment: Alignment.topCenter,
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
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(truePublishDate,
                                            style: const TextStyle(
                                                color: Colors.grey), textAlign: TextAlign.right,),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            )),
                      );
                    }))),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
