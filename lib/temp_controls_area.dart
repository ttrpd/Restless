
import 'package:flutter/material.dart';

class TempControlsArea extends StatefulWidget
{
  @override
  TempControlsAreaState createState() {
    return new TempControlsAreaState();
  }
}

class TempControlsAreaState extends State<TempControlsArea> {
  double _sliderValue = 30.0;
  bool _playing = false;

  @override
  Widget build(BuildContext context)
  {
    return Container(
      child: Expanded(// controls area
        child: Container(//showmodalbottomsheet && bottomsheet
          child: Container(
            color: Color.fromARGB(255, 20, 20, 20),
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
                    Expanded(child: Container(),),
                    Row(// player controls
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
                    Expanded(child: Container(),),
                    Slider(// volume slider
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
                    Expanded(child: Container(),),

                  ],
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black54,
            boxShadow: [
              BoxShadow(
                spreadRadius: 25.0,
                blurRadius: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}