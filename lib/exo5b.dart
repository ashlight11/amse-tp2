import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp2/exo4.dart';

String image = 'https://picsum.photos/512/1024';
List<Tile> tiles = [
  new Tile(imageURL: image, alignment: Alignment(-1, -1)),
  new Tile(imageURL: image, alignment: Alignment(0, -1)),
  new Tile(imageURL: image, alignment: Alignment(1, -1)),
  new Tile(imageURL: image, alignment: Alignment(-1, 0)),
  new Tile(imageURL: image, alignment: Alignment(0, 0)),
  new Tile(imageURL: image, alignment: Alignment(1, 0)),
  new Tile(imageURL: image, alignment: Alignment(-1, 1)),
  new Tile(imageURL: image, alignment: Alignment(0, 1)),
  new Tile(imageURL: image, alignment: Alignment(1, 1))
];

class Exo5bWidget extends StatelessWidget {
  @override
  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(child: tile.croppedImageTile());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercice 5b'),
      ),
      body: Center(
          child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(4),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[0])),
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[1])),
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[2])),
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[3])),
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[4])),
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[5])),
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[6])),
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[7])),
          Container(
              margin: EdgeInsets.all(4.0),
              child: this.createTileWidgetFrom(tiles[8])),
        ],
      )),
    );
  }
}
