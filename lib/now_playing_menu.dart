
import 'package:flutter/material.dart';

class NowPlayingMenu extends StatefulWidget
{

  bool playing;

  NowPlayingMenu({
    Key key,
    @required this.playing,
  }) : super(key: key);

  @override
  NowPlayingMenuState createState() {
    return new NowPlayingMenuState();
  }
}

class NowPlayingMenuState extends State<NowPlayingMenu> {
  double _volumeSliderValue = 30.0;

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: double.maxFinite,
      height: 780.0,
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
              // Track Times //
              Row(
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

              // Player Controls //
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Container(),),

                    // rewind //
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

                    // play/pause //
                    Container(
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          widget.playing?Icons.pause:Icons.play_arrow,
                          color: Colors.black,
                          size: 40.0,
                        ),
                        onPressed: () {
                          //TODO:
                          setState(() {
                            widget.playing = !widget.playing;
                          });
                        },
                      ),
                    ),

                    Expanded(child: Container(),),

                    // forward //
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

              // Volume Slider //
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Slider(// volume slider
                  value: _volumeSliderValue,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white70,
                  min: 0.0,
                  max: 200.0,
                  divisions: 200,
                  onChanged: (double value) {
                    setState(() {
                      _volumeSliderValue = value;
                    });
                  },
                ),
              ),

//              Container(
//                color: Colors.red,
//                width: double.maxFinite,
//                height: 100.0,
//                child: Center(
//                  child: FlatButton(
//                    child: Text('TAGS!'),
//
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}