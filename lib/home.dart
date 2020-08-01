import 'package:flutter/material.dart';
import 'game.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CaroGame"),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [const Color(0xFFB3E5FC), const Color(0xFF2196F3)])),
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.control_point,
                    size: 140,
                    color: Colors.orange,
                  ),
                  Icon(
                    Icons.radio_button_checked,
                    size: 140,
                    color: Colors.red,
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Container(
                        child: Center(
                      child: Text(
                        'vs AI',
                        style: TextStyle(
                            color: Colors.lightBlue[800], fontSize: 30),
                      ),
                    )),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return new GamePage(
                          isBot: true,
                        );
                      }));
                    },
                  ),
                  FlatButton(
                    child: Container(
                      child: Center(
                        child: Text(
                          'vs Friend',
                          style: TextStyle(
                              color: Colors.lightBlue[800], fontSize: 30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return new GamePage(
                          isBot: false,
                        );
                      }));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
