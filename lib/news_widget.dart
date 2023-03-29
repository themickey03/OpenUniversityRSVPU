import 'package:flutter/material.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  _WithNewsWidgetState createState() => _WithNewsWidgetState();
}

class _WithNewsWidgetState extends State<NewsWidget>
    with AutomaticKeepAliveClientMixin<NewsWidget> {
  final items = List<String>.generate(10, (i) => "Новость № $i");

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