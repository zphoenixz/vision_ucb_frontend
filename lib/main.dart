import 'package:flutter/material.dart';
import 'camara.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOVISPRO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'NOVISPRO'),
    );
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
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Container(
                          margin: EdgeInsets.only(top: statusBarHeight),
                          decoration: myBoxDecorationInfo(),
                        ),
                      ),
                    ),
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Container(
                                  decoration: myBoxDecorationPaper(),
                                ),
                              ),
                            ),
                            Flexible(
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Container(
                                  decoration: myBoxDecorationWatch(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Container(
                  decoration: myBoxDecorationEye(),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  BoxDecoration myBoxDecorationInfo() {
    return BoxDecoration(
      image: DecorationImage(
          image: new AssetImage(
              'img/info.png'),
          fit: BoxFit.none,
        ),
      color: Color(0xFFC2DFE3),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 5.0,
      ),
    );
  }
  BoxDecoration myBoxDecorationPaper() {
    return BoxDecoration(
      image: DecorationImage(
          image: new AssetImage(
              'img/papel 1.png'),
          fit: BoxFit.none,
        ),
      color: Color(0xFFA0D2DB),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 5.0,
      ),
    );
  }
  BoxDecoration myBoxDecorationWatch() {
    return BoxDecoration(
      image: DecorationImage(
          image: new AssetImage(
              'img/reloj 1.png'),
          fit: BoxFit.none,
        ),
      color: Color(0xFFD36582),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 5.0,
      ),
    );
  }
  BoxDecoration myBoxDecorationEye() {
    return BoxDecoration(
      image: DecorationImage(
          image: new AssetImage(
              'img/testigo 1.png'),
          fit: BoxFit.none,
        ),
      color: Color(0xFF6F9BB4),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 5.0,
      ),
    );
  }
}
