import 'package:flutter/material.dart';

class OneNews{
  final String title;
  final String description;
  final String imagelink;
  final String views;
  final String publish_date;

  OneNews(this.title, this.description, this.imagelink, this.publish_date, this.views);
}


class NewsItemWidget extends StatefulWidget {
  final OneNews oneNews;
  const NewsItemWidget({Key? key, required this.oneNews}) : super(key: key);

  @override
  _WithNewsItemWidgetState createState() => _WithNewsItemWidgetState();
}

class _WithNewsItemWidgetState extends State<NewsItemWidget>
    with AutomaticKeepAliveClientMixin<NewsItemWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.oneNews.title),
          SizedBox(
            width: 350,
            height: 196.88,
            child: Image.network(widget.oneNews.imagelink)
          ),
          Text("${widget.oneNews.description.substring(0, 75)}..."),
          Text("Просмотров: ${widget.oneNews.views}"),
          Text(widget.oneNews.publish_date)
        ],
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
}

