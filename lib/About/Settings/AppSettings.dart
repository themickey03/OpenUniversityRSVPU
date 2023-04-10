import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppSettingsWidget extends StatefulWidget {
  const AppSettingsWidget({super.key});

  @override
  _AppSettingsWidgetState createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {

  var _isVideoWatchedSaving = true;

  @override
  void initState(){
    super.initState();
    getSettings();
  }

  void getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool("VideoWatchedSaving") != null){
        _isVideoWatchedSaving = prefs.getBool("VideoWatchedSaving")!;
      }
      else{
        prefs.setBool("VideoWatchedSaving", true);
      }
    });
  }

  void clearVideoCache() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getKeys().where((String key) => key.toString().toLowerCase().contains("lections_") || key.toString().toLowerCase().contains("stories_")).toList();
    for (int i = 0; i < list.length; i++){
      prefs.remove(list[i]);
    }
  }

  void setSettings(id, value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType){
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
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
        title: const Align(alignment: Alignment.centerLeft,child: Text("Настройки", style: TextStyle(fontSize: 24))),
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0, bottom: 5.0),
              child: Text("Настройки оформления", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
            ),
            const Divider(),
            //TODO: https://github.com/nbnD/theme_switcher/
            const ListTile(
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              title: Text("Тема", style: TextStyle(fontSize: 16)),
              leading: Icon(Icons.sunny),
              trailing: Icon(Icons.switch_right),
            ),
            const Divider(),
            const SizedBox(
              height: 50,
              child: Text(""),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0, bottom: 5.0),
              child: Text("Настройки видео", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
            ),
            const Divider(),
            SwitchListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                title: Row(
                  children: [
                    Icon(_isVideoWatchedSaving ? Icons.videocam : Icons.videocam_off),
                    const Expanded(child: Text("   Сохранять историю просмотра", style: TextStyle(fontSize: 16))),
                  ],
                ),
                value: _isVideoWatchedSaving,
                onChanged: (bool value) {
                  setState(() {
                    _isVideoWatchedSaving = !_isVideoWatchedSaving;
                  });
                  setSettings("VideoWatchedSaving", _isVideoWatchedSaving);
                  if (_isVideoWatchedSaving == false){
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Внимание!'),
                          content: const Text('При отключении сохранения истории просмотра — ваша текущая история просмотра будет удалена. Вы согласны?'),
                          actions: <Widget>[
                            MaterialButton(
                              child: const Text('Хорошо, я согласен'),
                              onPressed: () {
                                clearVideoCache();
                                Navigator.of(context).pop();
                              },
                            ),
                            MaterialButton(
                              child: const Text('Нет, оставить историю просмотра'),
                              onPressed: () {
                                setState(() {
                                  _isVideoWatchedSaving = !_isVideoWatchedSaving;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
            ),
            const Divider(),
            //TODO: при очистке Alert("Вы уверены?")
            const ListTile(
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              title: Text("Отчистить историю просмотра", style: TextStyle(fontSize: 16)),
              leading: Icon(Icons.sd_storage),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}