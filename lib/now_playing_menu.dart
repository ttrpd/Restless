
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:restless/neighbor.dart';
import 'package:restless/neighbor_page.dart';
import 'package:restless/progress_bar.dart';

class NowPlayingMenu extends StatefulWidget
{

  bool playing;
  double trackProgressPercent = 0.0;

  NowPlayingMenu({
    Key key,
    @required this.playing,
    @required this.trackProgressPercent,
  }) : super(key: key);

  @override
  NowPlayingMenuState createState() {
    return new NowPlayingMenuState();
  }
}

class NowPlayingMenuState extends State<NowPlayingMenu> {
//  double trackProgressPercent = 0.0;
  double _volumeSliderValue = 30.0;

  @override
  Widget build(BuildContext context)
  {
    return Stack(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          height: 782.0,
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
                  AudioComponent(
                    updateMe: [
                      WatchableAudioProperties.audioPlayhead,
                      WatchableAudioProperties.audioSeeking,
                    ],
                    playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
                      double trackProgress = 0.0;

                      if(player.audioLength != null && player.position != null) {
                        trackProgress = player.position.inMilliseconds / player.audioLength.inMilliseconds;
                      }

                      return SeekBar(trackProgressPercent: widget.trackProgressPercent,);
                    },
                  ),
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
                            heroTag: 'rewind',
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
                          child: AudioComponent(
                            updateMe: [
                              WatchableAudioProperties.audioPlayerState
                            ],
                            playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
                              IconData icon = Icons.play_arrow;
                              Function onPressed;

                              if(player.state == AudioPlayerState.playing){
                                icon = Icons.pause;
                                onPressed = player.pause;
                              }
                              else if(player.state == AudioPlayerState.paused
                              || player.state == AudioPlayerState.completed) {
                                icon = Icons.play_arrow;
                                onPressed = player.play;
                              }

                              return FloatingActionButton(
                                heroTag: 'playpause',
                                backgroundColor: Colors.white,
                                child: Icon(
                                  icon,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                onPressed: onPressed
                              );
                            },
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
                    padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
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

      ],
    );
  }
}

class SeekBar extends StatefulWidget
{

  double trackProgressPercent;
  double thumbHeight;
  double thumbWidth;

  SeekBar({
    Key key,
    this.thumbWidth = 3.0,
    this.thumbHeight = -10.0,
    this.trackProgressPercent = 0.0,
  }) : super(key: key);

  @override
  SeekBarState createState() {
    return new SeekBarState();
  }
}

class SeekBarState extends State<SeekBar> {
  double _trackProgressPercent;

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(// seekbar
      onHorizontalDragStart: (DragStartDetails details)
      {
        setState(() {
          _trackProgressPercent =  details.globalPosition.dx / MediaQuery.of(context).size.width;
          widget.thumbHeight *= 2;
          widget.thumbWidth *= 2;
        });
      },
      onHorizontalDragUpdate: (DragUpdateDetails details)
      {
        setState(() {
          if(details.globalPosition.dx <= MediaQuery.of(context).size.width)
            _trackProgressPercent =  details.globalPosition.dx / MediaQuery.of(context).size.width;
          else
            widget.trackProgressPercent = 1.0;
        });
      },
      onHorizontalDragEnd: (DragEndDetails details)
      {
        setState(() {
          widget.thumbHeight /= 2;
          widget.thumbWidth /= 2;
        });
      },
      child: Container(// Seek bar
          width: MediaQuery.of(context).size.width,
          height: 30.0,
          color: Colors.transparent,
          child: ProgressBar(
            progressPercent: _trackProgressPercent,
            thumbWidth: widget.thumbWidth,
            thumbHeight: widget.thumbHeight,
          )
      ),
    );
  }

  @override
  void initState() {
    widget.trackProgressPercent = widget.trackProgressPercent;
  }

  @override
  void didUpdateWidget(SeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.trackProgressPercent = widget.trackProgressPercent;
  }
}