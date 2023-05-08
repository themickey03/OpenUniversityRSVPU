import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/About/Contacts/single_person_model.dart';
import 'package:open_university_rsvpu/About/Contacts/single_person_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactWidgetNew extends StatefulWidget {
  const ContactWidgetNew({Key? key}) : super(key: key);

  @override
  State<ContactWidgetNew> createState() => _WithContactWidgetNewState();
}

class _WithContactWidgetNewState extends State<ContactWidgetNew>
    with AutomaticKeepAliveClientMixin<ContactWidgetNew> {
  var _url = "";
  var _postsJson = [];
  final _postsJsonFiltered = [];
  String _searchValue = '';
  void fetchDataPersons() async {
    try {
      setState(() {
        _url = 'https://ouapi.koralex.fun/persons?order=id';
      });
      final response = await get(Uri.parse(_url));
      var jsonData = jsonDecode(response.body) as List;
      var prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString("persons_output", json.encode(jsonData));
        _postsJson = jsonData;
      });
    } catch (err) {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("persons_output")) {
        setState(() {
          _postsJson = json.decode(prefs.getString("persons_output")!);
        });
      }
    }
  }

  @override
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
          if (_postsJson[i]["last_name"]
                  .toString()
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase()) ||
              _postsJson[i]["middle_name"]
                  .toString()
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase()) ||
              _postsJson[i]["first_name"]
                  .toString()
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase()) ||
              _postsJson[i]["job_title"]
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
          systemOverlayStyle: const SystemUiOverlayStyle().copyWith(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor:
                  themeNotifier.isDark ? Colors.black : Colors.white),
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
          color: const Color.fromRGBO(34, 76, 164, 1),
          onRefresh: onRefresh,
          child: Center(
            child: ListView.builder(
              itemCount: _postsJsonFiltered.length,
              itemBuilder: (context, index) {
                var firstName = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['first_name'] !=
                        null &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['first_name'] !=
                        "") {
                  firstName =
                      _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                          ['first_name'];
                }
                var lastName = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['last_name'] !=
                        null &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['last_name'] !=
                        "") {
                  lastName =
                      _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                          ['last_name'];
                }
                var middleName = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['middle_name'] !=
                        null &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['middle_name'] !=
                        "") {
                  middleName =
                      _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                          ['middle_name'];
                }
                var imgLink = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['img_id'] !=
                        null &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['img_id'] !=
                        "") {
                  imgLink =
                      "https://ouimg.koralex.fun/${_postsJsonFiltered[_postsJsonFiltered.length - index - 1]['img_id']}.png";
                }
                var jobTitle = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['job_title'] !=
                        null &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['job_title'] !=
                        "") {
                  jobTitle =
                      _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                          ['job_title'];
                }
                var academDegree = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['academ_degree'] !=
                        null &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['academ_degree'] !=
                        "") {
                  academDegree =
                      _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                          ['academ_degree'];
                }
                var academTitle = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['academ_title'] !=
                        null &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['academ_title'] !=
                        "") {
                  academTitle =
                      _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                          ['academ_title'];
                }
                var awards = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['awards'] !=
                        null &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['awards'] !=
                        "") {
                  awards =
                      _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                          ['awards'];
                }
                var interview = "";
                if (_postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['interview'] !=
                        "" &&
                    _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                            ['interview'] !=
                        null) {
                  interview =
                      _postsJsonFiltered[_postsJsonFiltered.length - index - 1]
                          ['interview'];
                  String br = " ";
                  interview = interview.replaceAll(r"\n", br);
                }

                return Card(
                  shadowColor: Colors.black,
                  elevation: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SinglePersonWidget(
                              singlePersonModelNew: SinglePersonModelNew(
                                  firstName,
                                  middleName,
                                  lastName,
                                  jobTitle,
                                  academDegree,
                                  academTitle,
                                  awards,
                                  interview,
                                  imgLink))));
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
                            child:
                                Stack(alignment: Alignment.center, children: [
                              Opacity(
                                  opacity: 0.5,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Image(
                                        image: AssetImage(
                                            'images/Loading_icon.gif')),
                                    imageUrl: imgLink,
                                    fit: BoxFit.contain,
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    alignment: Alignment.topCenter,
                                    fadeInDuration:
                                        const Duration(milliseconds: 0),
                                    fadeOutDuration:
                                        const Duration(milliseconds: 0),
                                  )),
                              ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Image(
                                        image: AssetImage(
                                            'images/Loading_icon.gif')),
                                    imageUrl: imgLink,
                                    fit: BoxFit.contain,
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    alignment: Alignment.topCenter,
                                    fadeInDuration:
                                        const Duration(milliseconds: 0),
                                    fadeOutDuration:
                                        const Duration(milliseconds: 0),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "$lastName $firstName $middleName",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 10.0, right: 10.0),
                          child: Text(
                            jobTitle,
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
