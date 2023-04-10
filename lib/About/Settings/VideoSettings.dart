import 'package:flutter/material.dart';


class VideoSettingsWidget extends StatefulWidget {
  const VideoSettingsWidget({super.key});

  @override
  _VideoSettingsWidgetState createState() => _VideoSettingsWidgetState();
}

class _VideoSettingsWidgetState extends State<VideoSettingsWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
        title: const Align(alignment: Alignment.centerLeft,child: Text("Настройки видео", style: TextStyle(fontSize: 24))),
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          children: const [
            Text("video settings")
          ],
        ),
      ),
    );
  }
}