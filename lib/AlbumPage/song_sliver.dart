import 'dart:ui';
import 'package:restless/artist_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';

class SongSliver extends StatefulWidget {

  const SongSliver({
    Key key,
    @required this.index,
    @required this.track,
    @required this.album,
    @required this.onClick,
  }) : super(key: key);
  
  final int index;
  final TrackData track;
  final AlbumData album;
  final void Function() onClick;
  
  
  @override
  SongSliverState createState() {
    return new SongSliverState();
  }
}

class SongSliverState extends State<SongSliver> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              (NowPlayingProvider.of(context).track == widget.track && NowPlayingProvider.of(context).playing)?Icons.pause:Icons.play_arrow,
              color: Theme.of(context).accentColor,
            ),
            onPressed: widget.onClick,
          ),
          Flexible(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: widget.track.name,
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).accentColor,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}