import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restless/AlbumPage/song_sliver.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/artist_data.dart';
import 'package:restless/diamond_frame.dart';


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
      color: Theme.of(context).accentColor,//Color.fromARGB(255, 220, 220, 220),
      child: PageView.builder(
        itemCount: widget.artist.albums.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 90.0),
                child: DiamondFrame(
                  height: 140.0,
                  padding: 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.artist.albums.elementAt(index).albumArt,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 10.0, left: 30.0, right: 30.0),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: widget.artist.albums.elementAt(index).name,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 36.0,
                      fontFamily: 'Inconsolata',
                      fontStyle: FontStyle.normal
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.artist.albums.elementAt(index).songs.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                      child: Container(
                        height: 40.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100.0)),
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                                child: Container(
                                  color: Theme.of(context).accentColor,
                                  child: Material(
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          splashColor: Colors.black12,
                                          onPressed: (){
                                            if(NowPlayingProvider.of(context).track == widget.artist.albums[index].songs[i])
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
                                              NowPlayingProvider.of(context).track = widget.artist.albums[index].songs[i];
                                              NowPlayingProvider.of(context).playQueue.clear();
                                              NowPlayingProvider.of(context).playQueue.add(
                                                NowPlayingProvider.of(context).track
                                              );
                                              NowPlayingProvider.of(context).playQueue.addAll(
                                                widget.artist.albums[index].songs.sublist(i+1)
                                              );
                                              setState(() {
                                                NowPlayingProvider.of(context).playCurrentTrack();
                                              });
                                            }
                                          },
                                          iconSize: 20.0,
                                          icon: (NowPlayingProvider.of(context).track == widget.artist.albums.elementAt(index).songs.elementAt(i) && NowPlayingProvider.of(context).playing)?Icon(Icons.pause):Icon(Icons.play_arrow),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text: widget.artist.albums.elementAt(index).songs.elementAt(i).name,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Inconsolata',
                                                fontStyle: FontStyle.normal,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: RichText(
                                            text: TextSpan(
                                              text: '0:00',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Inconsolata',
                                                fontStyle: FontStyle.normal,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  
}

