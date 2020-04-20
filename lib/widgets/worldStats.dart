import 'dart:convert';

import 'package:covi_info/main.dart';
import 'package:covi_info/models/World.dart';
import 'package:covi_info/widgets/loaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:decoding_text_effect/decoding_text_effect.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class WorldStats extends StatefulWidget {
  @override
  _WorldStatsState createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> {
  Future<WorldData> worldData;
  NumberFormat numberFormat = NumberFormat();

  Color primaryGreen = Color.fromRGBO(1, 50, 32, 1);

  @override
  void initState() {
    super.initState();
    worldData = fetchWorldData();
  }

  Future<WorldData> fetchWorldData() async {
    try {
      final response = await http.get('$baseMainUrl/all');

      if (response.statusCode == 200) {
        return WorldData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return WorldData(active: -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "WorldWide Statistics",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            child: FutureBuilder(
                future: worldData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WorldData data = snapshot.data;
                    return data.active != -1
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 14),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    buildWorldStatTile(context, "Total cases",
                                        data.totalCases, Colors.blueAccent),
                                    buildWorldStatTile(context, "Deaths",
                                        data.deaths, Colors.redAccent),
                                  ],
                                ),
                                Container(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    buildWorldStatTile(
                                        context,
                                        "Recovered",
                                        data.recovered,
                                        Colors.teal.withOpacity(0.7)),
                                    buildWorldStatTile(context, "Active",
                                        data.active, Colors.deepPurpleAccent),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _buildChart(context, data),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            _percentLabel(
                                                context,
                                                Colors.redAccent,
                                                "Deaths",
                                                data.deaths *
                                                    100 ~/
                                                    data.totalCases),
                                            _percentLabel(
                                                context,
                                                Colors.teal.withOpacity(0.7),
                                                "Recovered",
                                                data.recovered *
                                                    100 ~/
                                                    data.totalCases),
                                            _percentLabel(
                                                context,
                                                Colors.deepPurpleAccent,
                                                "Active",
                                                data.active *
                                                    100 ~/
                                                    data.totalCases),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return loaderWidget(context);
                }),
          ),
        ],
      ),
    );
  }

  Widget _percentLabel(
      BuildContext context, Color color, String type, int percent) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            margin: EdgeInsets.all(8),
          ),
          Text(
            type,
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            "  $percent%",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, WorldData worldData) {
    return Container(
      //  padding: EdgeInsets.all(24),
      child: AnimatedCircularChart(
        size: Size(150, 150),
        initialChartData: <CircularStackEntry>[
          CircularStackEntry(
            <CircularSegmentEntry>[
              CircularSegmentEntry(
                (worldData.active / worldData.totalCases) * 100,
                Colors.deepPurpleAccent,
                rankKey: 'active',
              ),
              CircularSegmentEntry(
                (worldData.deaths / worldData.totalCases) * 100,
                Colors.redAccent,
                rankKey: 'remaining',
              ),
              CircularSegmentEntry(
                (worldData.recovered / worldData.totalCases) * 100,
                Colors.teal.withOpacity(0.7),
                rankKey: 'remaining',
              ),
            ],
            rankKey: 'progress',
          ),
        ],
        chartType: CircularChartType.Radial,
        percentageValues: true,
        holeRadius: 50,
        holeLabel: "Total cases\n${numberFormat.format(worldData.totalCases)}",
        labelStyle:
            TextStyle(color: Colors.black.withOpacity(0.75), fontFamily: 'Sen'),
      ),
    );
  }

  Widget buildWorldStatTile(
      BuildContext context, String type, int number, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(18)),
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
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(24)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    type,
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.75)),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 12),
              child: DecodingTextEffect(
                numberFormat.format(number),
                decodeEffect: DecodeEffect.fromStart,
                refreshDuration: Duration(milliseconds: 35),
                textStyle: TextStyle(fontSize: 28, letterSpacing: -1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
