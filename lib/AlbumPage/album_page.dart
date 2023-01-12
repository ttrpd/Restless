import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restless/AlbumPage/song_sliver.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/MusicLibrary/artist_data.dart';


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

  playSong(BuildContext context, int i, int j)
  {
    NowPlayingProvider.of(context).pause();
    setState(() {
      NowPlayingProvider.of(context).track = widget.artist.albums[i].songs[j];
    });
    NowPlayingProvider.of(context).playQueue.clear();
    
    NowPlayingProvider.of(context).playQueue.addAll(
      widget.artist.albums[i].songs.sublist(j)
    );
    setState(() {
      NowPlayingProvider.of(context).playCurrentTrack();
    });
  }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.artist.albums.length,
        itemBuilder: (BuildContext context, int i)
        {
          return Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.artist.albums[i].albumArt,
                      ),
                    ),
                    foregroundDecoration: BoxDecoration(
                      color: Color.fromARGB(80, 0, 0, 0)
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.7),
                        end: Alignment.topCenter,
                        colors: [
                          const Color(0xFF000000),
                          const Color(0x00000000),
                        ],
                      )
                    ),
                  ),
                ],
              ),
              
              SafeArea(
                child: Column(
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, top: 10.0),
                        alignment: Alignment.topLeft,
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Theme.of(context).accentColor,
                              iconSize: 26.0,
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget.artist.name,
                                style: TextStyle(
                                  fontFamily: 'Oswald',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 255, 174, 0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget.artist.albums[i].name,
                                style: TextStyle(
                                  fontFamily: 'Oswald',
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.075,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child: InkWell(
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Colors.black,
                                            size: 26.0,
                                          ),
                                          onTap: ()=>playSong(context, i, 0),
                                        ),
                                        color: Color.fromARGB(255, 255, 174, 0),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child: InkWell(
                                          child: Icon(
                                            Icons.playlist_add,
                                            color: Theme.of(context).accentColor,
                                            size: 26.0,
                                          ),
                                          onTap: (){
                                            NowPlayingProvider.of(context).playQueue.addAll(
                                              widget.artist.albums[i].songs
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child: InkWell(
                                          child: Icon(
                                            Icons.add,
                                            color: Theme.of(context).accentColor,
                                            size: 26.0,
                                          ),
                                          onTap: (){},
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: widget.artist.albums[i].songs.length,
                              itemBuilder: (BuildContext context, int j) {
                                return Material(
                                  color: Colors.transparent,
                                  child: SongSliver(
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
                                        playSong(context, i, j);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          );
        }
      ),
    );
  }

  
}


