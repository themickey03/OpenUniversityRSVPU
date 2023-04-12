import 'dart:convert';
import 'dart:io';
import 'package:byte_converter/byte_converter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/Videos/Stories/SingleStorieModel.dart';
import 'package:open_university_rsvpu/Videos/Stories/SingleStorieWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class StoriesWidget extends StatefulWidget {
  @override
  _StoriesWidgetState createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget>
    with AutomaticKeepAliveClientMixin<StoriesWidget> {
  final url = "http://api.bytezone.online/stories";
  var _postsJson = [];
  var _tempPath = "";
  var _indexOfDownloadingVideo = 0;
  var _isDownloadingNow = false;
  var _savedPosition = List.filled(999, 0);
  var _isVideoStorySaved = true;
  var _isVideoDownloaded = List.filled(999, false);
  var _textOnDownloadedPlaceHolder = List.filled(999, "");
  var _pathToSavedVideo = List.filled(999, "");
  var _fileSizeList = List.filled(999, "");
  var cancelToken = List.filled(999, CancelToken());

  void fetchDataPersons() async {
    final prefs = await SharedPreferences.getInstance();
    Directory tempDir = await getApplicationDocumentsDirectory();
    _tempPath = tempDir.path;
    final list = prefs
        .getKeys()
        .where((String key) =>
            key.toString().toLowerCase().contains("stories_downloaded"))
        .toList();
    for (int i = 0; i < list.length; i++) {
      var number = int.parse(list[i].split("stories_downloaded_")[1]);
      _isVideoDownloaded[number] = true;
    }
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
        if (prefs.containsKey("stories_output")) {
          _postsJson = json.decode(prefs.getString("stories_output")!);
        }
        if (_savedPosition.isEmpty) {
          _savedPosition = List.filled(_postsJson.length + 1, 0);
        }
      });
    }

    for (int i=0; i < _postsJson.length; i++){
      print("path: ${_postsJson[i]['path']}");
      final r = await head(Uri.parse("${_postsJson[i]['path']}"));
      final fileSize = r.headers["content-length"];
      print("fileSize: $fileSize");
      setState(() {
        print(ByteConverter.fromBytes(int.parse(fileSize ?? "0").toDouble()).megaBytes.round());
        _fileSizeList[i] = ByteConverter.fromBytes(int.parse(fileSize ?? "0").toDouble()).megaBytes.round().toString();
      });

    }

  }

  @override
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

  void DownloadFunction(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("saved: ${"stories_downloaded_${index}"}");
    prefs.setBool("stories_downloaded_${index}", true);
    setState(() {
      _isVideoDownloaded[index] = true;
      _pathToSavedVideo[index] = "$_tempPath/${_postsJson[index]['id']}.mp4";
      if (File(_pathToSavedVideo[index]).existsSync()) {
        _textOnDownloadedPlaceHolder[0] = "Загружено в память телефона";
      } else {
        _isDownloadingNow = true;
        download(_postsJson[index]['path'], "stories_${_postsJson[index]['id']}.mp4",
            "$_tempPath/${_postsJson[index]['id']}.mp4", index);
      }
    });
  }

  void DeleteFile(int index) async {
    _textOnDownloadedPlaceHolder[index] = "";
    _isVideoDownloaded[index] = false;
    _pathToSavedVideo[index] = "$_tempPath/${_postsJson[index]['id']}.mp4";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("stories_downloaded_${index}");
    if (File("$_tempPath/${_postsJson[index]['id']}.mp4").existsSync()) {
      File("$_tempPath/${_postsJson[index]['id']}.mp4").delete();
    } else {
      cancelToken[index].cancel();
    }
  }

  Future download(
      String url, String filename, String savePath, int index) async {
    var dio = Dio();
    _indexOfDownloadingVideo = index;
    print("Global var: $_indexOfDownloadingVideo");
    try {
      var response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        cancelToken: cancelToken[index],
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 1),
        ),
      );
      var file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        if (received == total) {
          _textOnDownloadedPlaceHolder[_indexOfDownloadingVideo] =
              "Загружено в память телефона";
        } else {
          _textOnDownloadedPlaceHolder[_indexOfDownloadingVideo] =
              "Загружено: ${(received / total * 100).toStringAsFixed(0) + '%, Скачано: ' + (ByteConverter.fromBytes(received.toDouble()).megaBytes.toInt()).toString() + ' Мб из ' + (ByteConverter.fromBytes(total.toDouble()).megaBytes.toInt()).toString() + ' Мб'}";
        }
      });
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
                if (_isVideoDownloaded[index] == true) {
                  if (File("$_tempPath/${_postsJson[index]['id']}.mp4")
                      .existsSync()) {
                    _isDownloadingNow = false;
                    _textOnDownloadedPlaceHolder[index] =
                        "Видео загружено в память телефона";
                    _pathToSavedVideo[index] =
                        "$_tempPath/${_postsJson[index]['id']}.mp4";
                  } else {
                    if (_isDownloadingNow != true) {
                      _isVideoDownloaded[index] = false;
                    }
                  }
                }
                return Card(
                    shadowColor: Colors.black,
                    elevation: 20,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SingleLectionWidget(
                                path: _pathToSavedVideo[index],
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
                                        placeholder: (context, url) =>
                                            const Image(
                                                image: AssetImage(
                                                    'images/Loading_icon.gif')),
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
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
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
                                        ),
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
                                            : Container(),
                                        _isVideoDownloaded[index] != false
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, bottom: 5),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    _textOnDownloadedPlaceHolder[
                                                        index],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child:
                                            _isVideoDownloaded[index] == false
                                                ? PopupMenuButton<String>(
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem<String>(
                                                          child: Text(
                                                            'Скачать',
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                          onTap: () {
                                                            _isDownloadingNow == true
                                                                ?
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 0),
                                                                    () =>
                                                                    showDialog(
                                                                        context:
                                                                        context,
                                                                        builder: (context) =>
                                                                            AlertDialog(
                                                                              title: const Text('Внимание!'),
                                                                              content: const Text('Происходит загрузка другого видео. Подождите, пока оно загрузится.'),
                                                                              actions: <Widget>[
                                                                                MaterialButton(
                                                                                  child: const Text('ОК'),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            )))
                                                            : Future.delayed(
                                                                const Duration(
                                                                    seconds: 0),
                                                                    () =>
                                                                    showDialog(
                                                                        context:
                                                                        context,
                                                                        builder: (context) =>
                                                                            AlertDialog(
                                                                              title: const Text('Внимание!'),
                                                                              content: Text('Вес файла: ${_fileSizeList[index]} Мегабайт.\nУбедитесь, что у Вас достаточно места для скачивания.'),
                                                                              actions: <Widget>[
                                                                                MaterialButton(
                                                                                  child: const Text('Скачать'),
                                                                                  onPressed: () {
                                                                                    DownloadFunction(index);
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                                MaterialButton(
                                                                                  child: const Text('Не скачивать'),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                )
                                                                              ],
                                                                            )));
                                                          }),
                                                    ],
                                                  )
                                                : PopupMenuButton<String>(
                                                    onSelected: (_) =>
                                                        DeleteFile(index),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem<String>(
                                                          value: "delete",
                                                          child: File(_pathToSavedVideo[
                                                                          index])
                                                                      .existsSync() ==
                                                                  true
                                                              ? const Text(
                                                                  'Удалить',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .redAccent,
                                                                      fontSize:
                                                                          16))
                                                              : const Text(
                                                                  'Остановить загрузку',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .redAccent,
                                                                      fontSize:
                                                                          16))),
                                                    ],
                                                  )),
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

//getApplicationDocumentsDirectory()
