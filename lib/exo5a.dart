
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Exo5aWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercice 5a'),
      ),
      body: Center(child :
      GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: Center (child : const Text("Are you, are you, coming to the tree?", textAlign: TextAlign.center)),
            color: Colors.teal[100],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Center (child : const Text("They strung up a man,", textAlign: TextAlign.center)),
            color: Colors.teal[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Center (child : const Text("They said who murdered three", textAlign: TextAlign.center)),
            color: Colors.teal[300],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Center (child : const Text("Strange things did happen here", textAlign: TextAlign.center)),
            color: Colors.teal[400],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Center (child : const Text("No stranger would it be", textAlign: TextAlign.center)),
            color: Colors.teal[500],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Center (child : const Text("If we met at midnight, in the hanging tree", textAlign: TextAlign.center)),
            color: Colors.teal[600],
          ),
        ],
      )),
    );
  }
}