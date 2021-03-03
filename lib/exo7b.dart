import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'exo6.dart';

/* ------------------------------------------
Jeu du taquin avc des morceaux d'images

Implémente un mélangeur qui garantit que le plateau peut être résolu

-> But du jeu : Recréer l'image initiale
-> Les boutons flèches haut et bas permettent d'ajuster la taille du plateau entre 4 (à des fins de test) et 36 cases
Les boutons sont actifs tant que le joueur ne joue pas
-> Pour commencer à jouer, le joueur doit cliquer sur "Jouer"
-> Le jeu s'arrête à tout moment à l'appui sur le bouton "Stop"
-> Lorsque les cases sont dans le bon ordre, une pop-up apparaît
--------------------------------------------- */

String image = 'https://picsum.photos/512/1024';

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
  double nbOfTiles; // -> contrôler la division de l'image initiale
  int id; // -> identifiant qui permet de savoir si les images sont dans le bon ordre

  TileWidget(this.tile, this.nbOfTiles, this.id);

  @override
  Widget build(BuildContext context) {
    return createTileWidgetFrom(nbOfTiles);
  }

  Widget createTileWidgetFrom(double number) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: (isEmpty || isNextToEmpty) ? myEmptyBoxDecoration() : null,
      child:
          isEmpty ? null : InkWell(child: this.tile.croppedImageTile(number)),
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
  double _currentNbOfTiles = 2; // 2 afin de jouer plus vite
  List<TileWidget> tiles = [];
  bool inPlay = false;
  int _moveCount = 0;

  _Exo7bWidget() {
    this.tiles = List<TileWidget>.generate(
        (_currentNbOfTiles * _currentNbOfTiles).toInt(), (index) {
      return TileWidget(
          createTiles(_currentNbOfTiles)[index], _currentNbOfTiles, index);
    });
  }

  // compte le nombre d'inversions (c-a-d de numéros non à leur place) dans une liste
  int inversionCount(List<TileWidget> list) {
    int res = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].id != i) {
        res++;
      }
    }
    return res;
  }

  // mélange la liste aléatoirement mais garanti que l'on peut résoudre le puzzle
  void mixUp() {
    List<TileWidget> test = tiles;

    // si la largeur du plateau est impaire
    if (_currentNbOfTiles % 2 == 1) {
      // on mélange
      do {
        test.shuffle();
        // tant que le nombre d'inversions est impair (c-a-d tant qu'il n'est pas pair)
      } while (inversionCount(test) % 2 == 1);
    } else {
      // sinon -> largeur paire
      // et case vide sur une ligne paire depuis le bas du tableau
      if ((findTheEmpty() ~/ _currentNbOfTiles) % 2 == 0) {
        do {
          test.shuffle();
          // on veut un nombre d'inversions impair
        } while (inversionCount(test) % 2 == 0);
      } else {
        // case vide sur une ligne impaire
        do {
          test.shuffle();
          // nombre d'inversions pair
        } while (inversionCount(test) % 2 == 1);
      }
    }
    // on affecte la liste résoluble à tiles
    tiles = test;
  }

  // vide le widget
  void emptyTheWidget(int index) {
    tiles[index].isEmpty = true;
  }

  // détermine quels sont les voisins d'une case à une certaine position donnée
  void identifyNeighbours(int position) {
    if (position - _currentNbOfTiles >= 0) {
      tiles[position - _currentNbOfTiles.toInt()].isNextToEmpty = true;
    }
    if (position - 1 >= 0 &&
        ((position - 1) % _currentNbOfTiles) != _currentNbOfTiles - 1) {
      tiles[position - 1].isNextToEmpty = true;
    }
    if (position + 1 < tiles.length &&
        ((position + 1) % _currentNbOfTiles) != 0) {
      tiles[position + 1].isNextToEmpty = true;
    }
    if (position + _currentNbOfTiles < tiles.length) {
      tiles[position + _currentNbOfTiles.toInt()].isNextToEmpty = true;
    }
  }

  // inverse le contenu des tuiles ainsi que leurs identifiants
  void swapTiles(int index) {
    _moveCount ++;
    Tile temp = tiles[index].tile;
    int idTemp = tiles[index].id;
    tiles[index].tile = tiles[findTheEmpty()].tile;
    tiles[index].id = tiles[findTheEmpty()].id;
    tiles[findTheEmpty()].tile = temp;
    tiles[findTheEmpty()].id = idTemp;
  }

  // retourne la position du widget vide
  int findTheEmpty() {
    int res = 0;
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].isEmpty == true) {
        res = i;
      }
    }
    return res;
  }

  // nettoie les alentours de l'ancien widget vide ainsi que lui-même
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

  // génère un nouveau plateau de tuiles non-mélangé
  void reset() {
    _moveCount = 0;
    this.tiles = List<TileWidget>.generate(
        (_currentNbOfTiles * _currentNbOfTiles).toInt(), (index) {
      return TileWidget(
          createTiles(_currentNbOfTiles)[index], _currentNbOfTiles, index);
    });
  }

  // détecte si le puzzle est reconstitué
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
                      if (inPlay) {
                        if (tiles[index].isNextToEmpty == true) {
                          // on inverse les deux tuiles
                          swapTiles(index);
                          // on enlève les précédentes mises en forme
                          cleanTheRest();
                          // on vide le nouveau widget qui sera la tuile vide
                          emptyTheWidget(index);
                          identifyNeighbours(index);
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
                  // on vide un widget aléatoirement
                  emptyTheWidget(random.nextInt(tiles.length));
                  // on mélange les tuiles de manière résoluble
                  mixUp();
                  // on indique les voisins
                  identifyNeighbours(findTheEmpty());
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
                          if (_currentNbOfTiles > 2) {
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
          Text("Déplacements effectués : $_moveCount"),
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
