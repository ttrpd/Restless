import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AlbumArtArea extends StatefulWidget {

  double blurValue;

  AlbumArtArea({
    Key key,
    @required this.blurValue,
  }) : super(key: key);

  @override
  AlbumArtAreaState createState() {
    return new AlbumArtAreaState();
  }
}

class AlbumArtAreaState extends State<AlbumArtArea> {

  @override
  Widget build(BuildContext context) {
    return Center(// album art
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/art21.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: widget.blurValue,
                    sigmaY: widget.blurValue
                ),
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}