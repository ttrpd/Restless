import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:restless/home.dart';
import 'package:restless/music_provider.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    return MusicProvider(
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
            primaryColorLight: Color.fromARGB(255, 255, 174, 0),//Color.fromARGB(255, 255, 188, 53),
            primaryColor: Color.fromARGB(255, 20, 20, 20),//Color.fromARGB(255, 44,44,44),//Color.fromARGB(255, 255, 130, 76),
            primaryColorDark: Color.fromARGB(255, 100, 100, 110),//Color.fromARGB(255, 145, 70, 33),
            highlightColor: Color.fromARGB(255, 250, 250, 250),//Color.fromARGB(255, 250, 250, 250),
            accentColor: Color.fromARGB(255, 240, 240, 240),//Color.fromARGB(255, 240, 240, 240),
            dividerColor: Color.fromARGB(255, 210, 210, 210),//Color.fromARGB(255, 210, 210, 210)
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