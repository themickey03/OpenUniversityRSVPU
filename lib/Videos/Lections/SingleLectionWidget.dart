import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SingleLectionModel.dart';



class SingleLectionWidget extends StatefulWidget {
  final SingleLectionModel singleLectionModel;
  const SingleLectionWidget({Key? key, required this.singleLectionModel}) : super(key: key);

  @override
  _SingleLectionWidgetState createState() => _SingleLectionWidgetState();
}

class _SingleLectionWidgetState extends State<SingleLectionWidget>
    with AutomaticKeepAliveClientMixin<SingleLectionWidget> {

  late GlobalKey _betterPlayerKey = GlobalKey();
  late int? _currentPosition;
  late int _savedPosition = 1;
  late BetterPlayerController _betterPlayerController;
  void initState(){
    super.initState();
    getData();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.singleLectionModel.video_link,
    );
    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSubtitles: false,
          enableAudioTracks: false,
          enableQualities: false,
          enablePlaybackSpeed: false,
      ),
      autoPlay: false,
      looping: false,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
      allowedScreenSleep: false,
    );

    _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource);
    _betterPlayerController.addEventsListener((event){
      if (event.betterPlayerEventType.name == "initialized"){
        _betterPlayerController.seekTo(Duration(seconds: _savedPosition));
      }
      if (event.betterPlayerEventType.name == "openFullscreen") {
        _betterPlayerController.setOverriddenFit(BoxFit.fitHeight);
      }
      if (event.betterPlayerEventType.name == "hideFullscreen"){
        _betterPlayerController.setOverriddenFit(BoxFit.fill);
      }
      if (event.betterPlayerEventType.name == "progress"){
        setState(() {
          _currentPosition = _betterPlayerController.videoPlayerController?.value.position.inSeconds;
          saveData(_currentPosition);

        });
      }
    });
    _betterPlayerController.enablePictureInPicture(_betterPlayerKey);

  }

  void saveData(data) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.singleLectionModel.id.toString(), data);
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPosition = prefs.getInt(widget.singleLectionModel.id.toString())!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 16 * 9,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(
                    controller: _betterPlayerController,
                    key: _betterPlayerKey,
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                child: Text(widget.singleLectionModel.name, style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                  child: Text(widget.singleLectionModel.desc, style: const TextStyle(
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
  }

  @override
  bool get wantKeepAlive => true;
}