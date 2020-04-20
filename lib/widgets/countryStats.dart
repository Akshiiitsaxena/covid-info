import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:covi_info/main.dart';
import 'package:covi_info/models/Country.dart';
import 'package:covi_info/screens/CountryInformation.dart';
import 'package:covi_info/widgets/loaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CountryStats extends StatefulWidget {
  @override
  _CountryStatsState createState() => _CountryStatsState();
}

class _CountryStatsState extends State<CountryStats> {
  Future<List<CountryData>> allCountryData;
  NumberFormat numberFormat = NumberFormat();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allCountryData = fetchCountryData();
  }

  Future<List<CountryData>> fetchCountryData() async {
    try {
      final response = await http.get('$baseMainUrl/countries?sort=country');
      List<CountryData> allCountries = [];

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        for (var obj in data) {
          CountryData temp = CountryData.fromJson(obj);

          if (temp.name != "World") allCountries.add(temp);
        }

        allCountries.sort((a, b) {
          return b.confirmedCases.compareTo(a.confirmedCases);
        });

        allCountries.add(allCountries[allCountries.length - 1]);

        CountryData india;

        for (var country in allCountries) {
          if (country.countryCode == "IN") {
            india = country;
          }
        }

        for (int i = allCountries.length - 2; i > 0; i--) {
          allCountries[i] = allCountries[i - 1];
        }

        allCountries[0] = india;

        return allCountries;
      } else {
        throw Exception('Failed to load daaaa');
      }
    } catch (e) {
      return [];
    }
  }

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode;

  bool isTapped = false;

  List<CountryData> searched = [];
  List<CountryData> allData = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 24),
          child: Text(
            "Country Statistics",
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900),
          ),
        ),
        Container(
          child: FutureBuilder(
            future: allCountryData,
            builder: (context, snapshot) {
              print(isTapped);
              if (snapshot.hasData) {
                List<CountryData> data;
                isTapped ? data = searched : data = snapshot.data;
                allData = snapshot.data;
                return data != []
                    ? Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(12, 24, 0, 12),
                            height: 355,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  return buildCountryCard(ctx, data[index]);
                                }),
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(12, 12, 12, 24),
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.red,
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.075),
                                        Colors.black.withOpacity(0.075)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(Icons.search),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 200,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        onTap: () {
                                          isTapped = true;
                                        },
                                        onChanged: (value) {
                                          List<CountryData> searchedData = [];

                                          for (CountryData country in allData) {
                                            if (country.name
                                                .toLowerCase()
                                                .contains(
                                                    value.toLowerCase())) {
                                              searchedData.add(country);
                                            }
                                          }
                                          setState(() {
                                            searched = searchedData;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Search'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          "There seems to be a connectivity error,\nplease try again.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black38),
                        ),
                      );
                ;
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: loaderWidget(context),
              );
            },
          ),
        )
      ],
    ));
  }

  Widget buildCountryCard(BuildContext context, CountryData countryData) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.0, 12, 24, 12),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  spreadRadius: 1)
            ]),
        width: 250,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Hero(
                      tag: 'countryName${countryData.name}',
                      child: Text(
                        countryData.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Hero(
                        transitionOnUserGestures: false,
                        tag: 'countryHero${countryData.name}',
                        child:
                            CachedNetworkImage(imageUrl: countryData.flagUrl))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  buildCountryStatTile(context, "Total",
                      countryData.confirmedCases, Colors.blueAccent),
                  buildCountryStatTile(context, "Deaths",
                      countryData.deathCases, Colors.redAccent),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  buildCountryStatTile(context, "Recovered",
                      countryData.recoveredCases, Colors.teal),
                  buildCountryStatTile(
                      context,
                      "Active ",
                      countryData.confirmedCases -
                          (countryData.deathCases + countryData.recoveredCases),
                      Colors.deepPurpleAccent),
                ],
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return CountryPage(
                      countryData: countryData,
                    );
                  }));
                },
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.angleUp,
                        color: Colors.teal,
                      ),
                      Container(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "More information",
                            style: TextStyle(color: Colors.teal),
                          ))
                    ],
                  ),
                  alignment: Alignment.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCountryStatTile(
      BuildContext context, String type, int number, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 2.0),
      child: Container(
        //  width: MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(24)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    type,
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.6)),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(
                numberFormat.format(number),
                style: TextStyle(fontSize: 20, letterSpacing: -1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
