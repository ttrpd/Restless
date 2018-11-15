import 'package:flutter/material.dart';

import 'package:restless/app.dart';
import 'package:restless/Artists/artist_page.dart';
import 'package:restless/home.dart';
import 'package:restless/NowPlaying/now_playing_page.dart';
import 'package:restless/Neighbors/neighbor_page.dart';
import 'package:restless/Artists/artists_page_provider.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return ArtistsPageProvider(
      child: NowPlayingProvider(
        playing: false,
        blurValue: 0.0,
        volumeValue: 100.0,
        currentTime: Duration(milliseconds: 1),
        endTime: Duration(milliseconds: 1),
        trackProgressPercent: 0.0,
        child: MaterialApp(
          title: 'MyApp',
          debugShowCheckedModeBanner: false,
          routes: <String, WidgetBuilder> {
            '/neighbor_page': (BuildContext context) => NeighborPage(),
          },
          home: Home(),
        ),
      ),
    );
  }
}