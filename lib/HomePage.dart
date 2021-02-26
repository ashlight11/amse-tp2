import 'package:flutter/material.dart';
import 'package:tp2/exo2.dart';
import 'package:tp2/exo5c.dart';
import 'package:tp2/main.dart';
import 'package:tp2/exo1.dart';
import 'package:tp2/exo4.dart';
import 'exo5a.dart';
import 'exo5b.dart';
import 'exo6.dart';
import 'testtt.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildList() {

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: Exercices.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          child: Center(child: _buildRow(Exercices[index])),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildRow(String exercice) {
    return ListTile(
      title: Text(
        exercice,
        style: _biggerFont,
      ),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) {
              switch (exercice) {
            case 'Exercice 1':
              return Exo1Widget();
            case 'Exercice 2':
              return Exo2Widget();
            case 'Exercice 4':
              return Exo4Widget();
            case 'Exercice 5a':
              return Exo5aWidget();
            case 'Exercice 5b':
              return Exo5bWidget();
            case 'Exercice 5c':
              return Exo5cWidget();
            case 'Exercice 6':
              return PositionedTiles2();
            case 'Test':
              return PositionedTiles3();
            default:
              return HomePage();
              break;
          }
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page d'accueil"),
      ),
      body: _buildList(),
    );
  }
}
