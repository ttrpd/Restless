import 'dart:ui';

import 'package:flutter/material.dart';

class Neighbor extends StatefulWidget
{
  String path;
  double _blurValue = 0.0;

  Neighbor({
    Key key,
    @required this.path,
  }) : super(key: key);

  @override
  NeighborState createState() {
    return new NeighborState();
  }
}

class NeighborState extends State<Neighbor> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          print('Neighbor Track!');
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.path),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}