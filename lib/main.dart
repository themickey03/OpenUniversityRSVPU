import 'package:flutter/material.dart';
import 'main_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    Map<int, Color> mainBlueMapColor =
    {
      50:const Color.fromRGBO(34,76,164, .1),
      100:const Color.fromRGBO(34,76,164, .2),
      200:const Color.fromRGBO(34,76,164, .3),
      300:const Color.fromRGBO(34,76,164, .4),
      400:const Color.fromRGBO(34,76,164, .5),
      500:const Color.fromRGBO(34,76,164, .6),
      600:const Color.fromRGBO(34,76,164, .7),
      700:const Color.fromRGBO(34,76,164, .8),
      800:const Color.fromRGBO(34,76,164, .9),
      900:const Color.fromRGBO(34,76,164, 1),
    };
    MaterialColor mainBlue = MaterialColor(0xFF224CA4, mainBlueMapColor);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(secondary: mainBlue, primary: mainBlue)
      ),
      darkTheme: ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(secondary: mainBlue[900])
      ),
      debugShowCheckedModeBanner: false,
      home: const MainWidget(),
    );
  }
}