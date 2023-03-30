import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/ContactWidget.dart';
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
    ContactWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String setTitleFromId(int index){
    String result = 'Открытый университет РГППУ';
    switch (index) {
      case 0:
        result = "Новости";
        break;
      case 1:
        result = "Видео";
        break;
      case 2:
        result = "Контакты";
        break;
      default:
        result = "Открытый университет РГППУ";
        break;
    }
    return result;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(setTitleFromId(_selectedIndex)),
          ],
        ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Контакты',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}