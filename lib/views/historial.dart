import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'camara.dart';

class HistorialView extends StatefulWidget {
  @override
  _HistorialViewState createState() => _HistorialViewState();
}

class _HistorialViewState extends State<HistorialView> {
  @override
  Widget build(BuildContext context) {
    void _showCamera() async {
      final cameras = await availableCameras();
      final camera = cameras.first;

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CameraView(camera: camera)));
    }

    //get status bar height
    double statusBarHeight = MediaQuery.of(context).padding.top;
    //return Scaffold with all containers
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Semantics(
                      child: new InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: Container(
                          decoration: myBoxDecorationHome(),
                        ),
                      ),
                      label: "Volver al menú",
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Semantics(
                      child: new InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: Container(
                          decoration: myBoxDecorationWatch(),
                        ),
                      ),
                      label: "Volver al menú",
                    ),
                  ),
                ],
              ),
            ),
            Flexible(flex: 18, child: Container()),
            Flexible(
              flex: 3,
              child: Semantics(
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
                label: "Ingresar a la cámara",
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.lightBlue, //                   <--- border color
        width: 2.5,
      ),
    );
  }

  BoxDecoration myBoxDecorationInfo() {
    return BoxDecoration(
      image: DecorationImage(
        image: new AssetImage('img/camera_circle.png'),
        fit: BoxFit.scaleDown,
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
        fit: BoxFit.scaleDown,
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
        fit: BoxFit.scaleDown,
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
        fit: BoxFit.scaleDown,
      ),
      color: Color(0xFF6F9BB4),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 2.5,
      ),
    );
  }

  BoxDecoration myBoxDecorationHome() {
    return BoxDecoration(
      image: DecorationImage(
        image: new AssetImage('img/home.png'),
        fit: BoxFit.scaleDown,
      ),
      color: Color(0xFFC2DFE3),
      border: Border.all(
        color: Color(0xFF2050AC), //                   <--- border color
        width: 2.5,
      ),
    );
  }
}
