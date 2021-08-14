import 'package:flutter/material.dart';
import 'package:orders_app/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders App',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
