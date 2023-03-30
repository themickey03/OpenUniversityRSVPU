import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:ui' as ui;

class TextWithHyphenation extends StatelessWidget {
  const TextWithHyphenation(
      this.data, {
        Key? key,
        this.style,
      }) : super(key: key);

  final String data;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final String text = data;
      final span = TextSpan(text: text, style: style);
      final textPainter = TextPainter(
          text: span, maxLines: 2, textDirection: ui.TextDirection.ltr)
        ..layout(maxWidth: size.maxWidth);

      final TextSelection selection =
      TextSelection(baseOffset: 0, extentOffset: text.length);
      final List<TextBox> boxes = textPainter.getBoxesForSelection(selection);
      final int lines = boxes.length;
      if (lines > 1) {
        return Text(text.replaceFirst('\u00ad', '\u00ad-'), style: style);
      } else {
        return Text(text, style: style);
      }
    });
  }
}



class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);


  @override
  _WithNewsWidgetState createState() => _WithNewsWidgetState();
}

class _WithNewsWidgetState extends State<NewsWidget>
    with AutomaticKeepAliveClientMixin<NewsWidget> {

  final url = "http://45.8.147.95:3333/news";

  var _postsJson = [];
  void fetchDataNews() async{

    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postsJson = jsonData;
      });
    } catch (err){
      print(err);
    }
  }

  @override
  initState() {
    super.initState();
    fetchDataNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: _postsJson.length,
          itemBuilder: (context, index) {

            var title = "";
            if (_postsJson[index]["title"] != null) {
              title = _postsJson[index]["title"];
            }
            var description = "";
            if (_postsJson[index]["description"] != null) {
              description = _postsJson[index]["description"];
            }
            var imagelink = "https://cdn-icons-png.flaticon.com/512/3858/3858629.png";
            if (_postsJson[index]["img"]["id"] != null && _postsJson[index]["img"]["format"] != null) {
              imagelink = "http://45.8.147.95:3333/imgs/${_postsJson[index]["img"]["id"]}.${_postsJson[index]["img"]["format"]}";
            }
            var publish_date = "";
            if (_postsJson[index]["date"] != null) {
              publish_date = _postsJson[index]["date"];
            }
            var views = "0";
            if (_postsJson[index]["views"] != null) {
              views = _postsJson[index]["views"].toString();
            }
            var truePublishDate = "";
            var dt = DateTime.parse(publish_date);
            try{
              truePublishDate = DateFormat('dd.MM.yyyy в kk:mm').format(dt);
            }
            catch (err){
              truePublishDate = publish_date;
            }
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                  shadowColor: Colors.black,
                  elevation: 20,
                  child: SizedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width-10.0,
                            height: (MediaQuery.of(context).size.width-10.0)/16*9,
                            child: FadeInImage.assetNetwork(
                              alignment: Alignment.topCenter,
                              placeholder: 'images/Loading_icon.gif',
                              image: imagelink,
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                              height: double.maxFinite,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                            child: TextWithHyphenation("${title}", style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                            child: TextWithHyphenation("${description}",
                              style: const TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                            child: Row(
                              children: [
                                Text("Просмотров: ${views}",style: TextStyle(
                                    color: Colors.grey
                                )
                                ),
                                Spacer(),
                                Text(truePublishDate, style: TextStyle(
                                    color: Colors.grey
                                )),
                              ],
                            ),
                          )
                        ],
                      )
                  )
              ),
            );
          }

        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}