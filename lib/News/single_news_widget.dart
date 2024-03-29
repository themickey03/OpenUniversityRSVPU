import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/News/single_news_model.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:share_plus/share_plus.dart';

class SingleNewsWidgetNew extends StatelessWidget {
  final SingleNewsModelNew singleNewsModelNew;

  const SingleNewsWidgetNew({Key? key, required this.singleNewsModelNew})
      : super(key: key);

  void _onShare(context, shareText, shareSubject) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      shareText,
      subject: shareSubject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle().copyWith(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor:
                  themeNotifier.isDark ? Colors.black : Colors.white),
          title: const Text(
            "Новость",
            style: TextStyle(fontSize: 24),
          ),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  _onShare(
                      context,
                      "Новость РГППУ: ${singleNewsModelNew.linkToNews}",
                      "Новость РГППУ: ${singleNewsModelNew.linkToNews}");
                },
                child: const Icon(Icons.share),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 10.0,
              height: (MediaQuery.of(context).size.width - 10.0) / 16 * 9,
              child: CachedNetworkImage(
                placeholder: (context, url) =>
                    const Image(image: AssetImage('images/Loading_icon.gif')),
                imageUrl: singleNewsModelNew.imgLink,
                fit: BoxFit.fitHeight,
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.topCenter,
                fadeInDuration: const Duration(milliseconds: 0),
                fadeOutDuration: const Duration(milliseconds: 0),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text("Просмотров: ${singleNewsModelNew.views}",
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.left),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                          "Дата публикации: ${singleNewsModelNew.publishTime}",
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.right),
                    ),
                  ),
                ],
              ),
            ),
            singleNewsModelNew.name != ""
                ? Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 10, right: 5),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        singleNewsModelNew.name,
                        locale: const Locale("ru", "RU"),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
            singleNewsModelNew.subtitle != ""
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(singleNewsModelNew.subtitle,
                          style: const TextStyle(fontSize: 16),
                          softWrap: true,
                          textAlign: TextAlign.center),
                    ),
                  )
                : Container(),
            singleNewsModelNew.newsTags != ""
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(singleNewsModelNew.newsTags,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          softWrap: true,
                          textAlign: TextAlign.left),
                    ))
                : Container(),
            const Divider(),
            ListView.builder(
                itemCount: singleNewsModelNew.content.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (singleNewsModelNew.content[index]['tag'] == 'p') {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: singleNewsModelNew.content[index]["value"] != ""
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                              child: Text(
                                  singleNewsModelNew.content[index]["value"],
                                  style: const TextStyle(fontSize: 16),
                                  softWrap: true,
                                  textAlign: TextAlign.justify),
                            )
                          : Container(),
                    );
                  }
                  if (singleNewsModelNew.content[index]['tag'] == 'quote') {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                singleNewsModelNew.content[index]["value"]
                                            ["text"] !=
                                        ""
                                    ? Text(
                                        singleNewsModelNew.content[index]
                                            ["value"]["text"],
                                        style: const TextStyle(fontSize: 16),
                                        softWrap: true,
                                        textAlign: TextAlign.justify)
                                    : Container(),
                                singleNewsModelNew.content[index]["value"]
                                            ["name"] !=
                                        ""
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              "— ${singleNewsModelNew.content[index]["value"]["name"]}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              softWrap: true,
                                              textAlign: TextAlign.center),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  if (singleNewsModelNew.content[index]['tag'] == 'image') {
                    if (singleNewsModelNew.content[index]["value"] != "") {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 10.0,
                          height: (MediaQuery.of(context).size.width - 10.0) /
                              16 *
                              9,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => const Image(
                                image: AssetImage('images/Loading_icon.gif')),
                            imageUrl: singleNewsModelNew.content[index]
                                ["value"],
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                            height: double.maxFinite,
                            alignment: Alignment.topCenter,
                            fadeInDuration: const Duration(milliseconds: 0),
                            fadeOutDuration: const Duration(milliseconds: 0),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
                  return Container();
                }),
            SizedBox(
              height: 30,
              child: Container(),
            )
          ],
        ),
      );
    });
  }
}
