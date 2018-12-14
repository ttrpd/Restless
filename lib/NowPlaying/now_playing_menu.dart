
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

  List<Widget> tags = List<Widget>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    _volumeValue = NowPlayingProvider.of(context).volumeValue;

    tags.add(
      Chip(
        backgroundColor: Theme.of(context).accentColor,
        label: Text(
          NowPlayingProvider.of(context).track.name, 
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
    tags.add(
      Chip(
        backgroundColor: Theme.of(context).accentColor,
        label: Text(
          NowPlayingProvider.of(context).track.albumName, 
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
    tags.add(
      Chip(
        backgroundColor: Theme.of(context).accentColor,
        label: Text(
          NowPlayingProvider.of(context).track.artistName, 
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
    tags.add(
      Chip(
        backgroundColor: Theme.of(context).accentColor,
        label: Text(
          NowPlayingProvider.of(context).track.tags['track'], 
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );

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
      if(NowPlayingProvider.of(context).playQueue != null)
      {
        NowPlayingProvider.of(context).audioPlayer.play(
          NowPlayingProvider.of(context).playQueue.elementAt(0).path
        );
        setState(() {
          NowPlayingProvider.of(context).track = NowPlayingProvider.of(context).playQueue.elementAt(0);
        });
        NowPlayingProvider.of(context).playQueue.removeAt(0);
      }
      
      setState(() {
        NowPlayingProvider.of(context).trackProgressPercent = 1.0;
        NowPlayingProvider.of(context).playing = true;
      });
      
    };
    


    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        width: double.maxFinite,
        height: 860.0,//820.0,
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
                            if(NowPlayingProvider.of(context).playQueue != null)
                            {
                              NowPlayingProvider.of(context).audioPlayer.play(
                                NowPlayingProvider.of(context).playQueue.elementAt(0).path
                              );
                              setState(() {
                                NowPlayingProvider.of(context).track = NowPlayingProvider.of(context).playQueue.elementAt(0);
                              });
                              NowPlayingProvider.of(context).playQueue.removeAt(0);
                            }
                            
                            setState(() {
                              NowPlayingProvider.of(context).trackProgressPercent = 1.0;
                              NowPlayingProvider.of(context).playing = true;
                            });
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
                            if(NowPlayingProvider.of(context).playQueue != null)
                            {
                              NowPlayingProvider.of(context).audioPlayer.play(
                                NowPlayingProvider.of(context).playQueue.elementAt(0).path
                              );
                              setState(() {
                                NowPlayingProvider.of(context).track = NowPlayingProvider.of(context).playQueue.elementAt(0);
                              });
                              NowPlayingProvider.of(context).playQueue.removeAt(0);
                            }
                            
                            setState(() {
                              // NowPlayingProvider.of(context).trackProgressPercent = 1.0;
                              NowPlayingProvider.of(context).playing = true;
                            });
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
                            children: tags,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                //up next list
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
                              text: 'Up Next',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: (){},
                        ),

                      ),

                      Expanded(child: Container(),),

                    ],
                  ),
                ),
                Container(
                  height: 280.0,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: (NowPlayingProvider.of(context).playQueue==null)?0:NowPlayingProvider.of(context).playQueue.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Divider(
                            color: Theme.of(context).accentColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40.0,
                              width: double.maxFinite,
                              color: Theme.of(context).primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    RichText(
                                      overflow: TextOverflow.clip,
                                      text: TextSpan(
                                        text: (NowPlayingProvider.of(context).playQueue==null)?'':NowPlayingProvider.of(context).playQueue[index].tags['track'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18.0,
                                          height: 1.0,
                                          letterSpacing: 0.0,
                                          color: Theme.of(context).accentColor
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: RichText(
                                        overflow: TextOverflow.clip,
                                        text: TextSpan(
                                          text: (NowPlayingProvider.of(context).playQueue==null)?'':NowPlayingProvider.of(context).playQueue[index].name,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            height: 1.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).accentColor
                                          ),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      overflow: TextOverflow.clip,
                                      text: TextSpan(
                                        text: (NowPlayingProvider.of(context).playQueue==null)?'':NowPlayingProvider.of(context).playQueue[index].artistName,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          height: 1.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(context).accentColor
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container(),),
                                    RichText(
                                      overflow: TextOverflow.clip,
                                      text: TextSpan(
                                        text: '0:00',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          height: 1.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(context).accentColor
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
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