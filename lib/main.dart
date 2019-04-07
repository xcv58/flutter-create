import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

var N = 8, M = 30, LEN = M * N;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments 123',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text("Flutter Experiments",
          style: new TextStyle(
            color: Colors.white,
            fontFamily: 'Nunito',
            letterSpacing: 1.0
          ),
        ),
        backgroundColor: new Color(0xFF2979FF),
        centerTitle: true
      ),
      body:new HomeContent()
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

String getContent(n) {
  if (n == -4) {
    return "💀";
  }
  if (n == -2 || n == -3) {
    return "💣";
  }
  if (n > 0 && n < 9) {
    return n.toString();
  }
  return "";
}

class _HomeContentState extends State<HomeContent>{
  List state = [];
  int finish = 0;
  @override
  void initState() {
    setState(() {
      state = List.generate(LEN, (i) => i < LEN / 5 ? -1 : 0)..shuffle();
      finish = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var buttons = List.from(state.asMap().keys).map((i) => ButtonTheme(
      // minWidth: 36,
      // height: 36,
      child: GestureDetector(
        onLongPress: () {
          debugPrint('long press');
          // -1 is unchecked
          // -2 is marked correct
          // -3 is marked incorrect
          // -4 is clicked incorrect
          setState(() {
            if (state[i] == -1) {
              state[i] = -2;
            } else if (state[i] == -2 || state[i] == -3) {
              state[i] = 0;
            } else {
              state[i] = -3;
            }
          });
        },
        child: RaisedButton(
          child: Text(getContent(state[i])),
          onPressed: state[i] <= 0 ? () {
            // TODO: if current = -1, fail
            setState(() {
            // TODO: collect number
              if (state[i] == -1) {
                state[i] = -4;
                return finish = -1;
              }
              if (state[i] < -1) {
                return state[i];
              }
              var x = (i / N).toInt(), y = i % N;
              debugPrint('onPressed index: ${i}; ${x}, ${y}');
              var count = 0;
              for (var i = -1; i < 2; i++) {
                for (var j = -1; j < 2; j++) {
                  var xi = x + i, yj = y + j;
                  debugPrint('$xi, $yj');
                  if (xi < 0 || xi >= M) {
                    continue;
                  }
                  if (yj < 0 || yj >= N) {
                    continue;
                  }
                  var neighbor = state[xi*N+yj];
                  debugPrint('$xi, $yj: state[${xi*N+yj}] = $neighbor');
                  count += (neighbor == -1 || neighbor == -2) ? 1 : 0;
                }
              }
              state[i] = count == 0 ? 9 : count;
            });
          } : null,
      ),
      )
    )
    );
    return new Center(
      // child: CustomPaint(
        child: GridView.count(
          crossAxisCount: N,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          // padding: 10,
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
          children: buttons.toList(),
        ),
      // ),
    );
    // return new Center(
    //   child: new Container(
    //     height: 100,
    //     width: 100,
    //     child: new CustomPaint(
    //       foregroundPainter: new MyPainter(
    //           lineColor: Colors.amber,
    //           completeColor: Colors.blueAccent,
    //           completePercent: percentage,
    //           width: 0
    //       ),
    //       child: new Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: new RaisedButton(
    //             color: Colors.purple,
    //             splashColor: Colors.blueAccent,
    //             shape: new RoundedRectangleBorder(),
    //             // shape: new CircleBorder(),
    //             child: new Text("1"),
    //             // onPressed: () { setState(() { percentage += 10.0; if(percentage>100.0){ percentage=0.0; } }); }
    //             // onPressed: null,
    //             onPressed: () { return null; },
    //             ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class MyPainter extends CustomPainter{
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter({this.lineColor,this.completeColor,this.completePercent,this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
        ..color = lineColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center  = new Offset(size.width/2, size.height/2);
    double radius  = min(size.width/2,size.height/2);
    canvas.drawCircle(
        center,
        radius,
        line
    );
    double arcAngle = 2*pi* (completePercent/100);
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: radius),
        -pi/2,
        arcAngle,
        false,
        complete
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
