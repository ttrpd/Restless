import 'package:flutter/material.dart';

import 'package:restless/home.dart';
import 'package:restless/Neighbors/neighbor_page.dart';
import 'package:restless/AlbumPage/album_page.dart';
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
      child: NowPlayingProvider(
        playing: false,
        blurValue: 0.0,
        volumeValue: 100.0,
        currentTime: Duration(milliseconds: 1),
        endTime: Duration(milliseconds: 1),
        trackProgressPercent: 0.0,
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.black,
            primaryColorDark: Color.fromARGB(255, 103, 103, 103),
            accentColor: Colors.white,
          ),
          title: 'MyApp',
          debugShowCheckedModeBanner: false,
          routes: <String, WidgetBuilder> {
            '/neighbor_page': (BuildContext context) => NeighborPage(),
            '/albums_page': (BuildContext context) => AlbumPage(),
          },
          home: Home(),
        ),
      ),
    );
  }
}