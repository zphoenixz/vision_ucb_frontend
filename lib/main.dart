import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'views/mainMenu.dart';
import 'views/camara.dart';
import 'views/saves.dart';
import 'views/historial.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/camera': (context) => CameraView(),
        '/paper': (context) => SavesView(),
        '/watch': (context) => HistorialView(),
      },
      title: 'NOVISPRO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
