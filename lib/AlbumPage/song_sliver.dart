import 'dart:ui';
import 'package:restless/music_provider.dart';
import 'package:restless/MusicLibrary/artist_data.dart';
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
  
  Widget getSongNumberIcon(BuildContext context) {
    if(NowPlayingProvider.of(context).track == widget.track && NowPlayingProvider.of(context).playing)
    {
      return Icon(
        Icons.pause,
        color: Theme.of(context).accentColor,
      );
    }
    else if (NowPlayingProvider.of(context).track == widget.track && !NowPlayingProvider.of(context).playing)
    {
      return Icon(
        Icons.play_arrow,
        color: Theme.of(context).accentColor,
      );
    }
    else
    {
      return RichText(
        maxLines: 1,
        overflow: TextOverflow.clip,
        text: TextSpan(
          text: (widget.index+1).toString(),
          style: TextStyle(
            fontFamily: 'Oswald',
            fontWeight: FontWeight.normal,
            color: Theme.of(context).accentColor,
            fontSize: 18.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: widget.onClick,
        child: Row(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 50.0,
              alignment: Alignment.center,
              child: getSongNumberIcon(context),
            ),
            Expanded(
              // fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
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
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: widget.track.artistName,
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.playlist_add,
                color: Theme.of(context).accentColor,
              ),
              onPressed: (){
                setState(() {
                  NowPlayingProvider.of(context).playQueue.add(widget.track);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// secondaryActions: <Widget>[
//         IconSlideAction(
//           color: Theme.of(context).accentColor,
//           icon: Icons.playlist_add,
//           onTap: (){
//             setState(() {
//               NowPlayingProvider.of(context).playQueue.add(widget.track);
//             });
//           },
//         ),
//         IconSlideAction(
//           color: Theme.of(context).primaryColorDark,
//           icon: Icons.more_horiz,
//           onTap: (){},
//         ),
//       ],