import 'package:flutter/material.dart';

class ContactWidget extends StatefulWidget {
  const ContactWidget({Key? key}) : super(key: key);

  @override
  _WithContactWidgetState createState() => _WithContactWidgetState();
}

class _WithContactWidgetState extends State<ContactWidget>
    with AutomaticKeepAliveClientMixin<ContactWidget> {
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