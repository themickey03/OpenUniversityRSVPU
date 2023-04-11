import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/Videos/Stories/SingleStorieModel.dart';
import 'package:open_university_rsvpu/Videos/Stories/SingleStorieWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:provider/provider.dart';

class StoriesWidget extends StatefulWidget {
  @override
  _StoriesWidgetState createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget>
    with AutomaticKeepAliveClientMixin<StoriesWidget> {
  final url = "http://api.bytezone.online/stories";
  var _postsJson = [];
  var _savedPosition = List.filled(999, 0);
  var _isVideoStorySaved = true;
  void fetchDataPersons() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      final prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString("stories_output", json.encode(jsonData));
        _postsJson = jsonData;
        if (_savedPosition.isEmpty) {
          _savedPosition = List.filled(_postsJson.length + 1, 0);
        }
      });
    } catch (err) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        if (prefs.containsKey("stories_output")){
          _postsJson = json.decode(prefs.getString("stories_output")!);
        }
        if (_savedPosition.isEmpty) {
          _savedPosition = List.filled(_postsJson.length + 1, 0);
        }
      });
    }
  }

  void initState() {
    super.initState();
    fetchDataPersons();
  }

  Future onRefresh() async {
    setState(() {
      fetchDataPersons();
    });
  }

  void getData(id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt("stories_${id.toString()}") != null) {
        _savedPosition[id] = prefs.getInt("stories_${id.toString()}")!;
      } else {
        _savedPosition[id] = 0;
      }
      if (prefs.getBool("VideoWatchedSaving") != null) {
        _isVideoStorySaved = prefs.getBool("VideoWatchedSaving")!;
      }
    });
  }

  String do_time_from_string(duration) {
    String result = "";

    var intTime = int.parse(duration);
    var intTimeH = intTime ~/ 3600;
    var intTimeM = (intTime % 3600) ~/ 60;
    var intTimeS = ((intTime % 3600) % 60).toInt();

    if (intTimeS != 0) {
      if (intTimeM != 0) {
        if (intTimeS < 10) {
          result = "0$intTimeS";
        } else {
          result = intTimeS.toString();
        }
      } else {
        if (intTimeS < 10) {
          result = "0:0$intTimeS";
        } else {
          result = "0:$intTimeS";
        }
      }
    } else {
      if (intTimeM != 0 || intTimeH != 0) {
        result = "00";
      }
    }
    if (intTimeM != 0) {
      if (intTimeM < 10) {
        result = "0$intTimeM:$result";
      } else {
        result = "$intTimeM:$result";
      }
    } else {
      if (intTimeH != 0) {
        result = "00:$result";
      }
    }
    if (intTimeH != 0) {
      if (intTimeH < 10) {
        result = "0$intTimeH:$result";
      } else {
        result = "$intTimeH:$result";
      }
    }
    if (_isVideoStorySaved == false) {
      return "";
    } else {
      if (result == "") {
        return result;
      } else {
        return "$result/";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        body: Center(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: _postsJson.length,
              itemBuilder: (context, index) {
                var id = 0;
                if (_postsJson[index]['id'] != "" &&
                    _postsJson[index]['id'] != null) {
                  id = _postsJson[index]['id'];
                }
                getData(id);
                var name = "";
                if (_postsJson[index]['title'] != "" &&
                    _postsJson[index]['title'] != null) {
                  name = _postsJson[index]['title'];
                }
                var mainDesc = Map<String, dynamic>();
                if (_postsJson[index]['description'] != null) {
                  mainDesc = _postsJson[index]['description'];
                }
                var imgLink = "";
                if (_postsJson[index]['img'] != "" &&
                    _postsJson[index]['img'] != null) {
                  if (_postsJson[index]['img']['id'] != "" &&
                      _postsJson[index]['img']['id'] != null) {
                    if (_postsJson[index]['img']['format'] != "" &&
                        _postsJson[index]['img']['format'] != null) {
                      imgLink =
                          "http://api.bytezone.online/imgs/${_postsJson[index]["img"]["id"]}.${_postsJson[index]["img"]["format"]}";
                    }
                  }
                }
                var duration = "";
                if (_postsJson[index]['duration'] != "" &&
                    _postsJson[index]['duration'] != null) {
                  duration = _postsJson[index]['duration'];
                }
                var desc = "";
                if (mainDesc['Описание'] != "" &&
                    mainDesc['Описание'] != null) {
                  desc = mainDesc['Описание'];
                }
                var videoLink = "";
                if (_postsJson[index]['path'] != "" &&
                    _postsJson[index]['path'] != null) {
                  videoLink = _postsJson[index]['path'];
                }
                return Card(
                    shadowColor: Colors.black,
                    elevation: 20,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SingleLectionWidget(
                                singleLectionModel: SingleLectionModel(id, name,
                                    videoLink, duration, desc, imgLink))));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 10.0,
                                  height: (MediaQuery.of(context).size.width -
                                          10.0) /
                                      16 *
                                      9,
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        placeholder: (context, url) => const Image(image: AssetImage('images/Loading_icon.gif')),
                                        imageUrl: imgLink,
                                        fit: BoxFit.cover,
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        alignment: Alignment.topCenter,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12.0, bottom: 6.0),
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                              child: Container(
                                                width: 9.0 *
                                                    (do_time_from_string(
                                                                _savedPosition[
                                                                        id]
                                                                    .toString())
                                                            .length +
                                                        duration.length),
                                                height: 20,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                                child: Center(
                                                  child: Text(
                                                      do_time_from_string(
                                                              _savedPosition[id]
                                                                  .toString()) +
                                                          duration,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14)),
                                                ),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
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
                                ),
                                desc == ""
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 5,
                                            bottom: 7),
                                        child: Text(
                                          desc,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    : const Text("")
                              ]))
                        ],
                      ),
                    ));
              },
            ),
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
