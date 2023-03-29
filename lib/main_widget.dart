import 'package:flutter/material.dart';
import 'news_widget.dart';
import 'video_widget.dart';


class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  _WithMainWidgetState createState() => _WithMainWidgetState();
}

class _WithMainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    NewsWidget(),
    VideoWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Открытый университет РГГПУ'),
        elevation: 0,
      ),
      body: IndexedStack(
        children: _pages,
        index: _selectedIndex,
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
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}