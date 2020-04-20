import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarr extends StatefulWidget {
  @override
  _AppBarrState createState() => _AppBarrState();
}

class _AppBarrState extends State<AppBarr> {
  bool isPressed = false;

  Color primaryGreen = Color.fromRGBO(1, 50, 32, 1);

  Color mainCol = Colors.white;
  Color sec = Color.fromRGBO(82, 173, 162, 1).withOpacity(1);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(24.0),
            constraints: BoxConstraints(minHeight: 150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [sec, sec.withOpacity(0.8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Corona Updates",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen),
                ),
                Container(height: 20),
                AnimatedContainer(
                  alignment: isPressed ? Alignment.topCenter : Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  duration: Duration(milliseconds: 600),
                  height: isPressed ? 400 : 60,
                  curve: Curves.fastLinearToSlowEaseIn,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.deepPurple.withOpacity(0.8),
                      Colors.deepPurpleAccent.withOpacity(0.8)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  child: !isPressed
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                FontAwesomeIcons.handsWash,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Remind me to wash my hands!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : _buildRemindColumn(context),
                )
              ],
            ),
          ),
          onTap: () {
            setState(() {
              isPressed = !isPressed;
            });
          },
        ),
        preferredSize: Size(double.infinity, 100));
  }

  Widget _buildRemindColumn(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(ctx).size.width * 0.6,
                  child: Text(
                    "How often do you want to be reminded?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                child: Icon(
                  FontAwesomeIcons.times,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Container(height: 20),
          _buildTimeTile("Once every 15 minutes"),
          _buildTimeTile("Once every 30 minutes"),
          _buildTimeTile("Once every hour"),
          _buildTimeTile("Once every 2 hours"),
          _buildTimeTile("Once every 6 hours"),
        ],
      ),
    );
  }

  Widget _buildTimeTile(String str) {
    return ListTile(
      leading: Icon(
        FontAwesomeIcons.clock,
        color: Colors.white,
      ),
      onTap: () {},
      title: Text(
        str,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
