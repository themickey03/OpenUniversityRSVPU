import 'package:flutter/material.dart';

class LectionsWidget extends StatefulWidget {
  @override
  _LectionsWidgetState createState() => _LectionsWidgetState();
}

class _LectionsWidgetState extends State<LectionsWidget>
    with AutomaticKeepAliveClientMixin<LectionsWidget> {
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