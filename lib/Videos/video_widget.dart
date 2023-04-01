import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/Videos/Lections/LectionsWidget.dart';
import 'package:open_university_rsvpu/Videos/Stories/StoriesWidget.dart';

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
            children: const [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Сюжеты',
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
            StoriesWidget(),
            LectionsWidget(),
          ],
        ),
      ),
    );
  }
}