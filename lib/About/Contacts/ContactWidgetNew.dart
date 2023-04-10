import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/About/Contacts/SinglePersonModelNew.dart';
import 'package:open_university_rsvpu/About/Contacts/SinglePersonWidgetNew.dart';

class ContactWidgetNew extends StatefulWidget {
  const ContactWidgetNew({Key? key}) : super(key: key);

  @override
  _WithContactWidgetNewState createState() => _WithContactWidgetNewState();
}

class _WithContactWidgetNewState extends State<ContactWidgetNew>
    with AutomaticKeepAliveClientMixin<ContactWidgetNew> {
  //TODO change link
  final url = "http://koralex.fun/back/persons";
  var _postsJson = [];
  var _postsJsonFiltered = [];
  String _searchValue = '';
  void fetchDataPersons() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {
      print(err);
    }
  }

  void initState() {
    super.initState();
    fetchDataPersons();
  }

  Future onRefresh() async {
    setState(() {
      fetchDataPersons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      super.build(context);
      if (_searchValue != "") {
        _postsJsonFiltered.clear();
        for (int i = 0; i < _postsJson.length; i++) {
          if (_postsJson[i]["name"]
                  .toString()
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase()) ||
              _postsJson[i]["description"]["Должность"]
                  .toString()
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase())) {
            _postsJsonFiltered.add(_postsJson[i]);
          }
        }
      } else {
        _postsJsonFiltered.clear();
        for (int i = 0; i < _postsJson.length; i++) {
          _postsJsonFiltered.add(_postsJson[i]);
        }
      }

      return Scaffold(
        appBar: EasySearchBar(
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
          title: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Наставники", style: TextStyle(fontSize: 24))),
          onSearch: (value) {
            setState(() {
              _searchValue = value;
            });
          },
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Center(
            child: ListView.builder(
              itemCount: _postsJsonFiltered.length,
              itemBuilder: (context, index) {
                var name = "";
                if (_postsJsonFiltered[index]['name'] != "" &&
                    _postsJsonFiltered[index]['name'] != null) {
                  name = _postsJsonFiltered[index]['name'];
                  name = name.replaceAll("\n", "");
                  name = name.toUpperCase();
                }
                var mainDesc = <String, dynamic>{};
                if (_postsJsonFiltered[index]['description'] != null) {
                  mainDesc = _postsJsonFiltered[index]['description'];
                }
                var job_title = "";
                if (mainDesc['Должность'] != "" &&
                    mainDesc['Должность'] != null) {
                  job_title = mainDesc['Должность'];
                }
                var prizes = "";
                if (mainDesc['Награды'] != "" &&
                    mainDesc['Награды'] != null) {
                  prizes = mainDesc['Награды'];
                }
                var interview = "";
                if (_postsJsonFiltered[index]['interview'] != "" &&
                    _postsJsonFiltered[index]['interview'] != null) {
                  interview = _postsJsonFiltered[index]['interview'];
                  String br = "";
                  interview = interview.replaceAll(r"\n", br);

                }
                var img_link = "";
                if (_postsJsonFiltered[index]['img'] != "" &&
                    _postsJsonFiltered[index]['img'] != null) {
                  if (_postsJsonFiltered[index]['img']['id'] != "" &&
                      _postsJsonFiltered[index]['img']['id'] != null) {
                    if (_postsJsonFiltered[index]['img']['format'] != "" &&
                        _postsJsonFiltered[index]['img']['format'] != null) {
                      //TODO change link
                      img_link =
                          "http://koralex.fun/back/imgs/${_postsJsonFiltered[index]["img"]["id"]}.${_postsJsonFiltered[index]["img"]["format"]}";
                    }
                  }
                }
                return Card(
                  shadowColor: Colors.black,
                  elevation: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SinglePersonWidget(
                              singlePersonModelNew: SinglePersonModelNew(name,
                                  job_title, prizes, interview, img_link))));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          //padding: EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                          ),
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: FadeInImage.assetNetwork(
                              alignment: Alignment.topCenter,
                              placeholder: 'images/Loading_icon.gif',
                              //TODO change link
                              image: img_link != ""
                                  ? img_link
                                  : "http://koralex.fun:3000/_nuxt/assets/images/logo.png",
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                              height: double.maxFinite,
                            ),
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 10.0, right: 10.0),
                          child: Text(
                            job_title,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
