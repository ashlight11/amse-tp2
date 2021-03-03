import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'HomePage.dart';
import 'exo6.dart';

/* ------------------------------------------
Permet de déplacer des morceaux d'images entre eux selon une sélection initiale

Taille du plateau variable à l'aide du slider sous le plateau
--------------------------------------------- */

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
  Tile tile;
  bool isEmpty = false;
  bool isNextToEmpty = false;
  double nbOfTiles;
  int id;

  TileWidget(this.tile, this.nbOfTiles, this.id);

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

class Exo7bWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Exo7bWidget();
}

class _Exo7bWidget extends State<Exo7bWidget> {
  double _currentNbOfTiles = 3;
  List<TileWidget> tiles = [];
  bool inPlay = false;

  _Exo7bWidget() {
    this.tiles = List<TileWidget>.generate(
        (_currentNbOfTiles * _currentNbOfTiles).toInt(), (index) {
      return TileWidget(
          createTiles(_currentNbOfTiles)[index], _currentNbOfTiles, index);
    });
  }

  void emptyTheWidget(int index) {
    tiles[index].isEmpty = true;

    if (index - _currentNbOfTiles >= 0) {
      tiles[index - _currentNbOfTiles.toInt()].isNextToEmpty = true;
    }
    if (index - 1 >= 0 &&
        ((index - 1) % _currentNbOfTiles) != _currentNbOfTiles - 1) {
      tiles[index - 1].isNextToEmpty = true;
    }
    if (index + 1 < tiles.length && ((index + 1) % _currentNbOfTiles) != 0) {
      tiles[index + 1].isNextToEmpty = true;
    }
    if (index + _currentNbOfTiles < tiles.length) {
      tiles[index + _currentNbOfTiles.toInt()].isNextToEmpty = true;
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
    if (position - _currentNbOfTiles >= 0) {
      tiles[position - _currentNbOfTiles.toInt()].isNextToEmpty = false;
    }
    if (position - 1 >= 0 &&
        ((position - 1) % _currentNbOfTiles) != _currentNbOfTiles - 1) {
      tiles[position - 1].isNextToEmpty = false;
    }
    if (position + 1 < tiles.length &&
        ((position + 1) % _currentNbOfTiles) != 0) {
      tiles[position + 1].isNextToEmpty = false;
    }
    if (position + _currentNbOfTiles < tiles.length) {
      tiles[position + _currentNbOfTiles.toInt()].isNextToEmpty = false;
    }
  }

  void reset(){
    this.tiles = List<TileWidget>.generate(
        (_currentNbOfTiles * _currentNbOfTiles).toInt(), (index) {
      return TileWidget(
          createTiles(_currentNbOfTiles)[index], _currentNbOfTiles, index);
    });
  }

  bool isInOrder() {
    bool res = true;
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].id != i) {
        res = false;
        break; // -> sort dès que la condition est remplie une seule fois
      }
    }
    return res;
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
                          if (inPlay){
                            if (tiles[index].isNextToEmpty == true) {
                              // on inverse les deux tuiles
                              Tile temp = tiles[index].tile;
                              tiles[index].tile = tiles[findTheEmpty()].tile;
                              tiles[findTheEmpty()].tile = temp;

                              // on enlève les précédentes mises en forme
                              cleanTheRest();
                              // on vide le nouveau widget qui sera la tuile vide
                              emptyTheWidget(index);
                            }
                            if (isInOrder()) {
                              // à la suite de quoi, si l'odre est le bon
                              // on fait apparaître une pop-up
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context),
                              );
                            }
                          }
                        });
                        // on affiche de nouveau les widgets
                        rebuildAllChildren(context);
                      },
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _currentNbOfTiles.toInt(),
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: (_currentNbOfTiles * _currentNbOfTiles).toInt(),
                ),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    inPlay = !inPlay; // Gestion de "Jouer" et "Stop"
                    if (inPlay) {
                      // si on joue
                      // mélange des tuiles
                      tiles.shuffle();
                      // on vide un widget aléatoirement
                      emptyTheWidget(random.nextInt(tiles.length));
                    } else {
                      // sinon on arrête et on crée un nouveau plateau
                      reset();
                    }
                  });
                  rebuildAllChildren(context);
                },
                icon: Icon(Icons.play_arrow),
                label: inPlay ? Text("Stop") : Text("Jouer"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    // Gestion de la réduction de la taille du plateau
                    heroTag: "Bouton Moins",
                    onPressed: inPlay
                        ? null
                        : () {
                      setState(() {
                        if (_currentNbOfTiles > 3) {
                          _currentNbOfTiles--;
                          reset();
                        }
                      });
                    },
                    child: Icon(Icons.arrow_downward),
                    backgroundColor: inPlay ? Colors.grey : Colors.lightBlueAccent,
                  ),
                  FloatingActionButton(
                    // Gestion de l'augmentation de la taille du plateau
                    heroTag: "Bouton Plus",
                    onPressed: inPlay
                        ? null
                        : () {
                      setState(() {
                        if (_currentNbOfTiles < 6) {
                          _currentNbOfTiles++;
                          reset();
                        }
                      });
                    },
                    child: Icon(Icons.arrow_upward),
                    backgroundColor: inPlay ? Colors.grey : Colors.deepOrangeAccent,
                  )
                ],
              ),
            ],
          )),
    );
  }
}

// Widget de gestion de la pop-up
Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: Text('Vous avez gagné!'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text("Que souhaitez-vous faire?"),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Retour au menu'),
      ),
      FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Exo7bWidget();
            }));
          },
          child: const Text('Rejouer')),
    ],
  );
}
