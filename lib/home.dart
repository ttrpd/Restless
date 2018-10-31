import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:io';

import 'package:restless/album_art_area.dart';
import 'package:restless/now_playing_menu.dart';
import 'package:restless/seek_bar.dart';
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
  double _sliderValue = 0.0;
  bool _playing = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AlbumArtArea(blurValue: _blurValue,),
                ],
              ),
              ListView(

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
