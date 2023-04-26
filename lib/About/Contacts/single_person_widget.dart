import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/About/Contacts/single_person_model.dart';
import 'package:open_university_rsvpu/About/Contacts/interview_widget.dart';

class SinglePersonWidget extends StatelessWidget {
  final SinglePersonModelNew singlePersonModelNew;

  const SinglePersonWidget({Key? key, required this.singlePersonModelNew})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
        ),
        body: ListView(
          children: [
            Container(
              height: 300,
              width: 150,
              margin: const EdgeInsets.only(bottom: 5.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0)),
              ),
              child: SizedBox(
                width: 100,
                height: 150,
                child: Stack(alignment: Alignment.center, children: [
                  Opacity(
                      opacity: 0.3,
                      child: Image.network(singlePersonModelNew.imgLink,
                          color: Colors.black)),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const Image(
                            image: AssetImage('images/Loading_icon.gif')),
                        imageUrl: singlePersonModelNew.imgLink,
                        fit: BoxFit.contain,
                        width: double.maxFinite,
                        height: double.maxFinite,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        singlePersonModelNew.name
                            .replaceAll(r"/n", " ")
                            .replaceAll(r"\n", " "),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                  ListView.builder(
                      itemCount: singlePersonModelNew.description.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text.rich(TextSpan(
                                  style: const TextStyle(
                                      fontSize: 15), //apply style to all
                                  children: [
                                    TextSpan(
                                        text:
                                            "${singlePersonModelNew.description.keys.elementAt(index).replaceAll(r"/n", " ").replaceAll(r"\n", " ")}:",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            " ${singlePersonModelNew.description.values.elementAt(index).replaceAll(r"/n", " ").replaceAll(r"\n", " ")}")
                                  ])),
                            ));
                      }),
                  singlePersonModelNew.interview != ""
                      ? Column(
                          children: [
                            const Divider(),
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => InterviewWidget(
                                        data: singlePersonModelNew.interview)));
                              },
                              visualDensity: const VisualDensity(
                                  vertical: -4, horizontal: -4),
                              title: Row(
                                children: const [
                                  Icon(Icons.textsms, size: 15.0),
                                  Expanded(
                                    child: Text("    Интервью",
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 15.0),
                            ),
                            const Divider()
                          ],
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
