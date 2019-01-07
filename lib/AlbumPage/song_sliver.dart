import 'dart:ui';
import 'package:restless/artist_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/AlbumPage/album_page.dart';

class SongSliver extends StatefulWidget {

  const SongSliver({
    Key key,
    @required this.songIndex,
    @required this.albumIndex,
    @required this.artist,
  }) : super(key: key);
  
  final int songIndex;
  final int albumIndex;
  final ArtistData artist;
  
  
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
              onPressed: () {
                setState(() {
                  if(NowPlayingProvider.of(context).track == widget.artist.albums[widget.albumIndex].songs[widget.songIndex])
                  {
                    if(NowPlayingProvider.of(context).playing) {
                      NowPlayingProvider.of(context).audioPlayer.pause();
                    }
                    else
                    {
                      NowPlayingProvider.of(context).audioPlayer.resume();
                    }
                    setState(() {
                      NowPlayingProvider.of(context).playing = !NowPlayingProvider.of(context).playing;
                    });
                  }
                  else
                  {
                    NowPlayingProvider.of(context).playing = false;
                    NowPlayingProvider.of(context).audioPlayer.setUrl(
                      widget.artist.albums[widget.albumIndex].songs[widget.songIndex].path
                    );
                    NowPlayingProvider.of(context).track = widget.artist.albums[widget.albumIndex].songs[widget.songIndex];
                    NowPlayingProvider.of(context).audioPlayer.play(
                      widget.artist.albums[widget.albumIndex].songs[widget.songIndex].path
                    );

                    setState(() {
                      NowPlayingProvider.of(context).playing = true;
                    });

                    if(NowPlayingProvider.of(context).playQueue != null)
                    {
                      NowPlayingProvider.of(context).playQueue.clear();
                      NowPlayingProvider.of(context).playQueue.addAll(
                        widget.artist.albums[widget.albumIndex].songs.sublist(widget.songIndex+1)
                      );
                    }
                    else
                    {
                      // NowPlayingProvider.of(context).playQueue = new List<TrackData>();
                      NowPlayingProvider.of(context).playQueue += widget.artist.albums[widget.albumIndex].songs.sublist(widget.songIndex+1).reversed;
                    }

                    if(NowPlayingProvider.of(context).playedQueue.length < 1)
                    {
                      NowPlayingProvider.of(context).playedQueue += widget.artist.albums[widget.albumIndex].songs.sublist(widget.songIndex-1).reversed;
                    }
                  }
                });
              },
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