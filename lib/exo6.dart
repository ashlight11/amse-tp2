import 'package:flutter/material.dart';
import 'dart:math' as math;

// ==============
// Models
// ==============

math.Random random = new math.Random();

class Tile {
  Color color;
  String text;

  Tile(this.color, this.text);

  Tile.randomColor() {
    this.color = Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}

// ==============
// Widgets
// ==============

class TileWidget extends StatelessWidget {
  final Tile tile;

  TileWidget(this.tile, String s) {
    tile.text = s;
  }

  @override
  Widget build(BuildContext context) {
    return this.createColoredTileWithText(tile.text);
  }

  Widget createColoredTileWithText(String text) {
    return Container(
      key: UniqueKey(),
      padding: const EdgeInsets.all(8),
      child: Center(child: Text(text, textAlign: TextAlign.center)),
      color: tile.color,
    );
  }
}

class PositionedTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  List<Widget> tiles = List<Widget>.generate(
      16, (index) => TileWidget(Tile.randomColor(), "Tile $index"));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moving Tiles'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(4),
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                crossAxisCount: 4,
                children: tiles),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.sentiment_very_satisfied), onPressed: swapTiles),
    );
  }

  swapTiles() {
    setState(() {
      tiles.insert(6, tiles.removeAt(7));
    });
  }
}
