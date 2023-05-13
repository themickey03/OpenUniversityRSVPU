import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  var _isVideoWatchedSaving = true;
  var _newsSubscription = true;
  var _videoSubscription = true;
  var _preffedScreenForOpen = 0;

  String _versionNumber = "9.9.9";

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _versionNumber = packageInfo.version.toString();
      });
    });
  }

  void getUserTagsFromOneSignal() {
    OneSignal.shared.getTags().then((tags) {
      if (tags['video'] == "True") {
        setState(() {
          _videoSubscription = true;
        });
      } else {
        setState(() {
          _videoSubscription = false;
        });
      }
      if (tags['news'] == "True") {
        setState(() {
          _newsSubscription = true;
        });
      } else {
        setState(() {
          _newsSubscription = false;
        });
      }
      setSettings("videoSubscription", _videoSubscription);
      setSettings("newsSubscription", _newsSubscription);
    });
  }

  @override
  void initState() {
    super.initState();
    getSettings();
    getVersion();
    getUserTagsFromOneSignal();
  }

  void getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt("preffed_screen_for_open") != null) {
        _preffedScreenForOpen = prefs.getInt("preffed_screen_for_open")!;
      } else {
        prefs.setInt("preffed_screen_for_open", 0);
      }
      if (prefs.getBool("VideoWatchedSaving") != null) {
        _isVideoWatchedSaving = prefs.getBool("VideoWatchedSaving")!;
      } else {
        prefs.setBool("VideoWatchedSaving", true);
      }
      if (prefs.getBool("newsSubscription") != null) {
        _newsSubscription = prefs.getBool("newsSubscription")!;
      } else {
        prefs.setBool("newsSubscription", true);
      }
      if (prefs.getBool("videoSubscription") != null) {
        _videoSubscription = prefs.getBool("videoSubscription")!;
      } else {
        prefs.setBool("videoSubscription", true);
      }
    });
  }

  void clearVideoCache() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs
        .getKeys()
        .where((String key) =>
            key.toString().toLowerCase().contains("lections_") ||
            key.toString().toLowerCase().contains("stories_"))
        .toList();
    for (int i = 0; i < list.length; i++) {
      prefs.remove(list[i]);
    }
  }

  void clearDataCache() async {
    final prefs = await SharedPreferences.getInstance();
    final Directory tempDir = await getTemporaryDirectory();
    final Directory libCacheDir =
        Directory("${tempDir.path}/libCachedImageData");
    await libCacheDir.delete(recursive: true);
    final list = prefs
        .getKeys()
        .where((String key) =>
            key.toString().toLowerCase().contains("news_output") ||
            key.toString().toLowerCase().contains("stories_output") ||
            key.toString().toLowerCase().contains("lections_output") ||
            key.toString().toLowerCase().contains("persons_output"))
        .toList();
    for (int i = 0; i < list.length; i++) {
      prefs.remove(list[i]);
    }
  }

  void setSettings(id, value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case bool:
        prefs.setBool(id, value);
        break;
      case int:
        prefs.setInt(id, value);
        break;
      case String:
        prefs.setString(id, value);
        break;
      case double:
        prefs.setDouble(id, value);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle().copyWith(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor:
                  themeNotifier.isDark ? Colors.black : Colors.white),
          leadingWidth: 40,
          leading: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(RsvpuIconClass.universityLogo, color: Colors.white),
          ),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
          title: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Настройки", style: TextStyle(fontSize: 24))),
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    top: 15.0, bottom: 5.0, left: 5.0, right: 5.0),
                child: Image(
                  image: AssetImage('images/Logo.png'),
                  width: 250,
                  height: 141,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text("Открытый университет РГППУ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
              ),
              const Padding(
                padding: EdgeInsets.only(
                    top: 15.0, left: 10.0, right: 5.0, bottom: 5.0),
                child: Text(
                  "Настройки оформления",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
              const Divider(),
              SwitchListTile(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(themeNotifier.isDark
                          ? Icons.nightlight_round_sharp
                          : Icons.sunny),
                    ),
                    const Expanded(
                        child: Text("Темная тема",
                            style: TextStyle(fontSize: 16))),
                  ],
                ),
                value: themeNotifier.isDark,
                onChanged: (value) {
                  themeNotifier.isDark
                      ? themeNotifier.isDark = false
                      : themeNotifier.isDark = true;
                },
              ),
              const Divider(),
              ListTile(
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
                title: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.screenshot),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Начальный экран",
                          style: TextStyle(fontSize: 16)),
                    )),
                  ],
                ),
                trailing: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<int>(
                        hint: const Text("Выбрать"),
                        value: _preffedScreenForOpen,
                        underline: Container(),
                        items: <int>[0, 1, 2, 3].map((int value) {
                          return DropdownMenuItem<int>(
                              value: value,
                              child: value == 0
                                  ? const Text("О проекте")
                                  : value == 1
                                      ? const Text("Новости")
                                      : value == 2
                                          ? const Text("Видео")
                                          : value == 3
                                              ? const Text("Настройки")
                                              : Text(value.toString()));
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _preffedScreenForOpen = newVal!;
                            setSettings("preffed_screen_for_open", newVal);
                          });
                        }),
                  ),
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(
                    top: 15.0, left: 10.0, right: 5.0, bottom: 5.0),
                child: Text(
                  "Настройки видео",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
              const Divider(),
              SwitchListTile(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(_isVideoWatchedSaving
                          ? Icons.videocam
                          : Icons.videocam_off),
                    ),
                    const Expanded(
                        child: Text("Сохранять историю просмотра",
                            style: TextStyle(fontSize: 16))),
                  ],
                ),
                value: _isVideoWatchedSaving,
                onChanged: (bool value) {
                  if (_isVideoWatchedSaving == true) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Внимание!'),
                          content: const Text(
                              'При отключении сохранения истории просмотра — ваша текущая история просмотра будет удалена. Вы согласны?'),
                          actions: <Widget>[
                            MaterialButton(
                              child: const Text('Хорошо, я согласен'),
                              onPressed: () {
                                clearVideoCache();
                                setSettings("VideoWatchedSaving",
                                    !_isVideoWatchedSaving);
                                setState(() {
                                  _isVideoWatchedSaving =
                                      !_isVideoWatchedSaving;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            MaterialButton(
                              child:
                                  const Text('Нет, оставить историю просмотра'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    setSettings("VideoWatchedSaving", !_isVideoWatchedSaving);
                    setState(() {
                      _isVideoWatchedSaving = !_isVideoWatchedSaving;
                    });
                  }
                },
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Внимание!'),
                        content: const Text(
                            'Ваша текущая история просмотра будет удалена. Вы согласны?'),
                        actions: <Widget>[
                          MaterialButton(
                            child: const Text('Хорошо, я согласен'),
                            onPressed: () {
                              clearVideoCache();
                              Navigator.of(context).pop();
                            },
                          ),
                          MaterialButton(
                            child:
                                const Text('Нет, оставить историю просмотра'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  title: Row(children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.sd_storage),
                    ),
                    Expanded(
                        child: Text("Очистить историю просмотра видео",
                            style: TextStyle(fontSize: 16))),
                  ]),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Внимание!'),
                        content: const Text(
                            'Сохраненные данные новостей, информация о видео, и наставниках будет удалена. Вы согласны?'),
                        actions: <Widget>[
                          MaterialButton(
                            child: const Text('Хорошо, я согласен'),
                            onPressed: () {
                              clearDataCache();
                              Navigator.of(context).pop();
                            },
                          ),
                          MaterialButton(
                            child:
                                const Text('Нет, оставить загруженные данные'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  title: Row(children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.newspaper_sharp),
                    ),
                    Expanded(
                        child: Text(
                      "Очистить предзагруженные данные",
                      style: TextStyle(fontSize: 16),
                    )),
                  ]),
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(
                    top: 15.0, left: 10.0, right: 5.0, bottom: 5.0),
                child: Text(
                  "Уведомления",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
              const Divider(),
              SwitchListTile(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.newspaper),
                    ),
                    Expanded(
                        child: Text("Свежие новости",
                            style: TextStyle(fontSize: 16))),
                  ],
                ),
                value: _newsSubscription,
                onChanged: (bool value) {
                  if (_newsSubscription) {
                    setState(() {
                      _newsSubscription = false;
                      setSettings("newsSubscription", false);
                      OneSignal.shared.sendTag("news", "False");
                    });
                  } else {
                    setState(() {
                      _newsSubscription = true;
                      setSettings("newsSubscription", true);
                      OneSignal.shared.sendTag("news", "True");
                    });
                  }
                },
              ),
              const Divider(),
              SwitchListTile(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.videocam),
                    ),
                    Expanded(
                        child: Text("Новые видео",
                            style: TextStyle(fontSize: 16))),
                  ],
                ),
                value: _videoSubscription,
                onChanged: (bool value) {
                  if (_videoSubscription) {
                    setState(() {
                      _videoSubscription = false;
                      setSettings("videoSubscription", false);
                      OneSignal.shared.sendTag("video", "False");
                    });
                  } else {
                    setState(() {
                      _videoSubscription = true;
                      setSettings("videoSubscription", true);
                      OneSignal.shared.sendTag("video", "True");
                    });
                  }
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 15.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 8.0, right: 8.0, bottom: 20.0),
                    child: Text(
                      "Версия: $_versionNumber - ${Platform.isIOS ? "IOS" : "Android"}\nРоссийский Государственный Профессионально-Педагогический Университет\n2023 г.",
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
