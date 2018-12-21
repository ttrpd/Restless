import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:restless/artist_data.dart';

class NowPlayingProvider extends InheritedWidget
{
  bool playing;
  double blurValue;
  double volumeValue;
  Duration currentTime;
  Duration endTime;
  double trackProgressPercent = 0.0;
  ImageProvider albumArt;
  TrackData track;
  List<TrackData> playQueue = new List<TrackData>();
  List<TrackData> playedQueue = new List<TrackData>();
  AudioPlayer audioPlayer = new AudioPlayer();


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
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // may need to be optimized

  static NowPlayingProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(NowPlayingProvider) as NowPlayingProvider);
  }
}