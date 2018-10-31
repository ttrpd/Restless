import 'package:flutter/material.dart';

import 'package:restless/app.dart';
import 'package:restless/home.dart';

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    // TODO: implement build
    return MaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}