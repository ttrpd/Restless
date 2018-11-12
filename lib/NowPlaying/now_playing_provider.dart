import 'package:flutter/material.dart';

class NowPlayingProvider extends InheritedWidget
{
  bool playing;
  double blurValue;
  Duration currentTime;
  Duration endTime;
  double trackProgressPercent = 0.0;
  ImageProvider albumArt;
  String artist;
  String album;
  String track;

  NowPlayingProvider({
    Key key,
    Widget child,
    this.playing,
    this.blurValue,
    this.endTime,
    this.currentTime,
    this.trackProgressPercent,
    this.albumArt,
    this.artist,
    this.album,
    this.track,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // may need to be optimized

  static NowPlayingProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(NowPlayingProvider) as NowPlayingProvider);
  }
}