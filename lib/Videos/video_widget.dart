import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/Videos/Lections/LectionsWidget.dart';
import 'package:open_university_rsvpu/Videos/Stories/StoriesWidget.dart';



class VideoWidgetMain extends StatelessWidget {
  const VideoWidgetMain({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
          title: const Align(alignment: Alignment.centerLeft,child: Text("Видео", style: TextStyle(fontSize: 24))),
          elevation: 0,
        ),
      body: VideoWidget()
      );
  }
}



class VideoWidget extends StatelessWidget {
  const VideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Истории',
                  ),
                  Tab(
                    text: 'Лекции',
                  ),
                ],
                indicatorColor: Colors.blueAccent,
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StoriesWidget(),
            LectionsWidget(),
          ],
        ),
      ),
    );
  }
}