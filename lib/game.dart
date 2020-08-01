import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

bool vsBot;
int currentMoves = 0;
//empty board
String status = '';
String winner = '';
var _gamePageState;
var _turnState;
var _context;
String _turn = 'First Move: X';
bool loading = false;
int testLoop = 0;
List<String> _board = [
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
];

// ignore: must_be_immutable
class GamePage extends StatefulWidget {
  bool isBot;

  GamePage({this.isBot}) {
    _resetGame();
    vsBot = this.isBot;

    if (vsBot) _turn = 'First Move: O';
  }

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    _gamePageState = this;
    return Scaffold(
      appBar: AppBar(
        //leading: Container(width: 0,height: 0,),
        title: Text(vsBot ? 'Playing vs Bot' : 'Playing vs Friend'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue[200]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[_BoxContainer(), Status()],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            awaitfn('Reset?', 'Want to reset the current game?', 'Go Back',
                'Reset');
          });
        },
        tooltip: 'Restart',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class _BoxContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          border: new Border.all(color: Colors.blue),
          boxShadow: [
            BoxShadow(
                color: Colors.blue[100],
                blurRadius: 20.0,
                spreadRadius: 5.0,
                offset: Offset(7.0, 7.0))
          ]),
      child: Center(
        child: GridView.count(
          primary: false,
          crossAxisCount: 5,
          children: List.generate(_board.length, (index) {
            return Box(index);
          }),
        ),
      ),
    );
  }
}

class Box extends StatefulWidget {
  final int index;
  Box(this.index);
  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  void pressed() {
    setState(() {
      currentMoves++;
      if (checkGameVer1()) {
        awaitfnn();
      } else if (currentMoves >= _board.length) {
        awaitfn('It\'s a Draw', 'Want to try again?', 'Go Back', 'New Game');
      }
      _turnState.setState(() {
        if (currentMoves % 2 == 0)
          _turn = 'Turn: X';
        else
          _turn = 'Turn: O';
        _gamePageState.setState(() {});
      });
    });
  }

  @override
  Widget build(context) {
    return MaterialButton(
        padding: EdgeInsets.all(0),
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: new Border.all(color: Colors.blue)),
            child: Center(
              child: Text(
                _board[widget.index].toUpperCase(),
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        onPressed: () {
          if (_board[widget.index] == '') {
            if (vsBot == false) {
              if (currentMoves % 2 == 0)
                _board[widget.index] = 'x';
              else
                _board[widget.index] = 'o';
            } else if (!loading) {
              loading = true;
              _board[widget.index] = 'o';
              if (currentMoves >= 24) {
              } else
                _bestMove(_board);
            }
            pressed();
          }
        });
  }
}

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    _turnState = this;
    return Card(
        margin: EdgeInsets.all(40),
        child: Container(
          width: 220,
          height: 60,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            _turn,
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ));
  }
}

//-------------------------------------Caro game Brain ---------------------------
bool checkGameVer1() {
  bool checkGameHorizontal = _checkGameHorizontal();
  bool checkGameVertical = _checkGameVertical();
  bool checkDiagonallyRightToLeft2 = _checkDiagonallyRightToLeft2();
  bool checkDiagonallyRightToLeft1 = _checkDiagonallyRightToLeft1();
  bool checkDiagonallyLeftToRight2 = _checkDiagonallyLeftToRight2();
  bool checkDiagonallyLeftToRight1 = _checkDiagonallyLeftToRight1();
  if (checkGameHorizontal == true ||
      checkGameVertical == true ||
      checkDiagonallyRightToLeft2 == true ||
      checkDiagonallyRightToLeft1 == true ||
      checkDiagonallyLeftToRight2 == true ||
      checkDiagonallyLeftToRight1 == true) {
    return true;
  }
  return false;
}

