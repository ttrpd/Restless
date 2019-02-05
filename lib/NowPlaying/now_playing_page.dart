
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:restless/NowPlaying/NowPlayingMenu/tag_area.dart';
import 'package:restless/NowPlaying/NowPlayingMenu/up_next_list.dart';
import 'package:restless/NowPlaying/Visualizer/visualizer.dart';
import 'package:restless/NowPlaying/circular_seek_bar.dart';
import 'package:restless/diamond_frame.dart';

import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/NowPlaying/NowPlayingMenu/now_playing_menu.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';


class NowPlaying extends StatefulWidget
{
  final AudioPlayer audioPlayer;
  final PageController pgCtrl;
  NowPlaying({
    Key key,
    @required this.audioPlayer,
    @required this.pgCtrl,
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
      height: double.infinity,
      child: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Theme.of(context).accentColor,
          child: Stack(
            children: <Widget>[
              
              Container(
                padding: EdgeInsets.only(top: 25.0),
                height: 360.0,
                child: PageView(
                  controller: widget.pgCtrl,
                  children: <Widget>[
                    buildTrackProgressArea(context),
                    buildTrackInfoArea(context,)
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(child: Container(),),
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

  Widget buildTrackProgressArea(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 360.0,
      width: double.infinity,
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

  Widget buildTrackInfoArea(BuildContext context) {
    return ListView(
      children: <Widget>[
        TagArea(tags: NowPlayingProvider.of(context).track.tags),
        UpNextList(),
      ],
    );
  }
}

