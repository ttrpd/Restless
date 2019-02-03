
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:restless/NowPlaying/Visualizer/visualizer.dart';
import 'package:restless/NowPlaying/circular_seek_bar.dart';
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
                  Visualizer(height: 60.0, width: MediaQuery.of(context).size.width,),
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
      height: 360.0,
      width: 320.0,
      color: Theme.of(context).accentColor,
      child:  Center(
        
        child: CircularSeekBar(
          diameter: 140.0,
          trackProgressPercent: NowPlayingProvider.of(context).currentTime.inMilliseconds / NowPlayingProvider.of(context).currentTime.inMilliseconds,
          onSeekRequested: (double seekPercent) {
            setState(() {
              final seekMils = (NowPlayingProvider.of(context).endTime.inMilliseconds.toDouble() * seekPercent).round();//source of toDouble called on null error
              widget.audioPlayer.seek(Duration(milliseconds: seekMils));
              NowPlayingProvider.of(context).trackProgressPercent = seekMils.toDouble() / NowPlayingProvider.of(context).endTime.inMilliseconds.toDouble();
              NowPlayingProvider.of(context).currentTime = Duration(milliseconds: seekMils);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NowPlayingProvider.of(context).track.albumArt,
              )
            ),
          ),
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
                image: DecorationImage(
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

