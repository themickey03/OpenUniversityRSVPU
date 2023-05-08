import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/Videos/single_video_widget.dart';
import 'package:open_university_rsvpu/Videos/single_video_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:provider/provider.dart';

class VideoListWidget extends StatefulWidget {
  final String type;
  const VideoListWidget({super.key, required this.type});

  @override
  State<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget>
    with AutomaticKeepAliveClientMixin<VideoListWidget> {
  var _url = "";
  var _postsJson = [];
  var _savedPosition = List.filled(999, 0);
  var _isVideoStorySaved = true;

  void fetchDataPersons() async {
    try {
      _url = 'https://ouapi.koralex.fun/${widget.type}?order=id';
      final response = await get(Uri.parse(_url));
      final jsonData = jsonDecode(response.body) as List;

      final prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString("${widget.type}_output", json.encode(jsonData));
        _postsJson = jsonData;
        if (_savedPosition.isEmpty) {
          _savedPosition = List.filled(_postsJson.length + 1, 0);
        }
      });
    } catch (err) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        if (prefs.containsKey("${widget.type}_output")) {
          _postsJson = json.decode(prefs.getString("${widget.type}_output")!);
        }
        if (_savedPosition.isEmpty) {
          _savedPosition = List.filled(_postsJson.length + 1, 0);
        }
      });
    }
  }

  @override
  void initState() {
    fetchDataPersons();
    super.initState();
  }

  Future onRefresh() async {
    setState(() {
      fetchDataPersons();
    });
  }

  void getData(id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt("${widget.type}_${id.toString()}") != null) {
        _savedPosition[id] = prefs.getInt("${widget.type}_${id.toString()}")!;
      } else {
        _savedPosition[id] = 0;
      }
      if (prefs.getBool("VideoWatchedSaving") != null) {
        _isVideoStorySaved = prefs.getBool("VideoWatchedSaving")!;
      }
    });
  }

  String doTimeFromString(duration) {
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
    super.build(context);
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        body: Center(
          child: RefreshIndicator(
            color: const Color.fromRGBO(34, 76, 164, 1),
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: _postsJson.length,
              itemBuilder: (context, index) {
                var id = 0;
                if (_postsJson[_postsJson.length - index - 1]['id'] != "" &&
                    _postsJson[_postsJson.length - index - 1]['id'] != null) {
                  id = _postsJson[_postsJson.length - index - 1]['id'];
                }
                getData(id);
                var name = "";
                if (_postsJson[_postsJson.length - index - 1]['title'] != "" &&
                    _postsJson[_postsJson.length - index - 1]['title'] !=
                        null) {
                  name = _postsJson[_postsJson.length - index - 1]['title'];
                }
                var desc = "";
                if (_postsJson[_postsJson.length - index - 1]['description'] !=
                    null) {
                  desc =
                      _postsJson[_postsJson.length - index - 1]['description'];
                }
                var imgLink = "";
                if (_postsJson[_postsJson.length - index - 1]['img_id'] != "" &&
                    _postsJson[_postsJson.length - index - 1]['img_id'] !=
                        null) {
                  imgLink =
                      "https://ouimg.koralex.fun/${_postsJson[_postsJson.length - index - 1]['img_id']}.png";
                }
                var duration = "";
                if (_postsJson[_postsJson.length - index - 1]['duration'] !=
                        "" &&
                    _postsJson[_postsJson.length - index - 1]['duration'] !=
                        null) {
                  duration =
                      _postsJson[_postsJson.length - index - 1]['duration'];
                }
                var videoLink = "";
                if (_postsJson[_postsJson.length - index - 1]['path'] != "" &&
                    _postsJson[_postsJson.length - index - 1]['path'] != null) {
                  videoLink = _postsJson[_postsJson.length - index - 1]['path'];
                }
                var resolutions = [];
                if (_postsJson[_postsJson.length - index - 1]['resolutions'] !=
                        null &&
                    _postsJson[_postsJson.length - index - 1]['resolutions'] !=
                        "") {
                  resolutions =
                      _postsJson[_postsJson.length - index - 1]['resolutions'];
                }

                return Card(
                    shadowColor: Colors.black,
                    elevation: 10,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SingleVideoWidget(
                                singleVideoModel: SingleVideoModel(
                                    id,
                                    _postsJson,
                                    resolutions,
                                    name,
                                    videoLink,
                                    duration,
                                    desc,
                                    imgLink,
                                    widget.type))));
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
                                        placeholder: (context, url) =>
                                            const Image(
                                                image: AssetImage(
                                                    'images/Loading_icon.gif')),
                                        imageUrl: imgLink,
                                        fit: BoxFit.cover,
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        alignment: Alignment.topCenter,
                                        fadeInDuration:
                                            const Duration(milliseconds: 0),
                                        fadeOutDuration:
                                            const Duration(milliseconds: 0),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0, bottom: 6.0),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              constraints: const BoxConstraints(
                                                maxWidth: 300.0,
                                                minWidth: 30.0,
                                              ),
                                              child: Wrap(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                        doTimeFromString(
                                                                _savedPosition[
                                                                        id]
                                                                    .toString()) +
                                                            duration,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    name != ""
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 5, bottom: 5),
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  overflow: TextOverflow.clip,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    desc != ""
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, bottom: 5),
                                              child: Text(
                                                desc,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                )
                              ])),
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
