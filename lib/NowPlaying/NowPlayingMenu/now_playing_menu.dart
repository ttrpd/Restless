

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:restless/NowPlaying/NowPlayingMenu/tag_area.dart';
import 'package:restless/NowPlaying/NowPlayingMenu/up_next_list.dart';
import 'package:restless/NowPlaying/progress_bar.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';

class NowPlayingMenu extends StatefulWidget
{

  final AudioPlayer audioPlayer;

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


  List<Widget> tags = List<Widget>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {

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


    return Container(
      // color: Theme.of(context).primaryColor,
      height: 860.0,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                height: 200.0,
                width: 200.0,
              ),
              Container(
                height: 660.0,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 200.0,
                      blurRadius: 200.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            height: 760.0,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  children: <Widget>[
                    SeekBar(
                      trackProgressPercent: NowPlayingProvider.of(context).trackProgressPercent,
                      onSeekRequested: (double seekPercent) {
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
                      padding: const EdgeInsets.only(top: 0.0, bottom: 15.0),
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
                                NowPlayingProvider.of(context).audioPlayer.seek(Duration(milliseconds: 0));

                                setState(() {
                                  NowPlayingProvider.of(context).trackProgressPercent = 0.0;
                                });

                                setState(() {
                                  NowPlayingProvider.of(context).previousTrack();                           
                                });

                                NowPlayingProvider.of(context).playCurrentTrack();
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
                                setState(() {
                                  NowPlayingProvider.of(context).audioPlayer.seek(
                                    NowPlayingProvider.of(context).endTime
                                  );
                                  NowPlayingProvider.of(context).trackProgressPercent = 1.0;
                                });
                              },
                            ),
                          ),

                          Expanded(child: Container(),),
                        ],
                      ),
                    ),

                    // track flow buttons //
                    Padding(// shuffle
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Container(),),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: RawMaterialButton(
                              shape: CircleBorder(),
                              fillColor: (NowPlayingProvider.of(context).trackFlow==TrackFlow.shuffle)?Theme.of(context).accentColor:Colors.black12,
                              onPressed: (){
                                setState(() {
                                  if(NowPlayingProvider.of(context).trackFlow == TrackFlow.shuffle)
                                    NowPlayingProvider.of(context).trackFlow = TrackFlow.natural;
                                  else
                                    NowPlayingProvider.of(context).trackFlow = TrackFlow.shuffle;                                  
                                });
                              },
                              child: Icon(
                                Icons.shuffle,
                                color: (NowPlayingProvider.of(context).trackFlow==TrackFlow.shuffle)?Theme.of(context).primaryColor:Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Container(// repeat
                            width: 40.0,
                            height: 40.0,
                            child: RawMaterialButton(
                              shape: CircleBorder(),
                              fillColor: (NowPlayingProvider.of(context).trackFlow==TrackFlow.repeat)?Theme.of(context).accentColor:Colors.black12,
                              onPressed: (){
                                setState(() {
                                  if(NowPlayingProvider.of(context).trackFlow == TrackFlow.repeat)
                                    NowPlayingProvider.of(context).trackFlow = TrackFlow.natural;
                                  else
                                    NowPlayingProvider.of(context).trackFlow = TrackFlow.repeat;                                  
                                });
                              },
                              child: Icon(
                                Icons.repeat,
                                color: (NowPlayingProvider.of(context).trackFlow==TrackFlow.repeat)?Theme.of(context).primaryColor:Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Container(// repeat once
                            width: 40.0,
                            height: 40.0,
                            child: RawMaterialButton(
                              shape: CircleBorder(),
                              fillColor: (NowPlayingProvider.of(context).trackFlow==TrackFlow.repeatOnce)?Theme.of(context).accentColor:Colors.black12,
                              onPressed: (){
                                setState(() {
                                  if(NowPlayingProvider.of(context).trackFlow == TrackFlow.repeatOnce)
                                    NowPlayingProvider.of(context).trackFlow = TrackFlow.natural;
                                  else
                                    NowPlayingProvider.of(context).trackFlow = TrackFlow.repeatOnce;                                  
                                });
                              },
                              child: Icon(
                                Icons.repeat_one,
                                color: (NowPlayingProvider.of(context).trackFlow==TrackFlow.repeatOnce)?Theme.of(context).primaryColor:Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          Expanded(child: Container(),),
                        ],
                      ),
                    ),

                    TagArea(tags: tags),
                    UpNextList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class SeekBar extends StatefulWidget
{
  final double trackProgressPercent;
  final Function(double) onSeekRequested;

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
            _seekProgressPercent = (details.globalPosition.dx) / MediaQuery.of(context).size.width;
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