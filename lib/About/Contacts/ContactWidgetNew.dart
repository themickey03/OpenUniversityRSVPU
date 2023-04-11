import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/About/Contacts/SinglePersonModelNew.dart';
import 'package:open_university_rsvpu/About/Contacts/SinglePersonWidgetNew.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactWidgetNew extends StatefulWidget {
  const ContactWidgetNew({Key? key}) : super(key: key);

  @override
  _WithContactWidgetNewState createState() => _WithContactWidgetNewState();
}

class _WithContactWidgetNewState extends State<ContactWidgetNew>
    with AutomaticKeepAliveClientMixin<ContactWidgetNew> {
  final url = "http://api.bytezone.online/persons";
  var _postsJson = [];
  var _postsJsonFiltered = [];
  String _searchValue = '';
  void fetchDataPersons() async {
    try {
      final response = await get(Uri.parse(url));
      var jsonData = jsonDecode(response.body) as List;
      var prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString("persons_output", json.encode(jsonData));
        _postsJson = jsonData;
      });
    } catch (err) {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("persons_output")){
        setState(() {
          _postsJson = json.decode(prefs.getString("persons_output")!);
        });
      }
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
                var job_title_and = "";
                if (mainDesc['Кандидат'] != "" &&
                    mainDesc['Кандидат'] != null) {
                  job_title_and = mainDesc['Кандидат'];
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
                var imgLink = "";
                if (_postsJsonFiltered[index]['img'] != "" &&
                    _postsJsonFiltered[index]['img'] != null) {
                  if (_postsJsonFiltered[index]['img']['id'] != "" &&
                      _postsJsonFiltered[index]['img']['id'] != null) {
                    if (_postsJsonFiltered[index]['img']['format'] != "" &&
                        _postsJsonFiltered[index]['img']['format'] != null) {
                      //TODO change link
                      imgLink =
                          "http://api.bytezone.online/imgs/${_postsJsonFiltered[index]["img"]["id"]}.${_postsJsonFiltered[index]["img"]["format"]}";
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
                                  job_title, job_title_and, prizes, interview, imgLink))));
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
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  10.0,
                              height: (MediaQuery.of(context).size.width -
                                  10.0) /
                                  16 *
                                  9,
                              child: CachedNetworkImage(
                                placeholder: (context, url) => const Image(image: AssetImage('images/Loading_icon.gif')),
                                imageUrl: imgLink,
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                                height: double.maxFinite,
                                alignment: Alignment.topCenter,
                              ),
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
