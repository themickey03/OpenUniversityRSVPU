import 'package:flutter/material.dart';


class AboutProjectWidget extends StatefulWidget {
  const AboutProjectWidget({super.key});

  @override
  _AboutProjectWidgetState createState() => _AboutProjectWidgetState();
}

class _AboutProjectWidgetState extends State<AboutProjectWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
        title: const Align(alignment: Alignment.centerLeft,child: Text("О проекте", style: TextStyle(fontSize: 24))),
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          children: const [
            Text("About project")
          ],
        ),
      ),
    );
  }
}