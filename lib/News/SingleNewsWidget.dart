import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/News/SingleNewsModel.dart';

class SingleNewsWidget extends StatelessWidget {
  final SingleNewsModel singleNewsModel;

  const SingleNewsWidget({Key? key, required this.singleNewsModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(""),),
      body: ListView(
        children: [
          Image.network(singleNewsModel.ImageUrl),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 8, right: 10.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("Время публикации: ${singleNewsModel.publish_time}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 10, right: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(singleNewsModel.name,
                locale: const Locale("ru", "RU"),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                softWrap: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(singleNewsModel.desc, style: TextStyle(fontSize: 16), softWrap: true, textAlign: TextAlign.justify),
          )
        ],
      ),
    );
  }
}