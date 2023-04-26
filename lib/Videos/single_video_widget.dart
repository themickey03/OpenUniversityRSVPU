import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'single_video_model.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';

class SingleVideoWidget extends StatefulWidget {
  final SingleVideoModel singleVideoModel;
  const SingleVideoWidget({Key? key, required this.singleVideoModel})
      : super(key: key);

  @override
  State<SingleVideoWidget> createState() => _SingleVideoWidgetState();
}

class _SingleVideoWidgetState extends State<SingleVideoWidget>
    with AutomaticKeepAliveClientMixin<SingleVideoWidget> {
  final GlobalKey _betterPlayerKey = GlobalKey();
  late int? _currentPosition;
  var _isVideoStorySaving = true;
  late int _savedPosition = 0;
  final _savedAnotherPosition = List.filled(999, 0);
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void initState() {
    super.initState();
    getData();
    Map<String, String> resolutions = {
      "1080p":
          "${widget.singleVideoModel.videoLink.substring(0, widget.singleVideoModel.videoLink.length - 4)}1080.mp4",
      "720p":
          "${widget.singleVideoModel.videoLink.substring(0, widget.singleVideoModel.videoLink.length - 4)}720.mp4",
      "480p":
          "${widget.singleVideoModel.videoLink.substring(0, widget.singleVideoModel.videoLink.length - 4)}480.mp4",
      "360p":
          "${widget.singleVideoModel.videoLink.substring(0, widget.singleVideoModel.videoLink.length - 4)}360.mp4",
    };

    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "${widget.singleVideoModel.videoLink.substring(0, widget.singleVideoModel.videoLink.length - 4)}1080.mp4",
      videoExtension: "mp4",
      resolutions: resolutions,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.singleVideoModel.name,
        author: "Открытый университет РГППУ",
        imageUrl: widget.singleVideoModel.imgLink,
        activityName: "MainActivity",
      ),
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 50000,
        maxBufferMs: 13107200,
        bufferForPlaybackMs: 2500,
        bufferForPlaybackAfterRebufferMs: 5000,
      ),
    );
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      controlsConfiguration: const BetterPlayerControlsConfiguration(
          enableSubtitles: false,
          enableAudioTracks: false,
          enableQualities: true,
          enablePlaybackSpeed: true,
          showControlsOnInitialize: false,
          enableOverflowMenu: true),
      translations: [
        BetterPlayerTranslations(
          languageCode: "ru",
          generalDefaultError: "Ошибка. Видео не может быть произведено",
          generalNone: "Ошибка :(",
          generalDefault: "Ошибка :(",
          generalRetry: "Повторить",
          playlistLoadingNextVideo: "Загружается следующее видео",
          controlsLive: "ПРЯМОЙ ЭФИР",
          controlsNextVideoIn: "Следующее видео",
          overflowMenuPlaybackSpeed: "Скорость видео",
          overflowMenuSubtitles: "Субтитры",
          overflowMenuQuality: "Качество видео",
        )
      ],
      autoPlay: true,
      looping: false,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
      ],
      allowedScreenSleep: false,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
        betterPlayerDataSource: _betterPlayerDataSource);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType.name == "initialized") {
        _betterPlayerController.play().then((_) => _betterPlayerController.seekTo(Duration(seconds: _savedPosition)).then((_) => {
          _betterPlayerController.play().then((_) => {
            _betterPlayerController.pause().then((_) => {
              _betterPlayerController.play()
            })
          })
        }));
      }
      if (event.betterPlayerEventType.name == "openFullscreen") {
        _betterPlayerController.setOverriddenFit(BoxFit.fitHeight);
      }
      if (event.betterPlayerEventType.name == "hideFullscreen") {
        _betterPlayerController.setOverriddenFit(BoxFit.fill);
      }
      if (event.betterPlayerEventType.name == "progress") {
        if (_isVideoStorySaving == true) {
          setState(() {
            _currentPosition = _betterPlayerController
                .videoPlayerController?.value.position.inSeconds;
            saveData(_currentPosition);
          });
        }
      }
    });
    _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
  }

  void saveData(data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        "${widget.singleVideoModel.typeOfVideo}_${widget.singleVideoModel.id.toString()}",
        data);
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt(
              "${widget.singleVideoModel.typeOfVideo}_${widget.singleVideoModel.id.toString()}") !=
          null) {
        _savedPosition = prefs.getInt(
            "${widget.singleVideoModel.typeOfVideo}_${widget.singleVideoModel.id.toString()}")!;
      }
      if (prefs.getBool("VideoWatchedSaving") != null) {
        _isVideoStorySaving = prefs.getBool("VideoWatchedSaving")!;
      }
    });
  }
  void getAnotherData(id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt("${widget.singleVideoModel.typeOfVideo}_${id.toString()}") != null) {
        _savedAnotherPosition[id] = prefs.getInt("${widget.singleVideoModel.typeOfVideo}_${id.toString()}")!;
      } else {
        _savedAnotherPosition[id] = 0;
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
    if (_isVideoStorySaving == false) {
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
      _betterPlayerController.setBetterPlayerControlsConfiguration(
          BetterPlayerControlsConfiguration(
              enableSubtitles: false,
              enableAudioTracks: false,
              enableQualities: true,
              enablePlaybackSpeed: true,
              showControlsOnInitialize: false,
              enableOverflowMenu: true,
              overflowMenuIconsColor:
                  !themeNotifier.isDark ? Colors.black : Colors.white,
              overflowModalColor: !themeNotifier.isDark
                  ? Colors.white
                  : ThemeData.dark().primaryColor,
              overflowModalTextColor:
                  !themeNotifier.isDark ? Colors.black : Colors.white));
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle()
              .copyWith(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: themeNotifier.isDark
                  ? Colors.black
                  : Colors.white),
          title: const Text("Видео"),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              kIsWeb
                  ? Container(
                      height: 300,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.red,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Тут находится видео",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 16 * 9,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: BetterPlayer(
                          controller: _betterPlayerController,
                          key: _betterPlayerKey,
                        ),
                      )),
              Expanded(
                child: ListView(
                  children: [
                    widget.singleVideoModel.name != ""
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, right: 10.0, left: 10.0),
                            child: Text(
                              widget.singleVideoModel.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    widget.singleVideoModel.desc != ""
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, right: 10.0, left: 10.0),
                              child: Text(
                                widget.singleVideoModel.desc,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, right: 10.0, left: 10.0, bottom: 10.0),
                        child: Text(
                          widget.singleVideoModel.typeOfVideo == "lections"
                              ? 'Еще из раздела "Лекции": '
                              : 'Еще из раздела "Истории": ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    ListView.builder(
                        itemCount: widget.singleVideoModel.dataOfVideo.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {

                          if (widget.singleVideoModel.dataOfVideo[index]
                                  ['id'] !=
                              widget.singleVideoModel.id) {
                            var id = 0;
                            if (widget.singleVideoModel.dataOfVideo[index]
                                        ['id'] !=
                                    "" &&
                                widget.singleVideoModel.dataOfVideo[index]
                                        ['id'] !=
                                    null) {
                              id = widget.singleVideoModel.dataOfVideo[index]
                                  ['id'];
                            }
                            getAnotherData(id);
                            var name = "";
                            if (widget.singleVideoModel.dataOfVideo[index]
                                        ['title'] !=
                                    "" &&
                                widget.singleVideoModel.dataOfVideo[index]
                                        ['title'] !=
                                    null) {
                              name = widget.singleVideoModel.dataOfVideo[index]
                                  ['title'];
                            }
                            var mainDesc = <String, dynamic>{};
                            if (widget.singleVideoModel.dataOfVideo[index]
                                    ['description'] !=
                                null) {
                              mainDesc = widget.singleVideoModel
                                  .dataOfVideo[index]['description'];
                            }
                            var imgLink = "";
                            if (widget.singleVideoModel.dataOfVideo[index]
                                        ['img'] !=
                                    "" &&
                                widget.singleVideoModel.dataOfVideo[index]
                                        ['img'] !=
                                    null) {
                              if (widget.singleVideoModel.dataOfVideo[index]
                                          ['img']['id'] !=
                                      "" &&
                                  widget.singleVideoModel.dataOfVideo[index]
                                          ['img']['id'] !=
                                      null) {
                                if (widget.singleVideoModel.dataOfVideo[index]
                                            ['img']['format'] !=
                                        "" &&
                                    widget.singleVideoModel.dataOfVideo[index]
                                            ['img']['format'] !=
                                        null) {
                                  if (kIsWeb) {
                                    imgLink =
                                        "https://koralex.fun/news_api/buffer.php?type=image&link=http://api.bytezone.online/imgs/${widget.singleVideoModel.dataOfVideo[index]["img"]["id"]}.${widget.singleVideoModel.dataOfVideo[index]["img"]["format"]}";
                                  } else {
                                    imgLink =
                                        "http://api.bytezone.online/imgs/${widget.singleVideoModel.dataOfVideo[index]["img"]["id"]}.${widget.singleVideoModel.dataOfVideo[index]["img"]["format"]}";
                                  }
                                }
                              }
                            }
                            var duration = "";
                            if (widget.singleVideoModel.dataOfVideo[index]
                                        ['duration'] !=
                                    "" &&
                                widget.singleVideoModel.dataOfVideo[index]
                                        ['duration'] !=
                                    null) {
                              duration = widget.singleVideoModel
                                  .dataOfVideo[index]['duration'];
                            }
                            var desc = "";
                            if (mainDesc['Описание'] != "" &&
                                mainDesc['Описание'] != null) {
                              desc = mainDesc['Описание'];
                            }
                            var videoLink = "";
                            if (widget.singleVideoModel.dataOfVideo[index]
                                        ['path'] !=
                                    "" &&
                                widget.singleVideoModel.dataOfVideo[index]
                                        ['path'] !=
                                    null) {
                              if (kIsWeb) {
                                videoLink =
                                    "https://koralex.fun/news_api/buffer.php?type=video&link=${widget.singleVideoModel.dataOfVideo[index]['path']}";
                              } else {
                                videoLink = widget.singleVideoModel
                                    .dataOfVideo[index]['path'];
                              }
                            }
                            return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return SingleVideoWidget(
                                        singleVideoModel: SingleVideoModel(
                                            id,
                                            widget.singleVideoModel.dataOfVideo,
                                            name,
                                            videoLink,
                                            duration,
                                            desc,
                                            imgLink,
                                            widget
                                                .singleVideoModel.typeOfVideo));
                                  }));
                                },
                                child: Card(
                                  shadowColor: Colors.black,
                                  elevation: 20,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  10.0,
                                              height: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      10.0) /
                                                  16 *
                                                  9,
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    placeholder: (context,
                                                            url) =>
                                                        const Image(
                                                            image: AssetImage(
                                                                'images/Loading_icon.gif')),
                                                    imageUrl: imgLink,
                                                    fit: BoxFit.cover,
                                                    width: double.maxFinite,
                                                    height: double.maxFinite,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    fadeInDuration:
                                                        const Duration(
                                                            milliseconds: 0),
                                                    fadeOutDuration:
                                                        const Duration(
                                                            milliseconds: 0),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0,
                                                              bottom: 6.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.7),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          constraints:
                                                              const BoxConstraints(
                                                            maxWidth: 300.0,
                                                            minWidth: 30.0,
                                                          ),
                                                          child: Wrap(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Text(
                                                                    doTimeFromString(_savedAnotherPosition[id]
                                                                            .toString()) +
                                                                        duration,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                name != ""
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Text(
                                                            name,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                desc != ""
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8,
                                                                  bottom: 5),
                                                          child: Text(
                                                            desc,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
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
                          } else {
                            return Container();
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// children: [
// ListTile(
// shape: RoundedRectangleBorder(
// side: const BorderSide(width: 1, color: Colors.grey),
// borderRadius: (BorderRadius.circular(10))
// ),
// visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
// title: name != "" ? Text(name, style: const TextStyle(fontWeight: FontWeight.bold)) : Container(),
// subtitle: desc != "" ? Text(desc, overflow: TextOverflow.ellipsis) : Container(),
// trailing: SizedBox(
// height: 55,
// width: 97,
// child: CachedNetworkImage(
// placeholder: (context, url) =>
// const Image(image: AssetImage('images/Loading_icon.gif')),
// imageUrl: imgLink,
// fit: BoxFit.fitHeight,
// width: double.maxFinite,
// height: double.maxFinite,
// alignment: Alignment.topCenter,
// fadeInDuration: const Duration(milliseconds: 0),
// fadeOutDuration: const Duration(milliseconds: 0),
// ),
// )
// )
// ],
// ),
// )
