import 'package:flutter/material.dart';

class Exo1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exo1'),
      ),
      body: Center(
          child:
              Container(
                  clipBehavior: Clip.hardEdge,
                  height: 400,
                  decoration: BoxDecoration(color: Colors.white),
                    child: Image.asset('assets/hp.jpg'),
                  )),
          );
  }
}

