import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/Videos/Lections/LectionsWidget.dart';
import 'package:open_university_rsvpu/Videos/Stories/StoriesWidget.dart';

class VideoWidget extends StatelessWidget {
  const VideoWidget({super.key});

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