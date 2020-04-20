import 'package:cached_network_image/cached_network_image.dart';
import 'package:covi_info/models/Country.dart';
import 'package:covi_info/widgets/countryChart.dart';
import 'package:decoding_text_effect/decoding_text_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intl/intl.dart';

class CountryPage extends StatefulWidget {
  final CountryData countryData;

  CountryPage({this.countryData});

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  NumberFormat numberFormat = NumberFormat();

  @override
  Widget build(BuildContext context) {
    CountryData data = widget.countryData;

    return Scaffold(
      appBar: PreferredSize(
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24.0),
              constraints: BoxConstraints(minHeight: 150),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 5, spreadRadius: 2)
                  ],
                  gradient: LinearGradient(colors: [
                    Colors.blue.withOpacity(1),
                    Colors.blueAccent.withOpacity(0.7)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Hero(
                    tag: 'countryName${data.name}',
                    child: Container(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        widget.countryData.name,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Hero(
                      tag: 'countryHero${data.name}',
                      child: CachedNetworkImage(
                          //fit: BoxFit.fitHeight,
                          alignment: Alignment.bottomCenter,
                          height: 300,
                          // width: 100,
                          imageUrl: widget.countryData.flagUrl))
                ],
              ),
            ),
          ),
          preferredSize: Size(double.infinity, 110)),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildWorldStatTile(context, "Total cases",
                        data.confirmedCases, Colors.blueAccent),
                    buildWorldStatTile(
                        context, "Deaths", data.deathCases, Colors.redAccent),
                  ],
                ),
                Container(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildWorldStatTile(context, "Recovered",
                        data.recoveredCases, Colors.teal.withOpacity(0.7)),
                    buildWorldStatTile(
                        context,
                        "Active",
                        data.confirmedCases -
                            (data.deathCases + data.recoveredCases),
                        Colors.deepPurpleAccent),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildChart(context, data),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _percentLabel(context, Colors.redAccent, "Deaths",
                                data.deathCases * 100 ~/ data.confirmedCases),
                            _percentLabel(
                                context,
                                Colors.teal.withOpacity(0.7),
                                "Recovered",
                                data.recoveredCases *
                                    100 ~/
                                    data.confirmedCases),
                            _percentLabel(
                                context,
                                Colors.deepPurpleAccent,
                                "Active",
                                (data.confirmedCases -
                                        (data.deathCases +
                                            data.recoveredCases)) *
                                    100 ~/
                                    data.confirmedCases),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          CountryChart(
            countryName: data.name.toLowerCase(),
          )
        ],
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

  Widget _buildChart(BuildContext context, CountryData countryData) {
    return Container(
      //  padding: EdgeInsets.all(24),
      child: AnimatedCircularChart(
        size: Size(150, 150),
        initialChartData: <CircularStackEntry>[
          CircularStackEntry(
            <CircularSegmentEntry>[
              CircularSegmentEntry(
                ((countryData.confirmedCases -
                            (countryData.deathCases +
                                countryData.recoveredCases)) /
                        countryData.confirmedCases) *
                    100,
                Colors.deepPurpleAccent,
                rankKey: 'active',
              ),
              CircularSegmentEntry(
                (countryData.deathCases / countryData.confirmedCases) * 100,
                Colors.redAccent,
                rankKey: 'remaining',
              ),
              CircularSegmentEntry(
                (countryData.recoveredCases / countryData.recoveredCases) * 100,
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
        holeLabel:
            "Total cases\n${numberFormat.format(countryData.confirmedCases)}",
        labelStyle:
            TextStyle(color: Colors.black.withOpacity(0.75), fontFamily: 'Sen'),
      ),
    );
  }
}
