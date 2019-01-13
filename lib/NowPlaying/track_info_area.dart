import 'dart:math';
import 'package:flutter/material.dart';

class TrackInfoArea extends StatefulWidget
{
  final double blurValue;
  final String name;
  final String album;
  final String artist;
  final String path;

  TrackInfoArea({
    Key key,
    @required this.blurValue,
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
              padding: const EdgeInsets.only(top: 70.0, left: 20.0, bottom: 5.0, right: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          text: widget.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            background: Paint()..color = Theme.of(context).primaryColor,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                            text: widget.album.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', '') ?? '(Album)',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              background: Paint()..color = Theme.of(context).primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 4.0,
                              height: 1.0
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          text: widget.artist.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', '') ?? '(Artist)',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            background: Paint()..color = Theme.of(context).primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 4.0,
                            height: 2.0
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              )
            ),
          ),
        ),
      ),
    );
  }

}