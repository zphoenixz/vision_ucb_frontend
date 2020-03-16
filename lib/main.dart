import 'package:flutter/material.dart';
import 'views/mainMenu.dart';
import 'views/camara.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/camera': (context) => CameraView(),
      },
      title: 'NOVISPRO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
