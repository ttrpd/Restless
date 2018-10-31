

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TrackInfoArea extends StatefulWidget {

  double blurValue;

  TrackInfoArea({
    Key key,
    @required this.blurValue,
  }) : super(key: key);

  @override
  TrackInfoAreaState createState() {
    return new TrackInfoAreaState();
  }
}

class TrackInfoAreaState extends State<TrackInfoArea> {

  @override
  Widget build(BuildContext context) {
    return Center(// album art area
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              //TODO: make width of screen
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/art5.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: widget.blurValue,
                        sigmaY: widget.blurValue
                    ),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                    ),
                  ),
                  Opacity(
                    opacity: pow(widget.blurValue, 2)/256.0,
                    child: Container(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0, bottom: 5.0),
                        child: RichText(

                          text: TextSpan(
                            text: '',
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Track Name\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  background: Paint(),
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  height: 3.0
                                ),
                              ),
                              TextSpan(
                                text: 'Album\n',
                                style: TextStyle(
                                    color: Colors.white,
                                    background: Paint(),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 4.0,
                                    height: 1.0
                                ),
                              ),
                              TextSpan(
                                text: 'Artist\n',
                                style: TextStyle(
                                    color: Colors.white,
                                    background: Paint(),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 4.0,
                                    height: 1.0
                                ),
                              ),
                            ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}