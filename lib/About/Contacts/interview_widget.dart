import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class InterviewWidget extends StatefulWidget {
  final String data;
  const InterviewWidget({super.key, required this.data});

  @override
  State<InterviewWidget> createState() => _InterviewWidgetState();
}

class _InterviewWidgetState extends State<InterviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle()
              .copyWith(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: themeNotifier.isDark
                  ? Colors.black
                  : Colors.white),
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
                  ? HtmlWidget(widget.data)
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HtmlWidget(widget.data))
            ],
          ),
        ),
      );
    });
  }
}
