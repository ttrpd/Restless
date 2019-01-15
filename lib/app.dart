import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:restless/home.dart';
import 'package:restless/Artists/artists_page_provider.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    return ArtistsPageProvider(
      artistSlivers: {'':null},
      child: NowPlayingProvider(
        playing: false,
        blurValue: 0.0,
        volumeValue: 100.0,
        currentTime: Duration(milliseconds: 1),
        endTime: Duration(milliseconds: 1),
        trackProgressPercent: 0.0,
        audioPlayer: AudioPlayer(),
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Color.fromARGB(255, 25, 25, 25),
            primaryColorDark: Color.fromARGB(255, 103, 103, 103),
            accentColor: Color.fromARGB(255, 240, 240, 240),
          ),
          title: 'Restless',
          debugShowCheckedModeBanner: false,
          routes: <String, WidgetBuilder> {
            // '/albums_page': (BuildContext context) => AlbumPage(),
          },
          home: Home(),
        ),
      ),
    );
  }
}