import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:restless/MusicLibrary/artist_data.dart';

enum TrackFlow {
  natural,
  shuffle, 
  repeat,
  repeatOnce,
}

class NowPlayingProvider extends InheritedWidget
{
  

  bool playing = false;
  TrackFlow trackFlow = TrackFlow.natural;
  double blurValue;
  double volumeValue;
  Duration currentTime;
  Duration endTime;
  double trackProgressPercent = 0.0;
  TrackData track;
  List<TrackData> playQueue = List<TrackData>();
  AudioPlayer audioPlayer = AudioPlayer();


  NowPlayingProvider({
    Key key,
    Widget child,
    this.playing,
    this.blurValue,
    this.endTime,
    this.currentTime,
    this.trackProgressPercent,
    this.track,
    this.volumeValue,
    this.audioPlayer,
    this.trackFlow,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // may need to be optimized

  int getQueuePos()
  {
    return this.playQueue.indexOf(this.track);
  }

  void playCurrentTrack()
  {
    this.audioPlayer.play(this.track.path);
    this.playing = true;
  } 

  void resume()
  {
    this.audioPlayer.resume();
    this.playing = true;
  }

  void pause()
  {
    this.audioPlayer.pause();
    this.playing = false;
  }

  TrackData previousTrack()
  {
    if(this.track != this.playQueue.first)
      this.track = this.playQueue.elementAt(this.getQueuePos()-1);
    
    return this.track;
  }

  TrackData nextTrack()
  {
    if(this.track != this.playQueue.last)
      this.track = this.playQueue.elementAt(this.getQueuePos()+1);
    
    return this.track;
  }

  TrackData randomTrack()
  {
    Random rand = Random();
    this.track = this.playQueue.elementAt(rand.nextInt(this.playQueue.length-1));
    return this.track;
  }

  static NowPlayingProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(NowPlayingProvider) as NowPlayingProvider);
  }
}