import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'views/mainMenu.dart';
import 'views/camara.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/camera': (context) => CameraView(camera: firstCamera),
      },
      title: 'NOVISPRO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    )
  );
}
