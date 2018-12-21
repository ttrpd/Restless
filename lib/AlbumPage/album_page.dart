import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

    NowPlayingProvider.of(context).audioPlayer.durationHandler = (Duration d) {
      if(NowPlayingProvider.of(context).endTime != null)
      setState(() {
        NowPlayingProvider.of(context).endTime = d;
      });
    };
    
    NowPlayingProvider.of(context).audioPlayer.positionHandler = (Duration d) {
      setState(() {
        NowPlayingProvider.of(context).currentTime = d;
      });
      NowPlayingProvider.of(context).trackProgressPercent = NowPlayingProvider.of(context).currentTime.inMilliseconds / NowPlayingProvider.of(context).endTime.inMilliseconds;
    };
    NowPlayingProvider.of(context).audioPlayer.completionHandler = () {
      if(NowPlayingProvider.of(context).playQueue != null)
      {
        NowPlayingProvider.of(context).audioPlayer.play(
          NowPlayingProvider.of(context).playQueue.elementAt(0).path
        );
        NowPlayingProvider.of(context).playQueue.removeAt(0);
      }

      setState(() {
        NowPlayingProvider.of(context).trackProgressPercent = 1.0;
        NowPlayingProvider.of(context).playing = false;
      });
    };

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   leading: IconButton(
      //     icon: Icon(Icons.chevron_left),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),
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
                itemBuilder: (BuildContext context, int j) {
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
                            icon: Icon((NowPlayingProvider.of(context).playing && NowPlayingProvider.of(context).track.name == widget.widget.artist.albums[widget.index].songs[j].name)?Icons.pause:Icons.play_arrow, color: Theme.of(context).accentColor), 
                            onPressed: () {
                              setState(() {
                                if(NowPlayingProvider.of(context).track == widget.widget.artist.albums[widget.index].songs[j])
                                {
                                  if(NowPlayingProvider.of(context).playing) {
                                    NowPlayingProvider.of(context).audioPlayer.pause();
                                  }
                                  else {
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
                                    widget.widget.artist.albums[widget.index].songs[j].path
                                  );
                                  NowPlayingProvider.of(context).track = widget.widget.artist.albums[widget.index].songs[j];
                                  NowPlayingProvider.of(context).audioPlayer.play(
                                    widget.widget.artist.albums[widget.index].songs[j].path
                                  );
                                  NowPlayingProvider.of(context).playing = true;
                                  if(NowPlayingProvider.of(context).playQueue != null)
                                  {
                                    NowPlayingProvider.of(context).playQueue.clear();
                                    NowPlayingProvider.of(context).playQueue.addAll(
                                      widget.widget.artist.albums[widget.index].songs.sublist(j+1)
                                    );
                                  }
                                  else
                                  {
                                    // NowPlayingProvider.of(context).playQueue = new List<TrackData>();
                                    NowPlayingProvider.of(context).playQueue += widget.widget.artist.albums[widget.index].songs.sublist(j+1);
                                  }

                                  if(NowPlayingProvider.of(context).playedQueue.length < 1)
                                  {
                                    NowPlayingProvider.of(context).playedQueue += widget.widget.artist.albums[widget.index].songs.sublist(0,j-1);
                                  }
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget.widget.artist.albums[widget.index].songs[j].name,
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
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}


  // Future _getTrackInfo(String path) async {
  //   TagProcessor tp = TagProcessor();
  //   File f = File(path);
  //   var img = await tp.getTagsFromByteArray(f.readAsBytes());


  //   setState(() {
  //     NowPlayingProvider.of(context).track = img.last.tags['title'];
  //     NowPlayingProvider.of(context).album = img.last.tags['album'];
  //     NowPlayingProvider.of(context).artist = img.last.tags['artist'];
  //     NowPlayingProvider.of(context).albumArt = Image.memory(Uint8List.fromList(img.last.tags['APIC'].imageData)).image;
  //   });
  // }