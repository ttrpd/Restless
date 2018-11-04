import 'dart:math';
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:restless/album_art_area.dart';
import 'package:restless/now_playing_menu.dart';
import 'package:restless/progress_bar.dart';
import 'package:restless/track_info_area.dart';


class Home extends StatefulWidget
{
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> with SingleTickerProviderStateMixin
{

  Animation animation;
  AnimationController animationController;

  @override
  void initState()
  {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
    );
    animation = Tween(begin: 0.0, end: 100.0).animate(animationController)
      ..addListener((){
        setState(() {

        });
      });
    animationController.forward();
  }



  double _blurValue = 0.0;
  bool _playing = false;
  double _trackProgressPercent = 0.0;
  AudioPlayer audioPlayer = new AudioPlayer();

  String _path = '/storage/emulated/0/Music/Little Drama/Little Drama.mp3';

  @override
  Widget build(BuildContext context) {
//    audioPlayer.setUrl('https://t4.bcbits.com/stream/2ab34fec48976b908635ff77dd779785/mp3-128/626133779?p=0&ts=1541373709&t=d98d969edff1d8b7baf05e9901203356cd2d0427&token=1541373709_213e4d81152f633ee17ba2b3e1e534a52c96ecf4');
    audioPlayer.setUrl(_path, isLocal: true);
    audioPlayer.setReleaseMode(ReleaseMode.STOP);


    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AlbumArtArea(blurValue: _blurValue, path: _path,),
                ],
              ),

              ListView(// info/control layer
                physics: ScrollPhysics(),
                children: <Widget>[

                  GestureDetector(// TrackInfoArea
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      //TODO: add animation curve based on scroll
                      setState(() {
                        if(_blurValue > 0.0 && details.delta.dy < 0)_blurValue -= 0.75;
                        if(_blurValue < 15 && details.delta.dy > 0)_blurValue += 0.75;
                      });
                    },
                    onVerticalDragEnd: (DragEndDetails details) {
                      setState(() {
                        if(_blurValue < 8)
                          _blurValue = 0.0;
                        else
                          _blurValue = 15.0;
                      });
                    },
                    child: TrackInfoArea(blurValue: _blurValue,),
                  ),
                  NowPlayingMenu(
                    playing: _playing,
                    audioPlayer: audioPlayer,
                    trackProgressPercent: _trackProgressPercent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child, AxisDirection
      axisDirection) {
    return child;
  }
}
