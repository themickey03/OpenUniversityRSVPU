import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
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
          systemOverlayStyle: const SystemUiOverlayStyle().copyWith(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor:
                  themeNotifier.isDark ? Colors.black : Colors.white),
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
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const Image(
                            image: AssetImage('images/Loading_icon.gif')),
                        imageUrl: singlePersonModelNew.imgLink,
                        fit: BoxFit.contain,
                        width: double.maxFinite,
                        height: double.maxFinite,
                        alignment: Alignment.topCenter,
                        fadeInDuration: const Duration(milliseconds: 0),
                        fadeOutDuration: const Duration(milliseconds: 0),
                      )),
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
                        fadeInDuration: const Duration(milliseconds: 0),
                        fadeOutDuration: const Duration(milliseconds: 0),
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
                  singlePersonModelNew.firstName != "" &&
                          singlePersonModelNew.middleName != "" &&
                          singlePersonModelNew.lastName != ""
                      ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${singlePersonModelNew.lastName} ${singlePersonModelNew.firstName} ${singlePersonModelNew.middleName}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ))
                      : Container(),
                  singlePersonModelNew.jobTitle != ""
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(TextSpan(
                                style: const TextStyle(
                                    fontSize: 15), //apply style to all
                                children: [
                                  const TextSpan(
                                      text: "Должность:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: " ${singlePersonModelNew.jobTitle}")
                                ])),
                          ))
                      : Container(),
                  singlePersonModelNew.academDegree != ""
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(TextSpan(
                                style: const TextStyle(
                                    fontSize: 15), //apply style to all
                                children: [
                                  const TextSpan(
                                      text: "Ученая степень:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          " ${singlePersonModelNew.academDegree}")
                                ])),
                          ))
                      : Container(),
                  singlePersonModelNew.academTitle != ""
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(TextSpan(
                                style: const TextStyle(
                                    fontSize: 15), //apply style to all
                                children: [
                                  const TextSpan(
                                      text: "Ученое звание:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          " ${singlePersonModelNew.academTitle}")
                                ])),
                          ))
                      : Container(),
                  singlePersonModelNew.awards != ""
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(TextSpan(
                                style: const TextStyle(
                                    fontSize: 15), //apply style to all
                                children: [
                                  const TextSpan(
                                      text: "Награды:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: " ${singlePersonModelNew.awards}")
                                ])),
                          ))
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
