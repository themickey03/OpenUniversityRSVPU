import 'package:flutter/material.dart';


class AboutAppWidget extends StatefulWidget {
  const AboutAppWidget({super.key});

  @override
  _AboutAppWidgetState createState() => _AboutAppWidgetState();
}

class _AboutAppWidgetState extends State<AboutAppWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
        title: const Align(alignment: Alignment.centerLeft,child: Text("О приложении", style: TextStyle(fontSize: 24))),
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          children: const [
            Text("About app")
          ],
        ),
      ),
    );
  }
}