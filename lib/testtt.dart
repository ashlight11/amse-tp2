import 'package:flutter/material.dart';
import 'dart:math' as math;

// ==============
// Models
// ==============

math.Random random = new math.Random();

// Tile of random color

class Tile {
  Color color;

  Tile(this.color);

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
  String text;
  bool isEmpty = false;

  TileWidget(this.tile, this.text);

  @override
  Widget build(BuildContext context) {
    return createColoredTileWithText();
  }

  Widget createColoredTileWithText() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isEmpty ? myEmptyBoxDecoration() : myBoxDecoration(),
      child: Center(child: Text(text, textAlign: TextAlign.center)),
    );
  }

  BoxDecoration myEmptyBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.red, width: 12),
      color: Colors.white,
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      color: tile.color,
    );
  }
}

bool oneIsEmpty(List<TileWidget> list) {
  bool res = false;
  for (int i = 0; i < list.length; i++) {
    if (list[i].isEmpty == true) {
      res = true;
    }
  }
  return res;
}

bool isNextToEmpty(TileWidget tileToVerify) {}

class PositionedTiles2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles2> {
  double _currentSliderValue = 3;
  List<TileWidget> tiles = List<TileWidget>.generate(16, (index) {
    return TileWidget(Tile.randomColor(), "Tile $index");
  });

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
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onTap: () {
                    setState(() {
                      if (tiles[index].isEmpty == false && !oneIsEmpty(tiles)) {
                        tiles.insert(
                            index, TileWidget(Tile(Colors.white), "Empty"));
                        tiles[index].isEmpty = true;
                      }
                      debugPrint((tiles[index].isEmpty).toString());
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
    );
  }

  swapTiles() {
    setState(() {
      tiles.insert(6, tiles.removeAt(7));
    });
  }
}
