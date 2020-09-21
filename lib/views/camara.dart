import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vision_ucb_frontend/compiler/juin_dart.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CameraView extends StatefulWidget {
  final CameraDescription camera;
  const CameraView({Key key, this.camera}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.veryHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

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
                          decoration: myBoxDecorationEye(),
                        ),
                      ),
                      label: "Volver al menú",
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 18,
              child: Semantics(
                child: Container(
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If the Future is complete, display the preview.
                        return CameraPreview(_controller);
                      } else {
                        // Otherwise, display a loading indicator.
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                excludeSemantics: true,
              ),
            ),
            Flexible(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: Semantics(
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
                      label: "Ingresar a los programas guardados",
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Semantics(
                      child: new InkWell(
                        onTap: () async {
                          // Take the Picture in a try / catch block. If anything goes wrong,
                          // catch the error.
                          try {
                            // Ensure that the camera is initialized.
                            await _initializeControllerFuture;

                            // Construct the path where the image should be saved using the
                            // pattern package.
                            final path = join(
                              // Store the picture in the temp directory.
                              // Find the temp directory using the `path_provider` plugin.
                              (await getTemporaryDirectory()).path,
                              '${DateTime.now()}.jpg',
                            );

                            //TRY COMPRESS

                            // Attempt to take a picture and log where it's been saved.
                            await _controller.takePicture(path);

                            //**Compression ***
                            File compressedFile =
                                await FlutterNativeImage.compressImage(path,
                                    quality: 80, percentage: 100);

                            /*print("Path is "+file.path);
                          var result = await FlutterImageCompress.compressAndGetFile(
                              file.absolute.path, path+"new.jpg",
                              quality: 80,
                              rotate: 180);
                          print(file.lengthSync());
                          print(result.lengthSync());
                          final String path2 = result.path;*/
                            // If the picture was taken, display it on a new screen.

                            //Try to send to API
                            var request = http.MultipartRequest(
                                'POST',
                                Uri.parse(
                                    'https://novispro.herokuapp.com/process/image'));
                            request.files.add(await http.MultipartFile.fromPath(
                                'image', path));
                            var response = await request.send();
                            print('Return of API');
                            print(response.statusCode);
                            String code, output;
                            response.stream
                                .transform(utf8.decoder)
                                .listen((value) {
                              print(value);
                              final JsonResponse = json.decode(value);
                              ResponseAPI rapi =
                                  new ResponseAPI.fromJson(JsonResponse);
                              print(rapi.text);
                              code = rapi.text;

                              output = compile(code.trim().split('\n'));
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Resultado(
                                    code: code, result: output),
                              ),
                            );
                          } catch (e) {
                            // If an error occurs, log the error to the console.
                            print(e);
                          }
                        },
                        child: Container(
                          decoration: myBoxDecorationInfo(),
                        ),
                      ),
                      label: "Tomar fotografía",
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Semantics(
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
                      label: "Ingresar al historial",
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
      //Color(0xFFC2DFE3)
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

//Prueba TTS
class Resultado extends StatefulWidget {
  final String code;
  final String result;
  const Resultado({Key key, this.code, this.result})
      : super(key: key);
  @override
  _Resultado createState() =>_Resultado();
}

enum TtsState { playing, stopped, paused, continued }

class _Resultado extends State<Resultado> {
  FlutterTts flutterTts;
  dynamic languages;
  String language="es-ES";
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.7;
  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        _getEngines();
      }
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (kIsWeb || Platform.isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setLanguage(language);
    setState(() {
      _newVoiceText = "Codigo"+'\n'+widget.code+'\n'+"Salida"+'\n'+widget.result;
    });
    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Resultado Programa'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: _speak,
            ),
            IconButton(
              icon: Icon(
                Icons.pause,
                color: Colors.white,
              ),
              onPressed: _pause,
            ),
            IconButton(
              icon: Icon(
                Icons.stop,
                color: Colors.white,
              ),
              onPressed: _stop,
            )
          ],
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 0, 122, 193),
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              "Codigo",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 103, 218, 255),
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            child: Text(
              widget.code,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 0, 122, 193),
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              "Salida",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 103, 218, 255),
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            child: Text(
              widget.result,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          )
        ],
      ),
      //body: Image.file(File(convertBN(imagePath))),
    );
  }

}

//show Picture

class DisplayPictureScreen extends StatelessWidget {
  final String code;
  final String result;
  const DisplayPictureScreen({Key key, this.code, this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado Programa')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 0, 122, 193),
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              "Codigo",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 103, 218, 255),
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            child: Text(
              code,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 0, 122, 193),
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              "Salida",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 103, 218, 255),
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            child: Text(
              result,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          )
        ],
      ),
      //body: Image.file(File(convertBN(imagePath))),
    );
  }

  String convertBN(String fileName) {
    File file = File(fileName);
    img.Image im = img.decodeImage(file.readAsBytesSync());
    im = img.grayscale(im);
    im = img.invert(im);
    img.encodeJpg(im);
    return fileName;
  }
}

class ResponseAPI {
  String message;
  String text;

  ResponseAPI({this.message, this.text});
  factory ResponseAPI.fromJson(Map<String, dynamic> parsedJson) {
    return ResponseAPI(
        message: parsedJson['message'], text: parsedJson['text']);
  }
}
