import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/About/Contacts/SinglePersonModelNew.dart';
import 'package:open_university_rsvpu/About/Contacts/InterviewWidget.dart';

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
          title: Text(singlePersonModelNew.name),
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
                      child: Image.network(singlePersonModelNew.img_link,
                          color: Colors.black)),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter,
                        placeholder: 'images/Loading_icon.gif',
                        image: singlePersonModelNew.img_link != ""
                            ? singlePersonModelNew.img_link
                            : "http://koralex.fun:3000/_nuxt/assets/images/logo.png",
                        fit: BoxFit.contain,
                        width: double.maxFinite,
                        height: double.maxFinite,
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
                        singlePersonModelNew.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                  singlePersonModelNew.job_title != ""
                      ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            singlePersonModelNew.job_title,
                            style: const TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(),
                  singlePersonModelNew.prizes != ""
                      ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              singlePersonModelNew.prizes,
                              style: const TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container(),
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
                      // ? SelectableText.rich(TextSpan(
                      // style: Theme.of(context).textTheme.bodyMedium,
                      // children: [
                      //   const TextSpan(
                      //       text: "Интервью: \n",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           decoration: TextDecoration.underline)),
                      //   //TextSpan(text: singlePersonModelNew.interview)
                      //   Html(data: singlePersonModelNew.interview)
                      // ]))
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
