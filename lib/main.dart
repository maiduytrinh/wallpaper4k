import 'package:flutter/material.dart';
import 'package:wallpaper_guru/views/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const HomeScreen(),
    );
  }
}

