import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/News/SingleNewsModel.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';

class SingleNewsWidget extends StatelessWidget {
  final SingleNewsModel singleNewsModel;

  const SingleNewsWidget({Key? key, required this.singleNewsModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          foregroundColor: Colors.white,
          backgroundColor:
          !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
        ),
        body: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width -
                  10.0,
              height: (MediaQuery.of(context).size.width -
                  10.0) /
                  16 *
                  9,
              child: CachedNetworkImage(
                placeholder: (context, url) => const Image(image: AssetImage('images/Loading_icon.gif')),
                imageUrl: singleNewsModel.ImageUrl,
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.topCenter,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 8, right: 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child:
                    Text("Время публикации: ${singleNewsModel.publish_time}"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 10, right: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  singleNewsModel.name,
                  locale: const Locale("ru", "RU"),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(singleNewsModel.desc,
                  style: const TextStyle(fontSize: 16),
                  softWrap: true,
                  textAlign: TextAlign.justify),
            )
          ],
        ),
      );
    });
  }
}
