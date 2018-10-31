

import 'dart:math';

import 'package:flutter/material.dart';

class TrackInfoArea extends StatefulWidget
{
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
  Widget build(BuildContext context)
  {
    return AspectRatio(
      aspectRatio: 1.08,
      child: Container(
        color: Colors.transparent,
        width: double.maxFinite,
        child: Opacity(
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
      ),
    );
  }
}