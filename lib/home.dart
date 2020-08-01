import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'game.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int depth = 1;
  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 5,
            title: new Text("Pick a new depth"),
            initialIntegerValue: depth,
          );
        }).then((value) {
      if (value != null) {
        setState(() {
          depth = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showDialog,
          )
        ],
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
                          maxDepthaAscendingInput: depth,
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
                          maxDepthaAscendingInput: depth,
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
