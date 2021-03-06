import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vision_ucb_frontend/views/camara.dart';
import 'package:vision_ucb_frontend/views/saves.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
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
                      child: Semantics(
                        child: FractionallySizedBox(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Container(
                            margin: EdgeInsets.only(top: statusBarHeight),
                            decoration: myBoxDecorationInfo(),
                          ),
                        ),
                        label: "Información",
                        enabled: false,
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
                              child: Semantics(
                                child: FractionallySizedBox(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: new InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/paper');
                                    },
                                    child: Hero(
                                      tag: 'paper',
                                      child: Container(
                                        decoration: myBoxDecorationPaper(),
                                      ),
                                    ),
                                  ),
                                ),
                                label: "Ingresar a programas guardados",
                              ),
                            ),
                            Flexible(
                              child: Semantics(
                                child: FractionallySizedBox(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: new InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/watch');
                                    },
                                    child: Hero(
                                      tag: 'watch',
                                      child: Container(
                                        decoration: myBoxDecorationWatch(),
                                      ),
                                    ),
                                  ),
                                ),
                                label: "Ingresar al historial",
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
              child: Semantics(
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: new InkWell(
                    onTap: () {
                      _showCamera();
                    },
                    child: Hero(
                      tag: 'eye',
                      child: Container(
                        decoration: myBoxDecorationEye(),
                      ),
                    ),
                  ),
                ),
                label: "Ingresar a la cámara",
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
        image: new AssetImage('img/info.png'),
        fit: BoxFit.none,
      ),
      color: Color(0xFFC2DFE3),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 2.5,
      ),
    );
  }

  BoxDecoration myBoxDecorationPaper() {
    return BoxDecoration(
      image: DecorationImage(
        image: new AssetImage('img/papel_1.png'),
        fit: BoxFit.none,
      ),
      color: Color(0xFFA0D2DB),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 2.5,
      ),
    );
  }

  BoxDecoration myBoxDecorationWatch() {
    return BoxDecoration(
      image: DecorationImage(
        image: new AssetImage('img/reloj_1.png'),
        fit: BoxFit.none,
      ),
      color: Color(0xFFD36582),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 2.5,
      ),
    );
  }

  BoxDecoration myBoxDecorationEye() {
    return BoxDecoration(
      image: DecorationImage(
        image: new AssetImage('img/testigo_1.png'),
        fit: BoxFit.none,
      ),
      color: Color(0xFF6F9BB4),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 2.5,
      ),
    );
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CameraView(camera: camera)));
  }
}
