import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:open_university_rsvpu/WelcomePage/welcome_page.dart';
import 'package:open_university_rsvpu/main_widget.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var _isFirstStart = true;
  void getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getKeys().contains("isFirstStart")) {
        _isFirstStart = prefs.getBool("isFirstStart")!;
      } else {
        prefs.setBool("isFirstStart", true);
      }
    });
  }

  @override
  void initState(){
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return AnimatedSplashScreen(
        splash: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          height: MediaQuery.of(context).size.height - 200,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('images/Logo.png'),
              ),
              const Align(
                  alignment: Alignment.center,
                  child: Text("Открытый университет РГППУ",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center))
            ],
          ),
        ),
        splashIconSize: 200,
        duration: 2000,
        nextScreen: _isFirstStart == true ? const WelcomePage() : const MainWidget(),
        centered: true,
        backgroundColor: !themeNotifier.isDark
            ? Colors.white
            : ThemeData.dark().primaryColor,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      );
    });
  }
}
