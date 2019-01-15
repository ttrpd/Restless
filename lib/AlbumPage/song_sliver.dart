import 'dart:ui';
import 'package:restless/artist_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';

class SongSliver extends StatefulWidget {

  const SongSliver({
    Key key,
    @required this.songIndex,
    @required this.albumIndex,
    @required this.artist,
    @required this.onClick,
  }) : super(key: key);
  
  final int songIndex;
  final int albumIndex;
  final ArtistData artist;
  final void Function() onClick;
  
  
  @override
  SongSliverState createState() {
    return new SongSliverState();
  }
}

class SongSliverState extends State<SongSliver> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 40.0,
        color: Theme.of(context).primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              iconSize: 18,
              icon: Icon((NowPlayingProvider.of(context).playing && NowPlayingProvider.of(context).track.name == widget.artist.albums[widget.albumIndex].songs[widget.songIndex].name)?Icons.pause:Icons.play_arrow, color: Theme.of(context).accentColor), 
              onPressed: widget.onClick,
            ),
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: widget.artist.albums[widget.albumIndex].songs[widget.songIndex].name,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                    height: 1.0
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 16.0),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: '0:00',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.0,
                    height: 1.0
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}