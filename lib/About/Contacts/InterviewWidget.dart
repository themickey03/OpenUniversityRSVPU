import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:flutter_html/flutter_html.dart';

class InterviewWidget extends StatefulWidget {
  final String data;
  const InterviewWidget({super.key, required this.data});

  @override
  _InterviewWidgetState createState() => _InterviewWidgetState();
}

class _InterviewWidgetState extends State<InterviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
          title: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Интервью", style: TextStyle(fontSize: 24))),
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            children: [
              kIsWeb
                  ? Html(
                    data: widget.data
                  )
                  : Html(data: widget.data, style: {
                      "H1": Style(
                          fontSize: Platform.isIOS == true
                              ? FontSize(30)
                              : FontSize(20),
                          textAlign: TextAlign.center,
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 5.0, right: 5.0, bottom: 20.0)),
                      "H2": Style(
                          fontSize: Platform.isIOS == true
                              ? FontSize(26)
                              : FontSize(16),
                          padding:
                              const EdgeInsets.only(left: 5.0, right: 5.0)),
                      "p": Style(
                          fontSize: Platform.isIOS == true
                              ? FontSize(26)
                              : FontSize(16),
                          padding:
                              const EdgeInsets.only(left: 5.0, right: 5.0)),
                    })
            ],
          ),
        ),
      );
    });
  }
}
