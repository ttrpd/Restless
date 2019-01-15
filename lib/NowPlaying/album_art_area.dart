import 'dart:ui';

import 'package:flutter/material.dart';

class AlbumArtArea extends StatefulWidget {

  final double blurValue;
  final ImageProvider img;
  
  AlbumArtArea({
    Key key,
    @required this.blurValue,
    @required this.img,
  }) : super(key: key);

  @override
  AlbumArtAreaState createState() {
    return new AlbumArtAreaState();
  }
}

class AlbumArtAreaState extends State<AlbumArtArea> {

  ImageProvider albumArt;

  @override
  Widget build(BuildContext context) {

    return Center(// album art
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: _buildAlbumArt(widget.img),

          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(ImageProvider albumArt) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(// use FutureBuilder here
          image: albumArt ?? AssetImage('lib/assets/default.jpg'),
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
    );
  }
}