//check nữa trên bàn cờ theo hàng xéo từ trái qua phải
bool _checkDiagonallyLeftToRight2(
    {int positonStart = 0,
    int positionEnd = 24,
    int lenght = 5,
    @required List<String> board}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  int lenghtTmp = lenght;
  for (int i = positonStartTmp; i <= positionEnd; i += 6) {
    _boardTmp.add(_board[i]);
  }
  try {
    for (int i = 0; i < lenght; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return true;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == 4) {
    return false;
  } else {
    return _checkDiagonallyLeftToRight2(
        positonStart: positonStartTmp + 1,
        lenght: lenghtTmp - 1,
        positionEnd: positionEndTmp - 5,
        board: board);
  }
}

//check nữa dưới bàn cờ theo hàng xéo từ trái qua phải
bool _checkDiagonallyLeftToRight1({
  int positonStart = 5,
  int positionEnd = 23,
  int lenght = 4,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  int lenghtTmp = lenght;
  for (int i = positonStartTmp; i <= positionEnd; i += 6) {
    _boardTmp.add(_board[i]);
  }
  try {
    for (int i = 0; i < lenght; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return true;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == 20) {
    return false;
  } else {
    return _checkDiagonallyLeftToRight1(
      positonStart: positonStartTmp + 5,
      lenght: lenghtTmp - 1,
      positionEnd: positionEndTmp - 1,
    );
  }
}

//check nữa trên bàn cờ theo hàng xéo từ phải qua trái
bool _checkDiagonallyRightToLeft2({
  int positonStart = 4,
  int positionEnd = 20,
  int lenght = 5,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  int lenghtTmp = lenght;
  for (int i = positonStartTmp; i <= positionEnd; i += 4) {
    _boardTmp.add(_board[i]);
  }
  try {
    for (int i = 0; i < lenght; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return true;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == 0) {
    return false;
  } else {
    return _checkDiagonallyRightToLeft2(
      positonStart: positonStartTmp - 1,
      lenght: lenghtTmp - 1,
      positionEnd: positionEndTmp - 5,
    );
  }
}

//check nữa dưới bàn cờ theo hàng xéo từ phải qua trái
bool _checkDiagonallyRightToLeft1({
  int positonStart = 9,
  int positionEnd = 21,
  int lenght = 4,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  int lenghtTmp = lenght;
  for (int i = positonStartTmp; i <= positionEnd; i += 4) {
    _boardTmp.add(_board[i]);
  }
  try {
    for (int i = 0; i < lenght; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return true;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == _board.length - 1) {
    return false;
  } else {
    return _checkDiagonallyRightToLeft1(
      positonStart: positonStartTmp + 5,
      lenght: lenghtTmp - 1,
      positionEnd: positionEndTmp + 1,
    );
  }
}

bool _checkGameHorizontal({
  int positonStart = 0,
  int positionEnd = 4,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  for (int i = positonStartTmp; i <= positionEndTmp; i++) {
    _boardTmp.add(_board[i]);
  }

  try {
    for (int i = 0; i < _boardTmp.length; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return true;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == _board.length - 1) {
    return false;
  } else {
    return _checkGameHorizontal(
      positonStart: positionEndTmp + 1,
      positionEnd: positionEndTmp + 5,
    );
  }
}

bool _checkGameVertical({
  int positonStart = 0,
  int positionEnd = 20,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  for (int i = positonStartTmp; i <= positionEndTmp; i += 5) {
    _boardTmp.add(_board[i]);
  }
  // chổ này khi i <3 nó sẽ tự cộng cộng lên 1 hoặc 2 để kiểm tra mấy thằng cuối chứ i mà bằng cuối là nhảy ra khỏi mảng
  try {
    for (int i = 0; i < _boardTmp.length; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return true;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == _board.length - 1) {
    return false;
  } else {
    return _checkGameVertical(
      positonStart: positonStart + 1,
      positionEnd: positionEndTmp + 1,
    );
  }
}

void _resetGame() {
  currentMoves = 0;
  status = '';
  _board = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  _turn = 'First Move: X';
  loading = false;
}

//------------------------------ Alerts Dialog --------------------------------------

void awaitfnn() async {
  bool result = await _showAlertBox(
      _context, '$winner won!', 'Start a new Game?', 'Exit', 'New Game');
  if (result) {
    _gamePageState.setState(() {
      _resetGame();
    });
  } else {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}

Future<bool> _showAlertBox(BuildContext context, String title, String content,
    String btn1, String btn2) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _context) => AlertDialog(
            title: Text(title.toUpperCase()),
            content: Text(content),
            actions: <Widget>[
              RaisedButton(
                color: Colors.white,
                child: Text(btn1),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              RaisedButton(
                color: Colors.white,
                child: Text(btn2),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ));
}

awaitfn(String title, String content, String btn1, String btn2) async {
  bool result = await _showAlertBox(_context, title, content, btn1, btn2);
  if (result) {
    _gamePageState.setState(() {
      _resetGame();
    });
  }
}

//------------------------------ MIN-MAX ------------------------------------------
//function return score
dynamic _checkDiagonallyLeftToRightScore2({
  int positonStart = 0,
  int positionEnd = 24,
  int lenght = 5,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  int lenghtTmp = lenght;
  for (int i = positonStartTmp; i <= positionEnd; i += 6) {
    _boardTmp.add(_board[i]);
  }
  try {
    for (int i = 0; i < lenght; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return winner == player ? 50 : -50;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == 4) {
    return false;
  } else {
    return _checkDiagonallyLeftToRightScore2(
      positonStart: positonStartTmp + 1,
      lenght: lenghtTmp - 1,
      positionEnd: positionEndTmp - 5,
    );
  }
}

//check nữa dưới bàn cờ theo hàng xéo từ trái qua phải
dynamic _checkDiagonallyLeftToRightScore1({
  int positonStart = 5,
  int positionEnd = 23,
  int lenght = 4,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  int lenghtTmp = lenght;
  for (int i = positonStartTmp; i <= positionEnd; i += 6) {
    _boardTmp.add(_board[i]);
  }
  try {
    for (int i = 0; i < lenght; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return winner == player ? 50 : -50;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == 20) {
    return false;
  } else {
    return _checkDiagonallyLeftToRightScore1(
      positonStart: positonStartTmp + 5,
      lenght: lenghtTmp - 1,
      positionEnd: positionEndTmp - 1,
    );
  }
}

//check nữa trên bàn cờ theo hàng xéo từ phải qua trái
dynamic _checkDiagonallyRightToLeftScore2({
  int positonStart = 4,
  int positionEnd = 20,
  int lenght = 5,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  int lenghtTmp = lenght;
  for (int i = positonStartTmp; i <= positionEnd; i += 4) {
    _boardTmp.add(_board[i]);
  }
  try {
    for (int i = 0; i < lenght; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return winner == player ? 50 : -50;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == 0) {
    return false;
  } else {
    return _checkDiagonallyRightToLeftScore2(
      positonStart: positonStartTmp - 1,
      lenght: lenghtTmp - 1,
      positionEnd: positionEndTmp - 5,
    );
  }
}

//check nữa dưới bàn cờ theo hàng xéo từ phải qua trái
dynamic _checkDiagonallyRightToLeftScore1({
  int positonStart = 9,
  int positionEnd = 21,
  int lenght = 4,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  int lenghtTmp = lenght;
  for (int i = positonStartTmp; i <= positionEnd; i += 4) {
    _boardTmp.add(_board[i]);
  }
  try {
    for (int i = 0; i < lenght; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return winner == player ? 50 : -50;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == _board.length - 1) {
    return false;
  } else {
    return _checkDiagonallyRightToLeftScore1(
      positonStart: positonStartTmp + 5,
      lenght: lenghtTmp - 1,
      positionEnd: positionEndTmp + 1,
    );
  }
}

dynamic _checkGameHorizontalScore({
  int positonStart = 0,
  int positionEnd = 4,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  for (int i = positonStartTmp; i <= positionEndTmp; i++) {
    _boardTmp.add(_board[i]);
  }

  try {
    for (int i = 0; i < _boardTmp.length; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return winner == player ? 50 : -50;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == _board.length - 1) {
    return false;
  } else {
    return _checkGameHorizontal(
      positonStart: positionEndTmp + 1,
      positionEnd: positionEndTmp + 5,
    );
  }
}

dynamic _checkGameVerticalScore({
  int positonStart = 0,
  int positionEnd = 20,
}) {
  List<String> _boardTmp = [];
  int positonStartTmp = positonStart;
  int positionEndTmp = positionEnd;
  for (int i = positonStartTmp; i <= positionEndTmp; i += 5) {
    _boardTmp.add(_board[i]);
  }
  // chổ này khi i <3 nó sẽ tự cộng cộng lên 1 hoặc 2 để kiểm tra mấy thằng cuối chứ i mà bằng cuối là nhảy ra khỏi mảng
  try {
    for (int i = 0; i < _boardTmp.length; i++) {
//      print("i $i");
      if (_boardTmp[i] != '' &&
          _boardTmp[i] == _boardTmp[i + 1] &&
          _boardTmp[i + 1] == _boardTmp[i + 2]) {
        winner = _boardTmp[i];
        return (winner == player) ? 50 : -50;
      }
    }
  } catch (err) {
    return false;
  }
  if (positionEndTmp == _board.length - 1) {
    return false;
  } else {
    return _checkGameVertical(
      positonStart: positonStart + 1,
      positionEnd: positionEndTmp + 1,
    );
  }
}

int max(int a, int b) {
  return a > b ? a : b;
}

int min(int a, int b) {
  return a < b ? a : b;
}

String player = 'x', opponent = 'o';

bool isMovesLeft(List<String> _board) {
  int i;
  for (i = 0; i < 25; i++) {
    if (_board[i] == '') return true;
  }
  return false;
}

int _eval(List<String> _board) {
  dynamic checkGameHorizontalScore = _checkGameHorizontalScore();
  dynamic checkGameVerticalScore = _checkGameVerticalScore();
  dynamic checkDiagonallyRightToLeftScore2 =
      _checkDiagonallyRightToLeftScore2();
  dynamic checkDiagonallyRightToLeftScore1 =
      _checkDiagonallyRightToLeftScore1();
  dynamic checkDiagonallyLeftToRightScore2 =
      _checkDiagonallyLeftToRightScore2();
  dynamic checkDiagonallyLeftToRightScore1 =
      _checkDiagonallyLeftToRightScore1();
  if (checkGameHorizontalScore.runtimeType != bool) {
    return checkGameHorizontalScore;
  }
  if (checkGameVerticalScore.runtimeType != bool) {
    return checkGameVerticalScore;
  }
  if (checkDiagonallyRightToLeftScore2.runtimeType != bool) {
    return checkDiagonallyRightToLeftScore2;
  }
  if (checkDiagonallyRightToLeftScore1.runtimeType != bool) {
    return checkDiagonallyRightToLeftScore1;
  }
  if (checkDiagonallyLeftToRightScore2.runtimeType != bool) {
    return checkDiagonallyLeftToRightScore2;
  }
  if (checkDiagonallyLeftToRightScore1.runtimeType != bool) {
    return checkDiagonallyLeftToRightScore1;
  }
  return 0;
}

// deth = 0, isMax = false
//, int depth
int minmax(List<String> _board, bool isMax) {
  int score = _eval(_board);
  int best = 0;

  if (score == 50 || score == -50) return score;
  //if (!isMovesLeft(_board)) return 0;
  if (isMax) {
    best = -1000000;
    for (int i = 0; i < 25; i++) {
      if (_board[i] == '') {
        // gán vào để tính giá trị min max mới
        _board[i] = player;
        //, depth + 1
        best = max(best, minmax(_board, !isMax));
        // remove giá trị mới gán để giữ nguyên list ban đầu
        _board[i] = '';
        print("Best Max, $best index, $i loop ${testLoop++}");
      }
    }
    return best;
  } else {
    best = 1000000;
    for (int i = 0; i < 25; i++) {
      if (_board[i] == '') {
        _board[i] = opponent;
        //, depth + 1
        best = min(best, minmax(_board, !isMax));
        _board[i] = '';
        print("best min $best, index $i, loop${testLoop++}");
      }
    }
    return best;
  }
}

int _bestMove(List<String> _board) {
  int bestMove = -1000000, moveVal;
  int i, bi;
  for (i = 0; i < 25; i++) {
    print("Lan lap $i");
    if (_board[i] == '') {
      moveVal = -1000000;
      _board[i] = player;
      // 0,
      moveVal = minmax(_board, false);
      // Lặp không return đc giá trị này luôn
      print("moveVal $moveVal");
      _board[i] = '';
      if (moveVal > bestMove) {
        bestMove = moveVal;
        bi = i;
      }
    }
  }
  _board[bi] = player;
  _gamePageState.setState(() {});
  loading = false;
  _turnState.setState(() {
    _turn = 'Turn: X';
    currentMoves++;
  });
  return bestMove;
}
