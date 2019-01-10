import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restless/AlbumPage/song_sliver.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/artist_data.dart';


class AlbumPage extends StatefulWidget {

  ArtistData artist;

  AlbumPage({
    Key key,
    @required this.artist,
  }) : super(key: key);


  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {

  

  int i = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 3000),
            child: Container(//blurred background image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.artist.albums[i].albumArt ?? AssetImage('lib/assets/art8.jpg'),
                  fit: BoxFit.fitHeight,
                )
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                ),
              ),
            ),
          ),
          PageView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: widget.artist.albums.length,
            onPageChanged: (index) {
              setState(() {
                this.i = index;                
              });
            },
            itemBuilder: (BuildContext context, int index) {
              
              return AlbumSongsPage(widget: widget, index: index,);
            },
          )
        ],
      ),
    );
  }
}

class AlbumSongsPage extends StatefulWidget {
  const AlbumSongsPage({
    Key key,
    @required this.widget,
    @required this.index,
  }) : super(key: key);

  final AlbumPage widget;
  final int index;

  @override
  AlbumSongsPageState createState() {
    return new AlbumSongsPageState();
  }
}

class AlbumSongsPageState extends State<AlbumSongsPage> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 70.0, bottom: 50.0),
              child: RichText(
                textAlign: TextAlign.center,
                maxLines: 3,
                text: TextSpan(
                  text: widget.widget.artist.albums[widget.index].name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    background: Paint()..color = Theme.of(context).primaryColor,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    height: 1.0
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 35.0, right: 35.0, bottom: 20.0),
            child: Container(
              color: Colors.transparent,
              height: widget.widget.artist.albums[widget.index].songs.length * 44.0,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.widget.artist.albums[widget.index].songs.length,
                itemBuilder: (BuildContext context, int i) {
                  return SongSliver(
                    albumIndex: widget.index, 
                    songIndex: i, 
                    artist: widget.widget.artist,
                    onClick: () {
                      if(NowPlayingProvider.of(context).track == widget.widget.artist.albums[widget.index].songs[i])
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
                        NowPlayingProvider.of(context).pause();
                        // NowPlayingProvider.of(context).audioPlayer.setUrl(
                        //   widget.widget.artist.albums[widget.index].songs[i].path
                        // );
                        NowPlayingProvider.of(context).track = widget.widget.artist.albums[widget.index].songs[i];
                        
                        NowPlayingProvider.of(context).playQueue.clear();
                        NowPlayingProvider.of(context).playQueue.add(
                          NowPlayingProvider.of(context).track
                        );

                        NowPlayingProvider.of(context).playQueue.addAll(
                          widget.widget.artist.albums[widget.index].songs.sublist(i+1)
                        );

                        setState(() {
                          NowPlayingProvider.of(context).playCurrentTrack();
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
