import 'package:flutter/material.dart';

import 'package:restless/app.dart';
import 'package:restless/Artists/artist_page.dart';
import 'package:restless/home.dart';
import 'package:restless/NowPlaying/now_playing_page.dart';
import 'package:restless/Neighbors/neighbor_page.dart';

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {

    return MaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder> {
        '/neighbor_page': (BuildContext context) => NeighborPage(),
      },
      home: Home(),
    );
  }
}