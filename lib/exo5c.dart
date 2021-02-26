import 'package:flutter/material.dart';

String image = 'https://picsum.photos/512/1024';

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

class Exo5cWidget extends StatefulWidget {
  @override
  State<Exo5cWidget> createState() => _Exo5cWidget();
}

List<Tile> createTiles(double nbTiles) {
  List<Tile> res = [];
  for (double i = -1; i <= 1; i += 2 / (nbTiles-1)) {
    // boucle y
    for (double j = -1; j <= 1; j += 2 / (nbTiles-1)) {
      // boucle x
        res.add(new Tile(imageURL: image, alignment: Alignment(j, i)));
    }
  }
  return res;
}

class _Exo5cWidget extends State<Exo5cWidget> {
  double _currentSliderValue = 3;

  Widget createTileWidgetFrom(Tile tile) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: InkWell(child: tile.croppedImageTile(_currentSliderValue)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercice 5c'),
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
                crossAxisCount: _currentSliderValue.toInt(),
                children: List.generate(
                    (_currentSliderValue * _currentSliderValue).toInt(),
                    (index) {
                  return createTileWidgetFrom(
                      createTiles(_currentSliderValue)[index]);
                })),
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
