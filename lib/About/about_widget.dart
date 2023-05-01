import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'ProjectText/about_project.dart';
import 'Contacts/contact_widget.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({super.key});

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
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
              child: Text("О проекте", style: TextStyle(fontSize: 24))),
          elevation: 0,
        ),
        body: Center(
            child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 10,
                      minWidth: 30.0,
                    ),
                    child: Wrap(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Image(
                            image: AssetImage(
                                'images/Front_page_screen_project_logo.png'),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
              child: Align(
                  alignment: Alignment.center,
                  child: Text("Открытый университет РГППУ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                  "Открытый университет РГППУ – это новый проект центра развития образовательных проектов Университета, который рассматривается как модель неформального образования взрослых.\n\n"
                  "Цель проекта «Открытого университета» - формирование нового образа Университета как лидера современных разработок и сценариев гуманитарного действия, соразмерного сегодняшней региональной, национальной и мировой ситуации.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16)),
            ),
            const Divider(),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutProjectWidget()));
                },
                child: Column(
                  children: const [
                    ListTile(
                      title: Text("Подробнее о проекте"),
                      leading: Icon(Icons.text_snippet),
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                    ),
                  ],
                )),
            const Divider(),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ContactWidgetNew()));
                },
                child: Column(
                  children: const [
                    ListTile(
                      title: Text("Наставники проекта"),
                      leading: Icon(Icons.people),
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                    ),
                  ],
                )),
            const Divider()
          ],
        )),
      );
    });
  }
}
