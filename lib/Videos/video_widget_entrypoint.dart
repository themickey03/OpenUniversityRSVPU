import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/Videos/video_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
class VideoWidgetMain extends StatelessWidget {
  const VideoWidgetMain({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle()
                .copyWith(
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: themeNotifier.isDark
                    ? Colors.black
                    : Colors.white),
            leadingWidth: 40,
            leading:
              const Padding(
                padding: EdgeInsets.only(left: 3),
                child: Icon(RsvpuIconClass.universityLogo, color: Colors.white),
              ),
            foregroundColor: Colors.white,
            backgroundColor: !themeNotifier.isDark
                ? const Color.fromRGBO(34, 76, 164, 1)
                : ThemeData.dark().primaryColor,
            title: const Align(
                alignment: Alignment.centerLeft,
                child: Text("Видео", style: TextStyle(fontSize: 24))),
            elevation: 0,
          ),
          body: const VideoWidget());
    });
  }
}

class VideoWidget extends StatelessWidget {
  const VideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle()
                .copyWith(
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: themeNotifier.isDark
                    ? Colors.black
                    : Colors.white),
            backgroundColor: !themeNotifier.isDark
                ? const Color.fromRGBO(34, 76, 164, 1)
                : ThemeData.dark().primaryColor,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                TabBar(
                  tabs: [
                    Tab(
                      text: 'Истории',
                    ),
                    Tab(
                      text: 'Лекции',
                    ),
                  ],
                  indicatorColor: Colors.blueAccent,
                )
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              VideoListWidget(type: "stories"),
              VideoListWidget(type: "lections")
            ],
          ),
        ),
      );
    });
  }
}
