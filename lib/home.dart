import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:restless/temp_controls_area.dart';
import 'dart:io';

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
  double _sliderValue = 30.0;
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(

      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TrackInfoArea(blurValue: _blurValue,),
                ],
              ),
              ListView(

                physics: ScrollPhysics(),
                children: <Widget>[
                  GestureDetector(
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
                    child: AspectRatio(
                      aspectRatio: 1.08,
                      child: Container(
                        color: Colors.transparent,
                        width: double.maxFinite,

                      ),
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 800.0,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 25.0,
                          blurRadius: 50.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Column(

                          children: <Widget>[
                            Row(// Track times
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'current',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Expanded(child: Container(),),
                                RichText(
                                  text: TextSpan(
                                    text: 'end',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Row(// player controls
                                children: <Widget>[
                                  Expanded(child: Container(),),

                                  // rewind
                                  Container(
                                    child: FloatingActionButton(
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.fast_rewind,
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                      onPressed: () {

                                      },
                                    ),
                                  ),

                                  Expanded(child: Container(),),

                                  // play/pause
                                  Container(
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        _playing?Icons.pause:Icons.play_arrow,
                                        color: Colors.black,
                                        size: 40.0,
                                      ),
                                      onPressed: () {
                                        //TODO:
                                        setState(() {
                                          _playing = !_playing;
                                        });
                                      },
                                    ),
                                  ),

                                  Expanded(child: Container(),),

                                  //forward
                                  Container(
                                    child: FloatingActionButton(
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.fast_forward,
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                      onPressed: () {

                                      },
                                    ),
                                  ),

                                  Expanded(child: Container(),),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Slider(// volume slider
                                value: _sliderValue,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white70,
                                min: 0.0,
                                max: 200.0,
                                divisions: 200,
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValue = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(child: Container(),),

                          ],
                        ),
                      ),
                    ),
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
