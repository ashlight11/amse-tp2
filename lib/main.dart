import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

List<String> Exercices = [
  "Exercice 1",
  "Exercice 2",
  "Exercice 4",
  "Exercice 5a",
  "Exercice 5b",
  "Exercice 5c",
  "Exercice 6",
  "Exercice 6b",
  "Jeu du Taquin - 1",
  "Jeu du Taquin - 2"
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


