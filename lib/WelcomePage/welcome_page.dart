import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/main_widget.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<Widget> _slides = [];
  double currentPage = 0.0;
  final _pageViewController = PageController();
  List<Widget> indicator() => List<Widget>.generate(
      _slides.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? Color(Colors.grey.value)
                    : Color(Colors.grey.value).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page!;
      });
    });
  }

  void setInfo(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstStart", value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      _slides = items
          .map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: item['image'] == "images/Logo.png"
                          ? Image.asset(
                              item['image'],
                              fit: BoxFit.fitWidth,
                              width: 175.0,
                              alignment: Alignment.center,
                            )
                          : Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 30.0,
                                    blurStyle: BlurStyle.normal)
                              ]),
                              child: Image.asset(
                                item['image'],
                                fit: BoxFit.fitWidth,
                                width: 200.0,
                                alignment: Alignment.center,
                              ),
                            ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 10, left: 5, right: 5),
                      child: Column(
                        children: <Widget>[
                          Text(item['header'],
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                height: 1,
                                color: themeNotifier.isDark == true
                                    ? Colors.white
                                    : Colors.black,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              item['description'],
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: themeNotifier.isDark == true
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  item['last_page'] == "true"
                      ? Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: MaterialButton(
                              color: const Color.fromRGBO(34, 76, 164, 1),
                              textColor: Color(Colors.white.value),
                              onPressed: () {
                                setState(() {
                                  setInfo(false);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const MainWidget();
                                  }));
                                });
                              },
                              child: const Text(
                                "Начать!",
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ),
                        )
                      : Flexible(
                          flex: 0,
                          fit: FlexFit.loose,
                          child: Container(
                            height: 0,
                          ),
                        )
                ],
              )))
          .toList();
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle().copyWith(
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor:
                    themeNotifier.isDark ? Colors.black : Colors.white),
            foregroundColor: Colors.white,
            backgroundColor: !themeNotifier.isDark
                ? ThemeData.light().scaffoldBackgroundColor
                : ThemeData.dark().scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Stack(
            children: <Widget>[
              PageView.builder(
                controller: _pageViewController,
                itemCount: _slides.length,
                itemBuilder: (BuildContext context, int index) {
                  return _slides[index];
                },
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 70.0),
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicator(),
                    ),
                  ))
            ],
          ));
    });
  }
}
