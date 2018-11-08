import 'package:flutter/material.dart';

import 'package:restless/app.dart';
import 'package:restless/artist_page.dart';
import 'package:restless/home.dart';
import 'package:restless/now_playing_page.dart';
import 'package:restless/neighbor_page.dart';

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