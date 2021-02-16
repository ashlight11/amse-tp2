import 'dart:math';

import 'package:flutter/material.dart';

class Exo2Widget extends StatefulWidget {
  @override
  State<Exo2Widget> createState() => _Exo2Widget();
}

class _Exo2Widget extends State<Exo2Widget> {
  double _rotateAngleDegreeX = 0.2;
  double _rotateAngleDegreeZ = 0.0;
  bool _mirror = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercice 2'),
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(1),
        children: <Widget>[
          Container(
              clipBehavior: Clip.hardEdge,
              height: 400,
              decoration: BoxDecoration(color: Colors.white),
              child: Transform(
                transform: Matrix4(
                  1, 0, 0, 0, // scale X
                  0, 1, 0, 0, // scale Y
                  0, 0, 1, 0,
                  0, 0, 0, 1 // (_size / 100), // scale X&Y
                )
                  ..rotateX(pi / 180 * _rotateAngleDegreeX)
                  ..rotateY(_mirror ? pi : 0)
                  ..rotateZ(pi / 180 * _rotateAngleDegreeZ),
                child: Container (child: Image.asset('assets/hp.jpg'),
                clipBehavior: Clip.hardEdge, decoration: BoxDecoration(color: Colors.white),
                height: 400),
              )),
          Slider(
              value: _rotateAngleDegreeX,
              min: 0,
              max: 360,
              divisions: 10,
              label: _rotateAngleDegreeX.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _rotateAngleDegreeX = value;
                });
              }),
          Slider (value: _rotateAngleDegreeZ,
              min: 0,
              max: 360,
              divisions: 10,
              label: _rotateAngleDegreeZ.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _rotateAngleDegreeZ = value;
                });
              }),
          Switch(value: _mirror, onChanged: (value){
            setState(() {
              _mirror = value;
            });
          })
        ],
      )),
    );
  }
}
