import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restless/AlbumPage/song_sliver.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/artist_data.dart';


class AlbumPage extends StatefulWidget {

  final ArtistData artist;

  const AlbumPage({
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
      body: PageView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.artist.albums.length,
        onPageChanged: (index) {
          setState(() {
            this.i = index;   
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              AlbumSongsPage(widget: widget, index: index,),
              _buildArt(index),
            ],
          );
        },
      ),
    );
  }

  Widget _buildArt(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Stack(
        children: <Widget>[
          Container(//blurred background image
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.artist.albums[index].albumArt ?? AssetImage('lib/assets/default.jpg'),
                fit: BoxFit.fitHeight,
              )
            ),
            // child: BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            //   child: Container(
            //     decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            //   ),
            // ),
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [
                  0.2,
                  0.4,
                  1.0,
                ],
                colors: [
                  Colors.black54,
                  Colors.black45,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: _buildAlbumName(index),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumName(int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(
          text: widget.artist.albums[index].name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
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
        Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 20.0),
          child: Container(
            color: Theme.of(context).accentColor,
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
                    {//if track is currently playing
                      if(NowPlayingProvider.of(context).playing)
                        NowPlayingProvider.of(context).audioPlayer.pause();
                      else
                        NowPlayingProvider.of(context).audioPlayer.resume();

                      setState(() {
                        NowPlayingProvider.of(context).playing = !NowPlayingProvider.of(context).playing;
                      });
                    }
                    else
                    {
                      NowPlayingProvider.of(context).pause();
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
      ],
    );
  }
}
