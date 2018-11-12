

import 'package:flutter/material.dart';

class NowPlayingProvider extends InheritedWidget
{
  bool playing;
  double blurValue;
  Duration currentTime;
  Duration endTime;
  double trackProgressPercent = 0.0;

  NowPlayingProvider({
    Key key,
    Widget child,
    this.playing,
    this.blurValue,
    this.endTime,
    this.currentTime,
    this.trackProgressPercent
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // may need to be optimized

  static NowPlayingProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(NowPlayingProvider) as NowPlayingProvider);
  }
}