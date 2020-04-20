import 'dart:convert';

import 'package:covi_info/models/CaseRecord.dart';
import 'package:covi_info/widgets/loaderWidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryChart extends StatefulWidget {
  final String countryName;

  CountryChart({this.countryName});

  @override
  _CountryChartState createState() => _CountryChartState();
}

class _CountryChartState extends State<CountryChart> {
  Future<List<CaseRecordData>> deathCases;
  Future<List<CaseRecordData>> recoveredCases;
  Future<List<CaseRecordData>> confirmedCases;

  final String countryUrl = "https://api.covid19api.com/total/dayone/country/";

  @override
  void initState() {
    super.initState();
    deathCases = fetchCaseData('deaths');
    recoveredCases = fetchCaseData('recovered');
    confirmedCases = fetchCaseData('confirmed');
  }

  Future<List<CaseRecordData>> fetchCaseData(String type) async {
    String countryName = widget.countryName;

    if (countryName == 'usa') {
      countryName = 'united-states';
    } else if (countryName == 'uk') {
      countryName = 'united-kingdom';
    }
    else if (countryName == 'uae') {
      countryName = 'united-arab-emirates';
    }

    try {
      final response = await http.get("$countryUrl/$countryName/status/$type");

      List<CaseRecordData> allData = [];

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        for (var obj in data) {
          allData.add(CaseRecordData.fromJson(obj));
        }

        return allData;
      } else {
        throw Exception('Failed to load datatt');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCaseChart("Death", Colors.redAccent),
          _buildCaseChart("Confirmed", Colors.blueAccent),
          _buildCaseChart("Recovered", Colors.teal),
        ],
      ),
    );
  }

  Widget _buildCaseChart(String type, Color color) {
    Future<List<CaseRecordData>> record;

    switch (type) {
      case 'Death':
        record = deathCases;
        break;
      case 'Confirmed':
        record = confirmedCases;
        break;
      case 'Recovered':
        record = recoveredCases;
        break;
      default:
    }

    return Column(
      
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "$type cases",
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900),
          ),
        ),
        FutureBuilder(
            future: record,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<CaseRecordData> cases = snapshot.data;
                List<FlSpot> caseData = getCaseData(cases);

                return Container(
                  height: 180,
                  padding: EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width,
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(enabled: false),
                      lineBarsData: [
                        LineChartBarData(
                            isCurved: true,
                            curveSmoothness: 0.1,
                            show: true,
                            spots: caseData,
                            colors: [color, color],
                            belowBarData: BarAreaData(
                                show: true,
                                colors: [
                                  color.withOpacity(0.9),
                                  color.withOpacity(0.1),
                                ],
                                gradientFrom: Offset(0.5, 0),
                                gradientTo: Offset(0.5, 1)),
                            dotData: FlDotData(show: false))
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                          margin: 12,
                          getTitles: (value) {
                            if (value % 7 == 0) {
                              return getDate(value.toInt(), cases);
                            }
                            return '';
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                          margin: 12,
                          getTitles: (value) {
                            return value > 0.5
                                ? '${value.toInt().toString()}${getSuffix(cases)}'
                                : '0';
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black54,
                            ),
                            left: BorderSide(
                              color: Colors.black54,
                            ),
                            right: BorderSide(
                              color: Colors.transparent,
                            ),
                            top: BorderSide(
                              color: Colors.transparent,
                            ),
                          )),
                    ),
                  ),
                );
              } else {
                Text('error');
              }
              return loaderWidget(context);
            }),
      ],
    );
  }

  List<FlSpot> getCaseData(List<CaseRecordData> cases) {
    List<FlSpot> data = [];

    int maxCases = cases.last.cases;

    int factor;

    if (maxCases <= 10) {
      factor = 1;
    } else if (maxCases > 10 && maxCases <= 100) {
      factor = 10;
    } else if (maxCases > 100 && maxCases <= 1000) {
      factor = 100;
    } else if (maxCases > 1000 && maxCases <= 10000) {
      factor = 1000;
    } else if (maxCases > 10000 && maxCases <= 100000) {
      factor = 10000;
    } else
      factor = 100000;

    for (var i in cases) {
      data.add(
          FlSpot(cases.indexOf(i).toDouble(), (i.cases / factor).toDouble()));
    }

    return data;
  }
}

String getDate(int value, List<CaseRecordData> cases) {
  return '${cases.elementAt(value).date.day.toString()}/${cases.elementAt(value).date.month.toString()}';
}

String getSuffix(List<CaseRecordData> cases) {
  int maxCases = cases.last.cases;
  if (maxCases <= 10) {
    return "";
  } else if (maxCases > 10 && maxCases <= 100) {
    return "0";
  } else if (maxCases > 100 && maxCases <= 1000) {
    return "00";
  } else if (maxCases > 1000 && maxCases <= 10000) {
    return "k";
  } else if (maxCases > 10000 && maxCases <= 100000) {
    return "0k";
  } else
    return "00k";
}
