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
  bool isNextToEmpty = false;

  TileWidget(this.tile, this.text);

  @override
  Widget build(BuildContext context) {
    return createColoredTileWithText();
  }

  Widget createColoredTileWithText() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: (isEmpty || isNextToEmpty)
          ? myEmptyBoxDecoration()
          : myBoxDecoration(),
      child: Center(child: Text(text, textAlign: TextAlign.center)),
    );
  }

  BoxDecoration myEmptyBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.red, width: 8),
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
      res = !res;
      break;
    }
  }
  return res;
}

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

class PositionedTiles2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles2> {
  double _currentSliderValue = 3;
  List<TileWidget> tiles = List<TileWidget>.generate(16, (index) {
    return TileWidget(Tile.randomColor(), "Tile $index");
  });

  void emptyTheWidget(int index) {
    tiles.removeAt(index);
    tiles.insert(index, TileWidget(Tile(Colors.white), "Empty $index"));
    tiles[index].isEmpty = true;

    if (index - 4 >= 0) {
      tiles[index - 4].isNextToEmpty = true;
    }
    if (index - 1 >= 0 && ((index - 1) % 4) != 3) {
      tiles[index - 1].isNextToEmpty = true;
    }
    if (index + 1 < 16 && ((index + 1) % 4) != 0) {
      tiles[index + 1].isNextToEmpty = true;
    }
    if (index + 4 < 16) {
      tiles[index + 4].isNextToEmpty = true;
    }
  }

  int findTheEmpty() {
    int res = 0;
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].isEmpty == true) {
        res = i;
      }
    }
    return res;
  }

  void cleanTheRest() {
    int position = findTheEmpty();
    tiles.removeAt(position);
    tiles.insert(position, TileWidget(Tile.randomColor(), "Tile $position"));
    tiles[position].isEmpty = false;
    if (position - 4 >= 0) {
      tiles[position - 4].isNextToEmpty = false;
    }
    if (position - 1 >= 0 && ((position - 1) % 4) != 3) {
      tiles[position - 1].isNextToEmpty = false;
    }
    if (position + 1 < 16 && ((position + 1) % 4) != 0) {
      tiles[position + 1].isNextToEmpty = false;
    }
    if (position + 4 < 16) {
      tiles[position + 4].isNextToEmpty = false;
    }
  }

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
                      if (tiles[index].isEmpty == false && !oneIsEmpty(tiles)) {
                        emptyTheWidget(index);
                      }
                      if (tiles[index].isNextToEmpty == true) {
                        cleanTheRest();

                        emptyTheWidget(index);
                      }
                    });
                    rebuildAllChildren(context);
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
}
