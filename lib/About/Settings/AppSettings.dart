import 'package:flutter/material.dart';


class AppSettingsWidget extends StatefulWidget {
  const AppSettingsWidget({super.key});

  @override
  _AppSettingsWidgetState createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
        title: const Align(alignment: Alignment.centerLeft,child: Text("Настройки приложения", style: TextStyle(fontSize: 24))),
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          children: const [
            Text("App settings")
          ],
        ),
      ),
    );
  }
}