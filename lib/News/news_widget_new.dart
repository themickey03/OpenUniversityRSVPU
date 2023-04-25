import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/News/SingleNewsModelNew.dart';
import 'package:open_university_rsvpu/News/SingleNewsWidgetNew.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:open_university_rsvpu/rsvpu_icon_class_icons.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';


class NewsWidgetNew extends StatefulWidget {
  const NewsWidgetNew({Key? key}) : super(key: key);

  @override
  State<NewsWidgetNew> createState() => _WithNewsWidgetNewState();
}

class _WithNewsWidgetNewState extends State<NewsWidgetNew>
    with AutomaticKeepAliveClientMixin<NewsWidgetNew> {
  final url = "https://koralex.fun/news_api/";
  var _postsJson = [];
  final _postsJsonFiltered = [];
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
        if (prefs.containsKey("news_output")) {
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
        if (_postsJson[i]["name"]
                .toString()
                .toLowerCase()
                .contains(_searchValue.toLowerCase()) ||
            _postsJson[i]["subtitle"]
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
          leading: const Icon(RsvpuIconClass.universityLogo, color: Colors.white),
          systemOverlayStyle: const SystemUiOverlayStyle()
              .copyWith(statusBarIconBrightness: Brightness.light),
          title: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Новости", style: TextStyle(fontSize: 24))),
          onSearch: (value) => setState(() => _searchValue = value),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
        ),
        body: Center(
            child: RefreshIndicator(
                onRefresh: refresh,
                color: const Color.fromRGBO(34, 76, 164, 1),
                child: ListView.builder(
                    itemCount: _postsJsonFiltered.length,
                    itemBuilder: (context, index) {
                      var name = "";
                      if (_postsJsonFiltered[index]["name"] != null) {
                        name = _postsJsonFiltered[index]["name"];
                      }

                      var subtitle = "";
                      if (_postsJsonFiltered[index]["subtitle"] != null) {
                        subtitle = _postsJsonFiltered[index]["subtitle"];
                      }

                      var newsTags = "";
                      if (_postsJsonFiltered[index]["news_tags"] != null) {
                        newsTags = _postsJsonFiltered[index]["news_tags"];
                      }

                      var imagelink =
                          "http://koralex.fun:3000/_nuxt/assets/images/logo.png";
                      if (_postsJsonFiltered[index]["img_link"] != null &&
                          _postsJsonFiltered[index]["img_link"] != "") {
                        if (kIsWeb) {
                          imagelink =
                              "https://koralex.fun/news_api/buffer.php?type=image&link=${_postsJsonFiltered[index]["img_link"]}";
                        } else {
                          imagelink = _postsJsonFiltered[index]["img_link"];
                        }
                      }
                      var publishDate = "";
                      if (_postsJsonFiltered[index]["publish_date"] != null) {
                        publishDate = _postsJsonFiltered[index]["publish_date"];
                      }
                      var views = 0;
                      if (_postsJsonFiltered[index]["views"] != null) {
                        views = int.parse(_postsJsonFiltered[index]["views"]);
                      }
                      var content = [];
                      if (_postsJsonFiltered[index]["content"] != null) {
                        content = _postsJsonFiltered[index]["content"];
                      }
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                            shadowColor: Colors.black,
                            elevation: 20,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SingleNewsWidgetNew(
                                        singleNewsModelNew: SingleNewsModelNew(
                                            name,
                                            subtitle,
                                            newsTags,
                                            imagelink,
                                            publishDate,
                                            views,
                                            content))));
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
                                      placeholder: (context, url) =>
                                          const Image(
                                              image: AssetImage(
                                                  'images/Loading_icon.gif')),
                                      imageUrl: imagelink,
                                      fit: BoxFit.cover,
                                      width: double.maxFinite,
                                      height: double.maxFinite,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  newsTags != ""
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8, top: 5),
                                          child: Text(
                                            newsTags,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.clip,
                                                color: Colors.grey),
                                          ),
                                        )
                                      : Container(),
                                  name != ""
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8, top: 5),
                                          child: Text(
                                            name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  subtitle != ""
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8, top: 5),
                                          child: Text(
                                            subtitle,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            "Просмотров: $views",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "Дата публикации: $publishDate",
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
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
