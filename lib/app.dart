import 'package:flutter/material.dart';

import 'package:restless/app.dart';
import 'package:restless/home.dart';
import 'package:restless/neighbor_page.dart';

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    // TODO: implement build
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