
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:restless/Neighbors/neighbor.dart';
import 'package:restless/NowPlaying/progress_bar.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';

class NowPlayingMenu extends StatefulWidget
{

  AudioPlayer audioPlayer;

  NowPlayingMenu({
    Key key,
    @required this.audioPlayer,
  }) : super(key: key);

  @override
  NowPlayingMenuState createState() {
    return new NowPlayingMenuState();
  }
}

class NowPlayingMenuState extends State<NowPlayingMenu> {

  double _volumeValue;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    _volumeValue = NowPlayingProvider.of(context).volumeValue;

    widget.audioPlayer.durationHandler = (Duration d) {
      if(NowPlayingProvider.of(context).endTime != null)
      setState(() {
        NowPlayingProvider.of(context).endTime = d;
      });
    };
    
    widget.audioPlayer.positionHandler = (Duration d) {
      setState(() {
        NowPlayingProvider.of(context).currentTime = d;
      });
      NowPlayingProvider.of(context).trackProgressPercent = NowPlayingProvider.of(context).currentTime.inMilliseconds / NowPlayingProvider.of(context).endTime.inMilliseconds;
    };
    widget.audioPlayer.completionHandler = () {
      setState(() {
        NowPlayingProvider.of(context).trackProgressPercent = 1.0;
        NowPlayingProvider.of(context).playing = false;
      });
    };
    


    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        width: double.maxFinite,
        height: 820.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
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
                  trackProgressPercent: NowPlayingProvider.of(context).trackProgressPercent,
                  onSeekRequested: (double seekPercent) {//seekPercent is sometimes null
                    setState(() {
                      final seekMils = (NowPlayingProvider.of(context).endTime.inMilliseconds.toDouble() * seekPercent).round();//source of toDouble called on null error
                      widget.audioPlayer.seek(Duration(milliseconds: seekMils));
                      NowPlayingProvider.of(context).trackProgressPercent = seekMils.toDouble() / NowPlayingProvider.of(context).endTime.inMilliseconds.toDouble();
                      NowPlayingProvider.of(context).currentTime = Duration(milliseconds: seekMils);
                    });
                  },
                ),
                // Track Times //
                Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: NowPlayingProvider.of(context).currentTime.toString().substring(NowPlayingProvider.of(context).currentTime.toString().indexOf(':')+1,NowPlayingProvider.of(context).currentTime.toString().lastIndexOf('.')),
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Expanded(child: Container(),),
                    RichText(
                      text: TextSpan(
                        text: NowPlayingProvider.of(context).endTime.toString().substring(NowPlayingProvider.of(context).endTime.toString().indexOf(':')+1,NowPlayingProvider.of(context).endTime.toString().lastIndexOf('.')),
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
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
                            color: Theme.of(context).accentColor,
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
                            backgroundColor: Theme.of(context).accentColor,
                            child: Icon(
                              NowPlayingProvider.of(context).playing?Icons.pause:Icons.play_arrow,
                              color: Theme.of(context).primaryColor,
                              size: 40.0,
                            ),
                            onPressed: () {
                              if(NowPlayingProvider.of(context).playing) {
                                widget.audioPlayer.pause();
                              }
                              else {
                                widget.audioPlayer.resume();
                              }
                              setState(() {
                                NowPlayingProvider.of(context).playing = !NowPlayingProvider.of(context).playing;
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
                            color: Theme.of(context).accentColor,
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
                    value: _volumeValue,
                    activeColor: Theme.of(context).accentColor,
                    inactiveColor: Theme.of(context).primaryColorDark,
                    min: 0.0,
                    max: 200.0,
                    divisions: 200,
                    onChanged: (double value) {
                      setState(() {
                        print(NowPlayingProvider.of(context).volumeValue);
                        widget.audioPlayer.setVolume(value / 200.0);
                        NowPlayingProvider.of(context).volumeValue = value;
                        _volumeValue = value;
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 0.0),
                  child: Divider(
                    color: Theme.of(context).accentColor,
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
                                  color: Theme.of(context).accentColor,
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
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('hello', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('hi', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('bonjour', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('salut', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('anyonghaseo', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('aurevoir', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('bye', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('see ya', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('hello', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('hi', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('bonjour', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('salut', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('anyonghaseo', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('aurevoir', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('bye', style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              Chip(
                                backgroundColor: Theme.of(context).accentColor,
                                label: Text('see ya', style: TextStyle(color: Theme.of(context).primaryColor),),
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
                                color: Theme.of(context).accentColor,
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
                                color: Theme.of(context).accentColor,
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
            progressColor: Theme.of(context).accentColor,
            trackColor: Theme.of(context).primaryColorDark,
            thumbColor: Theme.of(context).accentColor,
          )
      ),
    );
  }
}