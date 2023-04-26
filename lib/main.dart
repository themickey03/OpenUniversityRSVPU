import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ModelTheme(),
        child: Consumer<ModelTheme>(
            builder: (context, ModelTheme themeNotifier, child) {
          Map<int, Color> mainBlueMapColor = {
            50: const Color.fromRGBO(34, 76, 164, .1),
            100: const Color.fromRGBO(34, 76, 164, .2),
            200: const Color.fromRGBO(34, 76, 164, .3),
            300: const Color.fromRGBO(34, 76, 164, .4),
            400: const Color.fromRGBO(34, 76, 164, .5),
            500: const Color.fromRGBO(34, 76, 164, .6),
            600: const Color.fromRGBO(34, 76, 164, .7),
            700: const Color.fromRGBO(34, 76, 164, .8),
            800: const Color.fromRGBO(34, 76, 164, .9),
            900: const Color.fromRGBO(34, 76, 164, 1),
          };
          MaterialColor mainBlue = MaterialColor(0xFF224CA4, mainBlueMapColor);
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru'),
            ],
            theme: themeNotifier.isDark
                ? ThemeData(
                    colorScheme: const ColorScheme.dark()
                        .copyWith(secondary: mainBlue[900]))
                : ThemeData(
                    colorScheme: const ColorScheme.light().copyWith(
                        secondary: mainBlue[900], primary: mainBlue[900])),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        }));
  }
}
