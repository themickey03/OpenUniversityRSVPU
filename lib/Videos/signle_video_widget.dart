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
      widget.singleVideoModel.videoLink,
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
        _betterPlayerController.seekTo(Duration(seconds: _savedPosition));
        _betterPlayerController.play();
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
        "${widget.singleVideoModel.typeOfVideo}_${widget.singleVideoModel.id.toString()}", data);
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt("${widget.singleVideoModel.typeOfVideo}_${widget.singleVideoModel.id.toString()}") !=
          null) {
        _savedPosition = prefs
            .getInt("${widget.singleVideoModel.typeOfVideo}_${widget.singleVideoModel.id.toString()}")!;
      }
      if (prefs.getBool("VideoWatchedSaving") != null) {
        _isVideoStorySaving = prefs.getBool("VideoWatchedSaving")!;
      }
    });
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
              Padding(
                padding:
                    const EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                child: Text(
                  widget.singleVideoModel.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                  child: Text(
                    widget.singleVideoModel.desc,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
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
