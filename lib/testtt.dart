import 'package:flutter/material.dart';
import 'dart:math' as math;

String image = 'https://picsum.photos/512/1024';

// ==============
// Models
// ==============

math.Random random = new math.Random();

// Tile : piece of a picture

class Tile {
  String imageURL;
  Alignment alignment;

  Tile({this.imageURL, this.alignment});

  Widget croppedImageTile(double number) {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: this.alignment,
            widthFactor: 1 / number,
            heightFactor: 1 / number,
            child: Image.network(this.imageURL),
          ),
        ),
      ),
    );
  }
}

// ==============
// Widgets
// ==============

class TileWidget extends StatelessWidget {
  final Tile tile;
  bool isEmpty = false;
  bool isNextToEmpty = false;
  double nbOfTiles;

  TileWidget(this.tile, this.nbOfTiles);

  @override
  Widget build(BuildContext context) {
    return createTileWidgetFrom(nbOfTiles);
  }

  Widget createTileWidgetFrom(double number) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: (isEmpty || isNextToEmpty) ? myEmptyBoxDecoration() : null,
      child: InkWell(child: this.tile.croppedImageTile(number)),
    );
  }

  BoxDecoration myEmptyBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.red, width: 5),
    );
  }
}

List<Tile> createTiles(double nbTiles) {
  List<Tile> res = [];
  for (double i = -1; i <= 1; i += 2 / (nbTiles - 1)) {
    // boucle y
    for (double j = -1; j <= 1; j += 2 / (nbTiles - 1)) {
      // boucle x
      res.add(new Tile(imageURL: image, alignment: Alignment(j, i)));
    }
  }
  return res;
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

class PositionedTiles3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles3> {
  double _currentSliderValue = 3;

  List<TileWidget> tiles = List<TileWidget>.generate((9).toInt(), (index) {
    return TileWidget(createTiles(3)[index], 3);
  });

  void emptyTheWidget(int index) {
    tiles[index].isEmpty = true;

    if (index - _currentSliderValue >= 0) {
      tiles[index - _currentSliderValue.toInt()].isNextToEmpty = true;
    }
    if (index - 1 >= 0 &&
        ((index - 1) % _currentSliderValue) != _currentSliderValue - 1) {
      tiles[index - 1].isNextToEmpty = true;
    }
    if (index + 1 < tiles.length && ((index + 1) % _currentSliderValue) != 0) {
      tiles[index + 1].isNextToEmpty = true;
    }
    if (index + _currentSliderValue < tiles.length) {
      tiles[index + _currentSliderValue.toInt()].isNextToEmpty = true;
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
    tiles[position].isEmpty = false;
    if (position - _currentSliderValue >= 0) {
      tiles[position - _currentSliderValue.toInt()].isNextToEmpty = false;
    }
    if (position - 1 >= 0 &&
        ((position - 1) % _currentSliderValue) != _currentSliderValue - 1) {
      tiles[position - 1].isNextToEmpty = false;
    }
    if (position + 1 < tiles.length &&
        ((position + 1) % _currentSliderValue) != 0) {
      tiles[position + 1].isNextToEmpty = false;
    }
    if (position + _currentSliderValue < tiles.length) {
      tiles[position + _currentSliderValue.toInt()].isNextToEmpty = false;
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
                        if (oneIsEmpty(tiles)) {
                          tiles.insert(index, tiles.removeAt(findTheEmpty()));
                        }

                        cleanTheRest();

                        emptyTheWidget(index);
                      }
                    });
                    rebuildAllChildren(context);
                  },
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _currentSliderValue.toInt(),
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: (_currentSliderValue * _currentSliderValue).toInt(),
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
