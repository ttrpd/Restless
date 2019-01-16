
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:restless/NowPlaying/album_art_area.dart';
import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/NowPlaying/NowPlayingMenu/now_playing_menu.dart';
import 'package:restless/NowPlaying/track_info_area.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';


class NowPlaying extends StatefulWidget
{
  final AudioPlayer audioPlayer;

  NowPlaying({
    Key key,
    @required this.audioPlayer,
  }) : super(key: key);

  @override
  NowPlayingState createState() => NowPlayingState();
}

class NowPlayingState extends State<NowPlaying> with SingleTickerProviderStateMixin
{

  String stringBeautify(String s)
  {
    return s.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', '');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: <Widget>[
              buildMovingBackground(context),
              ListView(// info/control layer
                physics: ScrollPhysics(),
                children: <Widget>[
                  buildTrackInfoArea(context),
                  NowPlayingMenu(
                    audioPlayer: widget.audioPlayer,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTrackInfoArea(BuildContext context) {
    return Container(
      height: 500.0,
      width: 500.0,
      color: Colors.transparent,
      child:  Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 20.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: RichText(
                maxLines: 2,
                text: TextSpan(
                  text: stringBeautify(NowPlayingProvider.of(context).track.name),
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RichText(
                  maxLines: 2,
                  text: TextSpan(
                    text: stringBeautify(NowPlayingProvider.of(context).track.albumName) ?? '(Album)',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 4.0,
                      height: 1.0
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: RichText(
                maxLines: 2,
                text: TextSpan(
                  text: stringBeautify(NowPlayingProvider.of(context).track.artistName) ?? '(Artist)',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 4.0,
                    height: 3.0
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Stack buildMovingBackground(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform(
          alignment: Alignment.topLeft,
          transform: Matrix4.translationValues(
            -(NowPlayingProvider.of(context).trackProgressPercent * 
              (MediaQuery.of(context).size.height - MediaQuery.of(context).size.width)
             ),
            0.0,
            0.0,
          ),
          child: OverflowBox(
            maxWidth: double.infinity,
            alignment: Alignment.topLeft,
            child: Container(
              alignment: Alignment.topLeft,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(// use FutureBuilder here
                  image: NowPlayingProvider.of(context).track.albumArt ?? AssetImage('lib/assets/default.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromARGB(100, 0, 0, 0),
        ),
      ],
    );
  }
}


// GestureDetector(// TrackInfoArea
//   onVerticalDragUpdate: (DragUpdateDetails details) {
//     //TODO: add animation curve based on scroll
//     setState(() {
//       if(NowPlayingProvider.of(context).blurValue > 0.0 && details.delta.dy < 0)NowPlayingProvider.of(context).blurValue -= 0.75;
//       if(NowPlayingProvider.of(context).blurValue < 15 && details.delta.dy > 0)NowPlayingProvider.of(context).blurValue += 0.75;
//     });
//   },
//   onVerticalDragEnd: (DragEndDetails details) {
//     setState(() {
//       if(NowPlayingProvider.of(context).blurValue < 8)
//         NowPlayingProvider.of(context).blurValue = 0.0;
//       else
//         NowPlayingProvider.of(context).blurValue = 15.0;
//     });
//   },
//   child: TrackInfoArea(
//     blurValue: NowPlayingProvider.of(context).blurValue,
//     name: (NowPlayingProvider.of(context).track==null)?'':NowPlayingProvider.of(context).track.name,
//     album: (NowPlayingProvider.of(context).track==null)?'':NowPlayingProvider.of(context).track.albumName,
//     artist: (NowPlayingProvider.of(context).track==null)?'':NowPlayingProvider.of(context).track.artistName, 
//     path: (NowPlayingProvider.of(context).track==null)?'':NowPlayingProvider.of(context).track.path,//'/storage/emulated/0/Music/TestMusic/Carousel Casualties/Madison/Bright Red Lights.mp3',
//   ),
// ),