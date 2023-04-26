import 'package:flutter/material.dart';
import 'News/news_widget_new.dart';
import 'Videos/VideoWidget.dart';
import 'About/AboutWidget.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _WithMainWidgetState();
}

class _WithMainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    NewsWidgetNew(),
    VideoWidgetMain(),
    AboutWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Видео',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'О нас',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
