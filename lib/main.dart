import 'package:flutter/material.dart';
import 'package:tv_app/screens/netflix_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV App',
      theme: ThemeData.dark(),
      home: NetflixLikeUI(),
    );
  }
}
