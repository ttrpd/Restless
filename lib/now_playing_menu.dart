
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:restless/neighbor.dart';
import 'package:restless/progress_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dart_tags/dart_tags.dart';

class NowPlayingMenu extends StatefulWidget
{

  bool playing;
  double trackProgressPercent = 0.0;//currently unused
  AudioPlayer audioPlayer;

  NowPlayingMenu({
    Key key,
    @required this.playing,
    @required this.trackProgressPercent,
    @required this.audioPlayer,
  }) : super(key: key);

  @override
  NowPlayingMenuState createState() {
    return new NowPlayingMenuState();
  }
}

class NowPlayingMenuState extends State<NowPlayingMenu> {
  double _volumeSliderValue = 30.0;
  Duration currentTime = Duration(milliseconds: 1);
  Duration endTime = Duration(milliseconds: 1);
  double _trackProgressPercent = 0.0;


  @override
  void initState() {
    _trackProgressPercent = widget.trackProgressPercent;
  }

  @override
  void dispose() {
    super.dispose();
    widget.trackProgressPercent = _trackProgressPercent;
  }

  @override
  Widget build(BuildContext context)
  {

    widget.audioPlayer.durationHandler = (Duration d) {
      if(endTime != null)
      setState(() {
        endTime = d;
      });
    };
    
    widget.audioPlayer.positionHandler = (Duration d) {
      setState(() {
        currentTime = d;
      });
      _trackProgressPercent = currentTime.inMilliseconds / endTime.inMilliseconds;
    };

    widget.audioPlayer.completionHandler = () {
      setState(() {
        _trackProgressPercent = 1.0;
        widget.playing = false;
      });
    };


    return Container(
      color: Colors.black,
      child: Container(
        width: double.maxFinite,
        height: 820.0,
        decoration: BoxDecoration(
          color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 5.0,
                blurRadius: 70.0,
              ),
            ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: <Widget>[
                SeekBar(
                  trackProgressPercent: _trackProgressPercent,
                  onSeekRequested: (double seekPercent) {//seekPercent is sometimes null
                    setState(() {
                      final seekMils = (endTime.inMilliseconds.toDouble() * seekPercent).round();//source of toDouble called on null error
                      widget.audioPlayer.seek(Duration(milliseconds: seekMils));
                      _trackProgressPercent = seekMils.toDouble() / endTime.inMilliseconds.toDouble();
                      currentTime = Duration(milliseconds: seekMils);
                    });
                  },
                ),
                // Track Times //
                Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: currentTime.toString().substring(currentTime.toString().indexOf(':')+1,currentTime.toString().lastIndexOf('.')),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Expanded(child: Container(),),
                    RichText(
                      text: TextSpan(
                        text: endTime.toString().substring(endTime.toString().indexOf(':')+1,endTime.toString().lastIndexOf('.')),
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
                          heroTag: 'rewind',
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.fast_rewind,
                            color: Colors.white,
                            size: 40.0,
                          ),
                          onPressed: () {
                            print(Directory('/storage/emulated/0/Music').listSync());// need to set permissions for this
                          },
                        ),
                      ),

                      Expanded(child: Container(),),

                      // play/pause //
                      Container(
                        child: FloatingActionButton(
                            heroTag: 'playpause',
                            backgroundColor: Colors.white,
                            child: Icon(
                              widget.playing?Icons.pause:Icons.play_arrow,
                              color: Colors.black,
                              size: 40.0,
                            ),
                            onPressed: () {
                              if(widget.playing) {
                                widget.audioPlayer.pause();
                              }
                              else {
                                widget.audioPlayer.resume();
                              }
                              setState(() {
                                widget.playing = !widget.playing;
                              });
                            }
                        ),
                      ),

                      Expanded(child: Container(),),

                      // forward //
                      Container(
                        child: FloatingActionButton(
                          heroTag: 'forward',
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

                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 0.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),

                Padding(// tags area
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: double.maxFinite,
                    height: 186.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            child: RichText(
                              text: TextSpan(
                                text: 'Tags',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () {
                              print('tags!');
                            },
                          ),

                        ),
                        Flexible(
                          child: Wrap(

                            spacing: 3.0,
                            children: <Widget>[
                              Chip(
                                label: Text('hello'),
                              ),
                              Chip(
                                label: Text('hi'),
                              ),
                              Chip(
                                label: Text('bonjour'),
                              ),
                              Chip(
                                label: Text('salut'),
                              ),
                              Chip(
                                label: Text('anyonghaseo'),
                              ),
                              Chip(
                                label: Text('aurevoir'),
                              ),
                              Chip(
                                label: Text('bye'),
                              ),
                              Chip(
                                label: Text('see ya'),
                              ),
                              Chip(
                                label: Text('hello'),
                              ),
                              Chip(
                                label: Text('hi'),
                              ),
                              Chip(
                                label: Text('bonjour'),
                              ),
                              Chip(
                                label: Text('salut'),
                              ),
                              Chip(
                                label: Text('anyonghaseo'),
                              ),
                              Chip(
                                label: Text('aurevoir'),
                              ),
                              Chip(
                                label: Text('bye'),
                              ),
                              Chip(
                                label: Text('see ya'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                //neighbors list
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          child: RichText(
                            text: TextSpan(
                              text: 'Neighbors',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/neighbor_page');
                            print('neighbors!');
                          },
                        ),

                      ),

                      Expanded(child: Container(),),

                      Container(
                        alignment: Alignment.topRight,
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          child: RichText(
                            text: TextSpan(
                              text: 'Sort',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () {
//                          Navigator.of(context).pushNamed('/sort_page');
                            print('sort!');
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: <Widget>[
                        Neighbor(path:'lib/assets/art0.jpg'),
                        Neighbor(path:'lib/assets/art1.jpg'),
                        Neighbor(path:'lib/assets/art2.jpg'),
                        Neighbor(path:'lib/assets/art3.jpg'),
                        Neighbor(path:'lib/assets/art4.jpg'),
                        Neighbor(path:'lib/assets/art5.jpg'),
                        Neighbor(path:'lib/assets/art6.jpg'),
                        Neighbor(path:'lib/assets/art7.jpg'),
                        Neighbor(path:'lib/assets/art8.jpg'),
                        Neighbor(path:'lib/assets/art9.jpg'),
                        Neighbor(path:'lib/assets/art10.jpg'),
                        Neighbor(path:'lib/assets/art11.jpg'),
                        Neighbor(path:'lib/assets/art12.jpg'),
                        Neighbor(path:'lib/assets/art13.jpg'),
                        Neighbor(path:'lib/assets/art14.jpg'),
                        Neighbor(path:'lib/assets/art15.jpg'),
                        Neighbor(path:'lib/assets/art16.jpg'),
                        Neighbor(path:'lib/assets/art17.jpg'),
                        Neighbor(path:'lib/assets/art18.jpg'),
                        Neighbor(path:'lib/assets/art19.jpg'),
                        Neighbor(path:'lib/assets/art20.jpg'),
                        Neighbor(path:'lib/assets/art21.jpg'),
                      ],
                    ),

                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SeekBar extends StatefulWidget
{
  double trackProgressPercent;
//  double thumbHeight;
//  double thumbWidth;
  Function(double) onSeekRequested;

  SeekBar({
    Key key,
//    this.thumbWidth = 3.0,
//    this.thumbHeight = -10.0,
    this.trackProgressPercent = 0.0,
    this.onSeekRequested,
  }) : super(key: key);

  @override
  SeekBarState createState() {
    return new SeekBarState();
  }
}

class SeekBarState extends State<SeekBar> {
  double _thumbWidth = 3.0;
  double _thumbHeight = -10.0;
  double _seekProgressPercent = 0.0;
  bool _seeking = false;

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(// seekbar
      onHorizontalDragStart: (DragStartDetails details)
      {
        setState(() {
          _seekProgressPercent = (details.globalPosition.dx) / MediaQuery.of(context).size.width;
          _thumbHeight *= 2.0;
          _thumbWidth *= 2.0;
          _seeking = true;
        });
      },
      onHorizontalDragUpdate: (DragUpdateDetails details)
      {
        setState(() {
          if(details.globalPosition.dx <= MediaQuery.of(context).size.width)
            _seekProgressPercent =  (details.globalPosition.dx) / MediaQuery.of(context).size.width;
          else
            _seekProgressPercent = 1.0;
        });
      },
      onHorizontalDragEnd: (DragEndDetails details)
      {

        if(widget.onSeekRequested != null) {
          widget.onSeekRequested(_seekProgressPercent);
        }
        setState(() {
          _seeking = false;
          _thumbHeight /= 2.0;
          _thumbWidth /= 2.0;
        });
      },
      child: Container(// Seek bar
          width: MediaQuery.of(context).size.width,
          height: 30.0,
          color: Colors.transparent,
          child: ProgressBar(
            progressPercent: _seeking?_seekProgressPercent:widget.trackProgressPercent,
            thumbWidth: _thumbWidth,
            thumbHeight: _thumbHeight,
          )
      ),
    );
  }

  @override
  void initState() {
  }
}