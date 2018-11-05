

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dart_tags/dart_tags.dart';

class TrackInfoArea extends StatefulWidget
{
  double blurValue;
//  Future<List<Tag>> tags;
  String name;
  String album;
  String artist;
  String path;

  TrackInfoArea({
    Key key,
    @required this.blurValue,
//    this.tags,
    @required this.name,
    @required this.album,
    @required this.artist,
    this.path,
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
              child: _buildTrackInfo(widget.name, widget.album, widget.artist),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackInfo(String name, String album, String artist)
  {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: name,
                style: TextStyle(
                  color: Colors.white,
                  background: Paint(),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  height: 3.0
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: album,
                style: TextStyle(
                  color: Colors.white,
                  background: Paint(),
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 4.0,
                  height: 1.0
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: artist,
                style: TextStyle(
                  color: Colors.white,
                  background: Paint(),
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 4.0,
                  height: 1.0
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }

  Widget _buildPlaceholder()
  {
    return RichText(

      text: TextSpan(
          text: '',
          children: <TextSpan>[
            TextSpan(
              text: widget.path.substring(widget.path.lastIndexOf('/')+1, widget.path.lastIndexOf('.')),
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
    );
  }
}