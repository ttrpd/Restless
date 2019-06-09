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
    return Container(
      color: Theme.of(context).accentColor,
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.artist.albums.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4, bottom: 20.0, left: 20.0, right: 20.0),
                  child: Material(
                    elevation: 10.0,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        padding: EdgeInsets.only(top: 70.0),
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 40.0,
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: widget.artist.albums[i].name,
                                  style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: widget.artist.albums[i].songs.length,
                                  itemBuilder: (BuildContext context, int j) {
                                    return SongSliver(
                                      index: j,
                                      album: widget.artist.albums[i],
                                      track: widget.artist.albums[i].songs[j],
                                      onClick: (){
                                        if(NowPlayingProvider.of(context).track == widget.artist.albums[i].songs[j])
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
                                          setState(() {
                                            NowPlayingProvider.of(context).track = widget.artist.albums[i].songs[j];
                                          });
                                          NowPlayingProvider.of(context).playQueue.clear();
                                          NowPlayingProvider.of(context).playQueue.add(
                                            NowPlayingProvider.of(context).track
                                          );
                                          NowPlayingProvider.of(context).playQueue.addAll(
                                            widget.artist.albums[i].songs.sublist(j+1)
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
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
                  child: Material(
                    elevation: 10.0,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: widget.artist.albums[i].albumArt
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  
}