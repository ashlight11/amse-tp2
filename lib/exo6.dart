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
  bool isTapped = false;

  TileWidget(this.tile, String s) {
    tile.text = s;
  }

  @override
  Widget build(BuildContext context) {
    return createColoredTileWithText(tile.text);
  }

  Widget createColoredTileWithText(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(child: Text(text, textAlign: TextAlign.center)),
      color: tile.color,
    );
  }
}

Widget emptyTheWidget(TileWidget tileToEmpty) {
  tileToEmpty.isTapped = true;
  return Container(
    padding: const EdgeInsets.all(8),
    child: Center(child: Text("Empty tile", textAlign: TextAlign.center)),
    color: Colors.white,
  );
}

bool oneIsEmpty(List<TileWidget> list) {
  bool res = false;
  for (int i = 0; i < list.length; i++) {
    if (list[i].isTapped == true) {
      res = true;
      break;
    }
  }
  return res;
}

/*List<Widget> createTiles(double nbTiles) {
  return List<Widget>.generate(
      (16).toInt(), (index) => TileWidget(Tile.randomColor(), "Tile $index"));
} */

class PositionedTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  double _currentSliderValue = 3;
  List<TileWidget> tiles = List<TileWidget>.generate(
      (16).toInt(), (index) => TileWidget(Tile.randomColor(), "Tile $index"));

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
            child: GridView.builder(
              primary: false,
              padding: const EdgeInsets.all(4),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: tiles[index],
                  onTap: () {
                    setState(() {
                      if (!oneIsEmpty(tiles)) {
                        tiles.insert(index, emptyTheWidget(tiles[index]));
                      }
                    });
                  },
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //TODO : implémenter taille variable
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 16, //TODO : implémenter taille variable
            ),
          ),
          Slider(
              value: _currentSliderValue,
              min: 3,
              max: 6,
              divisions: 3,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              })
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
