import 'package:covi_info/widgets/appbar.dart';
import 'package:covi_info/widgets/countryStats.dart';
import 'package:covi_info/widgets/worldStats.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final String baseMainUrl = "https://corona.lmao.ninja/v2";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid Info',
      theme: ThemeData(fontFamily: 'Sen'),
      home: MyHomePage(title: 'Covid Info'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        cacheExtent: 10000,
        children: <Widget>[
          AppBarr(),
          WorldStats(),
          CountryStats(),
          Container()
        ],
      ),
    );
  }
}
