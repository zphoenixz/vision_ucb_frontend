import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key key}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
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
                    child: new InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: myBoxDecorationHome(),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: new InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Hero(
                        tag: 'eye',
                        child: Container(
                          decoration: myBoxDecorationEye(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 18,
                child: Container(
                  decoration: myBoxDecoration(),
                )),
            Flexible(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Flexible(
                      flex: 4,
                      child: Hero(
                          tag: 'paper',
                          child: Container(
                            decoration: myBoxDecorationPaper(),
                          ))),
                  Flexible(
                      flex: 3,
                      child: Container(
                        decoration: myBoxDecorationInfo(),
                      )),
                  Flexible(
                    flex: 4,
                    child: Hero(
                      tag: 'watch',
                      child: Container(
                        decoration: myBoxDecorationWatch(),
                      ),
                    ),
                  ),
                ],
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
        width: 5.0,
      ),
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
        width: 5.0,
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
        width: 5.0,
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
        width: 5.0,
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
        width: 5.0,
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
        width: 5.0,
      ),
    );
  }
}
