import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';

class AboutAppWidget extends StatefulWidget {
  const AboutAppWidget({super.key});

  @override
  State<AboutAppWidget> createState() => _AboutAppWidgetState();
}

class _AboutAppWidgetState extends State<AboutAppWidget> {

  String _versionNumber = "9.9.9";

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _versionNumber = packageInfo.version.toString();
      });
    });
  }
  @override
  void initState(){
    super.initState();
    getVersion();
  }
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
              child: Text("О приложении", style: TextStyle(fontSize: 24))),
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 80,
                child: Text(""),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 5.0, right: 5.0),
                      child: Image(
                        image: AssetImage('images/logo.png'),
                        width: 250,
                        height: 141,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Открытый университет РГППУ",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Приложение-компаньон для веб-ресурса",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 8.0, right: 8.0, bottom: 20.0),
                        child: Text(
                          "Версия: $_versionNumber - ${!kIsWeb ? Platform.isIOS ? "IOS" : "Android" : "Browser Version"}\nРоссийский Государственный Профессионально-Педагогический Университет\n2023 г.",
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
