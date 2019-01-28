
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:restless/NowPlaying/Visualizer/visualizer.dart';
import 'package:restless/diamond_frame.dart';

import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/NowPlaying/NowPlayingMenu/now_playing_menu.dart';
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
          color: Theme.of(context).accentColor,
          child: Stack(
            children: <Widget>[
              
              ListView(// info/control layer
                physics: ScrollPhysics(),
                children: <Widget>[
                  buildTrackInfoArea(context),
                  Visualizer(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,),
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
      alignment: Alignment.topCenter,
      height: 320.0,
      width: 320.0,
      color: Theme.of(context).accentColor,
      child:  Padding(
        padding: const EdgeInsets.only(top: 50.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DiamondFrame(
              height: 130.0,
              padding: 8.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NowPlayingProvider.of(context).track.albumArt,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    text: stringBeautify(NowPlayingProvider.of(context).track.name),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 32.0,
                      fontFamily: 'Inconsolata',
                      letterSpacing: 2.0,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    text: stringBeautify(NowPlayingProvider.of(context).track.albumName) ?? '(Album)',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontFamily: 'Inconsolata',
                      letterSpacing: 4.0,
                      height: 1.0
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    text: stringBeautify(NowPlayingProvider.of(context).track.artistName) ?? '(Artist)',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.0,
                      fontFamily: 'Inconsolata',
                      letterSpacing: 4.0,
                      height: 3.0
                    ),
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

