

import 'package:flutter/material.dart';

class NeighborPage extends StatefulWidget
{
  @override
  NeighborPageState createState() {
    return new NeighborPageState();
  }
}

class NeighborPageState extends State<NeighborPage> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: RichText(
          text: TextSpan(
            text: 'Neighbors',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
      ),
    );
  }
}