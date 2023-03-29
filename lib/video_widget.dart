import 'package:flutter/material.dart';

class VideoWidget extends StatelessWidget {
  const VideoWidget();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Новости',
                  ),
                  Tab(
                    text: 'Лекции',
                  ),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VideoNewsPage(),
            VideoLecturePage(),
          ],
        ),
      ),
    );
  }
}

class VideoNewsPage extends StatefulWidget {
  @override
  _VideoNewsPageState createState() => _VideoNewsPageState();
}

class _VideoNewsPageState extends State<VideoNewsPage>
    with AutomaticKeepAliveClientMixin<VideoNewsPage> {
  final items = List<String>.generate(10, (i) => "Новостное видео № $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${items[index]}'),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}




class VideoLecturePage extends StatefulWidget {
  @override
  _VideoLecturePageState createState() => _VideoLecturePageState();
}

class _VideoLecturePageState extends State<VideoLecturePage>
    with AutomaticKeepAliveClientMixin<VideoLecturePage> {
  final items = List<String>.generate(10, (i) => "Видео лекция № $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${items[index]}'),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}