import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraView extends StatefulWidget {
  final CameraDescription camera;
  const CameraView({Key key,this.camera}) : super(key: key);

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
                    child: new InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/');
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
                        Navigator.pushNamed(context, '/');
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
                )),
            Flexible(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Flexible(
                      flex: 4,
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
                    ),),
                  Flexible(
                    flex: 3,
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
                          File compressedFile = await FlutterNativeImage.compressImage(path,
                          quality: 80,percentage: 100);
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
                          var request = http.MultipartRequest('POST',Uri.parse('https://novispro.herokuapp.com/process/image'));
                          request.files.add(
                            await http.MultipartFile.fromPath(
                              'image',compressedFile.path
                            )
                          );
                          var response = await request.send();
                          print('Return of API');
                          print(response.statusCode);
                          String code;
                          response.stream.transform(utf8.decoder).listen((value){
                            print(value);
                            final JsonResponse = json.decode(value);
                            ResponseAPI rapi = new ResponseAPI.fromJson(JsonResponse);
                            print(rapi.text);
                            code = rapi.text;
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DisplayPictureScreen(code: code),
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
                  ),
                  Flexible(
                    flex: 4,
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

//show Picture

class DisplayPictureScreen extends StatelessWidget {
  final String code;

  const DisplayPictureScreen({Key key, this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Codigo')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Text(code),
      //body: Image.file(File(convertBN(imagePath))),
    );
  }

  String convertBN(String fileName){
    File file = File(fileName);
    img.Image im = img.decodeImage(file.readAsBytesSync());
    im = img.grayscale(im);
    im = img.invert(im);
    img.encodeJpg(im);
    return fileName;
  }

}

class ResponseAPI{
  String message;
  String text;

  ResponseAPI(
  {
    this.message,
    this.text
  });
  factory ResponseAPI.fromJson(Map<String,dynamic> parsedJson){
    return ResponseAPI(
      message: parsedJson['message'],
      text: parsedJson['text']
    );
  }
}