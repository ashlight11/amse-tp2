import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tp2/HomePage.dart';

/* ------------------------------------------
Jeu du taquin avc des tuiles de couleur

-> But du jeu : Avoir fait apparaître le texte de chaque case afin de recréer l'odre naturel [0,1,2,3....,N]
-> Les boutons flèches haut et bas permettent d'ajuster la taille du plateau entre 9 et 36 cases
Les boutons sont actifs tant que le joueur ne joue pas
-> Pour commencer à jouer, le joueur doit cliquer sur "Jouer"
-> Le jeu s'arrête à tout moment à l'appui sur le bouton "Stop"
-> Lorsque les cases sont dans le bon ordre, une pop-up apparaît

--------------------------------------------- */

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
  Tile tile;
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
      child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isEmpty ? Colors.white : Colors.black,
            ),
          )),
    );
  }

  // Visuel d'une case vide
  BoxDecoration myEmptyBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.red, width: 8),
      color: Colors.white,
    );
  }

// Visuel d'une case normale
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      color: tile.color,
    );
  }
}

// retourne "vrai" dès qu'une case vide est trouvée
// Cela permet de n'avoir qu'une seule case vide sur le plateau
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

// redemande la construction des Widgets
// Puisque l'on modifie l'affichage à la volée
void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

// Génère une liste de Widgets
List<TileWidget> createTiles(double nbTiles) {
  return List<TileWidget>.generate(nbTiles.toInt(), (index) {
    return TileWidget(Tile.randomColor(), "Tile $index");
  });
}

class Exo7Widget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Exo7Widget();
}

class _Exo7Widget extends State<Exo7Widget> {
  double _currentNbOfTiles = 3;
  bool inPlay = false;
  List<TileWidget> tiles = [];

  _Exo7Widget() {
    this.tiles = createTiles(_currentNbOfTiles * _currentNbOfTiles);
  }

  // retourne la position dans la liste "tiles" de l'unique widget vide
  int findTheEmpty() {
    int res = 0;
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].isEmpty == true) {
        res = i;
      }
    }
    return res;
  }

  // vide le widget et crée les voisins déplaçables
  void emptyTheWidget(int index) {
    tiles[index].isEmpty = true;

    if (index - _currentNbOfTiles >= 0) {
      tiles[index - _currentNbOfTiles.toInt()].isNextToEmpty = true;
    }

    if (index - 1 >= 0 &&
        ((index - 1) % _currentNbOfTiles) != _currentNbOfTiles - 1) {
      tiles[index - 1].isNextToEmpty = true;
    } // on vérifie que le -1 n'est pas sur la ligne du dessus

    if (index + 1 < tiles.length && ((index + 1) % _currentNbOfTiles) != 0) {
      tiles[index + 1].isNextToEmpty = true;
    } // on vérifie que le +1 n'est pas sur la ligne du dessous

    if (index + _currentNbOfTiles < tiles.length) {
      tiles[index + _currentNbOfTiles.toInt()].isNextToEmpty = true;
    }
  }

  // appelée s'il y avait un widget vide auparavant
  // retour à la normale du widget précedemment vide
  // retour à la normale des wigdgets précedemment voisins
  void cleanTheRest(int index) {
    int position = findTheEmpty();
    tiles.removeAt(position);
    tiles.insert(position, TileWidget(Tile.randomColor(), "Tile $position"));
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

  // générer une nouvelle liste de tuiles
  void reset() {
    this.tiles = createTiles(_currentNbOfTiles * _currentNbOfTiles);
  }

  // condition de fond pour vérifier le bon/mauvais ordre des tuiles
  bool isInOrder() {
    bool res = true;
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].text != "Tile $i") {
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
        title: Text('Jeu du Taquin'),
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
                            // si le jeu est lancé
                            if (tiles[index].isNextToEmpty == true) {
                              // si on a appuyé sur un voisin
                              // on "nettoie" la tuile précdemment vide et ses voisins
                              cleanTheRest(index);
                              // on vide le nouveau widget selectionné
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
                        // peu importe l'action, on à affiche les tuiles à nouveau
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
              return Exo7Widget();
            }));
          },
          child: const Text('Rejouer')),
    ],
  );
}
